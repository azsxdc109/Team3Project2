package com.foodspot.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.foodspot.dao.UserDAO;
import com.foodspot.dto.UserDTO;
import com.google.gson.*;

/**
 * 로그인 처리를 담당하는 서블릿
 * AJAX 요청을 받아 JSON 형태로 응답을 반환합니다.
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // POST 요청을 처리합니다.
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    	// 응답 컨텐츠 타입을 JSON으로 설정하고, UTF-8 인코딩을 지정합니다.
    	resp.setContentType("application/json; charset=UTF-8");
    	
    	// JSON 응답을 생성하기 위한 객체들을 준비
    	Gson gson = new Gson();
    	JsonObject jsonResponse = new JsonObject();
    	
    	// POST 요청의 파라미터로 전송된 아이디와 비밀번호, '로그인 상태 유지' 체크 여부를 받음.
    	// HTTP 요청에서 넘어오는 모든 파라미터 값은 문자열(String) 형태 -> 실제 타입 변환이 필요함.
    	String userId = req.getParameter("userId");
    	String password = req.getParameter("password");
    	boolean rememberMe = Boolean.parseBoolean(req.getParameter("rememberMe"));
    	
    	// DAO 객체를 생성하여 DB 작업을 위임합니다.
        UserDAO userDAO = new UserDAO();
        
    	try {
    		// DAO를 호출하여 DB에서 사용자 정보를 조회
    		// getUserByUserId 메서드는 UserDTO 객체를 반환함.
    		UserDTO user = userDAO.getUserByUserId(userId);
    		
    		if (user != null) {
    			// 조회된 사용자가 있으면 비밀번호를 검증
    			// 입력된 비밀번호를 SHA-256으로 해시화해서 DB의 해시값과 비교
    			String inputPasswordHash = hashPassword(password);
    			
    			if (inputPasswordHash.equals(user.getPassword())) {
    				// 비밀번호 해시가 일치하면 로그인 성공
                    
    				// 1. 세션에 로그인 정보 저장
                    HttpSession session = req.getSession();
                    session.setAttribute("loggedInUser", user.getUserId());
                    session.setAttribute("userName", user.getUserName());
                    
                 // 2. '로그인 상태 유지' 옵션이 체크된 경우 쿠키 생성 및 추가
                    if (rememberMe) {
                        // user_id와 임의의 토큰(예: 해시값)을 쿠키에 저장합니다.
                        // 보안을 위해 비밀번호 해시를 직접 사용하지 않고, 별도의 토큰을 생성하는 것이 좋습니다.
                        // 여기서는 간단히 user_id를 쿠키 값으로 사용합니다.
                        Cookie rememberMeCookie = new Cookie("rememberMe", user.getUserId());
                        
                        // 쿠키의 유효 기간을 설정합니다 (예: 1시간).
                        // 초 단위로 설정하며, 60초 * 60분
                        rememberMeCookie.setMaxAge(60 * 60);
                        
                        // 쿠키의 경로를 설정합니다. '/'로 설정하면 모든 경로에서 유효합니다.
                        rememberMeCookie.setPath("/");

                        // HTTP-only 속성 설정: JavaScript의 document.cookie를 통한 접근을 막아 XSS 공격을 방지합니다.
                        rememberMeCookie.setHttpOnly(true);
                        
                        // HTTPS를 사용하는 경우 secure 속성을 true로 설정합니다.
                        // rememberMeCookie.setSecure(true);

                        // 응답에 쿠키를 추가하여 클라이언트에게 전송합니다.
                        resp.addCookie(rememberMeCookie);
                    }
                    
                    jsonResponse.addProperty("success", true);
                    jsonResponse.addProperty("message", "로그인 성공!");
                } else {
                    // 비밀번호 불일치
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "아이디 또는 비밀번호가 일치하지 않습니다.");
                }
            } else {
                // 사용자가 존재하지 않음
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "아이디 또는 비밀번호가 일치하지 않습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        } finally {
            // 응답을 클라이언트로 보냅니다.
            PrintWriter out = resp.getWriter();
            out.print(gson.toJson(jsonResponse));
            out.flush();
        }
    }
    	
	/**
     * 비밀번호를 해시화하는 유틸리티 메서드입니다.
     * SHA-256 알고리즘을 사용하여 비밀번호를 해시화합니다.
     *
     * @param password 해시화할 원본 비밀번호
     * @return 해시된 비밀번호 문자열 (16진수)
     */
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(password.getBytes());
            byte[] digest = md.digest();
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return ""; // 오류 발생 시 빈 문자열 반환
        }
    }
}
