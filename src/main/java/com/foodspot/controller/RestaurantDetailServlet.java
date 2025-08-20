package com.foodspot.controller;

import com.foodspot.dao.RestaurantDAO;
import com.foodspot.dao.ReviewDAO;
import com.foodspot.dto.RestaurantDTO;
import com.foodspot.dto.ReviewDTO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import com.google.gson.Gson;

/**
 * 식당 상세 정보를 처리하는 서블릿
 * 식당 정보와 해당 식당의 리뷰들을 조회하여 표시
 */
@WebServlet("/RestaurantDetailServlet")
public class RestaurantDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private RestaurantDAO restaurantDAO;
    private ReviewDAO reviewDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        restaurantDAO = new RestaurantDAO();
        reviewDAO = new ReviewDAO();
    }

    /**
     * GET 요청 처리 - 식당 상세 정보 조회
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 한글 인코딩 설정
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String restaurantId = request.getParameter("id");
        
        // ID 파라미터 유효성 검증
        if (restaurantId == null || restaurantId.trim().isEmpty()) {
            handleError(request, response, "식당 ID가 제공되지 않았습니다.");
            return;
        }
        
        try {
            int id = Integer.parseInt(restaurantId.trim());
            
            // 식당 정보 조회
            RestaurantDTO restaurant = restaurantDAO.getRestaurantById(id);
            if (restaurant == null) {
                handleError(request, response, "해당 식당을 찾을 수 없습니다.");
                return;
            }
            
            // 해당 식당의 리뷰 목록 조회
            List<ReviewDTO> reviews = reviewDAO.getReviewsByRestaurantId(id);
            
            // AJAX 요청인지 확인
            if (isAjaxRequest(request)) {
                handleAjaxRequest(response, restaurant, reviews);
            } else {
                handleNormalRequest(request, response, restaurant, reviews);
            }
            
        } catch (NumberFormatException e) {
            handleError(request, response, "잘못된 식당 ID 형식입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            handleError(request, response, "서버 오류가 발생했습니다.");
        }
    }
    
    /**
     * AJAX 요청인지 확인하는 메서드
     */
    private boolean isAjaxRequest(HttpServletRequest request) {
        String xRequestedWith = request.getHeader("X-Requested-With");
        String accept = request.getHeader("Accept");
        
        return "XMLHttpRequest".equals(xRequestedWith) ||
               (accept != null && accept.contains("application/json"));
    }
    
    /**
     * AJAX 요청 처리 - JSON 응답
     */
    private void handleAjaxRequest(HttpServletResponse response, RestaurantDTO restaurant, List<ReviewDTO> reviews) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // 응답 데이터 구성
        RestaurantDetailResponse responseData = new RestaurantDetailResponse();
        responseData.setRestaurant(restaurant);
        responseData.setReviews(reviews);
        
        Gson gson = new Gson();
        String jsonResponse = gson.toJson(responseData);
        response.getWriter().write(jsonResponse);
    }
    
    /**
     * 일반 요청 처리 - JSP 포워딩
     */
    private void handleNormalRequest(HttpServletRequest request, HttpServletResponse response, 
                                   RestaurantDTO restaurant, List<ReviewDTO> reviews) 
            throws ServletException, IOException {
        // request 속성에 데이터 설정
        request.setAttribute("restaurant", restaurant);
        request.setAttribute("reviews", reviews);
        
        // JSP 경로 수정 (백슬래시를 슬래시로 변경)
        request.getRequestDispatcher("/pages/restaurant-detail.jsp").forward(request, response);
    }
    
    /**
     * 에러 처리 메서드
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage) 
            throws IOException, ServletException {
        
        if (isAjaxRequest(request)) {
            // AJAX 요청인 경우 JSON 에러 응답
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            
            ErrorResponse errorResponse = new ErrorResponse();
            errorResponse.setSuccess(false);
            errorResponse.setMessage(errorMessage);
            
            Gson gson = new Gson();
            response.getWriter().write(gson.toJson(errorResponse));
        } else {
            // 일반 요청인 경우 에러 페이지로 리다이렉트
            request.getSession().setAttribute("errorMessage", errorMessage);
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
    
    /**
     * AJAX 응답을 위한 내부 클래스
     */
    private static class RestaurantDetailResponse {
        public void setRestaurant(RestaurantDTO restaurant) {
        }
        
        public void setReviews(List<ReviewDTO> reviews) {
        }
    }
    
    /**
     * 에러 응답을 위한 내부 클래스
     */
    private static class ErrorResponse {
        public void setSuccess(boolean success) {
        }
        
        public void setMessage(String message) {
        }
    }
}