<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>	
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>맛집내놔 - ${restaurant.name}</title>
    <!-- 부트스트랩 5.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 아이콘 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- jQuery 라이브러리 -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- 부트스트랩 5.3 JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        /* CSS 변수 정의 */
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #e74c3c;
            --light-bg: #f8f9fa;
            --border-radius: 12px;
        }
        
        /* 기본 스타일 초기화 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--light-bg);
            padding-top: 80px; /* 고정 헤더를 위한 패딩 */
        }
        
        /* 네비게이션 바 스타일 */
        .navbar {
            background: linear-gradient(135deg, var(--primary-color) 0%, #34495e 100%);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 1rem 0;
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
        
        /* 뒤로가기 버튼 스타일 */
        .back-button {
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 25px;
            padding: 10px 20px;
            margin-bottom: 20px;
            transition: all 0.3s;
        }
        
        .back-button:hover {
            background: #34495e;
            transform: translateY(-2px);
            color: white;
        }
        
        /* 식당 헤더 섹션 */
        .restaurant-header {
            background: white;
            border-radius: var(--border-radius);
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }
        
        .restaurant-image {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: var(--border-radius);
            margin-bottom: 20px;
        }
        
        .restaurant-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 10px;
        }
        
        .restaurant-meta {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            margin-bottom: 20px;
            align-items: center;
        }
        
        .badge-category {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 8px 20px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 0.9rem;
        }
        
        .rating-display {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.2rem;
        }
        
        .rating-stars {
            color: #ffc107;
        }
        
        .rating-number {
            font-weight: 700;
            color: var(--primary-color);
        }
        
        /* 정보 카드 스타일 */
        .info-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            height: 100%;
        }
        
        .info-card h4 {
            color: var(--primary-color);
            margin-bottom: 20px;
            font-weight: 600;
        }
        
        .info-item {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            margin-bottom: 15px;
            padding: 10px 0;
        }
        
        .info-item:last-child {
            margin-bottom: 0;
        }
        
        .info-icon {
            color: #6c757d;
            width: 20px;
            margin-top: 2px;
        }
        
        /* 메뉴 아이템 스타일 */
        .menu-item {
            background: #f8f9fa;
            border-left: 4px solid var(--primary-color);
            padding: 12px 15px;
            margin-bottom: 8px;
            border-radius: 0 8px 8px 0;
            font-weight: 500;
        }
        
        /* 리뷰 섹션 스타일 */
        .review-section {
            background: white;
            border-radius: var(--border-radius);
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }
        
        .review-form {
            background: var(--light-bg);
            border-radius: var(--border-radius);
            padding: 25px;
            margin-bottom: 30px;
        }
        
        /* 별점 선택 스타일 */
        .star-rating {
            display: flex;
            gap: 5px;
            font-size: 1.8rem;
            margin-bottom: 15px;
        }
        
        .star-rating .star {
            color: #ddd;
            cursor: pointer;
            transition: color 0.2s;
        }
        
        .star-rating .star:hover,
        .star-rating .star.active {
            color: #ffc107;
        }
        
        /* 개별 리뷰 스타일 */
        .review-item {
            border-bottom: 1px solid #e9ecef;
            padding: 25px 0;
        }
        
        .review-item:last-child {
            border-bottom: none;
        }
        
        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 15px;
        }
        
        .review-author {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .author-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 1.2rem;
        }
        
        .review-rating {
            color: #ffc107;
            font-size: 1rem;
        }
        
        .review-content {
            margin-left: 65px;
        }
        
        .review-images {
            display: flex;
            gap: 10px;
            margin-top: 15px;
            flex-wrap: wrap;
        }
        
        .review-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .review-image:hover {
            transform: scale(1.05);
        }
        
        /* 커스텀 버튼 스타일 */
        .btn-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 25px;
            padding: 12px 30px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102,126,234,0.3);
            color: white;
        }
        
        /* 이미지 업로드 영역 */
        .image-upload-area {
            border: 2px dashed #dee2e6;
            border-radius: 10px;
            padding: 30px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 15px;
        }
        
        .image-upload-area:hover {
            border-color: #667eea;
            background: rgba(102,126,234,0.05);
        }
        
        /* 이미지 미리보기 */
        .image-preview {
            display: flex;
            gap: 10px;
            margin-top: 15px;
            flex-wrap: wrap;
        }
        
        .image-preview-item {
            position: relative;
            width: 100px;
            height: 100px;
        }
        
        .image-preview-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 8px;
        }
        
        .image-preview-item .remove-btn {
            position: absolute;
            top: -8px;
            right: -8px;
            background: var(--secondary-color);
            color: white;
            border: none;
            border-radius: 50%;
            width: 25px;
            height: 25px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
        }
        
        /* 로그인 상태 네비게이션 */
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
        
        /* 빈 상태 메시지 */
        .empty-state {
            text-align: center;
            padding: 50px;
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 3rem;
            margin-bottom: 20px;
            opacity: 0.5;
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
            
            .restaurant-title {
                font-size: 2rem;
            }
            
            .review-content {
                margin-left: 0;
                margin-top: 15px;
            }
        }
        
        @media (max-width: 576px) {
            body {
                padding-top: 65px;
            }
            
            .restaurant-title {
                font-size: 1.8rem;
            }
            
            .restaurant-image {
                height: 250px;
            }
            
            .restaurant-header {
                padding: 20px;
            }
            
            .info-card {
                padding: 20px;
            }
            
            .review-section {
                padding: 20px;
            }
            
            .review-form {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <!-- 네비게이션 바 -->
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
	            </div>
	        </div>
        </div>
    </nav>

    <div class="container mt-4">
        <!-- 뒤로가기 버튼 -->
        <button onclick="history.back()" class="btn back-button">
            <i class="fas fa-arrow-left me-2"></i>뒤로가기
        </button>

        <!-- 식당 정보가 있는 경우 -->
        <c:if test="${not empty restaurant}">
            <!-- 식당 헤더 -->
            <div class="restaurant-header">
                <img src="${not empty restaurant.imageUrl ? pageContext.request.contextPath.concat('/image/').concat(restaurant.imageUrl) : 'https://via.placeholder.com/400x250/cccccc/666666?text=이미지+없음'}"
				     class="restaurant-image" 
				     alt="<c:out value='${restaurant.name}'/>"
				     onerror="this.onerror=null; this.src='https://via.placeholder.com/400x250/cccccc/666666?text=이미지+없음';">
                
                <h1 class="restaurant-title"><c:out value="${restaurant.name}"/></h1>
                
                <div class="restaurant-meta">
                    <span class="badge-category"><c:out value="${restaurant.category}"/></span>
                    <div class="rating-display">
                        <span class="rating-stars">
                            <c:forEach begin="1" end="5" var="star">
                                <c:choose>
                                    <c:when test="${star <= restaurant.rating}">
                                        <i class="fas fa-star"></i>
                                    </c:when>
                                    <c:when test="${star - 0.5 <= restaurant.rating}">
                                        <i class="fas fa-star-half-alt"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="far fa-star"></i>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </span>
                        <span class="rating-number">
                            <fmt:formatNumber value="${restaurant.rating}" pattern="0.0"/>
                        </span>
                        <span class="text-muted">(${restaurant.reviewCount}개 리뷰)</span>
                    </div>
                </div>
            </div>

            <!-- 식당 상세 정보 -->
            <div class="row">
                <div class="col-lg-6 mb-4">
                    <!-- 기본 정보 카드 -->
                    <div class="info-card">
                        <h4><i class="fas fa-info-circle me-2"></i>기본 정보</h4>
                        <div class="info-item">
                            <i class="fas fa-map-marker-alt info-icon"></i>
                            <span><c:out value="${restaurant.address}"/></span>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-phone info-icon"></i>
                            <span><c:out value="${not empty restaurant.phone ? restaurant.phone : '정보 없음'}"/></span>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-clock info-icon"></i>
                            <span><c:out value="${not empty restaurant.operatingHours ? restaurant.operatingHours : '운영시간 정보 없음'}"/></span>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-calendar-alt info-icon"></i>
                            <span>등록일: <fmt:formatDate value="${restaurant.postDate}" pattern="yyyy-MM-dd"/></span>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-6 mb-4">
                    <!-- 소개 및 메뉴 카드 -->
                    <div class="info-card">
                        <h4><i class="fas fa-align-left me-2"></i>소개</h4>
                        <p class="mb-4">
                            <c:out value="${not empty restaurant.description ? restaurant.description : '소개글이 없습니다.'}"/>
                        </p>
                        
                        <h5><i class="fas fa-utensils me-2"></i>대표 메뉴</h5>
                        <div id="menuContainer">
                            <c:choose>
                                <c:when test="${not empty restaurant.menu}">
                                    <c:set var="menuItems" value="${restaurant.menu}"/>
                                    <c:forTokens items="${menuItems}" delims="\\n" var="menuItem">
                                        <c:if test="${not empty menuItem}">
                                            <div class="menu-item"><c:out value="${menuItem}"/></div>
                                        </c:if>
                                    </c:forTokens>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-muted">메뉴 정보가 없습니다.</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- 식당 정보가 없는 경우 -->
        <c:if test="${empty restaurant}">
            <div class="empty-state">
                <i class="fas fa-exclamation-triangle"></i>
                <h3>식당 정보를 찾을 수 없습니다</h3>
                <p>요청하신 식당 정보가 존재하지 않거나 삭제되었을 수 있습니다.</p>
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-custom">
                    <i class="fas fa-home me-2"></i>메인으로 돌아가기
                </a>
            </div>
        </c:if>

        <!-- 리뷰 섹션 -->
        <c:if test="${not empty restaurant}">
            <div class="review-section">
                <h3 class="mb-4">
                    <i class="fas fa-comments me-2"></i>리뷰 
                    <span class="badge bg-secondary">${restaurant.reviewCount}</span>
                </h3>
                
                <!-- 로그인된 사용자만 리뷰 작성 가능 -->
                <c:if test="${not empty sessionScope.loggedInUser}">
                    <div class="review-form">
                        <h5 class="mb-3"><i class="fas fa-edit me-2"></i>리뷰 작성하기</h5>
                        <form id="reviewForm" enctype="multipart/form-data">
                            <input type="hidden" name="restaurantId" value="${restaurant.restaurantId}">
                            <input type="hidden" name="userId" value="${sessionScope.loggedInUser}">
                            
                            <!-- 별점 선택 -->
                            <div class="mb-3">
                                <label class="form-label fw-bold">평점을 선택해주세요</label>
                                <div class="star-rating" id="starRating">
                                    <i class="fas fa-star star" data-rating="1"></i>
                                    <i class="fas fa-star star" data-rating="2"></i>
                                    <i class="fas fa-star star" data-rating="3"></i>
                                    <i class="fas fa-star star" data-rating="4"></i>
                                    <i class="fas fa-star star" data-rating="5"></i>
                                </div>
                                <input type="hidden" name="rating" id="ratingInput" value="0">
                            </div>
                            
                            <!-- 리뷰 내용 -->
                            <div class="mb-3">
                                <label class="form-label fw-bold">리뷰 내용</label>
                                <textarea class="form-control" name="content" rows="4" 
                                         placeholder="이 식당에 대한 솔직한 후기를 남겨주세요. 음식 맛, 서비스, 분위기 등을 자유롭게 작성해주세요." required></textarea>
                            </div>
                            
                            <!-- 사진 첨부 -->
                            <div class="mb-3">
                                <label class="form-label fw-bold">사진 첨부 (선택)</label>
                                <div class="image-upload-area" onclick="$('#reviewImages').click()">
                                    <i class="fas fa-camera fa-3x text-muted mb-3"></i>
                                    <p class="mb-1 text-muted fs-5">클릭하여 이미지를 선택하세요</p>
                                    <small class="text-muted">최대 5장까지, JPG/PNG 형식 (각 파일 최대 5MB)</small>
                                </div>
                                <input type="file" id="reviewImages" name="images" multiple accept="image/*" style="display: none;">
                                <div class="image-preview" id="imagePreview"></div>
                            </div>
                            
                            <button type="submit" class="btn btn-custom btn-lg">
                                <i class="fas fa-paper-plane me-2"></i>리뷰 등록하기
                            </button>
                        </form>
                    </div>
                </c:if>
                
                <!-- 로그인하지 않은 사용자 안내 -->
                <c:if test="${empty sessionScope.loggedInUser}">
                    <div class="alert alert-info d-flex align-items-center">
                        <i class="fas fa-info-circle me-3 fs-4"></i>
                        <div>
                            <strong>리뷰를 작성하려면 로그인이 필요합니다.</strong><br>
                            <a href="${pageContext.request.contextPath}/pages/login.jsp" class="btn btn-sm btn-primary mt-2">
                                <i class="fas fa-sign-in-alt me-1"></i>로그인하기
                            </a>
                        </div>
                    </div>
                </c:if>
                
                <!-- 리뷰 목록 -->
                <div id="reviewList">
                    <c:choose>
                        <c:when test="${not empty reviews}">
                            <c:forEach var="review" items="${reviews}">
                                <div class="review-item">
                                    <div class="review-header">
                                        <div class="review-author">
                                            <div class="author-avatar">
                                                <c:out value="${review.userName.substring(0,1).toUpperCase()}"/>
                                            </div>
                                            <div>
                                                <div class="fw-bold fs-5"><c:out value="${review.userName}"/></div>
                                                <small class="text-muted">
                                                    <fmt:formatDate value="${review.createdDate}" pattern="yyyy년 MM월 dd일 HH:mm"/>
                                                </small>
                                            </div>
                                        </div>
                                        <div class="review-rating">
                                            <c:forEach begin="1" end="5" var="star">
                                                <c:choose>
                                                    <c:when test="${star <= review.rating}">
                                                        <i class="fas fa-star"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="far fa-star"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <div class="review-content">
                                        <p class="mb-3"><c:out value="${review.content}"/></p>
                                        
                                        <!-- 리뷰 이미지가 있는 경우 -->
                                        <c:if test="${not empty review.images}">
                                            <div class="review-images">
                                                <c:forEach var="image" items="${review.images}">
                                                   <img src="image/<c:out value='${image.imagePath}'/>" 
                                                         class="review-image" 
                                                         alt="리뷰 이미지"
                                                         onclick="showImageModal('${pageContext.request.contextPath}/image/<c:out value='${image.imagePath}'/>')"/>
                                                </c:forEach>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fas fa-comment-slash"></i>
                                <h4>아직 리뷰가 없습니다</h4>
                                <p>이 식당의 첫 번째 리뷰를 작성해보세요!</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:if>
    </div>

    <!-- 이미지 모달 -->
    <div class="modal fade" id="imageModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">이미지 보기</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center">
                    <img id="modalImage" src="" class="img-fluid" alt="확대 이미지">
                </div>
            </div>
        </div>
    </div>

    <script>
        // 전역 변수
        let selectedRating = 0;
        let selectedImages = [];
        
        $(document).ready(function() {
            // 별점 선택 이벤트
            $('.star').on('click', function() {
                selectedRating = $(this).data('rating');
                $('#ratingInput').val(selectedRating);
                updateStarDisplay(selectedRating);
            });
            
            // 별점 마우스 오버 이벤트
            $('.star').on('mouseenter', function() {
                let rating = $(this).data('rating');
                updateStarDisplay(rating);
            });
            
            // 별점 영역 마우스 아웃 이벤트
            $('#starRating').on('mouseleave', function() {
                updateStarDisplay(selectedRating);
            });
            
            // 이미지 파일 선택 이벤트
            $('#reviewImages').on('change', function(e) {
                handleImageSelect(e);
            });
            
            // 리뷰 폼 제출 이벤트
            $('#reviewForm').on('submit', function(e) {
                e.preventDefault();
                
                if(selectedRating === 0) {
                    alert('평점을 선택해주세요.');
                    return;
                }
                
                const content = $('textarea[name="content"]').val().trim();
                if(!content) {
                    alert('리뷰 내용을 입력해주세요.');
                    return;
                }
                
                // FormData 객체 생성
                let formData = new FormData(this);
                
                // AJAX로 리뷰 데이터 전송
                $.ajax({
                    url: '${pageContext.request.contextPath}/ReviewServlet',
                    type: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    beforeSend: function() {
                        $('button[type="submit"]').prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>등록 중...');
                    },
                    success: function(response) {
                        if(response.success) {
                            alert('리뷰가 성공적으로 등록되었습니다.');
                            // 폼 초기화
                            $('#reviewForm')[0].reset();
                            selectedRating = 0;
                            selectedImages = [];
                            updateStarDisplay(0);
                            $('#imagePreview').empty();
                         	// 메인 페이지도 새로고침하도록 sessionStorage 사용
                            sessionStorage.setItem('refreshMain', 'true');
                            // 페이지 새로고침하여 새 리뷰 표시
                            location.reload();
                        } else {
                            alert(response.message || '리뷰 등록에 실패했습니다.');
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error('AJAX Error:', error);
                        alert('서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
                    },
                    complete: function() {
                        $('button[type="submit"]').prop('disabled', false).html('<i class="fas fa-paper-plane me-2"></i>리뷰 등록하기');
                    }
                });
            });
            
            // 메뉴 텍스트 포맷팅 (줄바꿈 처리)
            formatMenuText();
        });
        
        /**
         * 선택된 평점에 따라 별 표시를 업데이트하는 함수
         */
        function updateStarDisplay(rating) {
            $('.star').each(function() {
                let starRating = $(this).data('rating');
                if(starRating <= rating) {
                    $(this).addClass('active');
                } else {
                    $(this).removeClass('active');
                }
            });
        }
        
        /**
         * 이미지 파일 선택 시 미리보기를 생성하는 함수
         */
        function handleImageSelect(e) {
            const files = Array.from(e.target.files);
            const preview = $('#imagePreview');
            
            // 파일 개수 체크
            if(files.length > 5) {
                alert('이미지는 최대 5장까지만 업로드할 수 있습니다.');
                e.target.value = '';
                return;
            }
            
            // 미리보기 초기화
            preview.empty();
            selectedImages = [];
            
            files.forEach((file, index) => {
                // 파일 타입 체크
                if(!file.type.match('image.*')) {
                    alert(`${file.name}은(는) 이미지 파일이 아닙니다.`);
                    return;
                }
                
                // 파일 크기 체크 (5MB 제한)
                if(file.size > 5 * 1024 * 1024) {
                    alert(`${file.name}의 크기가 5MB를 초과합니다.`);
                    return;
                }
                
                selectedImages.push(file);
                
                // 파일 읽기
                const reader = new FileReader();
                reader.onload = function(e) {
                    const previewHtml = `
                        <div class="image-preview-item" data-index="${index}">
                            <img src="${e.target.result}" alt="미리보기 ${index + 1}">
                            <button type="button" class="remove-btn" onclick="removeImage(${index})">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                    `;
                    preview.append(previewHtml);
                };
                reader.readAsDataURL(file);
            });
        }
        
        /**
         * 미리보기 이미지를 제거하는 함수
         */
        function removeImage(index) {
            // DOM에서 제거
            $(`.image-preview-item[data-index="${index}"]`).remove();
            
            // 배열에서 제거
            selectedImages.splice(index, 1);
            
            // 파일 입력 필드 업데이트
            const dt = new DataTransfer();
            selectedImages.forEach(file => dt.items.add(file));
            document.getElementById('reviewImages').files = dt.files;
            
            // 인덱스 재조정
            $('.image-preview-item').each(function(newIndex) {
                $(this).attr('data-index', newIndex);
                $(this).find('.remove-btn').attr('onclick', `removeImage(${newIndex})`);
            });
        }
        
        /**
         * 이미지 클릭 시 모달로 크게 보여주는 함수
         */
        function showImageModal(imageSrc) {
            $('#modalImage').attr('src', imageSrc);
            const imageModal = new bootstrap.Modal(document.getElementById('imageModal'));
            imageModal.show();
        }
        
        /**
         * 메뉴 텍스트의 줄바꿈을 처리하는 함수
         */
        function formatMenuText() {
            const menuContainer = $('#menuContainer');
            const menuText = menuContainer.find('.menu-item').text();
            
            if(menuText && menuText.includes('\\n')) {
                const menuItems = menuText.split('\\n');
                let formattedHtml = '';
                
                menuItems.forEach(function(item) {
                    if(item.trim()) {
                        formattedHtml += `<div class="menu-item">${item.trim()}</div>`;
                    }
                });
                
                if(formattedHtml) {
                    menuContainer.html(formattedHtml);
                }
            }
        }
        
        /**
         * 뒤로가기 함수 (브라우저 히스토리 사용)
         */
        function goBack() {
            if(document.referrer && document.referrer !== window.location.href) {
                history.back();
            } else {
                // 히스토리가 없으면 메인 페이지로
                location.href = '${pageContext.request.contextPath}/index.jsp';
            }
        }
        
        /**
         * 페이지 로딩 완료 후 추가 초기화
         */
        $(window).on('load', function() {
            // 이미지 로드 에러 처리
            $('img').on('error', function() {
                if($(this).hasClass('restaurant-image')) {
                    $(this).attr('src', 'https://via.placeholder.com/400x250/cccccc/666666?text=이미지+없음');
                } else if($(this).hasClass('review-image')) {
                    $(this).attr('src', 'https://via.placeholder.com/100x100/cccccc/666666?text=이미지+오류');
                }
            });
            
            // 스크롤 시 네비게이션 바 그림자 효과
            $(window).scroll(function() {
                if($(this).scrollTop() > 10) {
                    $('.navbar').addClass('shadow-lg');
                } else {
                    $('.navbar').removeClass('shadow-lg');
                }
            });
        });
        
        /**
         * 로그아웃 함수
         */
        function logout() {
            if(confirm('정말 로그아웃하시겠습니까?')) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/LogoutServlet',
                    type: 'POST',
                    success: function() {
                        location.href = '${pageContext.request.contextPath}/index.jsp';
                    },
                    error: function() {
                        // 에러가 발생해도 메인 페이지로 리다이렉트
                        location.href = '${pageContext.request.contextPath}/index.jsp';
                    }
                });
            }
        }
        
        /**
         * 텍스트 길이 제한 및 더보기 기능
         */
        function truncateText(selector, maxLength) {
            $(selector).each(function() {
                const text = $(this).text();
                if(text.length > maxLength) {
                    const truncated = text.substring(0, maxLength);
                    const remaining = text.substring(maxLength);
                    
                    $(this).html(`
                        <span class="truncated-text">${truncated}</span>
                        <span class="remaining-text" style="display: none;">${remaining}</span>
                        <a href="#" class="toggle-text text-primary ms-2">더보기</a>
                    `);
                }
            });
            
            // 더보기/접기 클릭 이벤트
            $(document).on('click', '.toggle-text', function(e) {
                e.preventDefault();
                const $this = $(this);
                const $remaining = $this.siblings('.remaining-text');
                
                if($remaining.is(':visible')) {
                    $remaining.hide();
                    $this.text('더보기');
                } else {
                    $remaining.show();
                    $this.text('접기');
                }
            });
        }
        
        // DOM 로드 완료 후 텍스트 길이 제한 적용
        $(document).ready(function() {
            truncateText('.review-content p', 200); // 리뷰 내용 200자 제한
        });
    </script>
</body>
</html>