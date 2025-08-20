<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:useBean id="reviewDAO" class="com.foodspot.dao.ReviewDAO" />

<%
    // 검색 파라미터 처리
    String ratingParam = request.getParameter("rating");
    String sortBy = request.getParameter("sortBy");
    String pageParam = request.getParameter("page");
    
    // 기본값 설정
    if (sortBy == null) sortBy = "latest";
    int currentPage = (pageParam != null) ? Integer.parseInt(pageParam) : 1;
    int minRating = (ratingParam != null && !ratingParam.isEmpty()) ? Integer.parseInt(ratingParam) : 0;
    
    int pageSize = 12; // 한 페이지당 리뷰 수
    int offset = (currentPage - 1) * pageSize;
    
    // ★★★ 수정된 부분: DAO를 사용해 DB에서 직접 필터링된 데이터 가져오기 ★★★
    // 1. 총 리뷰 수 가져오기 (페이지네이션 계산용)
    int totalCount = reviewDAO.getReviewCount(minRating);
    
    // 2. 페이지에 맞는 리뷰 목록 가져오기
    java.util.List<com.foodspot.dto.ReviewDTO> reviewList = reviewDAO.getFilteredAndSortedReviews(minRating, sortBy, offset, pageSize);
    
    // 페이지네이션 계산
    int totalPages = (int) Math.ceil((double) totalCount / pageSize);
    
    // request에 데이터 설정
    request.setAttribute("reviewList", reviewList);
    request.setAttribute("totalCount", totalCount);
    request.setAttribute("currentPage", currentPage);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("sortBy", sortBy);
    request.setAttribute("ratingParam", ratingParam);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>리뷰 목록 - 맛집내놔</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
	:root {
	--primary-color: #2c3e50; /* 기본 색상 (네이비 계열) */
	--secondary-color: #e74c3c; /* 보조 색상 (붉은 계열) */
	--light-bg: #f8f9fa; /* 밝은 배경색 */
	--border-radius: 12px; /* 모서리 둥글기 값 */
	}
	
	body {
	    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	    background-color: var(--light-bg);
	    padding-top: 50px;
	}
	
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
	
	.navbar-brand {
	    font-weight: 700;
	    font-size: 1.5rem;
	    color: white !important;
	}
	
	.navbar-nav .nav-link {
	    color: rgba(255, 255, 255, 0.8) !important;
	}
	
	.navbar-nav .nav-link:hover {
	    color: white !important;
	}
	
	.navbar-nav .nav-link.active {
	    color: white !important;
	    font-weight: 600;
	}
	
	.page-header {
		background-image: url('<%= request.getContextPath()%>/images/background.jpg');
		background-size: cover;
		background-position: center;
		color: white;
		padding: 80px 0px 60px 0px;
		opacity: 0.75;
	}
	
	/* 리뷰 카드 스타일 */
	.review-card {
	    background: white;
	    border-radius: var(--border-radius);
	    box-shadow: var(--card-shadow);
	    overflow: hidden;
	    transition: all 0.3s ease;
	    height: 100%;
	    display: flex;
	    flex-direction: column;
	}
	
	.review-card:hover {
	    transform: translateY(-5px);
	    box-shadow: var(--card-shadow-hover);
	}
	
	.review-card-image {
	    width: 100%;
	    height: 200px;
	    object-fit: cover;
	    border-bottom: 1px solid #eee;
	}
	
	.review-card-body {
	    padding: 20px;
	    flex-grow: 1;
	    display: flex;
	    flex-direction: column;
	}
	
	.restaurant-name {
	    font-size: 1.2rem;
	    font-weight: 600;
	    color: var(--primary-color);
	    margin-bottom: 8px;
	    text-decoration: none;
	}
	
	.restaurant-name:hover {
	    color: var(--secondary-color);
	    text-decoration: none;
	}
	
	.restaurant-meta {
	    font-size: 0.9rem;
	    color: #666;
	    margin-bottom: 15px;
	}
	
	.rating-stars {
	    color: #ffc107;
	    font-size: 1.1rem;
	    margin-bottom: 15px;
	}
	
	.review-content {
	    color: #333;
	    line-height: 1.6;
	    margin-bottom: 15px;
	    flex-grow: 1;
	    
	    /* 텍스트 넘침 처리 */
	    display: -webkit-box;
	    -webkit-line-clamp: 3;
	    -webkit-box-orient: vertical;
	    overflow: hidden;
	    text-overflow: ellipsis;
	}
	
	.review-images {
	    margin-bottom: 15px;
	}
	
	.review-thumbnail {
	    width: 60px;
	    height: 60px;
	    object-fit: cover;
	    border-radius: 6px;
	    margin-right: 8px;
	    margin-bottom: 8px;
	    cursor: pointer;
	    transition: transform 0.2s;
	}
	
	.review-thumbnail:hover {
	    transform: scale(1.1);
	}
	
	.review-footer {
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    padding-top: 15px;
	    border-top: 1px solid #eee;
	    margin-top: auto;
	}
	
	.review-author {
	    display: flex;
	    align-items: center;
	    gap: 8px;
	    font-size: 0.9rem;
	    color: #666;
	}
	
	.author-avatar {
	    width: 32px;
	    height: 32px;
	    border-radius: 50%;
	    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	    color: white;
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    font-weight: 600;
	    font-size: 0.8rem;
	}
	
	.review-date {
	    font-size: 0.8rem;
	    color: #999;
	}
	
	/* 검색 및 필터 섹션 */
	.search-section {
	    background: white;
	    padding: 25px;
	    border-radius: var(--border-radius);
	    box-shadow: var(--card-shadow);
	    margin-bottom: 30px;
	    margin-top: 30px;
	}
	
	.btn-write-review {
	    background: linear-gradient(45deg, #FF6B6B, #FF8E8E);
	    border: none;
	    color: white;
	    padding: 12px 25px;
	    border-radius: 25px;
	    transition: all 0.3s ease;
	}
	
	.btn-write-review:hover {
	    background: linear-gradient(45deg, #FF5252, #FF7575);
	    transform: translateY(-2px);
	    box-shadow: 0 5px 15px rgba(255, 107, 107, 0.4);
	    color: white;
	}
	
	/* 페이지네이션 */
	.pagination .page-link {
	    color: var(--primary-color);
	    border-color: #dee2e6;
	    padding: 10px 15px;
	}
	
	.pagination .page-item.active .page-link {
	    background-color: var(--primary-color);
	    border-color: var(--primary-color);
	}
	
	/* 빈 상태 */
	.empty-state {
	    text-align: center;
	    padding: 80px 20px;
	    color: #666;
	}
	
	.empty-state i {
	    font-size: 4rem;
	    margin-bottom: 20px;
	    opacity: 0.5;
	}
	
	/* 반응형 */
	@media (max-width: 991px) {
	    .review-card-image {
	        height: 180px;
	    }
	    
	    .review-card-body {
	        padding: 15px;
	    }
	}
	
	@media (max-width: 576px) {
	    body {
	        padding-top: 70px;
	    }
	    
	    .review-card-image {
	        height: 160px;
	    }
	    
	    .search-section {
	        padding: 20px;
	    }
	    
	    .page-header {
	        padding: 40px 0;
	    }
	}
	
	/* 로그인 네비게이션 스타일 */
	.navbar-text {
	    color: rgba(255, 255, 255, 0.9) !important;
	}
	    
	.btn-outline-primary {
	    border-color: rgba(255, 255, 255, 0.5);
	    color: rgba(255, 255, 255, 0.9);
	}
	
	.btn-outline-primary:hover {
	    background-color: #0d6efd;
	    border-color: #0d6efd;
	    color: white;
	}
	
	.btn-primary {
	    background-color: #0d6efd;
	    border-color: #0d6efd;
	}
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/main">
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

    <section class="page-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="display-4 mb-3">맛:집을 원해? <br/>집:중해</h1>
                    <p class="lead mb-4">다른 사람들의 맛집 경험을 확인하고 나만의 리뷰를 공유해보세요</p>
                </div>
                <div class="col-md-4 text-end">
                    <c:choose>
                        <c:when test="${not empty sessionScope.loggedInUser}">
                            <a href="${pageContext.request.contextPath}/pages/post.jsp" class="btn btn-write-review btn-lg">
                                <i class="fas fa-edit me-2"></i>맛집 등록하기
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/pages/login.jsp" class="btn btn-write-review btn-lg">
                                <i class="fas fa-edit me-2"></i>맛집 등록하기
                            </a>
                        </c:otherwise>
                    </c:choose>      
                </div>
            </div>
        </div>
    </section>

    <div class="container">
        <div class="search-section">
            <form action="${pageContext.request.contextPath}/pages/review.jsp" method="get">
                <div class="row g-3 align-items-center">
                    <div class="col-md-4">
                        <select class="form-select" name="rating" onchange="this.form.submit()">
                            <option value="">평점 전체</option>
                            <option value="5" <c:if test="${ratingParam eq '5'}">selected</c:if>>5점</option>
                            <option value="4" <c:if test="${ratingParam eq '4'}">selected</c:if>>4점 이상</option>
                            <option value="3" <c:if test="${ratingParam eq '3'}">selected</c:if>>3점 이상</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <select class="form-select" name="sortBy" onchange="this.form.submit()">
                            <option value="latest" <c:if test="${sortBy eq 'latest'}">selected</c:if>>최신순</option>
                            <option value="rating" <c:if test="${sortBy eq 'rating'}">selected</c:if>>평점순</option>
                        </select>
                    </div>
                    <div class="col-md-4 text-end">
                        <small class="text-muted">
                            총 <strong><c:out value="${totalCount}"/></strong>개의 리뷰
                        </small>
                    </div>
                </div>
            </form>
        </div>

        <c:choose>
            <c:when test="${not empty reviewList}">
                <div class="row">
                    <c:forEach var="review" items="${reviewList}">
                        <div class="col-lg-4 col-md-6 col-sm-12 mb-4">
                            <div class="review-card">
                                <c:if test="${not empty review.restaurantImage}">
                                    <img src="${pageContext.request.contextPath}/image/<c:out value='${review.restaurantImage}'/>" 
                                         alt="<c:out value='${review.restaurantName}'/>" 
                                         class="review-card-image"
                                         onerror="this.src='https://via.placeholder.com/400x200/cccccc/666666?text=이미지+없음';">
                                </c:if>
                                
                                <div class="review-card-body">
                                    <a href="${pageContext.request.contextPath}/RestaurantDetailServlet?id=${review.restaurantId}" 
                                       class="restaurant-name">
                                        <c:out value="${review.restaurantName}"/>
                                    </a>
                                    
                                    <div class="restaurant-meta">
                                        <i class="fas fa-tag me-1"></i><c:out value="${review.restaurantCategory}"/>
                                        <span class="ms-2">
                                            <i class="fas fa-map-marker-alt me-1"></i>
                                            <c:out value="${fn:substring(review.restaurantAddress, 0, 20)}"/>
                                            <c:if test="${fn:length(review.restaurantAddress) > 20}">...</c:if>
                                        </span>
                                    </div>
                                    
                                    <div class="rating-stars">
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
                                        <span class="ms-2 text-muted">
                                            <c:out value="${review.rating}"/>/5
                                        </span>
                                    </div>
                                    
                                    <div class="review-content">
                                        <c:out value="${review.content}"/>
                                    </div>
                                    
                                    <c:if test="${not empty review.images}">
                                        <div class="review-images">
                                            <c:forEach var="image" items="${review.images}" varStatus="status">
                                                <c:if test="${status.index < 3}">
                                                    <img src="${pageContext.request.contextPath}/image/<c:out value='${image.imagePath}'/>" 
                                                         alt="리뷰 이미지" 
                                                         class="review-thumbnail"
                                                         onclick="showImageModal('${pageContext.request.contextPath}/image/<c:out value='${image.imagePath}'/>')"
                                                         onerror="this.style.display='none';">
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${fn:length(review.images) > 3}">
                                                <span class="text-muted small">+${fn:length(review.images) - 3}장 더</span>
                                            </c:if>
                                        </div>
                                    </c:if>
                                    
                                    <div class="review-footer">
                                        <div class="review-author">
                                            <div class="author-avatar">
                                                <c:out value="${fn:substring(review.userName, 0, 1)}"/>
                                            </div>
                                            <div>
                                                <div class="fw-semibold">
                                                    <c:out value="${review.userName}"/>
                                                </div>
                                                <div class="review-date">
                                                    <fmt:formatDate value="${review.createdDate}" pattern="yyyy.MM.dd"/>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-comments"></i>
                    <h4>등록된 리뷰가 없습니다</h4>
                    <p class="mb-4">첫 번째 맛집을 등록하고 리뷰를 작성해보세요!</p>
                    <c:choose>
                        <c:when test="${not empty sessionScope.loggedInUser}">
                            <a href="${pageContext.request.contextPath}/pages/post.jsp" class="btn btn-write-review btn-lg">
                                <i class="fas fa-edit me-2"></i>맛집 등록하기
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/pages/login.jsp" class="btn btn-write-review btn-lg">
                                <i class="fas fa-edit me-2"></i>맛집 등록하기
                            </a>
                        </c:otherwise>
                    </c:choose>      
                </div>
            </c:otherwise>
        </c:choose>

        <c:if test="${not empty reviewList and totalPages > 1}">
            <nav aria-label="리뷰 페이지네이션" class="mt-5">
                <ul class="pagination justify-content-center">
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage - 1}&rating=${ratingParam}&sortBy=${sortBy}">
                                <i class="fas fa-chevron-left"></i> 이전
                            </a>
                        </li>
                    </c:if>
                    
                    <c:set var="startPage" value="${currentPage - 2 > 0 ? currentPage - 2 : 1}" />
                    <c:set var="endPage" value="${startPage + 4 < totalPages ? startPage + 4 : totalPages}" />
                    
                    <c:forEach begin="${startPage}" end="${endPage}" var="page">
                        <li class="page-item <c:if test='${page eq currentPage}'>active</c:if>">
                            <a class="page-link" href="?page=${page}&rating=${ratingParam}&sortBy=${sortBy}">
                                ${page}
                            </a>
                        </li>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage + 1}&rating=${ratingParam}&sortBy=${sortBy}">
                                다음 <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:if>
    </div>

    <div class="modal fade" id="imageModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">리뷰 이미지</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center">
                    <img id="modalImage" src="" alt="리뷰 이미지" class="img-fluid">
                </div>
            </div>
        </div>
    </div>

    <footer class="bg-dark text-white text-center py-4 mt-5">
        <div class="container">
            <p>&copy; 2025 공간정보아카데미 Team3 웹페이지</p>
        </div>
    </footer>

    <script>
        // 리뷰 삭제
        function deleteReview(reviewId) {
            if(confirm('정말로 이 리뷰를 삭제하시겠습니까?')) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/ReviewServlet',
                    type: 'POST',
                    data: {
                        action: 'delete',
                        reviewId: reviewId
                    },
                    success: function(response) {
                        if(response.success) {
                            alert('리뷰가 삭제되었습니다.');
                            location.reload();
                        } else {
                            alert('삭제에 실패했습니다.');
                        }
                    },
                    error: function() {
                        alert('오류가 발생했습니다.');
                    }
                });
            }
        }
        
        // 이미지 모달 표시
        function showImageModal(imageSrc) {
            $('#modalImage').attr('src', imageSrc);
            $('#imageModal').modal('show');
        }
        
        // 카드 호버 효과 개선
        $(document).ready(function() {
            // 이미지 로드 에러 처리
            $('.review-card-image, .review-thumbnail').on('error', function() {
                if($(this).hasClass('review-card-image')) {
                    $(this).attr('src', 'https://via.placeholder.com/400x200/cccccc/666666?text=이미지+없음');
                } else if($(this).hasClass('review-thumbnail')) {
                    $(this).hide();
                }
            });
            
            // 카드 클릭 시 식당 상세페이지로 이동 (이미지 클릭 제외)
            $('.review-card').on('click', function(e) {
                // 버튼이나 썸네일 이미지 클릭 시에는 이동하지 않음
                if(!$(e.target).closest('button, .review-thumbnail, .author-avatar').length) {
                    const restaurantId = $(this).find('.restaurant-name').attr('href').split('id=')[1];
                    if(restaurantId) {
                        window.location.href = '${pageContext.request.contextPath}/RestaurantDetailServlet?id=' + restaurantId;
                    }
                }
            });
            
            // 텍스트 더보기 기능
            $('.review-content').each(function() {
                const $this = $(this);
                const text = $this.text();
                if(text.length > 100) {
                    const truncated = text.substring(0, 100);
                    const full = text;
                    
                    $this.html(truncated + '... <span class="text-primary text-decoration-underline" style="cursor: pointer;">더보기</span>');
                    
                    $this.find('span').on('click', function(e) {
                        e.stopPropagation();
                        if($(this).text() === '더보기') {
                            $this.html(full + ' <span class="text-primary text-decoration-underline" style="cursor: pointer;">접기</span>');
                        } else {
                            $this.html(truncated + '... <span class="text-primary text-decoration-underline" style="cursor: pointer;">더보기</span>');
                        }
                        
                        // 이벤트 재바인딩
                        $this.find('span').on('click', arguments.callee);
                    });
                }
            });
                        
            // 무한 스크롤 효과 (옵션)
            let isLoading = false;
            $(window).scroll(function() {
                if($(window).scrollTop() + $(window).height() >= $(document).height() - 100 && !isLoading) {
                    const currentPage = parseInt('${currentPage}') || 1;
                    const totalPages = parseInt('${totalPages}') || 1;
                    
                    if(currentPage < totalPages) {
                        isLoading = true;
                        // 다음 페이지 로드 로직 (필요시 AJAX로 구현)
                        console.log('다음 페이지 로딩 가능: ' + (currentPage + 1));
                        setTimeout(() => { isLoading = false; }, 1000);
                    }
                }
            });
        });
        
        // 반응형 카드 레이아웃 조정
        function adjustCardLayout() {
            const cards = $('.review-card');
            const windowWidth = $(window).width();
            
            if(windowWidth < 576) {
                // 모바일: 1열
                cards.parent().removeClass('col-lg-4 col-md-6').addClass('col-12');
            } else if(windowWidth < 992) {
                // 태블릿: 2열
                cards.parent().removeClass('col-lg-4 col-12').addClass('col-md-6');
            } else {
                // 데스크톱: 3열
                cards.parent().removeClass('col-md-6 col-12').addClass('col-lg-4');
            }
        }
        
        // 윈도우 리사이즈 시 레이아웃 재조정
        $(window).on('resize', function() {
            clearTimeout(window.resizeTimer);
            window.resizeTimer = setTimeout(adjustCardLayout, 250);
        });
        
        // 페이지 로드 시 스크롤 위치 복원
        $(window).on('beforeunload', function() {
            sessionStorage.setItem('scrollPosition', $(window).scrollTop());
        });
        
        $(document).ready(function() {
            const scrollPosition = sessionStorage.getItem('scrollPosition');
            if(scrollPosition) {
                $(window).scrollTop(scrollPosition);
                sessionStorage.removeItem('scrollPosition');
            }
        });
    </script>
</body>
</html>