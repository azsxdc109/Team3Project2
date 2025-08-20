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
<title>맛집내놔 - 카테고리 맛집</title>
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

/* 1. body 스타일 수정 - padding-bottom 제거 */
body {
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	background-color: var(--light-bg);
	/* padding-bottom: 50px; <- 이 줄 삭제 */
	padding-top: 80px;
	/* 최소 높이를 화면 전체로 설정 */
	min-height: 100vh;
	display: flex;
	flex-direction: column;
}

/* 2. 메인 컨테이너에 flex-grow 추가 */
.main-content {
	/* 남은 공간을 모두 차지 */
	flex: 1;
}

/* 3. 푸터 스타일 수정 */
.footer {
	background-color: #343a40;
	color: #fff;
	padding: 20px 0;
	text-align: center;
	margin-top: auto; /* 자동으로 하단에 배치 */
	/* position과 bottom 속성 제거 */
}

/* 네비게이션 바 스타일 */
.navbar {
	background: linear-gradient(135deg, var(--primary-color) 0%, #34495e
		100%);
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
	padding: 1rem 0;
	/* 헤더를 페이지 최상단에 고정 */
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	z-index: 1000;
	width: 100%;
}

.navbar-brand {
	font-weight: 700;
	font-size: 1.5rem;
}

/* 카드 호버 효과 */
.card-hover {
	transition: all 0.3s ease;
	border: none;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	cursor: pointer;
}

.card-hover:hover {
	transform: translateY(-5px);
	box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
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

/* 카테고리 선택 버튼 스타일 (기존 CSS에 추가) */

/* 카테고리 선택 섹션 스타일 */
.category-selection {
	background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
	border-radius: var(--border-radius);
	padding: 40px 20px;
	margin: 20px 0;
}

/* 카테고리 버튼 기본 스타일 */
.btn-category {
	transition: all 0.3s ease;
	border-width: 2px;
	font-weight: 600;
	margin: 8px;
	min-width: 120px;
	border-radius: 25px;
}

/* 각 카테고리별 호버 효과 */
.btn-outline-success:hover {
	transform: translateY(-3px);
	box-shadow: 0 8px 20px rgba(40, 167, 69, 0.3);
}

.btn-outline-primary:hover {
	transform: translateY(-3px);
	box-shadow: 0 8px 20px rgba(0, 123, 255, 0.3);
}

.btn-outline-warning:hover {
	transform: translateY(-3px);
	box-shadow: 0 8px 20px rgba(255, 193, 7, 0.3);
}

.btn-outline-info:hover {
	transform: translateY(-3px);
	box-shadow: 0 8px 20px rgba(23, 162, 184, 0.3);
}

.btn-outline-danger:hover {
	transform: translateY(-3px);
	box-shadow: 0 8px 20px rgba(220, 53, 69, 0.3);
}

.btn-outline-dark:hover {
	transform: translateY(-3px);
	box-shadow: 0 8px 20px rgba(52, 58, 64, 0.3);
}

/* 경고 알림창 스타일 개선 */
.alert-warning {
	border-radius: var(--border-radius);
	border-left: 4px solid #ffc107;
	background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
}

/* 모바일 반응형 - 카테고리 버튼 */
@media ( max-width : 768px) {
	.btn-category {
		min-width: 100px;
		font-size: 0.9rem;
		margin: 4px;
	}
	.btn-lg {
		padding: 10px 16px;
		font-size: 1rem;
	}
}

/* 모바일 반응형 */
@media ( max-width : 991px) {
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

@media ( max-width : 576px) {
	body {
		padding-top: 65px;
	}
	.page-header {
		padding: 40px 0;
	}
}

/* 카테고리 JSP의 <style> 태그 안에 추가할 CSS */

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
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
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

/* 검색 결과 없음 섹션 스타일 */
.no-results {
	text-align: center;
	padding: 80px 20px;
	background: white;
	border-radius: var(--border-radius);
	box-shadow: 0 2px 15px rgba(0, 0, 0, 0.08);
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

/* 카드 이미지 높이 통일 (search.jsp와 동일하게) */
.card-img-top {
	height: 220px; /* 200px에서 220px로 변경 */
	object-fit: cover;
	transition: all 0.3s ease;
	border-radius: var(--border-radius) var(--border-radius) 0 0;
}

.card-hover:hover .card-img-top {
	transform: scale(1.05);
}
</style>
</head>
<body>
	<!-- JSTL을 사용하여 URL 파라미터(type)에 따라 한글 카테고리명을 설정합니다. -->
	<c:set var="categoryName" value="${param.type}" />
	<c:choose>
		<c:when test="${categoryName eq '한식'}">
			<c:set var="categoryName" value="한식" />
		</c:when>
		<c:when test="${categoryName eq '중식'}">
			<c:set var="categoryName" value="중식" />
		</c:when>
		<c:when test="${categoryName eq '양식'}">
			<c:set var="categoryName" value="양식" />
		</c:when>
		<c:when test="${categoryName eq '일식'}">
			<c:set var="categoryName" value="일식" />
		</c:when>
		<c:when test="${categoryName eq '디저트'}">
			<c:set var="categoryName" value="디저트" />
		</c:when>
		<c:when test="${categoryName eq '패스트푸드'}">
			<c:set var="categoryName" value="패스트푸드" />
		</c:when>
		<c:otherwise>
			<c:set var="categoryName" value="전체" />
		</c:otherwise>
	</c:choose>

	<!-- 헤더: 페이지 상단 네비게이션바 -->
	  <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}">
                <i class="fas fa-utensils me-2"></i>맛집내놔
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}">홈</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/pages/review.jsp">리뷰</a>
                    </li>
                </ul>
                
                <div class="d-flex">
                    <c:choose>
                        <c:when test="${not empty sessionScope.loggedInUser}">
                            <span class="navbar-text me-3">
                                환영합니다, <c:out value="${sessionScope.userName}" default="사용자"/>님!
                            </span> 
                            <a href="${pageContext.request.contextPath}/pages/logout.jsp" class="btn btn-outline-danger">로그아웃</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/pages/login.jsp" class="btn btn-outline-primary me-2">로그인</a>
                            <a href="${pageContext.request.contextPath}/pages/register.jsp" class="btn btn-primary">회원가입</a>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

	<!-- 메인 컨텐츠 영역 -->
	<div class="main-content">
		<!-- 페이지 헤더: 현재 카테고리명을 표시합니다. -->
		<div class="page-header">
			<div class="container">
				<!-- JSTL로 설정된 한글 카테고리명 변수를 사용합니다. -->
				<h1 id="pageTitle">${categoryName}맛집</h1>
				<p class="lead">선택하신 카테고리의 맛집들을 찾아보세요.</p>
			</div>
		</div>

		<!-- 에러 메시지 표시 영역 (서버 오류 발생시에만 표시) -->
		<c:if test="${not empty errorMessage}">
			<div class="container mt-3">
				<div class="alert alert-warning alert-dismissible fade show"
					role="alert">
					<i class="fas fa-exclamation-triangle me-2"></i>
					<c:out value="${errorMessage}" />
					<button type="button" class="btn-close" data-bs-dismiss="alert"></button>
				</div>
			</div>
		</c:if>

		<!-- 카테고리 JSP의 맛집 목록 섹션을 search.jsp와 동일하게 수정 -->
		<div class="container">
			<div class="row" id="restaurantList">
				<!-- JSTL을 사용하여 서버에서 전달받은 'restaurants' 리스트를 동적으로 표시합니다. -->
				<c:choose>
					<c:when test="${not empty restaurants}">
						<!-- 검색 결과 개수 및 맛집 등록 버튼 (search.jsp와 동일한 스타일) -->
						<div class="col-12">
							<div class="result-count">
								<div class="row align-items-center">
									<div class="col-md-6">
										<h5>
											<i class="fas fa-list me-2"></i>${categoryName} 맛집
											${fn:length(restaurants)}곳
										</h5>
									</div>
									<div class="col-md-6 text-end">
										<c:choose>
											<%-- JSTL을 사용해 로그인 상태에 따라 '맛집등록' 버튼의 동작을 다르게 설정합니다. --%>
											<c:when test="${not empty sessionScope.loggedInUser}">
												<button class="btn btn-register"
													onclick="location.href='${pageContext.request.contextPath}/pages/post.jsp'">
													<i class="fas fa-plus me-2"></i>새 맛집 등록
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
								</div>
							</div>
						</div>

						<!-- 맛집 카드 그리드 (search.jsp와 완전히 동일) -->
						<c:forEach var="restaurant" items="${restaurants}">
							<div class="col-lg-4 col-md-6 mb-4">
								<!-- 개별 맛집 카드 -->
								<div class="card card-hover h-100">
									<!-- 맛집 이미지 (fallback 이미지 처리 포함) -->
									<img
										src="<c:choose>
	                                        <c:when test='${not empty restaurant.imageUrl}'>
	                                            ${pageContext.request.contextPath}/image/<c:out value='${restaurant.imageUrl}'/>
	                                        </c:when>
	                                        <c:otherwise>
	                                            https://via.placeholder.com/400x220/FF9999/FFFFFF?text=맛집+이미지
	                                        </c:otherwise>
	                                    </c:choose>"
										class="card-img-top" alt="<c:out value='${restaurant.name}'/>"
										onerror="this.onerror=null; this.src='placeholder.jpg'">

									<!-- 카드 본문 내용 -->
									<div class="card-body d-flex flex-column">
										<!-- 음식 카테고리 태그 -->
										<span class="card-category"><c:out
												value="${restaurant.category}" /></span>

										<!-- 맛집명 (XSS 방지 처리) -->
										<h5 class="card-title mb-2">
											<c:out value="${restaurant.name}" />
										</h5>

										<!-- 주소 (XSS 방지 처리) -->
										<p class="card-address">
											<i class="fas fa-map-marker-alt"></i>
											<c:out value="${restaurant.address}" />
										</p>

										<!-- 맛집 설명 (80자 제한 + XSS 방지) -->
										<c:if test="${not empty restaurant.description}">
											<p class="card-text text-muted mb-3">
												<c:choose>
													<c:when test="${fn:length(restaurant.description) > 80}">
														<c:out
															value="${fn:substring(restaurant.description, 0, 80)}" />...
	                                            </c:when>
													<c:otherwise>
														<c:out value="${restaurant.description}" />
													</c:otherwise>
												</c:choose>
											</p>
										</c:if>

										<!-- 하단 정보 영역 (별점, 전화번호, 상세보기 버튼) -->
										<div class="mt-auto">
											<div
												class="d-flex justify-content-between align-items-center mb-3">
												<!-- 별점 표시 (1~5점) -->
												<c:if test="${not empty restaurant.rating}">
													<div class="text-warning">
														<!-- 별점을 별 아이콘으로 시각화 -->
														<c:forEach begin="1" end="5" var="star">
															<i
																class="<c:choose>
	                                                                <c:when test='${star <= restaurant.rating}'>fas fa-star</c:when>
	                                                                <c:otherwise>far fa-star</c:otherwise>
	                                                            </c:choose>"></i>
														</c:forEach>
														<span class="ms-1 text-dark"> <!-- 소수점 첫째자리까지 표시 -->
															<fmt:formatNumber value="${restaurant.rating}"
																pattern="0.0" />
														</span>
													</div>
												</c:if>
												<!-- 전화번호 (XSS 방지 처리) -->
												<c:if test="${not empty restaurant.phone}">
													<small class="text-muted"> <i
														class="fas fa-phone me-1"></i> <c:out
															value="${restaurant.phone}" />
													</small>
												</c:if>
											</div>
											<!-- 상세보기 버튼 -->
											<a
												href="${pageContext.request.contextPath}/RestaurantDetailServlet?id=${restaurant.restaurantId}"
												class="btn btn-primary w-100"> <i
												class="fas fa-eye me-2"></i>자세히 보기
											</a>
										</div>
									</div>
								</div>
							</div>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<div class="col-12">
							<div class="no-results">
								<!-- 검색 결과 없음 아이콘 -->
								<i class="fas fa-exclamation-triangle fa-2x mb-3"></i>
								<h4>선택하신 카테고리에 등록된 맛집이 없습니다.</h4>
								<p>${categoryName}
									카테고리에 아직 등록된 맛집이 없습니다.<br> 첫 번째로 맛집을 등록해보세요!
								</p>

								<div class="d-grid gap-2 d-md-flex justify-content-md-center">
									<button class="btn btn-lg btn-outline-secondary"
										onclick="history.back()">
										<span class="d-flex align-items-center justify-content-center">
											돌아가기
										</span>
									</button>
									<c:choose>
										<c:when test="${not empty sessionScope.loggedInUser}">
											<button class="btn btn-lg btn-register"
												onclick="location.href='${pageContext.request.contextPath}/pages/post.jsp'">
												<span
													class="d-flex align-items-center justify-content-center">
													맛집등록
												</span>
											</button>
										</c:when>
										<c:otherwise>
											<button class="btn btn-lg btn-register"
												onclick="alert('로그인이 필요한 서비스입니다.');">
												<span
													class="d-flex align-items-center justify-content-center">
													<i class="fas fa-plus"></i>맛집등록
												</span>
											</button>
										</c:otherwise>
									</c:choose>
								</div>

								<!-- 추천 카테고리 섹션 -->
								<div class="mt-4">
									<p class="mb-2">
										<strong>다른 카테고리는 어떠세요?</strong>
									</p>
									<div class="d-flex justify-content-center gap-2 flex-wrap">
										<!-- 다른 카테고리들을 링크로 제공 -->
										<a href="category?type=한식"
											class="btn btn-outline-secondary btn-sm">한식</a> <a
											href="category?type=양식"
											class="btn btn-outline-secondary btn-sm">양식</a> <a
											href="category?type=중식"
											class="btn btn-outline-secondary btn-sm">중식</a> <a
											href="category?type=일식"
											class="btn btn-outline-secondary btn-sm">일식</a> <a
											href="category?type=디저트"
											class="btn btn-outline-secondary btn-sm">디저트</a>
									</div>
								</div>
							</div>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>

	<!-- 푸터 -->
	<footer class="footer mt-5">
		<div class="container">
			<p>
				&copy;
				<fmt:formatDate value="${now}" pattern="yyyy" var="currentYear" />
				<c:out value="${not empty currentYear ? currentYear : '2025'}" />
				공간정보아카데미 Team3. All rights reserved.
			</p>
		</div>
	</footer>
</body>
</html>