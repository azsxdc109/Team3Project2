<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.List" %>
<%@ page import="com.foodspot.dao.RestaurantDAO" %>
<%@ page import="com.foodspot.dto.RestaurantDTO" %>
<%@ page import="java.util.*" %>

<%
    /* 서버사이드 로직: 맛집 검색 처리 */
    
    // 1. 클라이언트에서 전송된 검색 키워드 파라미터 추출
    String keyword = request.getParameter("keyword");
    
    // 2. 검색 결과를 담을 리스트 초기화
    List<RestaurantDTO> resultList = new ArrayList<>();
    
    // 3. 에러 메시지 변수 초기화 (예외 발생시 사용자에게 표시할 메시지)
    String errorMessage = null;

    // 4. 검색 키워드 유효성 검사 및 데이터베이스 조회
    if (keyword != null && !keyword.trim().isEmpty()) {
        try {
            // DAO 객체 생성
            RestaurantDAO dao = new RestaurantDAO();
            
            // ★ 중요: 메서드명 오타 수정 (findRestauarntsByName → findRestaurantsByName)
            // 공백 제거를 위한 trim() 메서드 적용
            resultList = dao.findRestaurantsByName(keyword.trim());
            
        } catch (Exception e) {
            // 예외 발생시 로그 출력 및 사용자 친화적 에러 메시지 설정
            e.printStackTrace();
            errorMessage = "검색 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.";
        }
    }

    // 5. JSP 페이지에서 사용할 수 있도록 request 스코프에 데이터 저장
    request.setAttribute("resultList", resultList);
    request.setAttribute("searchKeyword", keyword != null ? keyword.trim() : "");
    request.setAttribute("errorMessage", errorMessage);
%>

<!-- 컨텍스트 패스를 JSTL 변수로 설정 (페이지 전체에서 사용 가능) -->
<c:set var="contextPath" value="<%= request.getContextPath() %>" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <!-- ===================================================================
         HTML 메타데이터 및 외부 리소스 임포트
         =================================================================== -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- SEO 최적화를 위한 동적 메타 태그 -->
    <meta name="description" content="<c:out value='${searchKeyword}'/> 맛집 검색 결과 - 맛집내놔">
    
    <!-- 동적 페이지 타이틀 설정 -->
    <title>
        <c:choose>
            <c:when test="${not empty searchKeyword}">
                "<c:out value='${searchKeyword}'/>" 검색 결과 - 맛집내놔
            </c:when>
            <c:otherwise>
                맛집 검색 - 맛집내놔
            </c:otherwise>
        </c:choose>
    </title>
    
    <!-- Bootstrap 5 CSS 프레임워크 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome 아이콘 라이브러리 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <!-- jQuery 라이브러리 -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <!-- Bootstrap JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <style>
        /* ===================================================================
           CSS 커스텀 스타일 정의
           =================================================================== */
        
        /* CSS 변수 정의 - 일관된 색상 테마 관리 */
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #e74c3c;
            --light-bg: #f8f9fa;
            --border-radius: 12px;
        }
        
        /* 전체 페이지 기본 스타일 */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--light-bg);
        }
        
        /* 상단 네비게이션 바 스타일 */
        .navbar {
            background: linear-gradient(135deg, var(--primary-color) 0%, #34495e 100%);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 1rem 0;
        }
        
        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
        }
        
        /* 검색 결과 헤더 섹션 스타일 */
        .search-header {
            background-image: url('<%= request.getContextPath()%>/images/background.jpg');
			background-size: cover;
			background-position: center;
			color: white;
			padding: 100px 0 120px 0;
			opacity: 0.75;
        }
        
        .search-title {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .search-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
        }
        
        /* 맛집 카드 호버 효과 */
        .card-hover {
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: var(--border-radius);
        }
        
        .card-hover:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.15);
        }
        
        /* 카드 이미지 스타일 및 호버 효과 */
        .card-img-top {
            height: 220px;
            object-fit: cover;
            transition: all 0.3s ease;
            border-radius: var(--border-radius) var(--border-radius) 0 0;
        }
        
        .card-hover:hover .card-img-top {
            transform: scale(1.05);
        }
        
        /* 검색 결과 없음 섹션 스타일 */
        .no-results {
            text-align: center;
            padding: 80px 20px;
            background: white;
            border-radius: var(--border-radius);
            box-shadow: 0 2px 15px rgba(0,0,0,0.08);
            margin: 40px 0;
        }
        
        .no-results i {
            font-size: 4rem;
            color: #ddd;
            margin-bottom: 30px;
        }
        
        .no-results h4 {
            color: #666;
            margin-bottom: 15px;
        }
        
        .no-results p {
            color: #999;
            margin-bottom: 30px;
        }
        
        /* 맛집 등록 버튼 스타일 */
        .btn-register {
            background: linear-gradient(45deg, #FF6B6B, #FF8E8E);
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 25px;
            transition: all 0.3s ease;
            font-weight: 600;
        }
        
        .btn-register:hover {
            background: linear-gradient(45deg, #FF5252, #FF7575);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 107, 107, 0.4);
            color: white;
        }
        
        /* 검색 결과 개수 표시 영역 */
        .result-count {
            background: white;
            padding: 20px;
            border-radius: var(--border-radius);
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }
        
        .result-count h5 {
            margin: 0;
            color: var(--primary-color);
        }
        
        /* 카드 내용 세부 스타일 */
        .card-category {
            background: #e8f4fd;
            color: #2196F3;
            font-size: 0.85rem;
            padding: 4px 12px;
            border-radius: 20px;
            display: inline-block;
            margin-bottom: 10px;
            font-weight: 500;
        }
        
        .card-address {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 15px;
        }
        
        .card-address i {
            color: #FF6B6B;
            margin-right: 8px;
        }
        
        /* 재검색 네비게이션 스타일 */
        .search-nav {
            padding: 15px 0;
            background: rgba(255,255,255,0.1);
            border-radius: var(--border-radius);
            margin-top: 20px;
        }
        
        .search-nav .form-control {
            border-radius: 8px;
            border: 2px solid rgba(255,255,255,0.3);
            background: rgba(255,255,255,0.9);
        }
        
        .search-nav .btn {
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <!-- 상단 네비게이션 바 -->
    <nav class="navbar navbar-expand-lg navbar-light shadow-sm">
        <div class="container">
            <!-- 로고 및 브랜드명 -->
            <a class="navbar-brand text-white" href="${contextPath}">
                <i class="fas fa-utensils me-2"></i>맛집내놔
            </a>
            
            <!-- 모바일 토글 버튼 -->
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <!-- 네비게이션 메뉴 -->
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}">홈</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/pages/review.jsp">리뷰</a>
                    </li>
                </ul>
                
                <!-- 로그인/로그아웃 버튼 영역 -->
                <div class="d-flex">
                    <c:choose>
                        <c:when test="${not empty sessionScope.loggedInUser}">
                            <!-- 로그인된 사용자 정보 표시 -->
                            <span class="navbar-text me-3 text-white">환영합니다, 
                                <c:out value="${sessionScope.loggedInUser}" default="사용자"/>님!
                            </span>
                            <a href="${contextPath}/logout.jsp" class="btn btn-outline-danger">로그아웃</a>
                        </c:when>
                        <c:otherwise>
                            <!-- 비로그인 사용자용 버튼 -->
                            <a href="${contextPath}/pages/login.jsp" class="btn btn-outline-primary me-2">로그인</a>
                            <a href="${contextPath}/pages/register.jsp" class="btn btn-primary">회원가입</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

    <!-- 검색 헤더 섹션 - 검색 키워드 및 결과 개수 표시 -->
    <section class="search-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="search-title">
                        <i class="fas fa-search me-3"></i>
                        <!-- XSS 방지를 위한 c:out 태그 사용 -->
                        "<c:out value='${searchKeyword}'/>" 검색 결과
                    </h1>
                    <p class="search-subtitle">
                        <!-- 검색 결과 유무에 따른 동적 메시지 표시 -->
                        <c:choose>
                            <c:when test="${not empty resultList}">
                                총 <strong>${fn:length(resultList)}개</strong>의 맛집을 찾았습니다
                            </c:when>
                            <c:otherwise>
                                검색 조건에 맞는 맛집이 없습니다
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div class="col-md-4">
                        <form action="search.jsp" method="get">
                            <div class="input-group">
                                <!-- 현재 검색어를 기본값으로 설정 -->
                                <input type="text" name="keyword" class="form-control" 
                                       placeholder="다른 키워드로 검색" 
                                       value="<c:out value='${searchKeyword}' default=''/>">
                                <button class="btn btn-warning" type="submit">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </form>
                </div>
            </div>
        </div>
    </section>

    <!-- 에러 메시지 표시 영역 (서버 오류 발생시에만 표시) -->
    <c:if test="${not empty errorMessage}">
        <div class="container mt-3">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <c:out value="${errorMessage}"/>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </div>
    </c:if>

    <div class="container my-5">
        <!-- 검색 결과가 있는 경우와 없는 경우를 나누어 처리 -->
        <c:choose>
            <c:when test="${not empty resultList}">
                <!-- 검색 결과 개수 및 맛집 등록 버튼 -->
                <div class="result-count">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <h5><i class="fas fa-list me-2"></i>검색된 맛집 ${fn:length(resultList)}곳</h5>
                        </div>
                        <div class="col-md-6 text-end">
                            <button class="btn btn-register" onclick="location.href='${contextPath}/pages/post.jsp'">
                                <i class="fas fa-plus me-2"></i>새 맛집 등록
                            </button>
                        </div>
                    </div>
                </div>

                <!-- 검색 결과 카드 그리드 -->
                <div class="row">
                    <!-- JSTL forEach를 사용한 검색 결과 반복 출력 -->
                    <c:forEach var="r" items="${resultList}">
                        <div class="col-lg-4 col-md-6 mb-4">
                            <!-- 개별 맛집 카드 -->
                            <div class="card card-hover h-100">
                                <!-- 맛집 이미지 (fallback 이미지 처리 포함) -->
                                <img src="<c:choose>
                                            <c:when test='${not empty r.imageUrl}'>
                                                ${contextPath}/image/<c:out value='${r.imageUrl}'/>
                                            </c:when>
                                            <c:otherwise>
                                                https://via.placeholder.com/400x220/FF9999/FFFFFF?text=맛집+이미지
                                            </c:otherwise>
                                        </c:choose>" 
                                     class="card-img-top" alt="<c:out value='${r.name}'/>"
                                   	 onerror="this.onerror=null; this.src='placeholder.jpg'">
                                
                                <!-- 카드 본문 내용 -->
                                <div class="card-body d-flex flex-column">
                                    <!-- 음식 카테고리 태그 -->
                                    <span class="card-category"><c:out value="${r.category}"/></span>
                                    
                                    <!-- 맛집명 (XSS 방지 처리) -->
                                    <h5 class="card-title mb-2"><c:out value="${r.name}"/></h5>
                                    
                                    <!-- 주소 (XSS 방지 처리) -->
                                    <p class="card-address">
                                        <i class="fas fa-map-marker-alt"></i><c:out value="${r.address}"/>
                                    </p>
                                    
                                    <!-- 맛집 설명 (80자 제한 + XSS 방지) -->
                                    <c:if test="${not empty r.description}">
                                        <p class="card-text text-muted mb-3">
                                            <c:choose>
                                                <c:when test="${fn:length(r.description) > 80}">
                                                    <c:out value="${fn:substring(r.description, 0, 80)}"/>...
                                                </c:when>
                                                <c:otherwise>
                                                    <c:out value="${r.description}"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </c:if>
                                    
                                    <!-- 하단 정보 영역 (별점, 전화번호, 상세보기 버튼) -->
                                    <div class="mt-auto">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <!-- 별점 표시 (1~5점) -->
                                            <c:if test="${not empty r.rating}">
                                                <div class="text-warning">
                                                    <!-- 별점을 별 아이콘으로 시각화 -->
                                                    <c:forEach begin="1" end="5" var="star">
                                                        <i class="<c:choose>
                                                                    <c:when test='${star <= r.rating}'>fas fa-star</c:when>
                                                                    <c:otherwise>far fa-star</c:otherwise>
                                                                </c:choose>"></i>
                                                    </c:forEach>
                                                    <span class="ms-1 text-dark">
                                                        <!-- 소수점 첫째자리까지 표시 -->
                                                        <fmt:formatNumber value="${r.rating}" pattern="0.0"/>
                                                    </span>
                                                </div>
                                            </c:if>
                                            <!-- 전화번호 (XSS 방지 처리) -->
                                            <c:if test="${not empty r.phone}">
                                                <small class="text-muted">
                                                    <i class="fas fa-phone me-1"></i><c:out value="${r.phone}"/>
                                                </small>
                                            </c:if>
                                        </div>
                                        <!-- 상세보기 버튼 -->
                                        <a href="${contextPath}/RestaurantDetailServlet?id=${r.restaurantId}" 
                                           class="btn btn-primary w-100">
                                            <i class="fas fa-eye me-2"></i>자세히 보기
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            
            <c:otherwise>
                <div class="no-results">
                    <!-- 검색 결과 없음 아이콘 -->
                    <i class="fas fa-search"></i>
                    <h4>찾으시는 맛집이 없으신가요?</h4>
                    <p>"<c:out value='${searchKeyword}'/>"에 대한 검색 결과가 없습니다.<br>
                       다른 키워드로 검색해보시거나, 직접 맛집을 등록해보세요!</p>
                    
                    <!-- 액션 버튼들 -->
                    <div class="d-flex justify-content-center gap-3">
                        <button class="btn btn-outline-primary" onclick="history.back()">
                            <i class="fas fa-arrow-left me-2"></i>돌아가기
                        </button>
                        <button class="btn btn-register" onclick="location.href='${contextPath}/pages/post.jsp'">
                            <i class="fas fa-plus me-2"></i>맛집 등록하기
                        </button>
                    </div>
                    
                    <!-- 추천 검색어 섹션 -->
                    <div class="mt-4">
                        <p class="mb-2"><strong>이런 키워드는 어떠세요?</strong></p>
                        <div class="d-flex justify-content-center gap-2 flex-wrap">
                            <!-- 인기 검색어들을 링크로 제공 -->
                            <a href="search.jsp?keyword=한식" class="btn btn-outline-secondary btn-sm">한식</a>
                            <a href="search.jsp?keyword=이탈리안" class="btn btn-outline-secondary btn-sm">이탈리안</a>
                            <a href="search.jsp?keyword=카페" class="btn btn-outline-secondary btn-sm">카페</a>
                            <a href="search.jsp?keyword=강남" class="btn btn-outline-secondary btn-sm">강남</a>
                            <a href="search.jsp?keyword=홍대" class="btn btn-outline-secondary btn-sm">홍대</a>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 하단 푸터 -->
    <footer class="bg-dark text-white text-center py-4 mt-5">
        <div class="container">
            <p>&copy; 2025 공간정보아카데미 Team3 웹페이지</p>
        </div>
    </footer>
</body>
</html>