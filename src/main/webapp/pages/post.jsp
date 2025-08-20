<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>맛집내놔 - 맛집 등록</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
	rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<style>
:root {
	--primary-color: #2c3e50;
	--secondary-color: #e74c3c;
	--light-bg: #f8f9fa;
	--border-radius: 12px;
}

* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	min-height: 100vh;
	padding-top: 80px;
}

.navbar {
	background: linear-gradient(135deg, var(--primary-color) 0%, #34495e
		100%);
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
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

.form-container {
	max-width: 700px;
	margin: 20px auto;
	background: white;
	padding: 30px;
	border-radius: var(--border-radius);
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
}

.form-container h2 {
	text-align: center;
	color: var(--primary-color);
	margin-bottom: 25px;
	font-weight: 700;
}

.form-control:focus {
	border-color: #667eea;
	box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
}

.btn-custom-primary {
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	border: none;
	color: white;
	border-radius: 10px;
	padding: 12px 25px;
	font-weight: 600;
	transition: all 0.3s;
	width: 100%;
}

.btn-custom-primary:hover {
	transform: translateY(-2px);
	box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
	color: white;
}

.btn-outline-secondary {
	border: 2px solid #6c757d;
	color: #6c757d;
	font-weight: 600;
	border-radius: 8px;
	transition: all 0.3s;
	width: 100%;
}

.btn-outline-secondary:hover {
	background: #6c757d;
	color: white;
	transform: translateY(-2px);
}

.image-upload-area {
	border: 2px dashed #dee2e6;
	border-radius: 10px;
	padding: 30px;
	text-align: center;
	cursor: pointer;
	transition: all 0.3s;
	background: #f8f9fa;
}

.image-upload-area:hover {
	border-color: #667eea;
	background: rgba(102, 126, 234, 0.05);
}

.image-preview {
	display: flex;
	gap: 10px;
	margin-top: 15px;
	flex-wrap: wrap;
}

.image-preview-item {
	position: relative;
	width: 80px;
	height: 80px;
}

.image-preview-item img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	border-radius: 8px;
	border: 2px solid #dee2e6;
}

.image-preview-item .remove-btn {
	position: absolute;
	top: -8px;
	right: -8px;
	background: var(--secondary-color);
	color: white;
	border: none;
	border-radius: 50%;
	width: 22px;
	height: 22px;
	cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 12px;
}

.time-input-group {
	display: flex;
	gap: 10px;
	align-items: center;
	flex-wrap: wrap;
}
/* 140으로 수정함 */ 
.time-input {
	max-width: 140px;   
}

.time-separator {
	font-weight: bold;
	color: #6c757d;
	font-size: 1.1rem;
}

.alert-info {
	background: linear-gradient(135deg, #d1ecf1 0%, #bee5eb 100%);
	border: none;
	border-radius: var(--border-radius);
	border-left: 4px solid #17a2b8;
}

.form-section {
	background: #f8f9fa;
	padding: 20px;
	border-radius: var(--border-radius);
	margin-bottom: 20px;
	border-left: 4px solid #667eea;
}

.form-section h5 {
	color: var(--primary-color);
	margin-bottom: 15px;
	font-weight: 600;
}

.required {
	color: #e74c3c;
}

@media ( max-width : 768px) {
	.time-input-group {
		justify-content: center;
	}
	body {
		padding-top: 70px;
	}
	.form-container {
		margin: 10px;
		padding: 20px;
	}
	.btn-custom-primary, .btn-outline-secondary {
		margin-bottom: 10px;
	}
}
</style>
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-dark">
		<div class="container">
			<a class="navbar-brand" href="${pageContext.request.contextPath}/">
				<i class="fas fa-utensils me-2"></i>맛집내놔
			</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarNav">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav ms-auto">
					<c:choose>
						<c:when test="${not empty sessionScope.loggedInUser}">
							<li class="nav-item d-flex align-items-center">
								<span class="navbar-text me-3 text-white">환영합니다, <c:out
								value="${sessionScope.userName}" default="사용자" />님!
							</span>
							</li>
							<li class="nav-item"><a class="btn btn-outline-danger" href="#"
								onclick="logout()"> <i class="fas fa-sign-out-alt me-1"></i>로그아웃
							</a></li>
						</c:when>
						<c:otherwise>
							<li class="nav-item"><a class="nav-link" href="login.jsp">
									<i class="fas fa-sign-in-alt me-1"></i>로그인
							</a></li>
						</c:otherwise>
					</c:choose>
				</ul>
			</div>
		</div>
	</nav>

	<c:choose>
		<c:when test="${not empty sessionScope.loggedInUser}">
			<div class="form-container">
				<h2>
					<i class="fas fa-store me-2"></i>새로운 맛집 등록
				</h2>

				<div class="alert alert-info">
					<i class="fas fa-info-circle me-2"></i> <strong>안내:</strong> 정확한
					정보를 입력해주세요. 등록된 맛집은 다른 사용자들에게 공유됩니다.
				</div>

				<!-- 서블릿의 필드명과 정확히 매칭 -->
				<form id="restaurantPostForm" method="post"
					enctype="multipart/form-data">
					<!-- 기본 정보 섹션 -->
					<div class="form-section">
						<h5>
							<i class="fas fa-info-circle me-2"></i>기본 정보
						</h5>

						<!-- DB: name VARCHAR(100) NOT NULL -->
						<div class="mb-3">
							<label for="name" class="form-label">가게명 <span
								class="required">*</span></label> <input type="text"
								class="form-control" id="name" name="name" required
								maxlength="100" placeholder="예: 맛있는 파스타 집">
						</div>

						<!-- DB: category VARCHAR(50) NOT NULL -->
						<div class="mb-3">
							<label for="category" class="form-label">카테고리 <span
								class="required">*</span></label> <select class="form-select"
								id="category" name="category" required>
								<option value="">카테고리를 선택하세요</option>
								<option value="한식">🍚 한식</option>
								<option value="중식">🥟 중식</option>
								<option value="일식">🍣 일식</option>
								<option value="양식">🍝 양식</option>
								<option value="디저트">🍰 디저트</option>
								<option value="패스트푸드">🍔 패스트푸드</option>
								<option value="카페">☕ 카페</option>
								<option value="기타">🍽️ 기타</option>
							</select>
						</div>

						<!-- DB: address VARCHAR(255) NOT NULL -->
						<div class="mb-3">
							<label for="address" class="form-label">주소 <span
								class="required">*</span></label> <input type="text"
								class="form-control" id="address" name="address" required
								maxlength="255" placeholder="예: 서울특별시 강남구 테헤란로 123">
						</div>
						
						<!-- DB: hotspot_region VARCHAR(50) NOT NULL -->
						<div class="mb-3">
							<label for="hotspot_region" class="form-label">핫플 지역 선택 <span
								class="required">*</span></label> <select class="form-select"
								id="hotspot_region" name="hotspot_region" required>
								<option value="">지역을 선택하세요</option>
								<option value="성수">성수</option>
								<option value="강남">강남</option>
								<option value="홍대">홍대</option>
								<option value="잠실">잠실</option>
								<option value="용산">용산</option>
							</select>
						</div>

						<!-- DB: phone VARCHAR(20) NULL -->
						<div class="mb-3">
							<label for="phone" class="form-label">전화번호</label> <input
								type="tel" class="form-control" id="phone" name="phone"
								maxlength="20" placeholder="예: 02-1234-5678"
								pattern="[0-9\-\s]+">
						</div>
					</div>

					<!-- 운영 정보 섹션 -->
					<div class="form-section">
						<h5>
							<i class="fas fa-clock me-2"></i>운영 정보
						</h5>

						<!-- DB: operating_hours VARCHAR(255) NULL, 서블릿: hours -->
						<div class="mb-3">
							<label class="form-label">운영 시간</label>
							<div class="time-input-group">
								<input type="time" class="form-control time-input" id="openTime"
									value="09:00"> <span class="time-separator">~</span> <input
									type="time" class="form-control time-input" id="closeTime"
									value="22:00">
							</div>
							<!-- 서블릿에서 'hours' 필드로 받음 -->
							<input type="hidden" name="hours" id="operatingHours">
							<div class="form-text">운영 시간을 선택하세요. 휴무일이 있다면 소개글에 작성해주세요.</div>
						</div>

						<!-- DB: menu TEXT NULL -->
						<div class="mb-3">
							<label for="menu" class="form-label">대표 메뉴</label>
							<textarea class="form-control" id="menu" name="menu" rows="4"
								placeholder="예:&#10;스파게티 카르보나라 - 18,000원&#10;리조또 - 20,000원&#10;시저 샐러드 - 12,000원"></textarea>
							<div class="form-text">메뉴명과 가격을 한 줄씩 작성해주세요.</div>
						</div>
					</div>

					<!-- 상세 정보 섹션 -->
					<div class="form-section">
						<h5>
							<i class="fas fa-edit me-2"></i>상세 정보
						</h5>

						<!-- DB: description TEXT NULL -->
						<div class="mb-3">
							<label for="description" class="form-label">가게 소개</label>
							<textarea class="form-control" id="description"
								name="description" rows="5"
								placeholder="가게의 특징, 분위기, 추천 포인트 등을 자유롭게 작성해주세요.&#10;&#10;예:&#10;- 신선한 재료로 만드는 수제 파스타&#10;- 로맨틱한 분위기의 데이트 코스&#10;- 점심 특선 메뉴 운영"></textarea>
						</div>

						<!-- 서블릿에서 'images' 필드로 받아 image_url에 저장 -->
						<div class="mb-3">
							<label class="form-label">가게 사진</label>
							<div class="image-upload-area" onclick="$('#images').click()">
								<i class="fas fa-camera fa-2x text-muted mb-2"></i>
								<p class="mb-0 text-muted">사진을 클릭해서 선택하세요</p>
								<small class="text-muted">최대 5장, JPG/PNG 형식 (파일당 최대 5MB)</small>
							</div>
							<!-- 서블릿이 기대하는 필드명 'images' -->
							<input type="file" id="images" name="images" multiple
								accept="image/*" style="display: none;">
							<div class="image-preview" id="imagePreview"></div>
						</div>
					</div>

					<div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
						<button type="button" class="btn btn-outline-secondary me-md-2"
							onclick="goBack()">
							<i class="fas fa-arrow-left me-2"></i>취소
						</button>
						<button type="submit" class="btn btn-custom-primary">
							<i class="fas fa-paper-plane me-2"></i>맛집 등록하기
						</button>
					</div>
				</form>
			</div>
		</c:when>
		<c:otherwise>
			<div class="form-container">
				<div class="text-center">
					<i class="fas fa-lock fa-3x text-muted mb-3"></i>
					<h4>로그인이 필요합니다</h4>
					<p class="text-muted mb-4">맛집을 등록하려면 먼저 로그인해주세요.</p>
					<div class="row">
						<div class="col-md-6 mb-2">
							<a href="login.jsp" class="btn btn-custom-primary"> <i
								class="fas fa-sign-in-alt me-2"></i>로그인
							</a>
						</div>
						<div class="col-md-6">
							<a href="${pageContext.request.contextPath}/"
								class="btn btn-outline-secondary"> <i
								class="fas fa-home me-2"></i>홈으로
							</a>
						</div>
					</div>
				</div>
			</div>
		</c:otherwise>
	</c:choose>

	<script>
        let selectedFiles = [];

        $(document).ready(function() {
            $('#images').on('change', handleImageSelect);
            
            $('#restaurantPostForm').on('submit', function(e) {
                e.preventDefault();
                
                if (!validateForm()) {
                    return;
                }
                
                // 운영시간 조합 - 서블릿에서 'hours' 필드로 받음
                const openTime = $('#openTime').val();
                const closeTime = $('#closeTime').val();
                if (openTime && closeTime) {
                    $('#operatingHours').val(openTime + ' ~ ' + closeTime);
                }
                
                // FormData 생성 - 서블릿의 multipart 처리와 일치
                let formData = new FormData(this);
                
                // 서블릿에서 FileItem.isFormField()로 구분하므로 FormData 사용
                // 이미지 파일들은 이미 form에 포함되어 있음 (name="images")
                
                $('button[type="submit"]').prop('disabled', true)
                    .html('<i class="fas fa-spinner fa-spin me-2"></i>등록 중...');
                
                $.ajax({
                    url: '${pageContext.request.contextPath}/RestaurantServlet',
                    type: 'POST',
                    data: formData,
                    processData: false,  // FormData 사용 시 필수
                    contentType: false,  // FormData 사용 시 필수
                    success: function(response) {
                        if (response.success) {
                            alert('맛집이 성공적으로 등록되었습니다!');
                            location.href = '${pageContext.request.contextPath}/';
                        } else {
                            alert('등록 실패: ' + response.message);
                            $('button[type="submit"]').prop('disabled', false)
                                .html('<i class="fas fa-paper-plane me-2"></i>맛집 등록하기');
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error('AJAX 오류:', error);
                        console.error('응답:', xhr.responseText);
                        
                        let errorMessage = '맛집 등록에 실패했습니다.';
                        try {
                            const response = JSON.parse(xhr.responseText);
                            if (response.message) {
                                errorMessage = response.message;
                            }
                        } catch (e) {
                            errorMessage += ' 서버 오류가 발생했습니다.';
                        }
                        
                        alert(errorMessage);
                        $('button[type="submit"]').prop('disabled', false)
                            .html('<i class="fas fa-paper-plane me-2"></i>맛집 등록하기');
                    }
                });
            });
        });

        function validateForm() {
            // 필수 필드 검증 - DB의 NOT NULL 필드들
            if (!$('#name').val().trim()) {
                alert('가게명을 입력해주세요.');
                $('#name').focus();
                return false;
            }
            
            if (!$('#category').val()) {
                alert('카테고리를 선택해주세요.');
                $('#category').focus();
                return false;
            }
            
            if (!$('#address').val().trim()) {
                alert('주소를 입력해주세요.');
                $('#address').focus();
                return false;
            }
            
            // 길이 제한 검증 - DB 제약사항
            if ($('#name').val().length > 100) {
                alert('가게명은 100자 이내로 입력해주세요.');
                $('#name').focus();
                return false;
            }
            
            if ($('#address').val().length > 255) {
                alert('주소는 255자 이내로 입력해주세요.');
                $('#address').focus();
                return false;
            }
            
            if (!$('#hotspot_region').val()) {
                alert('핫플지역을 선택해주세요.');
                $('#hotspot_region').focus();
                return false;
            }
            
            
            if ($('#phone').val().length > 20) {
                alert('전화번호는 20자 이내로 입력해주세요.');
                $('#phone').focus();
                return false;
            }
            
            return true;
        }
        
        function handleImageSelect(e) {
            let files = e.target.files;
            let preview = $('#imagePreview');
            
            selectedFiles = [];
            preview.empty();
            
            // 서블릿의 파일 개수 제한에 맞춤
            if(files.length > 5) {
                alert('이미지는 최대 5장까지 업로드 가능합니다.');
                e.target.value = '';
                return;
            }
            
            for(let i = 0; i < files.length; i++) {
                let file = files[i];
                
                if(!file.type.match('image.*')) {
                    alert('이미지 파일만 업로드 가능합니다.');
                    continue;
                }
                
                // 서블릿의 MAX_FILE_SIZE (5MB)와 일치
                if(file.size > 5 * 1024 * 1024) {
                    alert('파일 크기는 5MB 이하만 가능합니다: ' + file.name);
                    continue;
                }
                
                selectedFiles.push(file);
                
                let reader = new FileReader();
                reader.onload = function(event) {
                    let html = 
                        `<div class="image-preview-item">
                            <img src="${event.target.result}" alt="Preview">
                            <button type="button" class="remove-btn" onclick="removeImage(${selectedFiles.length - 1})">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>`;
                    preview.append(html);
                };
                reader.readAsDataURL(file);
            }
        }
        
        function removeImage(index) {
            selectedFiles.splice(index, 1);
            let preview = $('#imagePreview');
            preview.empty();
            
            selectedFiles.forEach(function(file, i) {
                let reader = new FileReader();
                reader.onload = function(e) {
                    let html = 
                        `<div class="image-preview-item">
                            <img src="${e.target.result}" alt="Preview">
                            <button type="button" class="remove-btn" onclick="removeImage(${i})">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>`;
                    preview.append(html);
                };
                reader.readAsDataURL(file);
            });
            
            $('#images').val('');
        }

        function goBack() {
            if (confirm('작성 중인 내용이 사라집니다. 정말 나가시겠습니까?')) {
                window.history.back();
            }
        }

        function logout() {
            if (confirm('정말 로그아웃하시겠습니까?')) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/LogoutServlet',
                    type: 'POST',
                    success: function() {
                        location.href = '${pageContext.request.contextPath}/';
                    },
                    error: function() {
                        location.href = '${pageContext.request.contextPath}/';
                    }
                });
            }
        }
    </script>
</body>
</html>