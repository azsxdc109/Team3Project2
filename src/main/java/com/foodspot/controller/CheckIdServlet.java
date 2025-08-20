package com.foodspot.controller;

import com.foodspot.dao.UserDAO;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * 사용자 아이디 중복 체크를 처리하는 서블릿입니다.
 * 클라이언트의 AJAX 요청을 받아 DB에서 아이디 중복 여부를 확인하고 JSON 응답을 보냅니다.
 */
@WebServlet("/CheckIdServlet")
public class CheckIdServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 응답 타입을 JSON으로 설정하고, 한글 인코딩을 지정합니다.
        response.setContentType("application/json; charset=UTF-8");
        
        Gson gson = new Gson();
        JsonObject jsonResponse = new JsonObject();
        
        // AJAX 요청으로부터 사용자 아이디를 가져옵니다.
        String userId = request.getParameter("userId");
        
        UserDAO userDAO = new UserDAO();

        try {
            // DAO를 호출하여 DB에서 아이디 중복 여부를 확인합니다.
            boolean isExists = userDAO.isUserIdExists(userId);
            
            // 중복되지 않았다면 사용 가능
            if (!isExists) {
                jsonResponse.addProperty("available", true);
            } else {
                // 이미 존재하면 사용 불가능
                jsonResponse.addProperty("available", false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 서버 오류 발생 시 사용 불가능으로 응답
            jsonResponse.addProperty("available", false);
        } finally {
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(jsonResponse));
            out.flush();
        }
    }
}