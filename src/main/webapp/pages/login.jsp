<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>맛집내놔 - 로그인</title>
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
            /* Flexbox를 사용하여 컨텐츠를 화면 중앙에 배치합니다. */
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .login-container {
            background: white; /* 배경색을 흰색으로 설정 */
            border-radius: 20px; /* 모서리를 둥글게 만듭니다. */
            box-shadow: 0 20px 60px rgba(0,0,0,0.2); /* 그림자 효과를 추가합니다. */
            overflow: hidden; /* 자식 요소가 컨테이너 밖으로 넘어가지 않게 합니다. */
            width: 100%; /* 너비를 100%로 설정 */
            max-width: 400px; /* 최대 너비를 400px로 제한합니다. */
            animation: slideIn 0.5s ease-out; /* 페이지 로드 시 애니메이션 효과를 적용합니다. */
        }
        
        /* 로그인 컨테이너를 위한 애니메이션 키프레임 */
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
        
        .login-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, #34495e 100%); /* 그라데이션 배경 */
            color: white; /* 글자색을 흰색으로 설정 */
            padding: 30px; /* 내부 여백 설정 */
            text-align: center; /* 텍스트를 중앙 정렬 */
        }
        
        .login-header h2 {
            margin: 0; /* 마진 제거 */
            font-weight: 700; /* 글자 두께를 굵게 설정 */
        }
        
        .login-body {
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
        
        .btn-login {
            width: 100%; /* 너비를 부모 요소에 꽉 채웁니다. */
            padding: 12px; /* 내부 여백 설정 */
            border-radius: 10px; /* 모서리를 둥글게 */
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); /* 그라데이션 배경 */
            border: none; /* 테두리 제거 */
            color: white; /* 글자색을 흰색으로 설정 */
            font-weight: 600; /* 글자 두께 설정 */
            font-size: 1.1rem; /* 폰트 크기 설정 */
            transition: all 0.3s; /* 전환 효과 적용 */
            margin-top: 10px; /* 위쪽 외부 여백 설정 */
        }
        
        .btn-login:hover {
            transform: translateY(-2px); /* 마우스 오버 시 위로 살짝 이동 */
            box-shadow: 0 10px 20px rgba(102,126,234,0.3); /* 마우스 오버 시 그림자 효과 변경 */
        }
        
        .divider {
            text-align: center; /* 텍스트를 중앙 정렬 */
            margin: 25px 0; /* 위아래 외부 여백 설정 */
            position: relative; /* 자식 요소의 위치 기준이 됩니다. */
        }
        
        .divider::before {
            content: ''; /* 가상 요소의 내용 */
            position: absolute; /* 절대 위치 지정 */
            top: 50%; /* 부모 요소의 중앙에 위치 */
            left: 0;
            right: 0;
            height: 1px; /* 높이를 1px로 설정하여 선을 만듭니다. */
            background: #dee2e6; /* 선의 색상 */
        }
        
        .divider span {
            background: white; /* 배경색을 흰색으로 설정하여 선을 가립니다. */
            padding: 0 15px; /* 좌우 내부 여백 설정 */
            position: relative; /* 위치를 상대적으로 지정하여 선 위에 배치 */
            color: #6c757d; /* 글자색 설정 */
            font-size: 0.9rem; /* 폰트 크기 설정 */
        }
        
        .social-login {
            display: flex; /* Flexbox 레이아웃 적용 */
            gap: 10px; /* 요소들 사이의 간격 설정 */
            margin-bottom: 20px; /* 아래쪽 외부 여백 설정 */
        }
        
        .social-btn {
            flex: 1; /* 각 요소가 균등한 너비를 가지도록 설정 */
            padding: 10px; /* 내부 여백 설정 */
            border: 1px solid #dee2e6; /* 테두리 설정 */
            border-radius: 10px; /* 모서리를 둥글게 */
            background: white; /* 배경색을 흰색으로 설정 */
            color: #495057; /* 글자색 설정 */
            transition: all 0.3s; /* 전환 효과 적용 */
            text-decoration: none; /* 밑줄 제거 */
            text-align: center; /* 텍스트 중앙 정렬 */
        }
        
        .social-btn:hover {
            background: var(--light-bg); /* 마우스 오버 시 배경색 변경 */
            transform: translateY(-2px); /* 마우스 오버 시 위로 살짝 이동 */
        }
        
        .remember-me {
            display: flex; /* Flexbox 레이아웃 적용 */
            align-items: center; /* 세로 중앙 정렬 */
            margin-bottom: 20px; /* 아래쪽 외부 여백 설정 */
        }
        
        .remember-me input {
            margin-right: 8px; /* 체크박스와 레이블 사이 간격 설정 */
        }
        
        .links {
            text-align: center; /* 텍스트 중앙 정렬 */
            margin-top: 20px; /* 위쪽 외부 여백 설정 */
        }
        
        .links a {
            color: #667eea; /* 링크 글자색 설정 */
            text-decoration: none; /* 밑줄 제거 */
            font-size: 0.95rem; /* 폰트 크기 설정 */
            transition: color 0.3s; /* 글자색에 전환 효과 적용 */
        }
        
        .links a:hover {
            color: #764ba2; /* 마우스 오버 시 글자색 변경 */
            text-decoration: underline; /* 마우스 오버 시 밑줄 추가 */
        }
        
        .alert {
            border-radius: 10px; /* 모서리 둥글게 */
            margin-bottom: 20px; /* 아래쪽 외부 여백 설정 */
        }
        
        .back-home {
            position: absolute; /* 절대 위치 지정 */
            top: 20px; /* 위쪽에서 20px 떨어짐 */
            left: 20px; /* 왼쪽에서 20px 떨어짐 */
            color: white; /* 글자색을 흰색으로 설정 */
            text-decoration: none; /* 밑줄 제거 */
            font-size: 1.2rem; /* 폰트 크기 설정 */
            transition: all 0.3s; /* 전환 효과 적용 */
        }
        
        .back-home:hover {
            transform: translateX(-5px); /* 마우스 오버 시 왼쪽으로 살짝 이동 */
            color: #f0f0f0; /* 마우스 오버 시 글자색 변경 */
        }
    </style>
</head>
<body>
    <a href="${pageContext.request.contextPath}/" class="back-home">
        <i class="fas fa-arrow-left me-2"></i>홈으로
    </a>
    
    <div class="login-container">
        <div class="login-header">
            <i class="fas fa-utensils fa-3x mb-3"></i>
            <h2>맛집내놔</h2>
            <h2>로그인</h2>
            <p class="mb-0 mt-2">맛집 여행을 시작하세요</p>
        </div>
        
        <div class="login-body">
            <div id="alertBox"></div>
            
            <form id="loginForm">
                <div class="form-floating">
                    <input type="text" class="form-control" id="userId" name="userId" placeholder="아이디" required>
                    <label for="userId">
                        <i class="fas fa-user me-2"></i>아이디
                    </label>
                </div>
                
                <div class="form-floating">
                    <input type="password" class="form-control" id="password" name="password" placeholder="비밀번호" required>
                    <label for="password">
                        <i class="fas fa-lock me-2"></i>비밀번호
                    </label>
                </div>
                
                <div class="remember-me">
                    <input type="checkbox" id="rememberMe" name="rememberMe">
                    <label for="rememberMe" class="mb-0">로그인 상태 유지</label>
                </div>
                
                <button type="submit" class="btn btn-login">
                    <i class="fas fa-sign-in-alt me-2"></i>로그인
                </button>
            </form>
            
            <div class="divider">
                <span>또는</span>
            </div>
            
            <div class="social-login">
                <a href="#" class="social-btn">
                    <i class="fab fa-google me-2"></i>Google
                </a>
                <a href="#" class="social-btn">
                    <i class="fab fa-facebook-f me-2"></i>Facebook
                </a>
                <a href="#" class="social-btn">
                    <i class="fas fa-comment me-2"></i>Kakao
                </a>
            </div>
            
            <div class="links">
                <a href="register.jsp">아직 회원이 아니신가요? 회원가입</a><br>
                <a href="#" class="mt-2 d-inline-block">비밀번호를 잊으셨나요?</a>
            </div>
        </div>
    </div>
    
    <script>
    	// jQuery 사용
        // DOM이 완전히 로드된 후 실행될 코드
        $(document).ready(function() {
            // jQuery 셀렉터로 ID가 'loginForm'인 요소를 선택
            // 폼 제출 이벤트 핸들러
            $('#loginForm').on('submit', function(e) {
                // 기본 제출 동작(페이지 새로고침)을 막습니다.
                e.preventDefault();
                
                // 폼 데이터를 객체로 만듭니다.
                let formData = {
                    userId: $('#userId').val(),
                    password: $('#password').val(),
                    rememberMe: $('#rememberMe').is(':checked') // 체크박스 상태 확인
                };
                
                // AJAX POST 요청으로 'LoginServlet'을 호출합니다.
                $.ajax({
                    url: '${pageContext.request.contextPath}/LoginServlet',
                    type: 'POST',
                    data: formData, // 서버로 전송할 데이터
                    // 서버 요청이 성공했을 때 실행되는 콜백 함수
                    success: function(response) {
                        // 서블릿에서 반환된 JSON 응답을 처리합니다.
                        if(response.success) {
                            // 로그인 성공 시
                            showAlert('success', '로그인 성공! 잠시 후 메인 페이지로 이동합니다.');
                            // 1.5초 후 메인 페이지로 이동
                            setTimeout(function() {
                                location.href = '${pageContext.request.contextPath}/';
                            }, 1500);
                        } else {
                            // 로그인 실패 시
                            // 서버에서 받은 메시지를 사용하거나, 기본 메시지를 표시합니다.
                            showAlert('danger', response.message || '아이디 또는 비밀번호가 일치하지 않습니다.');
                        }
                    },
                    error: function() {
                        // AJAX 요청 실패 시
                        showAlert('danger', '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
                    }
                });
            });
        });
        
        // 경고 메시지를 동적으로 생성하여 표시하는 함수
        function showAlert(type, message) {
            let alertHtml = `
                <div class="alert alert-\${type} alert-dismissible fade show" role="alert">
                    \${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            `;
            // 'alertBox' 영역에 생성된 HTML을 삽입합니다.
            $('#alertBox').html(alertHtml);
        }
        
        // 아이디 입력 필드에서 엔터 키를 누르면 비밀번호 필드로 포커스 이동
        // keypress 이벤트가 발생하면 브라우저가 자동으로 KeyboardEvent 객체를 생성해서 콜백함수 매개변수로 전달함.
        $('#userId').on('keypress', function(e) {
        	// 13 (엔터키의 키코드)
            if(e.which === 13) {
                e.preventDefault();
                $('#password').focus();
            }
        });
    </script>
</body>
</html>