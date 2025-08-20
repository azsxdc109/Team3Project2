<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>맛집내놔 - 회원가입</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* CSS 변수: 프로젝트 전반에 걸쳐 재사용할 색상, 폰트 등을 정의합니다. */
        :root {
            --primary-color: #2c3e50; /* 기본 색상 (어두운 파랑) */
            --secondary-color: #e74c3c; /* 보조 색상 (붉은색) */
            --light-bg: #f8f9fa; /* 밝은 배경색 */
            --border-radius: 12px; /* 모서리 둥글기 값 */
        }
        
        body {
            /* 폰트 설정 */
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            /* 배경색을 그라데이션으로 설정합니다. */
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            /* 최소 높이를 뷰포트 높이로 설정하여 화면 전체를 채웁니다. */
            min-height: 100vh;
            /* 위아래 여백을 40px씩 줍니다. */
            padding: 40px 0;
        }
        
        .register-container {
            background: white; /* 배경색을 흰색으로 설정 */
            border-radius: 20px; /* 모서리를 둥글게 만듭니다. */
            box-shadow: 0 20px 60px rgba(0,0,0,0.2); /* 그림자 효과를 추가합니다. */
            overflow: hidden; /* 자식 요소가 컨테이너 밖으로 넘어가지 않게 합니다. */
            width: 100%; /* 너비를 100%로 설정 */
            max-width: 500px; /* 최대 너비를 500px로 제한합니다. */
            margin: 0 auto; /* 좌우 중앙 정렬 */
            animation: slideIn 0.5s ease-out; /* 페이지 로드 시 애니메이션 효과를 적용합니다. */
        }
        
        /* 회원가입 컨테이너를 위한 애니메이션 키프레임 */
        @keyframes slideIn {
            from {
                opacity: 0; /* 시작 시 투명도를 0으로 설정 */
                transform: translateY(-30px); /* 시작 시 y축으로 30px 위로 이동 */
            }
            to {
                opacity: 1; /* 종료 시 투명도를 1로 설정 */
                transform: translateY(0); /* 종료 시 원래 위치로 복귀 */
            }
        }
        
        .register-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, #34495e 100%); /* 그라데이션 배경 */
            color: white; /* 글자색을 흰색으로 설정 */
            padding: 30px; /* 내부 여백 설정 */
            text-align: center; /* 텍스트를 중앙 정렬 */
        }
        
        .register-header h2 {
            margin: 0; /* 마진 제거 */
            font-weight: 700; /* 글자 두께를 굵게 설정 */
        }
        
        .register-body {
            padding: 40px 30px; /* 내부 여백 설정 */
        }
        
        .form-floating {
            margin-bottom: 20px; /* 아래쪽 외부 여백 설정 */
        }
        
        .form-control {
            border-radius: 10px; /* 모서리를 둥글게 */
            border: 1px solid #dee2e6; /* 테두리 설정 */
            padding: 12px 15px; /* 내부 여백 설정 */
            font-size: 1rem; /* 폰트 크기 설정 */
            transition: all 0.3s; /* 모든 속성에 0.3초의 전환 효과 적용 */
        }
        
        .form-control:focus {
            border-color: #667eea; /* 포커스 시 테두리 색상 변경 */
            box-shadow: 0 0 0 0.2rem rgba(102,126,234,0.25); /* 포커스 시 그림자 효과 추가 */
        }
        
        .form-control.is-valid {
            border-color: #28a745; /* 유효성 검사 통과 시 테두리 색상 */
        }
        
        .form-control.is-invalid {
            border-color: #dc3545; /* 유효성 검사 실패 시 테두리 색상 */
        }
        
        .invalid-feedback, .valid-feedback {
            font-size: 0.875rem; /* 피드백 메시지 폰트 크기 */
            margin-top: 5px; /* 위쪽 외부 여백 설정 */
        }
        
        .btn-register {
            width: 100%; /* 너비를 부모 요소에 꽉 채웁니다. */
            padding: 12px; /* 내부 여백 설정 */
            border-radius: 10px; /* 모서리를 둥글게 */
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); /* 그라데이션 배경 */
            border: none; /* 테두리 제거 */
            color: white; /* 글자색을 흰색으로 설정 */
            font-weight: 600; /* 글자 두께 설정 */
            font-size: 1.1rem; /* 폰트 크기 설정 */
            transition: all 0.3s; /* 전환 효과 적용 */
            margin-top: 20px; /* 위쪽 외부 여백 설정 */
        }
        
        .btn-register:hover {
            transform: translateY(-2px); /* 마우스 오버 시 위로 살짝 이동 */
            box-shadow: 0 10px 20px rgba(102,126,234,0.3); /* 마우스 오버 시 그림자 효과 변경 */
        }
        
        .btn-register:disabled {
            opacity: 0.6; /* 비활성화 상태일 때 투명도를 낮춥니다. */
            cursor: not-allowed; /* 커서를 변경하여 클릭할 수 없음을 표시합니다. */
        }
        
        .back-home {
            position: fixed; /* 화면에 고정 */
            top: 20px; /* 위쪽에서 20px 떨어짐 */
            left: 20px; /* 왼쪽에서 20px 떨어짐 */
            color: white; /* 글자색을 흰색으로 설정 */
            text-decoration: none; /* 밑줄 제거 */
            font-size: 1.2rem; /* 폰트 크기 설정 */
            transition: all 0.3s; /* 전환 효과 적용 */
            z-index: 100; /* 다른 요소들 위에 보이도록 설정 */
        }
        
        .back-home:hover {
            transform: translateX(-5px); /* 마우스 오버 시 왼쪽으로 살짝 이동 */
            color: #f0f0f0; /* 마우스 오버 시 글자색 변경 */
        }
        
        .progress {
            height: 5px; /* 진행바의 높이 */
            margin-top: 10px; /* 위쪽 외부 여백 */
            border-radius: 5px; /* 모서리를 둥글게 */
        }
        
        .password-strength {
            font-size: 0.85rem; /* 폰트 크기 */
            margin-top: 5px; /* 위쪽 외부 여백 */
        }
        
        .terms-box {
            background: var(--light-bg); /* 배경색을 밝게 */
            border-radius: 10px; /* 모서리를 둥글게 */
            padding: 15px; /* 내부 여백 */
            margin-bottom: 20px; /* 아래쪽 외부 여백 */
            font-size: 0.9rem; /* 폰트 크기 */
        }
        
        .terms-box input {
            margin-right: 8px; /* 체크박스와 레이블 사이 간격 */
        }
        
        .links {
            text-align: center; /* 텍스트 중앙 정렬 */
            margin-top: 20px; /* 위쪽 외부 여백 */
        }
        
        .links a {
            color: #667eea; /* 링크 글자색 */
            text-decoration: none; /* 밑줄 제거 */
            font-size: 0.95rem; /* 폰트 크기 */
        }
        
        .links a:hover {
            color: #764ba2; /* 마우스 오버 시 글자색 변경 */
            text-decoration: underline; /* 마우스 오버 시 밑줄 추가 */
        }
    </style>
</head>
<body>
    <a href="../index.jsp" class="back-home">
        <i class="fas fa-arrow-left me-2"></i>홈으로
    </a>
    
    <div class="register-container">
        <div class="register-header">
            <i class="fas fa-user-plus fa-3x mb-3"></i>
            <h2>회원가입</h2>
            <p class="mb-0 mt-2">맛집내놔와 함께 맛집 여행을 시작하세요</p>
        </div>
        
        <div class="register-body">
            <form id="registerForm">
                <div class="form-floating">
                    <input type="text" class="form-control" id="userId" name="userId" placeholder="아이디" required>
                    <label for="userId">
                        <i class="fas fa-user me-2"></i>아이디 (영문, 숫자 4-20자)
                    </label>
                    <div class="invalid-feedback">
                        이미 사용중인 아이디입니다.
                    </div>
                    <div class="valid-feedback">
                        사용 가능한 아이디입니다.
                    </div>
                </div>
                
                <div class="form-floating">
                    <input type="password" class="form-control" id="password" name="password" placeholder="비밀번호" required>
                    <label for="password">
                        <i class="fas fa-lock me-2"></i>비밀번호 (8자 이상)
                    </label>
                    <div class="password-strength" id="passwordStrength"></div>
                    <div class="progress">
                        <div class="progress-bar" id="passwordStrengthBar" role="progressbar" style="width: 0%"></div>
                    </div>
                </div>
                
                <div class="form-floating">
                    <input type="password" class="form-control" id="passwordConfirm" placeholder="비밀번호 확인" required>
                    <label for="passwordConfirm">
                        <i class="fas fa-lock me-2"></i>비밀번호 확인
                    </label>
                    <div class="invalid-feedback">
                        비밀번호가 일치하지 않습니다.
                    </div>
                    <div class="valid-feedback">
                        비밀번호가 일치합니다.
                    </div>
                </div>
                
                <div class="form-floating">
                    <input type="text" class="form-control" id="userName" name="userName" placeholder="이름" required>
                    <label for="userName">
                        <i class="fas fa-id-card me-2"></i>이름
                    </label>
                </div>
                
                <div class="form-floating">
                    <input type="email" class="form-control" id="email" name="email" placeholder="이메일" required>
                    <label for="email">
                        <i class="fas fa-envelope me-2"></i>이메일
                    </label>
                    <div class="invalid-feedback">
                        올바른 이메일 형식이 아닙니다.
                    </div>
                </div>
                
                <div class="form-floating">
                    <input type="tel" class="form-control" id="phone" name="phone" placeholder="전화번호">
                    <label for="phone">
                        <i class="fas fa-phone me-2"></i>전화번호 (선택)
                    </label>
                </div>
                
                <div class="terms-box">
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="agreeAll">
                        <label class="form-check-label fw-bold" for="agreeAll">
                            전체 동의
                        </label>
                    </div>
                    <hr>
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input agree-item" id="agreeTerms" required>
                        <label class="form-check-label" for="agreeTerms">
                            [필수] 이용약관에 동의합니다
                        </label>
                    </div>
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input agree-item" id="agreePrivacy" required>
                        <label class="form-check-label" for="agreePrivacy">
                            [필수] 개인정보 처리방침에 동의합니다
                        </label>
                    </div>
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input agree-item" id="agreeMarketing">
                        <label class="form-check-label" for="agreeMarketing">
                            [선택] 마케팅 정보 수신에 동의합니다
                        </label>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-register" id="submitBtn">
                    <i class="fas fa-user-plus me-2"></i>가입하기
                </button>
            </form>
            
            <div class="links">
                <span>이미 회원이신가요?</span>
                <a href="login.jsp">로그인하기</a>
            </div>
        </div>
    </div>
    
    <script>
        $(document).ready(function() {
            // 각 유효성 검사 결과를 저장할 변수
            let isUserIdValid = false;
            let isPasswordValid = false;
            let isPasswordConfirmValid = false;
            let isEmailValid = false;
            
            // 아이디 입력 필드에서 포커스를 잃었을 때(blur) 중복 체크 실행
            $('#userId').on('blur', function() {
            	// this는 이벤트를 발생시킨 HTML 요소
                let userId = $(this).val().trim();
                // 아이디 길이 유효성 검사
                if(userId.length < 4 || userId.length > 20) {
                    $(this).removeClass('is-valid').addClass('is-invalid');
                    $(this).siblings('.invalid-feedback').text('아이디는 4-20자여야 합니다.');
                    isUserIdValid = false;
                    return;
                }
                
                // AJAX를 이용한 아이디 중복 확인
                $.ajax({
                    url: '${pageContext.request.contextPath}/CheckIdServlet',
                    type: 'POST',
                    data: { userId: userId },
                    success: function(response) {
                        if(response.available) {
                            // 사용 가능한 아이디인 경우
                            $('#userId').removeClass('is-invalid').addClass('is-valid');
                            isUserIdValid = true;
                        } else {
                            // 중복된 아이디인 경우
                            $('#userId').removeClass('is-valid').addClass('is-invalid');
                            $('#userId').siblings('.invalid-feedback').text('이미 사용중인 아이디입니다.');
                            isUserIdValid = false;
                        }
                    }
                });
            });
            
            // 비밀번호 입력 시 강도 체크
            $('#password').on('input', function() {
                let password = $(this).val();
                let strength = 0;
                let strengthText = '';
                let strengthColor = '';
                
                // 비밀번호 강도 계산 로직
                if(password.length >= 8) strength += 25; // 8자 이상
                if(password.length >= 12) strength += 25; // 12자 이상
                if(/[a-z]/.test(password) && /[A-Z]/.test(password)) strength += 25; // 소문자/대문자 혼합
                if(/[0-9]/.test(password)) strength += 12.5; // 숫자 포함
                if(/[^a-zA-Z0-9]/.test(password)) strength += 12.5; // 특수문자 포함
                
                // 강도에 따른 텍스트와 색상 설정
                if(strength <= 25) {
                    strengthText = '약함';
                    strengthColor = 'bg-danger';
                } else if(strength <= 50) {
                    strengthText = '보통';
                    strengthColor = 'bg-warning';
                } else if(strength <= 75) {
                    strengthText = '강함';
                    strengthColor = 'bg-info';
                } else {
                    strengthText = '매우 강함';
                    strengthColor = 'bg-success';
                }
                
                // 비밀번호 강도 메시지와 진행바 업데이트
                $('#passwordStrength').text(strengthText);
                $('#passwordStrengthBar').css('width', strength + '%')
                    .removeClass('bg-danger bg-warning bg-info bg-success')
                    .addClass(strengthColor);
                
                isPasswordValid = password.length >= 8;
                checkPasswordMatch(); // 비밀번호가 변경될 때마다 비밀번호 확인 필드도 체크
            });
            
            // 비밀번호 확인 입력 시 일치 여부 체크
            $('#passwordConfirm').on('input', function() {
                checkPasswordMatch();
            });
            
            // 비밀번호와 비밀번호 확인 필드의 일치 여부를 검사하는 함수
            function checkPasswordMatch() {
                let password = $('#password').val();
                let passwordConfirm = $('#passwordConfirm').val();
                
                if(passwordConfirm.length > 0) {
                    if(password === passwordConfirm) {
                        // 일치하는 경우
                        $('#passwordConfirm').removeClass('is-invalid').addClass('is-valid');
                        isPasswordConfirmValid = true;
                    } else {
                        // 일치하지 않는 경우
                        $('#passwordConfirm').removeClass('is-valid').addClass('is-invalid');
                        isPasswordConfirmValid = false;
                    }
                }
            }
            
            // 이메일 입력 필드에서 포커스를 잃었을 때 유효성 체크
            $('#email').on('blur', function() {
                let email = $(this).val();
                let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/; // 기본적인 이메일 정규식
                
                if(emailRegex.test(email)) {
                    $(this).removeClass('is-invalid').addClass('is-valid');
                    isEmailValid = true;
                } else {
                    $(this).removeClass('is-valid').addClass('is-invalid');
                    isEmailValid = false;
                }
            });
            
            // 전체 동의 체크박스
            $('#agreeAll').on('change', function() {
                // '전체 동의' 체크박스 상태에 따라 모든 약관 동의 체크박스 상태 변경
                $('.agree-item').prop('checked', $(this).prop('checked'));
            });
            
            // 개별 약관 동의 체크박스
            $('.agree-item').on('change', function() {
                // 필수 약관이 모두 체크되었는지 확인 (현재 코드는 모든 약관이 체크되었는지 확인)
                let allChecked = $('.agree-item:checked').length === $('.agree-item').length;
                // 모든 약관이 체크되었으면 '전체 동의' 체크박스도 체크
                $('#agreeAll').prop('checked', allChecked);
            });
            
            // 폼 제출 이벤트 핸들러
            $('#registerForm').on('submit', function(e) {
                e.preventDefault(); // 기본 제출 동작(페이지 새로고침) 방지
                
                // 모든 유효성 검사 변수 확인
                if(!isUserIdValid || !isPasswordValid || !isPasswordConfirmValid || !isEmailValid) {
                	let errorMessage = '입력 정보를 다시 확인해주세요.';

                    if (!isUserIdValid) {
                        errorMessage += '\n- 아이디를 확인해주세요.';
                    }
                    if (!isPasswordValid) {
                        errorMessage += '\n- 비밀번호는 8자 이상이어야 합니다.';
                    }
                    if (!isPasswordConfirmValid) {
                        errorMessage += '\n- 비밀번호 확인이 일치하지 않습니다.';
                    }
                    if (!isEmailValid) {
                        errorMessage += '\n- 이메일 형식이 올바르지 않습니다.';
                    }

                    alert(errorMessage);
                    return;
                }
                
                // 폼의 모든 데이터를 직렬화(serialize)하여 가져옵니다.
                let formData = $(this).serialize();
                
                // AJAX POST 요청으로 'RegisterServlet'을 호출합니다.
                $.ajax({
                    url: '${pageContext.request.contextPath}/RegisterServlet',
                    type: 'POST',
                    data: formData,
                    success: function(response) {
                        if(response.success) {
                            alert('회원가입이 완료되었습니다. 로그인 페이지로 이동합니다.');
                            location.href = 'login.jsp';
                        } else {
                            // 서버에서 실패 메시지를 받으면 표시
                            alert(response.message || '회원가입에 실패했습니다.');
                        }
                    },
                    error: function() {
                        // AJAX 요청 실패 시
                        alert('서버 오류가 발생했습니다.');
                    }
                });
            });
        });
    </script>
</body>
</html>