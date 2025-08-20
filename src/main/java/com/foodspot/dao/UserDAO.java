package com.foodspot.dao;

import com.foodspot.util.DBConnection; // DBConnection 클래스 import
import com.foodspot.dto.UserDTO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


/**
 * 사용자(User) 데이터베이스 접근을 담당하는 객체입니다.
 * 서블릿이나 서비스 계층에서 호출하여 DB 작업을 수행합니다.
 */

public class UserDAO {
	
	/**
     * 사용자 ID를 기반으로 회원 정보를 조회합니다.
     * 이 메서드는 아이디 중복 체크에 사용됩니다.
     * @param userId 조회할 사용자 ID
     * @return 일치하는 사용자가 있으면 true, 없으면 false
     */
    public boolean isUserIdExists(String userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean exists = false;

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM users WHERE user_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            
            rs = pstmt.executeQuery();
            if (rs.next()) {
                exists = rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.isUserIdExists() - SQL 예외 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return exists;
    }
    
    /**
     * 새로운 회원 정보를 데이터베이스에 삽입합니다.
     * @param user 회원 정보가 담긴 UserDTO 객체
     * @return 삽입 성공 시 1, 실패 시 0
     */
    public int insertUser(UserDTO user) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;

        try {
            conn = DBConnection.getConnection();
            // SQL 쿼리: users 테이블에 새로운 레코드를 삽입합니다.
            // password_hash와 agreed_marketing은 DTO에서 값을 가져옵니다.
            String sql = "INSERT INTO users (user_id, password_hash, user_name, email, phone, agreed_marketing) VALUES (?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            
            // PreparedStatement에 값 설정
            pstmt.setString(1, user.getUserId());
            pstmt.setString(2, user.getPassword()); // 이미 해시된 비밀번호가 DTO에 담겨 있음
            pstmt.setString(3, user.getUserName());
            pstmt.setString(4, user.getEmail());
            pstmt.setString(5, user.getPhone());
            pstmt.setBoolean(6, user.isAgreedMarketing());
            
            // 쿼리 실행 및 결과 반환 (성공적으로 삽입된 레코드 수)
            result = pstmt.executeUpdate();
            
        } catch (SQLException e) {
            System.err.println("UserDAO.insertUser() - SQL 예외 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt);
        }
        return result;
    }

	/**
     * 사용자 ID를 기반으로 회원 정보를 조회합니다.
     * 이 메서드는 주로 로그인 시 비밀번호 해시를 검증하기 위해 사용됩니다.
     *
     * @param userId 조회할 사용자 ID
     * @return 일치하는 사용자가 있는 경우 UserDTO 객체, 없으면 null
     */
	public UserDTO getUserByUserId(String userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        UserDTO user = null;

        try {
            // DBConnection 유틸리티 클래스를 사용하여 DB 연결을 얻습니다.
            conn = DBConnection.getConnection();
            
            // SQL Injection을 방지하기 위해 PreparedStatement를 사용합니다.
            String sql = "SELECT user_id, password_hash, user_name, email, phone, join_date, agreed_marketing FROM users WHERE user_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            
            rs = pstmt.executeQuery();

            // 결과셋에 데이터가 있다면
            if (rs.next()) {
                // UserDTO 객체를 생성하고, DB에서 가져온 값으로 필드를 채웁니다.
                user = new UserDTO();
                user.setUserId(rs.getString("user_id"));
                user.setPassword(rs.getString("password_hash")); // DTO의 password 필드에 해시값 저장
                user.setUserName(rs.getString("user_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setJoinDate(rs.getTimestamp("join_date"));
                user.setAgreedMarketing(rs.getBoolean("agreed_marketing"));
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.getUserByUserId() - SQL 예외 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // 연결 자원을 안전하게 해제합니다.
            DBConnection.close(conn, pstmt, rs);
        }
        return user;
    }
	

}