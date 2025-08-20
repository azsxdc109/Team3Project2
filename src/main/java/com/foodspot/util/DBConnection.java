package com.foodspot.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * 데이터베이스 연결을 관리하는 클래스입니다.
 * 모든 DAO 객체는 이 클래스의 정적(static) 메소드를 사용하여 DB 연결을 얻고, 자원을 반환합니다.
 * 이 클래스는 직접 객체로 생성하지 않고, 정적 메소드만 사용하도록 설계되었습니다.
 */
public class DBConnection {

    // --- 데이터베이스 연결 설정 ---
    // 개발 환경에 맞게 아래의 상수들을 수정해야 합니다.

    /** JDBC 드라이버 클래스 이름 */
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    /** 데이터베이스 URL: localhost의 3306 포트에 있는 foodspot_db 데이터베이스에 연결합니다. */
    /** `serverTimezone=UTC&useUnicode=true&characterEncoding=utf-8`는 한글 깨짐 방지 및 시간대 설정을 위한 필수 옵션입니다. */
    private static final String URL = "jdbc:mysql://172.168.10.35:3306/foodspot_db?serverTimezone=UTC&useUnicode=true&characterEncoding=utf-8";

    /** 데이터베이스 사용자 이름 */
    private static final String USER = "foodspot";

    /** 데이터베이스 비밀번호 */
    private static final String PASSWORD = "spotspot"; // TODO: 본인의 비밀번호로 변경하세요.

    // ----------------------------

    /**
     * 데이터베이스 연결(Connection) 객체를 반환합니다.
     * DAO 클래스에서 DB 작업 시작 시 이 메소드를 호출하여 연결을 얻습니다.
     *
     * @return 성공적으로 연결된 경우 Connection 객체, 실패 시 null
     */
    public static Connection getConnection() {
        try {
            // 1. JDBC 드라이버 로드
            // Class.forName() 메소드는 지정된 드라이버 클래스를 메모리에 올립니다.
            Class.forName(DRIVER);
            System.out.println("JDBC 드라이버 로드 성공"); // 디버깅용 메시지

            // 2. 데이터베이스 연결
            // DriverManager.getConnection()을 호출하여 실제 DB 연결을 생성합니다.
            return DriverManager.getConnection(URL, USER, PASSWORD);

        } catch (ClassNotFoundException e) {
            // JDBC 드라이버 클래스가 존재하지 않을 때 발생하는 예외
            System.err.println("JDBC 드라이버를 찾을 수 없습니다: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            // DB 연결 관련 오류 발생 시 (잘못된 URL, USER, PASSWORD 등)
            System.err.println("데이터베이스 연결에 실패했습니다: " + e.getMessage());
            e.printStackTrace();
        }
        
        // 연결 실패 시 null을 반환하여 호출 측에서 예외를 처리하도록 유도합니다.
        return null;
    }

    /**
     * JDBC 자원들을 안전하게 해제(close)하는 메소드입니다.
     * DB 작업 완료 후 반드시 호출하여 자원 누수를 방지해야 합니다.
     *
     * @param conn  Connection 객체
     * @param pstmt PreparedStatement 객체
     * @param rs    ResultSet 객체
     */
    public static void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        try {
            // 자원이 null이 아닌 경우에만 close()를 호출합니다.
            // 역순으로 닫는 것이 일반적인 관례입니다. (rs -> pstmt -> conn)
            if (rs != null) {
                rs.close();
            }
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            // 자원 해제 중 발생하는 예외
            System.err.println("자원 해제 중 오류가 발생했습니다: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 오버로딩된 close 메소드: ResultSet이 없는 경우 사용합니다.
     * 주로 INSERT, UPDATE, DELETE 쿼리 실행 후 호출됩니다.
     *
     * @param conn  Connection 객체
     * @param pstmt PreparedStatement 객체
     */
    public static void close(Connection conn, PreparedStatement pstmt) {
        close(conn, pstmt, null);
    }
}