package com.foodspot.dto;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * 사용자 정보를 담는 데이터 전송 객체(DTO)입니다.
 * DB 테이블 `users`의 한 레코드를 나타내며, 계층 간 데이터 전달을 위해 사용됩니다.
 * 직렬화(Serializable)를 구현하여 객체를 네트워크로 전송하거나 파일에 저장할 수 있게 합니다.
 */

public class UserDTO implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	// DB 테이블 컬럼과 매핑되는 필드들
	private String userId;
    private String password; // 실제로는 해시된 비밀번호를 저장
    private String userName;
    private String email;
    private String phone;
    private Timestamp joinDate;
    private boolean agreedMarketing;

    // --- Getter와 Setter 메소드 ---
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Timestamp getJoinDate() {
        return joinDate;
    }

    public void setJoinDate(Timestamp joinDate) {
        this.joinDate = joinDate;
    }

    public boolean isAgreedMarketing() {
        return agreedMarketing;
    }

    public void setAgreedMarketing(boolean agreedMarketing) {
        this.agreedMarketing = agreedMarketing;
    }
}