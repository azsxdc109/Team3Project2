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
 * 특정 지역으로 맛집 목록을 필터링하여 `region.jsp`에 전달하는 서블릿입니다.
 */
@WebServlet("/region")
public class RegionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // `region.jsp` 파일이 `pages` 폴더 안에 있다고 가정합니다.
        // URL에서 'area' 파라미터 값을 가져옵니다.
        String area = request.getParameter("area");

        List<RestaurantDTO> restaurants = new ArrayList<>();
        RestaurantDAO restaurantDAO = new RestaurantDAO();

        try {
            if (area != null && !area.isEmpty()) {
                // `RestaurantDAO`를 이용해 해당 지역의 맛집 목록을 조회합니다.
                restaurants = restaurantDAO.getRestaurantsByRegion(area);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 오류 발생 시 빈 리스트를 설정하여 JSP가 정상적으로 렌더링되도록 합니다.
            restaurants = new ArrayList<>();
        }

        // 조회된 맛집 목록을 request 속성에 담아 JSP로 전달합니다.
        request.setAttribute("restaurants", restaurants);
        
        // `region.jsp`로 요청을 포워딩합니다.
        request.getRequestDispatcher("/pages/region.jsp").forward(request, response);
    }
}
