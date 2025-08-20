package com.foodspot.controller;

import com.foodspot.dao.RestaurantDAO;
import com.foodspot.dto.RestaurantDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * 메인 페이지(index.jsp)에 표시될 맛집 목록을 조회하고 전달하는 서블릿입니다.
 */
@WebServlet("/main")
public class RestaurantListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	System.out.println("RestaurantListServlet이 실행되었습니다.");
    	System.out.println("=== RestaurantListServlet 실행됨 ===");
    	
        // 메인 페이지에서 사용할 데이터를 DB에서 가져옵니다.
        RestaurantDAO restaurantDAO = new RestaurantDAO();
        
        try {
            // 인기 TOP 10 맛집 목록을 조회합니다.
            List<RestaurantDTO> topRestaurants = restaurantDAO.getTopRestaurants(10);
            System.out.println("조회된 인기 맛집 수: " + topRestaurants.size());
            // 데이터 내용도 확인
            for(RestaurantDTO restaurant : topRestaurants) {
                System.out.println("맛집: " + restaurant.getName()); // getName() 메서드명 확인 필요
            }
            request.setAttribute("topRestaurants", topRestaurants);

            // 추천 맛집 목록을 조회합니다.
            // 여기서는 간단하게 첫 6개의 맛집을 추천 맛집으로 사용합니다.
            List<RestaurantDTO> recommendedRestaurants = restaurantDAO.getRecentRestaurants(6);
            request.setAttribute("recommendedRestaurants", recommendedRestaurants);

        } catch (Exception e) {
            e.printStackTrace();
            // 오류 발생 시에도 JSP 페이지가 정상적으로 로드되도록 빈 리스트를 설정합니다.
            request.setAttribute("topRestaurants", new ArrayList<RestaurantDTO>());
            request.setAttribute("recommendedRestaurants", new ArrayList<RestaurantDTO>());
        }

        // index.jsp로 요청을 포워딩합니다.
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
