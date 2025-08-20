package com.foodspot.dao;

import com.foodspot.dto.ReviewImageDTO;
import com.foodspot.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * 리뷰 이미지(ReviewImage) 데이터베이스 접근을 담당하는 객체입니다.
 */
public class ReviewImageDAO {

    /**
     * 리뷰에 첨부된 이미지 정보를 데이터베이스에 삽입합니다.
     * @param image 리뷰 이미지 정보가 담긴 ReviewImageDTO 객체
     * @return 삽입 성공 시 true, 실패 시 false
     */
    public boolean insertReviewImage(ReviewImageDTO image) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;

        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO review_images (review_id, image_path) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, image.getReviewId());
            pstmt.setString(2, image.getImagePath());
            
            int result = pstmt.executeUpdate();
            if (result > 0) {
                success = true;
            }
        } catch (SQLException e) {
            System.err.println("ReviewImageDAO.insertReviewImage() - SQL 예외 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt);
        }
        return success;
    }

    /**
     * 특정 리뷰 ID에 해당하는 모든 이미지 경로를 조회합니다.
     * @param reviewId 조회할 리뷰 ID
     * @return 이미지 경로 목록 (List<String>), 없으면 빈 리스트
     */
    public List<String> getReviewImagesByReviewId(int reviewId) {
        List<String> imageUrls = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT image_path FROM review_images WHERE review_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, reviewId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                imageUrls.add(rs.getString("image_path"));
            }
        } catch (SQLException e) {
            System.err.println("ReviewImageDAO.getReviewImagesByReviewId() - SQL 예외 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return imageUrls;
    }
}
