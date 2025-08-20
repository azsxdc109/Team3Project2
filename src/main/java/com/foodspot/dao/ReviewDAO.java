package com.foodspot.dao;

import com.foodspot.dto.ReviewDTO;
import com.foodspot.dto.ReviewImageDTO;
import com.foodspot.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 리뷰 관련 데이터베이스 작업을 처리하는 DAO 클래스
 */
public class ReviewDAO {
    
    /**
     * 특정 식당의 모든 리뷰를 조회 (이미지 포함)
     * @param restaurantId 식당 ID
     * @return 리뷰 목록
     */
    public List<ReviewDTO> getReviewsByRestaurantId(int restaurantId) {
        List<ReviewDTO> reviews = new ArrayList<>();
        
        String sql = "SELECT r.review_id, r.restaurant_id, r.user_id, r.rating, r.content, r.created_date, " +
                     "u.user_name " +
                     "FROM reviews r " +
                     "INNER JOIN users u ON r.user_id = u.user_id " +
                     "WHERE r.restaurant_id = ? " +
                     "ORDER BY r.created_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, restaurantId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ReviewDTO review = new ReviewDTO();
                    review.setReviewId(rs.getInt("review_id"));
                    review.setRestaurantId(rs.getInt("restaurant_id"));
                    review.setUserId(rs.getString("user_id"));
                    review.setUserName(rs.getString("user_name"));
                    review.setRating(rs.getInt("rating"));
                    review.setContent(rs.getString("content"));
                    review.setCreatedDate(rs.getTimestamp("created_date"));
                    
                    // 해당 리뷰의 이미지들 조회
                    List<ReviewImageDTO> images = getReviewImages(review.getReviewId());
                    review.setImages(images);
                    
                    reviews.add(review);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("리뷰 목록 조회 중 오류가 발생했습니다.", e);
        }
        
        return reviews;
    }
    
    /**
     * 특정 리뷰의 이미지들을 조회
     * @param reviewId 리뷰 ID
     * @return 이미지 목록
     */
    public List<ReviewImageDTO> getReviewImages(int reviewId) {
        List<ReviewImageDTO> images = new ArrayList<>();
        
        String sql = "SELECT image_id, review_id, image_path " +
                     "FROM review_images " +
                     "WHERE review_id = ? " +
                     "ORDER BY image_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, reviewId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ReviewImageDTO image = new ReviewImageDTO();
                    image.setImageId(rs.getInt("image_id"));
                    image.setReviewId(rs.getInt("review_id"));
                    image.setImagePath(rs.getString("image_path"));
                    images.add(image);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("리뷰 이미지 조회 중 오류가 발생했습니다.", e);
        }
        
        return images;
    }
    
    /**
     * 새로운 리뷰를 등록
     * @param review 리뷰 정보
     * @return 생성된 리뷰 ID
     */
    public int insertReview(ReviewDTO review) {
        String sql = "INSERT INTO reviews (restaurant_id, user_id, rating, content) " +
                     "VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, review.getRestaurantId());
            pstmt.setString(2, review.getUserId());
            pstmt.setInt(3, review.getRating());
            pstmt.setString(4, review.getContent());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int reviewId = generatedKeys.getInt(1);
                        
                        // 리뷰 이미지가 있다면 저장
                        if (review.getImages() != null && !review.getImages().isEmpty()) {
                            insertReviewImages(reviewId, review.getImages());
                        }
                        
                        // 식당의 평점과 리뷰 개수 업데이트
                        updateRestaurantRating(review.getRestaurantId());
                        
                        return reviewId;
                    }
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("리뷰 등록 중 오류가 발생했습니다.", e);
        }
        
        return -1;
    }
    
    /**
     * 리뷰 이미지들을 등록
     * @param reviewId 리뷰 ID
     * @param images 이미지 목록
     */
    public void insertReviewImages(int reviewId, List<ReviewImageDTO> images) {
        String sql = "INSERT INTO review_images (review_id, image_path) " +
                     "VALUES (?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            for (ReviewImageDTO image : images) {
                pstmt.setInt(1, reviewId);
                pstmt.setString(2, image.getImagePath());
                pstmt.addBatch();
            }
            
            pstmt.executeBatch();
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("리뷰 이미지 등록 중 오류가 발생했습니다.", e);
        }
    }
    
    /**
     * 식당의 평균 평점과 리뷰 개수를 업데이트
     * @param restaurantId 식당 ID
     */
    public void updateRestaurantRating(int restaurantId) {
        String sql = "UPDATE restaurants " +
                     "SET rating = (" +
                     "    SELECT COALESCE(AVG(rating), 0) " +
                     "    FROM reviews " +
                     "    WHERE restaurant_id = ?" +
                     "), " +
                     "review_count = (" +
                     "    SELECT COUNT(*) " +
                     "    FROM reviews " +
                     "    WHERE restaurant_id = ?" +
                     ") " +
                     "WHERE restaurant_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, restaurantId);
            pstmt.setInt(2, restaurantId);
            pstmt.setInt(3, restaurantId);
            
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("식당 평점 업데이트 중 오류가 발생했습니다.", e);
        }
    }
    
    /**
     * 특정 리뷰를 ID로 조회
     * @param reviewId 리뷰 ID
     * @return 리뷰 정보
     */
    public ReviewDTO getReviewById(int reviewId) {
        String sql = "SELECT r.review_id, r.restaurant_id, r.user_id, r.rating, r.content, r.created_date, " +
                     "u.user_name " +
                     "FROM reviews r " +
                     "INNER JOIN users u ON r.user_id = u.user_id " +
                     "WHERE r.review_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, reviewId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    ReviewDTO review = new ReviewDTO();
                    review.setReviewId(rs.getInt("review_id"));
                    review.setRestaurantId(rs.getInt("restaurant_id"));
                    review.setUserId(rs.getString("user_id"));
                    review.setUserName(rs.getString("user_name"));
                    review.setRating(rs.getInt("rating"));
                    review.setContent(rs.getString("content"));
                    review.setCreatedDate(rs.getTimestamp("created_date"));
                    
                    // 이미지 정보도 함께 조회
                    List<ReviewImageDTO> images = getReviewImages(reviewId);
                    review.setImages(images);
                    
                    return review;
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("리뷰 조회 중 오류가 발생했습니다.", e);
        }
        
        return null;
    }
    
    /**
     * 리뷰를 수정
     * @param review 수정할 리뷰 정보
     * @return 수정 성공 여부
     */
    public boolean updateReview(ReviewDTO review) {
        String sql = "UPDATE reviews " +
                     "SET rating = ?, content = ? " +
                     "WHERE review_id = ? AND user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, review.getRating());
            pstmt.setString(2, review.getContent());
            pstmt.setInt(3, review.getReviewId());
            pstmt.setString(4, review.getUserId());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                // 식당 평점 업데이트
                updateRestaurantRating(review.getRestaurantId());
                return true;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("리뷰 수정 중 오류가 발생했습니다.", e);
        }
        
        return false;
    }
    
    /**
     * 리뷰를 삭제 (본인만 삭제 가능)
     * @param reviewId 리뷰 ID
     * @param userId 사용자 ID
     * @return 삭제 성공 여부
     */
    public boolean deleteReview(int reviewId, String userId) {
        String sql = "DELETE FROM reviews WHERE review_id = ? AND user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            // 먼저 리뷰 정보를 조회하여 식당 ID를 얻기
            ReviewDTO review = getReviewById(reviewId);
            if (review == null || !review.getUserId().equals(userId)) {
                return false;
            }
            
            pstmt.setInt(1, reviewId);
            pstmt.setString(2, userId);
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                // 식당 평점 업데이트
                updateRestaurantRating(review.getRestaurantId());
                return true;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("리뷰 삭제 중 오류가 발생했습니다.", e);
        }
        
        return false;
    }
    
    /**
     * 특정 사용자가 특정 식당에 이미 리뷰를 작성했는지 확인
     * @param restaurantId 식당 ID
     * @param userId 사용자 ID
     * @return 리뷰 존재 여부
     */
    public boolean hasUserReviewedRestaurant(int restaurantId, String userId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE restaurant_id = ? AND user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, restaurantId);
            pstmt.setString(2, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("리뷰 존재 여부 확인 중 오류가 발생했습니다.", e);
        }
        
        return false;
    }
    
    /**
     * 특정 사용자의 모든 리뷰를 조회
     * @param userId 사용자 ID
     * @return 리뷰 목록
     */
    public List<ReviewDTO> getReviewsByUserId(String userId) {
        List<ReviewDTO> reviews = new ArrayList<>();
        
        String sql = "SELECT r.review_id, r.restaurant_id, r.user_id, r.rating, r.content, r.created_date, " +
                     "u.user_name, rst.name as restaurant_name " +
                     "FROM reviews r " +
                     "INNER JOIN users u ON r.user_id = u.user_id " +
                     "INNER JOIN restaurants rst ON r.restaurant_id = rst.restaurant_id " +
                     "WHERE r.user_id = ? " +
                     "ORDER BY r.created_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ReviewDTO review = new ReviewDTO();
                    review.setReviewId(rs.getInt("review_id"));
                    review.setRestaurantId(rs.getInt("restaurant_id"));
                    review.setUserId(rs.getString("user_id"));
                    review.setUserName(rs.getString("user_name"));
                    review.setRating(rs.getInt("rating"));
                    review.setContent(rs.getString("content"));
                    review.setCreatedDate(rs.getTimestamp("created_date"));
                    review.setRestaurantName(rs.getString("restaurant_name"));
                    
                    // 해당 리뷰의 이미지들 조회
                    List<ReviewImageDTO> images = getReviewImages(review.getReviewId());
                    review.setImages(images);
                    
                    reviews.add(review);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("사용자 리뷰 목록 조회 중 오류가 발생했습니다.", e);
        }
        
        return reviews;
    }
    
    // ★★★ 새로 추가된 메서드 ★★★
    /**
     * 필터링, 정렬, 페이지네이션이 적용된 리뷰 목록을 가져오는 메서드
     *
     * @param minRating 최소 평점 (필터링, 0이면 전체)
     * @param sortBy    정렬 기준 ("latest" 또는 "rating")
     * @param offset    시작 위치 (페이지네이션)
     * @param pageSize  페이지 크기 (페이지네이션)
     * @return 조건에 맞는 리뷰 DTO 목록
     */
    public List<ReviewDTO> getFilteredAndSortedReviews(int minRating, String sortBy, int offset, int pageSize) {
        List<ReviewDTO> reviewList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT r.review_id, r.restaurant_id, r.user_id, r.rating, r.content, r.created_date, " +
                "u.user_name, res.name AS restaurantName, res.image_url AS restaurantImage, " +
                "res.category AS restaurantCategory, res.address AS restaurantAddress " +
                "FROM reviews r " +
                "JOIN users u ON r.user_id = u.user_id " +
                "JOIN restaurants res ON r.restaurant_id = res.restaurant_id " +
                "WHERE 1=1"; // 조건절 시작

        if (minRating > 0) {
            sql += " AND r.rating >= ?";
        }

        if ("rating".equals(sortBy)) {
            sql += " ORDER BY r.rating DESC, r.created_date DESC";
        } else { // 기본값: latest
            sql += " ORDER BY r.created_date DESC";
        }
        
        sql += " LIMIT ? OFFSET ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            
            int paramIndex = 1;
            if (minRating > 0) {
                pstmt.setInt(paramIndex++, minRating);
            }
            pstmt.setInt(paramIndex++, pageSize);
            pstmt.setInt(paramIndex, offset);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                ReviewDTO review = new ReviewDTO();
                review.setReviewId(rs.getInt("review_id"));
                review.setRestaurantId(rs.getInt("restaurant_id"));
                review.setUserId(rs.getString("user_id"));
                review.setRating(rs.getInt("rating"));
                review.setContent(rs.getString("content"));
                review.setCreatedDate(rs.getTimestamp("created_date"));
                
                // JOIN을 통해 가져온 식당 및 사용자 정보 설정
                review.setUserName(rs.getString("user_name"));
                review.setRestaurantName(rs.getString("restaurantName"));
                review.setRestaurantImage(rs.getString("restaurantImage"));
                review.setRestaurantCategory(rs.getString("restaurantCategory"));
                review.setRestaurantAddress(rs.getString("restaurantAddress"));

                // 리뷰 이미지 목록을 가져오는 DAO 메서드 호출
                // 이 방법은 N+1 쿼리 문제 발생 가능.
                // 그러나 이미지를 별도 DTO로 관리하므로 현재 구조에서는 이 방식이 최선.
                List<ReviewImageDTO> images = getReviewImages(review.getReviewId());
                review.setImages(images);
                
                reviewList.add(review);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("필터링된 리뷰 목록 조회 중 오류가 발생했습니다.", e);
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return reviewList;
    }
    
    /**
     * 필터링 조건에 맞는 전체 리뷰 수를 가져오는 메서드 (페이지네이션 계산용)
     *
     * @param minRating 최소 평점 (0이면 전체)
     * @return 총 리뷰 수
     */
    public int getReviewCount(int minRating) {
        int count = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT COUNT(*) FROM reviews WHERE 1=1";
        if (minRating > 0) {
            sql += " AND rating >= ?";
        }
        
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            if (minRating > 0) {
                pstmt.setInt(1, minRating);
            }
            rs = pstmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("리뷰 수 조회 중 오류가 발생했습니다.", e);
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return count;
    }
    
}