<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>맛집내놔 - 맛집 추천 사이트</title>
<base href="${pageContext.request.contextPath}/">
<!-- 부트스트랩 5.3 CSS: 웹사이트의 전체적인 디자인과 레이아웃을 담당합니다. -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<!-- Font Awesome 아이콘: 다양한 아이콘을 사용하기 위한 라이브러리입니다. -->
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
	rel="stylesheet">
<!-- jQuery 라이브러리: DOM 조작 및 AJAX 요청을 간편하게 처리하기 위해 사용합니다. -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- 부트스트랩 5.3 JavaScript 번들: 드롭다운, 모달, 네비게이션바 토글 등 JS 기반 기능을 제공합니다. -->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<style>
/* CSS 변수: 일관된 디자인을 위해 전역 스타일 변수를 정의합니다. */
:root {
    --primary-color: #2c3e50; /* 기본 색상 (네이비 계열) */
    --secondary-color: #e74c3c; /* 보조 색상 (붉은 계열) */
    --light-bg: #f8f9fa; /* 밝은 배경색 */
    --border-radius: 12px; /* 모서리 둥글기 값 */
    --item-width: 350px;
}

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: var(--light-bg);
    padding-top: 50px;
}

/* 네비게이션 바 스타일: 상단 바의 색상, 그림자, 패딩 등을 설정합니다. */
.navbar {
    background: linear-gradient(135deg, var(--primary-color) 0%, #34495e 100%);
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    padding: 1rem 0;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 1000;
}

.btn-outline-primary {
    border-color: rgba(255,255,255,0.5);
    color: rgba(255,255,255,0.9);
}

.navbar-brand {
    font-weight: 700;
    font-size: 1.5rem;
    color: white !important;
}

.hero-section {
    background-image: url('<%= request.getContextPath()%>/images/background.jpg');
    background-size: cover;
    background-position: center;
    color: white;
    padding: 80px 0 60px 0;
    opacity: 0.75;
}

.search-box {
    max-width: 100%;
}

.filter-box {
    max-width: 450px;
}

/* 드롭다운 메뉴 스타일: 카테고리/지역 선택 드롭다운의 디자인을 꾸밉니다. */
.custom-select {
    border: 2px solid #fff;
    border-radius: 8px;
    padding: 8px 15px;
    font-size: 14px;
    background: rgba(255, 255, 255, 0.9);
    color: #333;
    transition: all 0.3s ease;
}

.custom-select:focus {
    border-color: #FFD700;
    box-shadow: 0 0 8px rgba(255, 215, 0, 0.3);
    outline: none;
}

.search-input {
    border: 2px solid #fff;
    border-radius: 8px;
    padding: 10px 15px;
    font-size: 14px;
    background: rgba(255, 255, 255, 0.9);
    color: #333;
}

.search-btn {
    border-radius: 8px;
    padding: 10px 20px;
    font-size: 14px;
}

/* 반응형 처리: 화면 크기가 768px 이하일 때 텍스트를 중앙 정렬합니다. */
@media (max-width: 768px) {
    .hero-section .row {
        text-align: center;
    }
    .hero-section .text-start {
        text-align: center !important;
    }
}

/* 카드 호버 효과: 마우스 오버 시 카드가 살짝 떠오르는 애니메이션을 적용합니다. */
.card-hover {
    transition: all 0.3s ease;
    border: none;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.card-hover:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
}

.card-img-top {
    height: 200px;
    object-fit: cover;
    transition: all 0.3s ease;
}

.card-hover:hover .card-img-top {
    transform: scale(1.05);
}

.section-title {
    text-align: left;
    margin: 50px 0 30px 0;
    font-weight: bold;
    color: #333;
    font-size: 1.8rem;
}

/* 맛집 등록 버튼 스타일 */
.btn-register {
    background: linear-gradient(45deg, #FF6B6B, #FF8E8E);
    border: none;
    color: white;
    padding: 10px 25px;
    border-radius: 25px;
    transition: all 0.3s ease;
}

.btn-register:hover {
    background: linear-gradient(45deg, #FF5252, #FF7575);
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(255, 107, 107, 0.4);
}

/* TOP 10 슬라이드 스타일 */
.top10-carousel {
    position: relative;
    padding: 0 60px; /* 버튼 공간 확보 */
    margin: 0 -15px; /* 컨테이너 여백 조정 */
}

.top10-slide-wrapper {
    overflow: hidden;
    border-radius: 10px;
    width: 100%;
}

.top10-slide-container {
    display: flex;
    transition: transform 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
    gap: 16px;
    padding: 20px 0;
    flex-wrap: nowrap;
}

.top10-item {
	 flex: 0 0 var(--item-width, 350px);   
    position: relative;
    background: white;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
    transition: all 0.3s ease;
    cursor: pointer;
    border: 1px solid #f0f0f0;
}

.top10-item:hover {
    transform: translateY(-6px);
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
}

.top10-item img {
    width: 100%;
    height: 300px;
    object-fit: cover;
    transition: transform 0.3s ease;
}

.top10-item:hover img {
    transform: scale(1.05);
}

.top10-rank {
    position: absolute;
    top: 8px;
    left: 8px;
    background: rgba(255, 107, 107, 0.95);
    color: white;
    padding: 3px 8px;
    border-radius: 12px;
    font-weight: 700;
    font-size: 11px;
    box-shadow: 0 2px 6px rgba(255, 107, 107, 0.3);
    z-index: 2;
    min-width: 18px;
    text-align: center;
}

.top10-content {
    padding: 12px;
}

.top10-content h6 {
    margin-bottom: 4px;
    font-weight: 600;
    color: #333;
    font-size: 13px;
    line-height: 1.3;
    display: -webkit-box;
    -webkit-line-clamp: 1;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.top10-content small {
    color: #888;
    font-size: 11px;
    display: block;
    margin-bottom: 6px;
}

.rating-stars {
    font-size: 11px;
    display: flex;
    align-items: center;
    gap: 1px;
}

.rating-stars i {
    color: #ffc107;
}

.rating-stars .rating-score {
    margin-left: 4px;
    font-size: 11px;
    font-weight: 600;
    color: #333;
}

/* 슬라이드 컨트롤 버튼 - 이미지와 동일한 스타일 */
.slide-btn {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    background: white;
    color: #666;
    border: 1px solid #e0e0e0;
    border-radius: 50%;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.3s ease;
    z-index: 10;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.slide-btn:hover {
    background: #f8f9fa;
    border-color: #ccc;
    color: #333;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
}

.slide-btn:active {
    transform: translateY(-50%) scale(0.95);
}

.slide-btn.prev {
    left: 15px;
}

.slide-btn.next {
    right: 15px;
}

.slide-btn.disabled {
    opacity: 0.4;
    cursor: not-allowed;
    pointer-events: none;
}

/* 반응형 처리: 각 아이템의 너비가 변하면, 슬라이더 컨테이너의 너비도 함께 수정 */
@media (max-width: 1200px) {
    .top10-item {
        flex: 0 0 180px;
    }
    .top10-slide-container {
        /* 수정: 아이템 너비에 맞춰 컨테이너 너비 다시 계산 */
        width: calc(180px * 10 + 16px * 9);
    }
}

@media (max-width: 768px) {
    .top10-item {
        flex: 0 0 160px;
    }
    .top10-slide-container {
        /* 수정: 아이템 너비에 맞춰 컨테이너 너비 다시 계산 */
        width: calc(160px * 10 + 16px * 9);
    }
}

@media (max-width: 480px) {
    .top10-item {
        flex: 0 0 140px;
    }
    .top10-slide-container {
        /* 수정: 아이템 너비에 맞춰 컨테이너 너비 다시 계산 */
        width: calc(140px * 10 + 16px * 9);
    }
}
</style>
</head>
<body>
	<!-- 헤더: 페이지 상단 네비게이션바. 로그인 상태에 따라 UI가 변경됩니다. -->
	<nav class="navbar navbar-expand-lg navbar-dark">
		<div class="container">
			<!-- 로고 및 브랜드 이름 -->
			<a class="navbar-brand text-white" href=""> <i class="fas fa-utensils me-2"></i>맛집내놔
			</a>

			<!-- 모바일 환경에서 메뉴를 토글하는 버튼 -->
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarNav">
				<span class="navbar-toggler-icon"></span>
			</button>

			<div class="collapse navbar-collapse" id="navbarNav">
				<!-- 네비게이션 메뉴 목록 -->
				<ul class="navbar-nav me-auto">
					<li class="nav-item"><a class="nav-link active" href="">홈</a>
					</li>
					<li class="nav-item"><a class="nav-link"
						href="pages/review.jsp">리뷰</a></li>
				</ul>

				<!-- 로그인/회원가입 버튼 또는 사용자 정보 표시 -->
				<div class="d-flex">
					<c:choose>
						<%-- JSTL을 사용하여 로그인 세션 'loggedInUser'가 비어있지 않으면 (로그인 상태) --%>
						<c:when test="${not empty sessionScope.loggedInUser}">
							<!-- 로그인한 사용자 이름과 로그아웃 버튼을 표시합니다. -->
							<span class="navbar-text me-3 text-white">환영합니다, <c:out
									value="${sessionScope.userName}" default="사용자" />님!
							</span>
							<a href="pages/logout.jsp" class="btn btn-outline-danger">로그아웃</a>
						</c:when>
						<%-- 로그인 세션이 없을 경우 (비로그인 상태) --%>
						<c:otherwise>
							<!-- 로그인 및 회원가입 버튼을 표시합니다. -->
							<a href="pages/login.jsp" class="btn btn-outline-primary me-2">로그인</a>
							<a href="pages/register.jsp" class="btn btn-primary">회원가입</a>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
	</nav>

	<!-- 히어로 섹션: 페이지 상단에 위치한 환영 메시지 및 검색/필터 영역입니다. -->
	<section class="hero-section">
		<div class="container">
			<div class="row align-items-center">
				<div class="col-md-8">
					<div class="text-start">
						<h1 class="display-4 mb-3">서울 구석구석 <br/> 숨은 맛집을 발견하세요</h1> 
						<p class="lead mb-4">맛집 줄게, 맛집 DAO</p>
					</div>
				</div>

				<div class="col-md-4">
					<!-- 검색 폼: 키워드를 입력받아 search.jsp로 전송합니다. -->
					<form action="pages/search.jsp" method="get">
						<div class="search-box mb-3">
							<div class="input-group">
								<input type="text" name="keyword"
									class="form-control search-input" placeholder="맛집이름 검색"
									value="<c:out value='${param.keyword}' default=''/>">
								<button class="btn btn-warning search-btn" type="submit">
									<i class="fas fa-search"></i> 검색
								</button>
							</div>
						</div>
					</form>

					<!-- 카테고리 및 지역 선택 드롭다운 -->
					<div class="filter-box">
						<div class="row g-2">
							<div class="col-6">
								<select class="form-select custom-select"
									onchange="selectCategory(this.value)">
									<option value="">음식 카테고리</option>
									<%-- 서버에서 전달된 카테고리 목록을 동적으로 생성합니다. --%>
									<c:if test="${not empty categoryList}">
										<c:forEach var="category" items="${categoryList}">
											<option value="${category.code}"
												<c:if test="${param.category eq category.code}">selected</c:if>>
												<c:out value="${category.name}" />
											</option>
										</c:forEach>
									</c:if>
									<!-- 하드코딩된 기본 카테고리 목록 -->
									<option value="한식"
										<c:if test="${param.category eq 'korean'}">selected</c:if>>한식</option>
									<option value="중식"
										<c:if test="${param.category eq 'chinese'}">selected</c:if>>중식</option>
									<option value="양식"
										<c:if test="${param.category eq 'western'}">selected</c:if>>양식</option>
									<option value="일식"
										<c:if test="${param.category eq 'japanese'}">selected</c:if>>일식</option>
									<option value="디저트"
										<c:if test="${param.category eq 'dessert'}">selected</c:if>>디저트</option>
									<option value="패스트푸드"
										<c:if test="${param.category eq 'fastfood'}">selected</c:if>>패스트푸드</option>
								</select>
							</div>
							<div class="col-6">
								<select class="form-select custom-select"
									onchange="selectRegion(this.value)">
									<option value="">핫플 지역</option>
									<%-- 서버에서 전달된 지역 목록을 동적으로 생성합니다. --%>
									<c:if test="${not empty regionList}">
										<c:forEach var="region" items="${regionList}">
											<option value="${region.code}"
												<c:if test="${param.region eq region.code}">selected</c:if>>
												<c:out value="${region.name}" />
											</option>
										</c:forEach>
									</c:if>
									<!-- 하드코딩된 기본 지역 목록 -->
									<option value="seongsu"
										<c:if test="${param.region eq 'seongsu'}">selected</c:if>>성수</option>
									<option value="gangnam"
										<c:if test="${param.region eq 'gangnam'}">selected</c:if>>강남</option>
									<option value="hongdae"
										<c:if test="${param.region eq 'hongdae'}">selected</c:if>>홍대</option>
									<option value="jamsil"
										<c:if test="${param.region eq 'jamsil'}">selected</c:if>>잠실</option>
									<option value="yongsan"
										<c:if test="${param.region eq 'yongsan'}">selected</c:if>>용산</option>
								</select>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>

	<!-- 인기 TOP 10 섹션: 데이터베이스에서 가져온 인기 맛집 목록을 슬라이드로 표시합니다. -->
	<section class="container my-5">
		<div class="mb-4">
			<h2 class="section-title">인기 TOP 10</h2>
		</div>

		<div class="top10-carousel">
			<!-- 슬라이더 이전 버튼 -->
			<button class="slide-btn prev" id="prevBtn"
				onclick="slideTop10('prev')">
				<i class="fas fa-chevron-left"></i>
			</button>
			<!-- 슬라이더 다음 버튼 -->
			<button class="slide-btn next" id="nextBtn"
				onclick="slideTop10('next')">
				<i class="fas fa-chevron-right"></i>
			</button>

			<div class="top10-slide-wrapper">
				<div class="top10-slide-container" id="top10Container">
					<!-- JSTL을 사용하여 'topRestaurants' 리스트의 데이터를 동적으로 반복하여 표시합니다. -->
					<c:choose>
						<c:when test="${not empty topRestaurants}">
							<c:forEach var="restaurant" items="${topRestaurants}"
								varStatus="status">
								<!-- 각 맛집 정보를 카드 형태로 보여줍니다. 클릭 시 상세 페이지로 이동 -->
								<div class="top10-item"
									onclick="location.href='RestaurantDetailServlet?id=${restaurant.restaurantId}'">
									<div class="top10-rank">${status.index + 1}</div>
									<c:choose>
										<c:when test="${not empty restaurant.imageUrl}">
											<img src="image/${restaurant.imageUrl}" class="card-img-top"
												alt="<c:out value='${restaurant.name}'/>">
										</c:when>
										<c:otherwise>
											<img
												src="https://via.placeholder.com/400x250/FF9999/FFFFFF?text=랭킹맛집"
												class="card-img-top"
												alt="<c:out value='${restaurant.name}'/>">
										</c:otherwise>
									</c:choose>
									<div class="top10-content">
										<h6>
											<c:out value="${restaurant.name}" />
										</h6>
										<small><c:out value="${restaurant.address}" /></small>
										<c:if test="${not empty restaurant.rating}">
											<div class="rating-stars">
												<c:forEach begin="1" end="5" var="star">
													<c:choose>
														<c:when test="${restaurant.rating >= star}">
															<i class="fas fa-star"></i>
															<!-- 평점보다 낮거나 같으면 꽉 찬 별 -->
														</c:when>
														<c:otherwise>
															<i class="far fa-star"></i>
															<!-- 평점보다 높으면 빈 별 -->
														</c:otherwise>
													</c:choose>
												</c:forEach>
												<span class="rating-score"><fmt:formatNumber
														value="${restaurant.rating}" pattern="0.0" /></span>
											</div>
										</c:if>
									</div>
								</div>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<!-- TOP 10 맛집 데이터가 없을 경우 표시되는 메시지 -->
							<div class="text-center py-5">
								<p>등록된 맛집이 없습니다.</p>
							</div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
	</section>

	<!-- 추천맛집 섹션: 데이터베이스에서 가져온 추천 맛집 목록을 카드 형태로 표시합니다. -->
	<section class="container my-5">
		<div class="d-flex justify-content-between align-items-center mb-4">
			<h2 class="section-title">추천맛집</h2>
			<c:choose>
				<%-- JSTL을 사용해 로그인 상태에 따라 '맛집등록' 버튼의 동작을 다르게 설정합니다. --%>
				<c:when test="${not empty sessionScope.loggedInUser}">
					<button class="btn btn-register"
						onclick="location.href='pages/post.jsp'">
						<i class="fas fa-plus me-2"></i>맛집등록
					</button>
				</c:when>
				<c:otherwise>
					<button class="btn btn-register"
						onclick="alert('로그인이 필요한 서비스입니다.');">
						<i class="fas fa-plus me-2"></i>맛집등록
					</button>
				</c:otherwise>
			</c:choose>
		</div>

		<div class="row">
			<!-- JSTL을 사용하여 'recommendedRestaurants' 리스트의 데이터를 동적으로 반복하여 표시합니다. -->
			<c:choose>
				<c:when test="${not empty recommendedRestaurants}">
					<c:forEach var="restaurant" items="${recommendedRestaurants}"
						varStatus="status">
						<div class="col-md-4 mb-4">
							<!-- 각 추천 맛집을 카드 형태로 보여줍니다. 클릭 시 상세 페이지로 이동 -->
							<div class="card card-hover h-100"
								onclick="location.href='RestaurantDetailServlet?id=${restaurant.restaurantId}'">
								<c:choose>
									<c:when test="${not empty restaurant.imageUrl}">
										<img src="image/${restaurant.imageUrl}" class="card-img-top"
											alt="<c:out value='${restaurant.name}'/>">
									</c:when>
									<c:otherwise>
										<img
											src="https://via.placeholder.com/400x250/FF9999/FFFFFF?text=추천맛집"
											class="card-img-top"
											alt="<c:out value='${restaurant.name}'/>">
									</c:otherwise>
								</c:choose>
								<div class="card-body">
									<h5 class="card-title">
										<c:out value="${restaurant.name}" />
									</h5>
									<p class="card-text">
										<c:choose>
											<c:when test="${fn:length(restaurant.description) > 50}">
												<c:out
													value="${fn:substring(restaurant.description, 0, 50)}" />...
                                            </c:when>
											<c:otherwise>
												<c:out value="${restaurant.description}" />
											</c:otherwise>
										</c:choose>
									</p>
									<div class="d-flex justify-content-between align-items-center">
										<small class="text-muted"><c:out
												value="${restaurant.address}" /></small>
										<div class="text-warning">
											<c:forEach begin="1" end="5" var="star">
												<c:choose>
													<c:when test="${restaurant.rating >= star}">
														<i class="fas fa-star"></i>
														<!-- 평점보다 낮거나 같으면 꽉 찬 별 -->
													</c:when>
													<c:otherwise>
														<i class="far fa-star"></i>
														<!-- 평점보다 높으면 빈 별 -->
													</c:otherwise>
												</c:choose>
											</c:forEach>
											<span class="ms-1"> <c:choose>
													<c:when test="${not empty restaurant.rating}">
														<fmt:formatNumber value="${restaurant.rating}"
															pattern="0.0" />
													</c:when>
													<c:otherwise>0.0</c:otherwise>
												</c:choose>
											</span>
										</div>
									</div>
								</div>
							</div>
						</div>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<!-- 추천 맛집 데이터가 없을 경우 표시되는 메시지 -->
					<div class="col-12 text-center py-5">
						<p>등록된 추천 맛집이 없습니다.</p>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</section>

	<!-- 푸터: 페이지 하단 저작권 정보 -->
	<footer class="bg-dark text-white text-center py-4 mt-5">
		<div class="container">
			<p>
				&copy;
				<fmt:formatDate value="${now}" pattern="yyyy" var="currentYear" />
				<c:out value="${not empty currentYear ? currentYear : '2025'}" />
				공간정보아카데미 Team3. All rights reserved.
			</p>
		</div>
	</footer>

	<script>
	
    // 전역 변수 선언: 슬라이더의 현재 상태를 추적하기 위해 사용됩니다.
    let currentSlide = 0; // 현재 보고 있는 슬라이드 인덱스
    let itemsPerSlide = 3; // 한 번에 보여줄 아이템의 개수
    let itemWidth = 0; // 아이템 하나의 너비 (반응형 계산을 위해 필요)
    let totalItems = 0; // 전체 아이템의 총 개수
    let maxSlide = 0; // 최대로 슬라이드할 수 있는 횟수
    let isAnimating = false; // 슬라이드 애니메이션 중 중복 클릭을 방지하기 위한 플래그
    
    // 화면 너비에 따라 한 번에 보여줄 아이템 수를 계산하는 함수
    function calculateItemsPerSlide() {
        if (window.innerWidth >= 1200) { // Large desktops
            return 3;
        } else if (window.innerWidth >= 992) { // Desktops
            return 3;
        } else if (window.innerWidth >= 768) { // Tablets
            return 2;
        } else if (window.innerWidth >= 576) { // Small tablets
            return 1;
        } else { // Mobile
            return 1;
        }
    }

    // 아이템 하나의 너비를 계산하는 함수
    function calculateItemWidth() {
        const container = document.getElementById('top10Container');
        const firstItem = container.querySelector('.top10-item');
        
        if (firstItem) {
        	
       	 	// ✅ 수정된 로직: 아이템 자체의 너비만 정확하게 계산
            itemWidth = firstItem.getBoundingClientRect().width;
            
        	// const containerWidth = container.offsetWidth;
            const containerStyle = getComputedStyle(container);
            const gap = parseFloat(containerStyle.gap) || 16; // 아이템 간 간격
            
            itemsPerSlide = calculateItemsPerSlide();
            totalItems = container.children.length; // 총 아이템 수 다시 계산
            maxSlide = Math.max(0, Math.ceil(totalItems / itemsPerSlide) - 1);
            
            console.log('계산된 itemsPerSlide:', itemsPerSlide);
        } else {
            itemWidth = 350; // 아이템이 없을 경우 기본값 설정
        }
    }
    
 	// 슬라이더를 초기화하는 함수 (일부 수정)
    function initializeSlider() {
        const container = document.getElementById('top10Container');
        if (!container) {
            return;
        }
        
        totalItems = container.children.length;
        if (totalItems === 0) return;
        
        calculateItemWidth();
        
        if (itemsPerSlide === 0) {
            itemsPerSlide = 1;
        }
        
        maxSlide = Math.max(0, Math.ceil(totalItems / itemsPerSlide) - 1);
        currentSlide = 0;
        container.style.transform = 'translateX(0px)';
        updateButtonState();
    }
    
 	// 슬라이더를 이동시키는 함수 (최종 수정)
    function slideTop10(direction) {
        if (isAnimating) {
            return;
        }
        
        const container = document.getElementById('top10Container');
        if (!container || container.children.length === 0) {
            return;
        }
        
        // 슬라이드 시 너비 및 상태를 다시 계산
        calculateItemsPerSlide(); // 보여줄 아이템 수 계산
        
        const canMoveNext = direction === 'next' && currentSlide < maxSlide;
        const canMovePrev = direction === 'prev' && currentSlide > 0;
        
        if (canMoveNext) {
            currentSlide++;
        } else if (canMovePrev) {
            currentSlide--;
        } else {
            return;
        }

        const firstItem = container.querySelector('.top10-item');
        const gap = parseFloat(getComputedStyle(container).gap) || 16;
        const itemFullWidth = firstItem.getBoundingClientRect().width + gap;
        
        // ✅ 수정된 로직: 이동 거리를 정확하게 계산
        const translateX = -currentSlide * itemsPerSlide * itemFullWidth;
        
        isAnimating = true;
        container.style.transform = `translateX(${translateX}px)`;
        
        setTimeout(() => {
            isAnimating = false;
        }, 400);
        
        updateButtonState();
    }

    
    // 슬라이더 버튼의 활성화/비활성화 상태를 업데이트하는 함수
    function updateButtonState() {
        const prevBtn = document.getElementById('prevBtn');
        const nextBtn = document.getElementById('nextBtn');
        
        if (!prevBtn || !nextBtn) {
            return;
        }
        
        calculateItemsPerSlide(); // 동적 버튼 표시를 위해 아이템 수를 다시 계산합니다.
        
        // 전체 아이템 수가 한 번에 보여줄 아이템 수보다 적으면 버튼을 숨깁니다.
        if (totalItems <= itemsPerSlide) {
            prevBtn.style.display = 'none';
            nextBtn.style.display = 'none';
            return;
        }
        
        // 아이템이 충분하면 버튼을 다시 표시합니다.
        prevBtn.style.display = 'flex';
        nextBtn.style.display = 'flex';
        
        const prevDisabled = currentSlide <= 0; // 첫 번째 슬라이드이면 이전 버튼 비활성화
        const nextDisabled = currentSlide >= maxSlide; // 마지막 슬라이드이면 다음 버튼 비활성화
        
        prevBtn.classList.toggle('disabled', prevDisabled);
        nextBtn.classList.toggle('disabled', nextDisabled);
    }
    
 	// 유틸리티 함수
    function navigateTo(path) {
        window.location.href = '${pageContext.request.contextPath}/' + path;
    }
    
    // 카테고리 선택 시 페이지를 이동시키는 함수
    function selectCategory(category) {
        if(category) {
        	navigateTo('category?type=' + category);
        }
    }
    
    // 지역 선택 시 페이지를 이동시키는 함수
    function selectRegion(region) {
        if(region) {
        	navigateTo('region?area=' + region);
        }
    }
    
    // 페이지 로드 후 DOM이 준비되었을 때 슬라이더를 초기화합니다.
    document.addEventListener('DOMContentLoaded', function() {
        initializeSlider();
    });
    
    // 페이지의 모든 리소스(이미지 등)가 완전히 로드된 후 슬라이더를 다시 초기화합니다.
    window.addEventListener('load', function() {
        initializeSlider();
    });
    
    // 화면 크기가 변경될 때 슬라이더를 재설정합니다.
    let resizeTimeout;
    window.addEventListener('resize', function() {
        clearTimeout(resizeTimeout);
        resizeTimeout = setTimeout(() => {
            currentSlide = 0; // 슬라이드 위치를 0으로 재설정
            isAnimating = false;
            initializeSlider();
        }, 250);
    });
    
    $(document).ready(function() {
        // 리뷰 등록 후 돌아온 경우 새로고침
        if(sessionStorage.getItem('refreshMain') === 'true') {
            sessionStorage.removeItem('refreshMain');
            location.reload();
        	}
     	})
    
	</script>

	<!-- 부트스트랩 5.3 JavaScript 번들: 이미 head에 선언되어 있으므로 제거 가능 -->
</body>
</html>