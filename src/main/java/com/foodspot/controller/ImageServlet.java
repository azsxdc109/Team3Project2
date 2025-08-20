package com.foodspot.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

/**
 * 업로드된 이미지 파일을 클라이언트에게 제공하는 서블릿입니다.
 * 보안을 위해 직접 파일 접근을 차단하고 서블릿을 통한 제어된 접근을 제공합니다.
 * 
 * URL 패턴: /image/파일명
 * 예시: http://localhost:9000/Team3/image/uuid-filename.jpg
 */
@WebServlet("/image/*")
public class ImageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // RestaurantServlet과 동일한 업로드 경로 사용
    private static final String UPLOAD_PATH = "C:\\lx\\images\\";
    
    // 지원하는 이미지 파일 확장자 (보안상 제한)
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp"};
    
    // 기본 이미지 캐시 시간 (1년)
    private static final long CACHE_MAX_AGE = 365 * 24 * 60 * 60; // 1년을 초 단위로
    
    /**
     * GET 요청을 처리하여 이미지 파일을 클라이언트에게 전송합니다.
     * 
     * @param request  클라이언트 요청 객체
     * @param response 서버 응답 객체
     * @throws ServletException 서블릿 처리 중 오류 발생 시
     * @throws IOException      입출력 오류 발생 시
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // URL에서 파일명 추출: /image/uuid-filename.jpg -> uuid-filename.jpg
        String pathInfo = request.getPathInfo();
        
        // 경로 정보가 없거나 잘못된 경우 404 에러 반환
        if (pathInfo == null || pathInfo.length() <= 1) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "이미지 파일명이 지정되지 않았습니다.");
            return;
        }
        
        // 맨 앞의 "/" 제거하여 실제 파일명 추출
        String fileName = pathInfo.substring(1);
        
        // 파일명 보안 검증 (디렉토리 탐색 공격 방지)
        if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 파일명입니다.");
            return;
        }
        
        // 허용된 파일 확장자인지 확인
        if (!isAllowedImageExtension(fileName)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "허용되지 않는 파일 형식입니다.");
            return;
        }
        
        // 실제 파일 경로 생성
        File imageFile = new File(UPLOAD_PATH + fileName);
        
        try {
            // 파일 존재 여부 및 보안 검사
            if (!imageFile.exists() || !imageFile.isFile()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "요청한 이미지를 찾을 수 없습니다.");
                return;
            }
            
            // 파일이 지정된 업로드 디렉토리 내에 있는지 확인 (보안 검증)
            String canonicalFilePath = imageFile.getCanonicalPath();
            String canonicalUploadPath = new File(UPLOAD_PATH).getCanonicalPath();
            
            if (!canonicalFilePath.startsWith(canonicalUploadPath)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근이 거부되었습니다.");
                return;
            }
            
            // 파일 확장자에 따른 MIME 타입 설정
            String mimeType = getMimeTypeByExtension(fileName);
            if (mimeType == null) {
                // 알 수 없는 타입인 경우 기본값 설정
                mimeType = "application/octet-stream";
            }
            response.setContentType(mimeType);
            
            // 파일 크기 설정 (브라우저 최적화)
            response.setContentLengthLong(imageFile.length());
            
            // HTTP 캐시 헤더 설정 (성능 향상)
            response.setHeader("Cache-Control", "public, max-age=" + CACHE_MAX_AGE);
            response.setHeader("Expires", new java.util.Date(System.currentTimeMillis() + CACHE_MAX_AGE * 1000).toString());
            
            // ETag 설정 (캐시 효율성 향상)
            String etag = fileName + "_" + imageFile.lastModified() + "_" + imageFile.length();
            response.setHeader("ETag", "\"" + etag + "\"");
            
            // 클라이언트의 If-None-Match 헤더 확인 (304 Not Modified 응답 가능)
            String ifNoneMatch = request.getHeader("If-None-Match");
            if (ifNoneMatch != null && ifNoneMatch.equals("\"" + etag + "\"")) {
                response.setStatus(HttpServletResponse.SC_NOT_MODIFIED);
                return;
            }
            
            // 파일 내용을 응답으로 전송
            try (FileInputStream fis = new FileInputStream(imageFile);
                 OutputStream os = response.getOutputStream()) {
                
                // 8KB 버퍼로 파일 내용 복사 (메모리 효율성)
                byte[] buffer = new byte[8192];
                int bytesRead;
                
                while ((bytesRead = fis.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                }
                
                // 버퍼 강제 출력
                os.flush();
            }
            
            // 성공 로그 (운영 환경에서는 제거 고려)
            System.out.println("Image served successfully: " + fileName + " (Size: " + imageFile.length() + " bytes)");
            
        } catch (IOException e) {
            // 파일 읽기 오류 처리
            System.err.println("Error serving image: " + fileName + " - " + e.getMessage());
            e.printStackTrace();
            
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "이미지 로드 중 오류가 발생했습니다.");
            }
        }
    }
    
    /**
     * 파일 확장자가 허용된 이미지 형식인지 확인합니다.
     * 
     * @param fileName 확인할 파일명
     * @return 허용된 확장자면 true, 아니면 false
     */
    private boolean isAllowedImageExtension(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return false;
        }
        
        // 파일명을 소문자로 변환하여 확장자 확인
        String lowerFileName = fileName.toLowerCase();
        
        for (String extension : ALLOWED_EXTENSIONS) {
            if (lowerFileName.endsWith(extension)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * 파일 확장자에 따라 적절한 MIME 타입을 반환합니다.
     * 
     * @param fileName 파일명
     * @return MIME 타입 문자열
     */
    private String getMimeTypeByExtension(String fileName) {
        if (fileName == null) {
            return null;
        }
        
        String lowerFileName = fileName.toLowerCase();
        
        // 주요 이미지 형식별 MIME 타입 매핑
        if (lowerFileName.endsWith(".jpg") || lowerFileName.endsWith(".jpeg")) {
            return "image/jpeg";
        } else if (lowerFileName.endsWith(".png")) {
            return "image/png";
        } else if (lowerFileName.endsWith(".gif")) {
            return "image/gif";
        } else if (lowerFileName.endsWith(".bmp")) {
            return "image/bmp";
        } else if (lowerFileName.endsWith(".webp")) {
            return "image/webp";
        }
        
        return null;
    }
    
    /**
     * POST 요청은 지원하지 않습니다.
     * 이미지 조회는 GET 요청으로만 처리됩니다.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST 요청은 지원되지 않습니다.");
    }
}