package com.foodspot.controller;

import com.foodspot.dao.RestaurantDAO;
import com.foodspot.dto.RestaurantDTO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

/**
 * 특정 카테고리로 맛집 목록을 필터링하여 `category.jsp`에 전달하는 서블릿입니다.
 */
@WebServlet("/category") // URL 매핑을 /category로 변경
public class CategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 인코딩 설정
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // URL에서 'type' 파라미터 값을 가져옵니다.
        String category = request.getParameter("type");
        List<RestaurantDTO> restaurants = new ArrayList<>();
        RestaurantDAO restaurantDAO = new RestaurantDAO();
        
        try {
            if (category != null && !category.isEmpty()) {
                // 영어 카테고리를 한글로 변환
                String koreanCategory = convertToKoreanCategory(category);
                // `RestaurantDAO`를 이용해 해당 카테고리의 맛집 목록을 조회합니다.
                restaurants = restaurantDAO.getRestaurantsByCategory(koreanCategory);
            } else {
                // 카테고리가 없으면 빈 리스트 유지
            	request.setAttribute("errorMessage", "카테고리를 선택해주세요.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 오류 발생 시 빈 리스트를 설정하여 JSP가 정상적으로 렌더링되도록 합니다.
            restaurants = new ArrayList<>();
            request.setAttribute("errorMessage", "맛집 정보를 불러오는 중 오류가 발생했습니다.");
        }
        
        // 조회된 맛집 목록을 request 속성에 담아 JSP로 전달합니다.
        request.setAttribute("restaurants", restaurants);
        request.setAttribute("categoryType", category); // 원본 영어 카테고리도 전달
        
        // `category.jsp`로 요청을 포워딩합니다.
        request.getRequestDispatcher("/pages/category.jsp").forward(request, response);
    }
    
    /**
     * 영어 카테고리를 한글로 변환하는 메서드
     */
    private String convertToKoreanCategory(String englishCategory) {
        switch (englishCategory.toLowerCase()) {
            case "korean": return "한식";
            case "chinese": return "중식";
            case "western": return "양식";
            case "japanese": return "일식";
            case "dessert": return "디저트";
            case "fastfood": return "패스트푸드";
            case "cafe": return "카페";
            case "bunsik": return "분식";
            case "chicken": return "치킨";
            case "pizza": return "피자";
            default: return englishCategory;
        }
    }
}