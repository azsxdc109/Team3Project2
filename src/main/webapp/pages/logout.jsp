<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 세션이 존재하고, 로그인 상태인 경우
    // 'session'은 JSP의 내장 객체이므로 별도로 선언할 필요가 없습니다.
    // 기존 세션이 없으면 새로 만들지 않고 null을 반환합니다.
    if (session != null) {
        // 세션에 저장된 사용자 정보(loggedInUser, userName)를 삭제합니다.
        session.removeAttribute("loggedInUser");
        session.removeAttribute("userName");

        // 만약 '로그인 상태 유지' 쿠키가 있다면 삭제합니다.
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberMe".equals(cookie.getName())) {
                    // 쿠키의 유효 시간을 0으로 설정하여 즉시 만료시킵니다.
                    cookie.setMaxAge(0);
                    // 쿠키의 경로를 '/'로 설정하여 모든 경로에서 삭제되도록 합니다.
                    cookie.setPath("/");
                    response.addCookie(cookie);
                    break;
                }
            }
        }
        
        // 세션 자체를 완전히 무효화합니다.
        session.invalidate();
    }
    
    // 로그아웃 처리 후 메인 페이지로 리다이렉션합니다.
    // response.sendRedirect()를 사용해 클라이언트에게 리다이렉션 응답을 보냅니다.
    response.sendRedirect(request.getContextPath() + "/index.jsp");
%>
