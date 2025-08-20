package com.foodspot.dao;

import com.foodspot.dto.RestaurantDTO;
import com.foodspot.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * 맛집(Restaurant) 데이터베이스 접근을 담당하는 객체입니다.
 * 서블릿이나 서비스 계층에서 호출하여 DB 작업을 수행합니다.
 */
public class RestaurantDAO {

    /**
     * 새로운 맛집 정보를 데이터베이스에 삽입합니다.
     * @param restaurant 맛집 정보가 담긴 RestaurantDTO 객체 (poster_user_id 포함)
     * @return 삽입 성공 시 1, 실패 시 0
     */
    public int insertRestaurant(RestaurantDTO restaurant) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;

        try {
            // DBConnection 유틸리티 클래스를 사용하여 DB 연결을 얻습니다.
            conn = DBConnection.getConnection();
            
            // ★ 중요 수정: poster_user_id 필드를 SQL 쿼리에 추가
            // SQL 쿼리: restaurants 테이블에 새로운 레코드를 삽입합니다.
            // post_date는 DEFAULT CURRENT_TIMESTAMP이므로 쿼리에서 제외합니다.
            String sql = "INSERT INTO restaurants(name, category, address, phone, operating_hours, menu, description, image_url, rating, review_count, poster_user_id, hotspot_region) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)";
            pstmt = conn.prepareStatement(sql);
            
            // PreparedStatement에 값 설정 (순서 중요!)
            pstmt.setString(1, restaurant.getName());
            pstmt.setString(2, restaurant.getCategory());
            pstmt.setString(3, restaurant.getAddress());
            pstmt.setString(4, restaurant.getPhone());
            pstmt.setString(5, restaurant.getOperatingHours());
            pstmt.setString(6, restaurant.getMenu());
            pstmt.setString(7, restaurant.getDescription());
            pstmt.setString(8, restaurant.getImageUrl());
            pstmt.setDouble(9, restaurant.getRating());
            pstmt.setInt(10, restaurant.getReviewCount());
            pstmt.setString(11, restaurant.getPosterUserId()); // ★ 추가: 등록자 ID
            pstmt.setString(12, restaurant.getHotspotRegion());
            
            
            // 디버깅용 로그 (운영 환경에서는 제거 고려)
            System.out.println("Inserting restaurant: " + restaurant.getName() + " by user: " + restaurant.getPosterUserId());
            
            // 쿼리 실행 및 결과 반환 (성공적으로 삽입된 레코드 수)
            result = pstmt.executeUpdate();
            
            if (result > 0) {
                System.out.println("Restaurant successfully inserted with poster_user_id: " + restaurant.getPosterUserId());
            }
            
        } catch (SQLException e) {
            System.err.println("RestaurantDAO.insertRestaurant() - SQL 예외 발생: " + e.getMessage());
            System.err.println("Failed to insert restaurant for user: " + restaurant.getPosterUserId());
            e.printStackTrace();
            // 명시적으로 실패를 나타내는 값 설정
            result = 0; 
            // 예외를 다시 던져서 상위 레이어에서 처리할 수 있도록 함
            throw e;
        } finally {
            // DBConnection 유틸리티를 사용하여 연결 자원을 안전하게 해제합니다.
            DBConnection.close(conn, pstmt);
        }
        return result;
    }
    
    /**
     * 데이터베이스에 저장된 모든 맛집 정보를 조회합니다.
     * @return 맛집 정보 목록 (List<RestaurantDTO>), 없으면 빈 리스트
     */
    public List<RestaurantDTO> getAllRestaurants() {
        List<RestaurantDTO> restaurants = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            
            String sql = "SELECT * FROM restaurants ORDER BY post_date DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                // 공통 메서드 사용으로 코드 일관성 유지
                RestaurantDTO restaurant = extractRestaurantFromResultSet(rs);
                restaurants.add(restaurant);
            }
        } catch (SQLException e) {
            System.err.println("RestaurantDAO.getAllRestaurants() - SQL 예외 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }

        return restaurants;
    }
    	
    /**
     * 평점과 리뷰 수를 기준으로 상위 맛집들을 조회 (TOP 10용)
     * @param limit 조회할 맛집 수
     * @return 상위 맛집 리스트
     */
    public List<RestaurantDTO> getTopRestaurants(int limit) {
        List<RestaurantDTO> restaurants = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            
            // ★ 수정: hotspot_region 컬럼을 명시적으로 추가
            String sql = "SELECT restaurant_id, name, category, address, phone, " +
                    "operating_hours, menu, description, image_url, rating, review_count, " +
                    "post_date, poster_user_id, hotspot_region " +  // ← 이 부분 추가
                    "FROM restaurants " +
                    "ORDER BY rating DESC, review_count DESC, post_date DESC " +
                    "LIMIT ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                RestaurantDTO restaurant = extractRestaurantFromResultSet(rs);
                restaurants.add(restaurant);
            }
            
            System.out.println("TOP " + limit + " 맛집 조회 완료: " + restaurants.size() + "개");
            
        } catch (SQLException e) {
            System.err.println("RestaurantDAO.getTopRestaurants() - SQL 예외 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return restaurants;
    }

    /**
     * 최신 등록순으로 맛집들을 조회 (추천 맛집용)
     * @param limit 조회할 맛집 수
     * @return 최신 맛집 리스트
     */
    public List<RestaurantDTO> getRecentRestaurants(int limit) {
        List<RestaurantDTO> restaurants = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            
            // ★ 수정: SELECT * 대신 명시적으로 컬럼 지정
            String sql = "SELECT restaurant_id, name, category, hotspot_region, address, phone, " +
                         "operating_hours, menu, description, image_url, rating, review_count, " +
                         "post_date, poster_user_id " +
                         "FROM restaurants " +
                         "ORDER BY post_date DESC " +
                         "LIMIT ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                RestaurantDTO restaurant = extractRestaurantFromResultSet(rs);
                restaurants.add(restaurant);
            }
            
            System.out.println("최신 " + limit + " 맛집 조회 완료: " + restaurants.size() + "개");
            
        } catch (SQLException e) {
            System.err.println("RestaurantDAO.getRecentRestaurants() - SQL 예외 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return restaurants;
    }

    /**
     * 검색창에서 입력한 가게명으로 맛집 목록을 조회합니다.
     * @param restaurantName 검색할 가게명 (부분 검색 가능)
     * @return 검색된 맛집 정보 목록
     * 민정님 작성 메서드명 : searchRestaurants -> 수정본 : findRestaurantsByName
     * 메서드 명명은 다음과 같은 규칙을 따르는게 좋습니다.
     *  - 동사와 명사를 결합하여 메서드가 수행하는 동작과 대상을 함께 표기하여 주세요.
    **/
    public List<RestaurantDTO> findRestaurantsByName(String restaurantName) {
        List<RestaurantDTO> restaurants = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            // 민정님 작성한 SQL에 ORDER BY 절만 추가했습니다.
            String sql = "SELECT * FROM restaurants WHERE name LIKE ? ORDER BY post_date DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + restaurantName + "%"); // LIKE 연산자와 와일드카드 %를 사용하여 부분 일치 검색
            rs = pstmt.executeQuery();
                
            while (rs.next()) {
                RestaurantDTO dto = extractRestaurantFromResultSet(rs); // 민정님 작성 공통 메서드 활용
                restaurants.add(dto);
            }
        } catch (SQLException e) {
            System.err.println("RestaurantDAO.findRestaurantsByName() - SQL 예외 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        // 검색된 식당 리스트 반환
        return restaurants;
    }
    
    /**
     * 특정 지역으로 필터링된 맛집 목록을 조회합니다.
     * @param area 필터링할 지역명
     * @return 해당 지역의 맛집 목록
     */
    public List<RestaurantDTO> getRestaurantsByRegion(String area) {
        List<RestaurantDTO> restaurants = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM restaurants WHERE hotspot_region LIKE ? ORDER BY post_date DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + area + "%"); // `LIKE` 연산자와 와일드카드 `%`를 사용하여 부분 일치 검색
            rs = pstmt.executeQuery();

            while (rs.next()) {
                RestaurantDTO dto = extractRestaurantFromResultSet(rs); // 민정님 작성 공통 메서드 활용
                restaurants.add(dto);
            }
        } catch (SQLException e) {
            System.err.println("RestaurantDAO.getRestaurantsByRegion() - SQL 예외 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        // 검색된 식당 리스트 반환
        return restaurants;
    }

    /**
     * 특정 카테고리로 필터링된 맛집 목록을 조회합니다.
     * @param category 필터링할 카테고리명
     * @return 해당 카테고리의 맛집 목록
     */
    public List<RestaurantDTO> getRestaurantsByCategory(String category) {
        List<RestaurantDTO> restaurants = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM restaurants WHERE category LIKE ? ORDER BY post_date DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + category + "%");
            rs = pstmt.executeQuery();

            while (rs.next()) {
                // 공통 메서드 사용으로 코드 일관성 및 유지보수성 향상
                RestaurantDTO restaurant = extractRestaurantFromResultSet(rs);
                restaurants.add(restaurant);
            }
        } catch (SQLException e) {
            System.err.println("RestaurantDAO.getRestaurantsByCategory() - SQL 예외 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return restaurants;
    }
    
    /**
     * 특정 사용자가 등록한 맛집 목록을 조회합니다.
     * @param userId 조회할 사용자 ID
     * @return 해당 사용자가 등록한 맛집 목록
     */
    public List<RestaurantDTO> getRestaurantsByUser(String userId) {
        List<RestaurantDTO> restaurants = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM restaurants WHERE poster_user_id = ? ORDER BY post_date DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                RestaurantDTO restaurant = extractRestaurantFromResultSet(rs);
                restaurants.add(restaurant);
            }
            
            System.out.println("Found " + restaurants.size() + " restaurants for user: " + userId);
            
        } catch (SQLException e) {
            System.err.println("RestaurantDAO.getRestaurantsByUser() - SQL 예외 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return restaurants;
    }
    
    /* 특정 ID의 식당 정보를 조회하는 메서드
    * @param restaurantId 조회할 맛집 ID
    * @return 맛집 정보 객체 (없으면 빈 객체)
    */
    public RestaurantDTO getRestaurantById(int restaurantId) throws SQLException {
       RestaurantDTO restaurant = new RestaurantDTO();
       
       // ★ 기본 정보와 집계 정보를 분리하여 조회
       String sql = "SELECT r.restaurant_id, r.name, r.category, r.hotspot_region, " +
               "r.address, r.phone, r.operating_hours, r.menu, r.description, r.image_url, " +
               "r.rating, r.review_count, r.poster_user_id, r.post_date, " +  // ← 기본 rating, review_count 사용
               "COALESCE(AVG(rv.rating), r.rating) as calculated_rating, " +  // ← 계산된 평균 별점
               "COUNT(rv.review_id) as calculated_review_count " +            // ← 실제 리뷰 개수
               "FROM restaurants r " +
               "LEFT JOIN reviews rv ON r.restaurant_id = rv.restaurant_id " +
               "WHERE r.restaurant_id = ? " +
               "GROUP BY r.restaurant_id";

       try (Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {
           
           pstmt.setInt(1, restaurantId);
           
           try (ResultSet rs = pstmt.executeQuery()) {
               if (rs.next()) {
                   // ★ 기본 정보는 공통 메서드 사용 (rating, review_count 포함)
                   restaurant = extractRestaurantFromResultSet(rs);
                   
                   // ★ 실시간 계산된 값으로 덮어쓰기
                   restaurant.setRating(rs.getDouble("calculated_rating"));
                   restaurant.setReviewCount(rs.getInt("calculated_review_count"));
               }
           }
       }
       
       return restaurant;
   }
    
    /**
     * 맛집 정보를 수정합니다.
     * @param restaurant 수정할 맛집 정보
     * @return 수정 성공 시 1, 실패 시 0
     */
    public int updateRestaurant(RestaurantDTO restaurant) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;

        try {
            conn = DBConnection.getConnection();
            
            // poster_user_id는 수정하지 않음 (등록자 정보 보존)
            String sql = "UPDATE restaurants SET name=?, category=?, address=?, phone=?, " +
                    "operating_hours=?, menu=?, description=?, image_url=?, hotspot_region=? " +  
                    "WHERE restaurant_id=? AND poster_user_id=?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, restaurant.getName());
            pstmt.setString(2, restaurant.getCategory());
            pstmt.setString(3, restaurant.getAddress());
            pstmt.setString(4, restaurant.getPhone());
            pstmt.setString(5, restaurant.getOperatingHours());
            pstmt.setString(6, restaurant.getMenu());
            pstmt.setString(7, restaurant.getDescription());
            pstmt.setString(8, restaurant.getImageUrl());
            pstmt.setString(9, restaurant.getHotspotRegion());
            pstmt.setInt(10, restaurant.getRestaurantId());
            pstmt.setString(11, restaurant.getPosterUserId()); // 본인이 등록한 맛집만 수정 가능
            
            result = pstmt.executeUpdate();
            
            if (result > 0) {
                System.out.println("Restaurant updated successfully: " + restaurant.getRestaurantId());
            } else {
                System.out.println("Update failed - either restaurant not found or user not authorized");
            }
            
        } catch (SQLException e) {
            System.err.println("RestaurantDAO.updateRestaurant() - SQL 예외 발생: " + e.getMessage());
            e.printStackTrace();
            throw e;
        } finally {
            DBConnection.close(conn, pstmt);
        }
        
        return result;
    }
    
    /**
     * 맛집을 삭제합니다. (본인이 등록한 맛집만 삭제 가능)
     * @param restaurantId 삭제할 맛집 ID
     * @param userId 요청한 사용자 ID
     * @return 삭제 성공 시 1, 실패 시 0
     */
    public int deleteRestaurant(int restaurantId, String userId) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;

        try {
            conn = DBConnection.getConnection();
            
            // 본인이 등록한 맛집만 삭제 가능하도록 WHERE 절에 poster_user_id 조건 추가
            String sql = "DELETE FROM restaurants WHERE restaurant_id = ? AND poster_user_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, restaurantId);
            pstmt.setString(2, userId);
            
            result = pstmt.executeUpdate();
            
            if (result > 0) {
                System.out.println("Restaurant deleted successfully: " + restaurantId + " by user: " + userId);
            } else {
                System.out.println("Delete failed - either restaurant not found or user not authorized");
            }
            
        } catch (SQLException e) {
            System.err.println("RestaurantDAO.deleteRestaurant() - SQL 예외 발생: " + e.getMessage());
            e.printStackTrace();
            throw e;
        } finally {
            DBConnection.close(conn, pstmt);
        }
        
        return result;
    }
    
    /**
     * ResultSet에서 RestaurantDTO 객체를 생성하는 헬퍼 메서드
     * @param rs 데이터베이스 쿼리 결과
     * @return RestaurantDTO 객체
     * @throws SQLException ResultSet에서 데이터 추출 실패 시
     */
    private RestaurantDTO extractRestaurantFromResultSet(ResultSet rs) throws SQLException {
        RestaurantDTO restaurant = new RestaurantDTO();
        
        restaurant.setRestaurantId(rs.getInt("restaurant_id"));
        restaurant.setName(rs.getString("name"));
        restaurant.setCategory(rs.getString("category"));
        restaurant.setAddress(rs.getString("address"));
        restaurant.setPhone(rs.getString("phone"));
        restaurant.setOperatingHours(rs.getString("operating_hours"));
        restaurant.setMenu(rs.getString("menu"));
        restaurant.setDescription(rs.getString("description"));
        restaurant.setImageUrl(rs.getString("image_url"));
        restaurant.setRating(rs.getDouble("rating"));
        restaurant.setReviewCount(rs.getInt("review_count"));
        restaurant.setPostDate(rs.getTimestamp("post_date"));
        restaurant.setPosterUserId(rs.getString("poster_user_id"));
        // ★ hotspot_region은 마지막에 처리
        restaurant.setHotspotRegion(rs.getString("hotspot_region"));
        
        return restaurant;
    }

}