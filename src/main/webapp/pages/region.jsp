<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>맛집내놔 - 지역 맛집</title>
    <!-- 부트스트랩 5.3 CSS: 웹사이트의 전체적인 디자인과 레이아웃을 담당합니다. -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 아이콘: 다양한 아이콘을 사용하기 위한 라이브러리입니다. -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- jQuery 라이브러리: DOM 조작 및 AJAX 요청을 간편하게 처리하기 위해 사용합니다. -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- 부트스트랩 5.3 JavaScript 번들: 드롭다운, 모달, 네비게이션바 토글 등 JS 기반 기능을 제공합니다. -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        /* CSS 변수: 일관된 디자인을 위해 전역 스타일 변수를 정의합니다. */
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #e74c3c;
            --light-bg: #f8f9fa;
            --border-radius: 12px;
        }
        
        /* body와 html의 기본 마진/패딩 제거 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--light-bg);
            padding-bottom: 50px;
            /* 고정된 헤더를 위한 padding-top 추가 */
            padding-top: 80px;
        }

        /* 네비게이션 바 스타일 */
        .navbar {
             background: linear-gradient(135deg, var(--primary-color) 0%, #34495e 100%);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 1rem 0;
            /* 헤더를 페이지 최상단에 고정 */
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
             color: white !important;
        }
        
        /* 카드 호버 효과 */
        .card-hover {
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .card-hover:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
        }
        
        .card-img-top {
            height: 200px;
            object-fit: cover;
        }
        
        .card-title {
            font-weight: bold;
            color: var(--primary-color);
        }
        
        .rating-stars i {
            color: #ffc107;
            font-size: 0.9rem;
        }
        
        .rating-score {
            font-size: 0.9rem;
            font-weight: 600;
            color: #333;
        }

        /* 페이지 헤더 스타일 */
        .page-header {
            background-image: url('<%= request.getContextPath()%>/images/background.jpg');
	background-size: cover;
	background-position: center;
	color: white;
	padding: 80px 0 60px 0;
	opacity: 0.75;
	margin-bottom : 30px;
        }
        
        .page-header h1 {
            font-weight: bold;
        }
        
        .empty-message {
            text-align: center;
            padding: 50px;
            color: #6c757d;
        }

        /* 푸터 스타일 */
        .footer {
            background-color: #343a40;
            color: #fff;
            padding: 20px 0;
            text-align: center;
            position: absolute;
            bottom: 0;
            width: 100%;
        }
        
        /* 로그인 상태에서의 네비게이션 정렬 개선 */
        .navbar-nav .nav-item.user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .navbar-nav .nav-item.user-info .navbar-text {
            margin: 0;
            white-space: nowrap;
        }
        
        .navbar-nav .nav-item.user-info .btn {
            white-space: nowrap;
        }
        
         .btn-outline-primary {
            border-color: rgba(255,255,255,0.5);
            color: rgba(255,255,255,0.9);
        }
        
        /* 모바일 반응형 */
        @media (max-width: 991px) {
            body {
                padding-top: 70px;
            }
            
            .navbar-nav .nav-item.user-info {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
                margin-top: 1rem;
            }
        }
        
        @media (max-width: 576px) {
            body {
                padding-top: 65px;
            }
            
            .page-header {
                padding: 40px 0;
            }
        }
    </style>
</head>
<body>
    <!-- JSTL을 사용하여 URL 파라미터(area)에 따라 한글 지역명을 설정합니다. -->
    <c:set var="areaName" value="${param.area}"/>
    <c:choose>
        <c:when test="${areaName eq 'seongsu'}"><c:set var="areaName" value="성수"/></c:when>
        <c:when test="${areaName eq 'gangnam'}"><c:set var="areaName" value="강남"/></c:when>
        <c:when test="${areaName eq 'hongdae'}"><c:set var="areaName" value="홍대"/></c:when>
        <c:when test="${areaName eq 'jamsil'}"><c:set var="areaName" value="잠실"/></c:when>
        <c:when test="${areaName eq 'yongsan'}"><c:set var="areaName" value="용산"/></c:when>
        <c:otherwise><c:set var="areaName" value="전국"/></c:otherwise>
    </c:choose>

    <!-- 헤더: 페이지 상단 네비게이션바 -->
    <nav class="navbar navbar-expand-lg navbar-dark shadow-sm">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <i class="fas fa-utensils me-2"></i>맛집내놔
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <!-- 로그인 상태에 따른 UI 변경 (JSTL을 활용) -->
                    <c:choose>
                        <c:when test="${not empty sessionScope.loggedInUser}">
                            <!-- 로그인 시 사용자 정보와 로그아웃 버튼을 한 줄로 정렬합니다. -->
                            <li class="nav-item user-info">
                                <span class="navbar-text text-white">
                                    <i class="fas fa-user-circle me-1"></i>환영합니다, <c:out value="${sessionScope.userName}"/>님!
                                </span>
                                <a href="logout.jsp" class="btn btn-outline-light">
                                    <i class="fas fa-sign-out-alt me-1"></i>로그아웃
                                </a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a href="login.jsp" class="btn btn-outline-light me-2">
                                    <i class="fas fa-sign-in-alt me-1"></i>로그인
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="register.jsp" class="btn btn-light">
                                    <i class="fas fa-user-plus me-1"></i>회원가입
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <!-- 페이지 헤더: 현재 지역명을 표시합니다. -->
    <div class="page-header">
        <div class="container">
            <!-- JSTL로 설정된 한글 지역명 변수를 사용합니다. -->
            <h1 id="pageTitle">${areaName} 지역 맛집</h1>
            <p class="lead">선택하신 지역의 맛집들을 찾아보세요.</p>
        </div>
    </div>

    <!-- 맛집 목록 섹션 -->
    <div class="container">
        <div class="row" id="restaurantList">
            <!-- JSTL을 사용하여 서버에서 전달받은 'restaurants' 리스트를 동적으로 표시합니다. -->
            <c:choose>
                <c:when test="${not empty restaurants}">
                    <c:forEach var="restaurant" items="${restaurants}">
                        <div class="col-md-4 mb-4">
                            <div class="card card-hover h-100" onclick="location.href='restaurant-detail.jsp?id=${restaurant.restaurantId}'">
                                <img src="<c:out value='${not empty restaurant.imageUrl ? restaurant.imageUrl : "https://via.placeholder.com/400x250/FF9999/FFFFFF?text=맛집"}'/>"
                                     class="card-img-top" alt="<c:out value='${restaurant.name}'/>">
                                <div class="card-body">
                                    <h5 class="card-title"><c:out value="${restaurant.name}"/></h5>
                                    <small class="text-muted"><c:out value="${restaurant.address}"/></small>
                                    <div class="d-flex justify-content-between align-items-center mt-2">
                                        <div class="rating-stars">
                                            <c:forEach begin="1" end="5" var="star">
                                                <i class="fas fa-star <c:if test='${star > restaurant.rating}'>far</c:if>"></i>
                                            </c:forEach>
                                            <span class="rating-score"><fmt:formatNumber value="${restaurant.rating}" pattern="0.0"/></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12 empty-message">
                        <i class="fas fa-exclamation-triangle fa-2x mb-3"></i>
                        <p>선택하신 지역에 등록된 맛집이 없습니다.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- 푸터 -->
    <footer class="footer mt-5">
        <div class="container">
            <p>&copy; <fmt:formatDate value="${now}" pattern="yyyy" var="currentYear"/><c:out value="${not empty currentYear ? currentYear : '2025'}"/> 공간정보아카데미 Team3. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>