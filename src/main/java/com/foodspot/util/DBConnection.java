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
    // 실제 운영 환경에서는 환경 변수나 별도의 설정 파일에서 주입받도록 분리하는 것이 좋습니다.

    /** JDBC 드라이버 클래스 이름 */
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    /**
     * 데이터베이스 URL
     * 예시: jdbc:mysql://localhost:3306/foodspot_db?serverTimezone=UTC&useUnicode=true&characterEncoding=utf-8
     */
    private static final String URL =
            "jdbc:mysql://[HOST]:3306/[DB_NAME]?serverTimezone=UTC&useUnicode=true&characterEncoding=utf-8";

    /** 데이터베이스 사용자 이름 (공개 저장소에는 실제 계정 대신 플레이스홀더를 사용합니다.) */
    private static final String USER = "[DB_USER]";

    /** 데이터베이스 비밀번호 (공개 저장소에는 실제 비밀번호 대신 플레이스홀더를 사용합니다.) */
    private static final String PASSWORD = "[DB_PASSWORD]";

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
            Class.forName(DRIVER);
            System.out.println("JDBC 드라이버 로드 성공"); // 디버깅용 메시지 (운영 환경에서는 로깅 프레임워크 사용 권장)

            // 2. 데이터베이스 연결
            return DriverManager.getConnection(URL, USER, PASSWORD);

        } catch (ClassNotFoundException e) {
            System.err.println("JDBC 드라이버를 찾을 수 없습니다: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
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
