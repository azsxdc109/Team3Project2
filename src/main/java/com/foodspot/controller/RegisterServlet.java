package com.foodspot.controller;

import com.foodspot.dao.UserDAO;
import com.foodspot.dto.UserDTO;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * 회원가입 요청을 처리하는 서블릿입니다.
 * 폼 데이터를 받아 UserDTO에 담고, UserDAO를 통해 DB에 저장합니다.
 */
@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 클라이언트에서 보낸 데이터의 한글 인코딩을 처리합니다.
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        
        Gson gson = new Gson();
        JsonObject jsonResponse = new JsonObject();

        try {
            // 1. 폼 데이터에서 필요한 정보를 추출합니다.
            String userId = request.getParameter("userId");
            String password = request.getParameter("password");
            String userName = request.getParameter("userName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            boolean agreedMarketing = Boolean.parseBoolean(request.getParameter("agreedMarketing"));

            // 2. DTO 객체를 생성하고 데이터를 담습니다.
            UserDTO newUser = new UserDTO();
            newUser.setUserId(userId);
            newUser.setUserName(userName);
            newUser.setEmail(email);
            newUser.setPhone(phone);
            newUser.setAgreedMarketing(agreedMarketing);
            
            // 3. 비밀번호를 해시화하여 DTO에 설정합니다.
            // 실제로는 BCrypt와 같은 강력한 알고리즘을 사용해야 합니다.
            String passwordHash = hashPassword(password);
            newUser.setPassword(passwordHash);

            // 4. DAO 객체를 생성하여 DB 작업을 위임합니다.
            UserDAO userDAO = new UserDAO();
            int result = userDAO.insertUser(newUser);

            if (result > 0) {
                // 삽입 성공
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "회원가입이 완료되었습니다.");
            } else {
                // 삽입 실패
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "회원가입에 실패했습니다. 다시 시도해주세요.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "서버 오류가 발생했습니다.");
        } finally {
            PrintWriter out = response.getWriter();
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
            return "";
        }
    }
}
