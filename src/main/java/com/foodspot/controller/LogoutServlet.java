package com.foodspot.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * 로그아웃 요청(POST)을 처리합니다.
     * JSP에서 AJAX로 요청이 오거나, 직접 URL로 요청이 올 때 사용됩니다.
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO: 로그인 상태를 해제하고, 메인 페이지로 리다이렉트하는 로직을 구현하세요.

        // 1. 현재 세션을 가져옵니다. (세션이 없으면 새로 생성하지 않습니다.)
        HttpSession session = request.getSession(false);

        // 2. 세션이 존재하는 경우, 세션을 무효화(invalidate)합니다.
        //    이렇게 하면 세션에 저장된 모든 사용자 정보가 삭제되어 로그아웃 상태가 됩니다.
        if (session != null) {
            session.invalidate();
            System.out.println("사용자 로그아웃 처리 완료.");
        }

        // 3. 로그아웃 후 메인 페이지(index.jsp)로 리다이렉트합니다.
        //    AJAX 요청을 처리하는 경우, 응답에 success:true 를 담아 보내고, 클라이언트에서 리다이렉트를 처리할 수도 있습니다.
        //    여기서는 서블릿에서 직접 리다이렉트를 수행하는 방식으로 구현합니다.
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}
