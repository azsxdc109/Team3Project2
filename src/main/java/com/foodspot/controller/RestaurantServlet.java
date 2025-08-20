package com.foodspot.controller;

import com.foodspot.dao.RestaurantDAO;
import com.foodspot.dto.RestaurantDTO;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import java.util.ArrayList;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

/**
 * 맛집 등록 요청을 처리하는 서블릿입니다.
 * 폼 데이터를 받아 RestaurantDTO에 담고, 이미지 파일을 저장한 후,
 * RestaurantDAO를 통해 DB에 저장합니다.
 */
@WebServlet("/RestaurantServlet")
public class RestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 실제 파일 저장 경로 (서버 외부 절대 경로)
    private static final String UPLOAD_PATH = "C:\\lx\\images\\";
    
    // 메모리 임계값: 3MB 이상의 파일은 임시 디스크에 저장
    private static final int MEMORY_THRESHOLD = 1024 * 1024 * 3;  // 3MB
    
    // 개별 파일 최대 크기: 5MB
    private static final int MAX_FILE_SIZE = 1024 * 1024 * 5;    // 5MB
    
    // 전체 요청 최대 크기: 50MB (여러 파일 업로드 시 모든 파일 크기 합계)
    private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 50; // 50MB
    
    // 민정님 작성 맛집 등록 요청 메서드
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 응답 타입을 JSON으로 설정합니다.
        response.setContentType("application/json; charset=UTF-8");
        
        // 클라이언트로 응답을 보내기 위한 PrintWriter 객체 생성
        PrintWriter out = response.getWriter();
        
        // JSON 응답을 생성하기 위한 Gson 라이브러리 객체
        Gson gson = new Gson();
        
        // 클라이언트에게 전송할 JSON 응답 객체
        JsonObject jsonResponse = new JsonObject();
        
        // 작성자 정보를 담기 위해 세션에서 user 정보 가져옴. 
        HttpSession session = request.getSession();
        
        // 세션에서 로그인된 사용자 ID 추출
        String loggedInUser = (String) session.getAttribute("loggedInUser");

        // 로그인 상태 확인
        if (loggedInUser == null) {
            // 비로그인 상태인 경우 에러 응답 생성
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "로그인이 필요한 서비스입니다.");
            
            // JSON 응답을 클라이언트에게 전송하고 메서드 종료
            out.print(gson.toJson(jsonResponse));
            out.flush();
            return;
        }

        // 멀티파트 폼 데이터인지 확인
        // 파일 업로드가 포함된 폼은 반드시 multipart/form-data 형식이어야 함
        if (!ServletFileUpload.isMultipartContent(request)) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "파일 업로드를 위해 multipart/form-data 형식으로 전송해야 합니다.");
            out.print(gson.toJson(jsonResponse));
            out.flush();
            return;
        }

        // 파일 업로드를 위한 DiskFileItemFactory 설정
        DiskFileItemFactory factory = new DiskFileItemFactory();
        
        // 메모리 임계값 설정: 이 크기를 초과하면 임시 파일로 저장
        factory.setSizeThreshold(MEMORY_THRESHOLD);
        
        // 임시 파일 저장 경로를 시스템 임시 디렉토리로 설정
        factory.setRepository(new File(System.getProperty("java.io.tmpdir")));

        // ServletFileUpload 객체 생성 및 크기 제한 설정
        ServletFileUpload upload = new ServletFileUpload(factory);
        
        // 개별 파일 최대 크기 설정
        upload.setFileSizeMax(MAX_FILE_SIZE);
        
        // 전체 요청 최대 크기 설정
        upload.setSizeMax(MAX_REQUEST_SIZE);
        
        // 업로드될 디렉토리 경로
        // ★ 핵심 수정 부분: 서버 외부의 고정 경로로 저장
        String uploadPath = UPLOAD_PATH; // 상수로 관리하여 일관성 유지
        
        // 업로드 디렉토리 File 객체 생성
        File uploadDir = new File(uploadPath);
        
        // 디렉토리가 존재하지 않으면 생성
        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs(); // mkdir() 대신 mkdirs() 사용
            System.out.println("Upload directory created: " + created + " at " + uploadPath);
            
            // 디렉토리 생성 실패 시 에러 응답
            if (!created) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "업로드 디렉토리 생성에 실패했습니다: " + uploadPath);
                out.print(gson.toJson(jsonResponse));
                out.flush();
                return;
            }
        }
        
        // 업로드된 파일 목록 (롤백용)
        List<File> uploadedFiles = new ArrayList<>();
        
        try {
            // multipart/form-data로 전송된 데이터를 파싱하여 FileItem 리스트로 변환
            // 세밀한 제어를 위해서 민정님의 MultipartRequest를 파싱했습니다.
            List<FileItem> formItems = upload.parseRequest(request);
            
            // 맛집 정보를 담을 DTO 객체 생성
            RestaurantDTO restaurant = new RestaurantDTO();
            
            // 업로드된 이미지 파일들의 파일명을 저장할 리스트
            List<String> imageFileNames = new ArrayList<>();

            // 폼에서 전송된 데이터가 있는지 확인
            if (formItems != null && formItems.size() > 0) {
                // 각 폼 아이템을 순회하며 처리
                for (FileItem item : formItems) {
                    // 파일 데이터인지 일반 폼 필드인지 구분
                    if (!item.isFormField()) {
                        // 파일 데이터인 경우 처리
                        
                        // 빈 파일 또는 파일명이 없는 경우 건너뛰기
                        if (item.getName() == null || item.getName().trim().isEmpty() || item.getSize() == 0) {
                            continue;
                        }
                        
                        // 한글 파일명 처리를 위한 개선된 코드
                        String fileName = new File(item.getName()).getName();

                        // 파일 확장자 추출
                        String fileExtension = "";
                        int lastDotIndex = fileName.lastIndexOf(".");
                        if (lastDotIndex > 0) {
                            fileExtension = fileName.substring(lastDotIndex);
                        }

                        // UUID만 사용하여 파일명 생성 (한글 문제 해결)
                        // 동일한 파일명 업로드 시 충돌을 방지하기 위함
                        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
                        
                        // 파일이 저장될 전체 경로 생성
                        String filePath = uploadPath + File.separator + uniqueFileName;
                        
                        // 저장할 파일 객체 생성
                        File storeFile = new File(filePath);
                        
                        // 파일 저장
                        item.write(storeFile);
                        
                        // 롤백을 위해 업로드된 파일 목록에 추가
                        uploadedFiles.add(storeFile);
                        
                        // 파일 저장 성공 로그
                        System.out.println("File saved successfully: " + filePath);
                        
                        // DB에는 파일명만 저장
                        imageFileNames.add(uniqueFileName); // 파일명만 저장: "uuid.jpg"
                        
                    } else {
                        // 폼 필드 데이터인 경우 처리
                        
                        // 폼 필드의 이름과 값 추출
                        String fieldName = item.getFieldName();
                        String fieldValue = item.getString("UTF-8"); // UTF-8 인코딩으로 값 추출
                        
                        // 필드 이름에 따라 RestaurantDTO 객체의 해당 속성에 값 설정
                        switch (fieldName) {
                            case "name":
                                restaurant.setName(fieldValue);
                                break;
                            case "category":
                                restaurant.setCategory(fieldValue);
                                break;
                            case "hotspot_region":
                                restaurant.setHotspotRegion(fieldValue);
                                break;
                            case "address":
                                restaurant.setAddress(fieldValue);
                                break;
                            case "phone":
                                restaurant.setPhone(fieldValue);
                                break;
                            case "hours":
                                restaurant.setOperatingHours(fieldValue);
                                break;
                            case "menu":
                                restaurant.setMenu(fieldValue);
                                break;
                            case "description":
                                restaurant.setDescription(fieldValue);
                                break;
                            // Post.jsp 수정하고 CASE문 추가
                            default:
                                // 알 수 없는 필드명에 대한 로그 (디버깅용)
                                System.out.println("Unknown field: " + fieldName + " = " + fieldValue);
                                break;
                        }
                    }
                }
            }

            // 첫 번째 이미지를 대표 이미지로 설정
            // 여러 이미지가 업로드된 경우 첫 번째를 메인 이미지로 사용
            if (!imageFileNames.isEmpty()) {
                restaurant.setImageUrl(imageFileNames.get(0));
            }
            
            // 로그인한 사용자 ID를 등록자로 설정
            restaurant.setPosterUserId(loggedInUser);

            // 필수 필드 검증
            if (restaurant.getName() == null || restaurant.getName().trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "맛집 이름은 필수 입력 항목입니다.");
                
                // 실패 시 업로드된 파일들 삭제 (롤백)
                rollbackUploadedFiles(uploadedFiles);
                
                out.print(gson.toJson(jsonResponse));
                out.flush();
                return;
            }

            // ★ 핵심 개선: 사용자 존재 여부 먼저 확인
            RestaurantDAO restaurantDAO = new RestaurantDAO();
            
            // 1단계: 사용자 ID 유효성 검증
            if (!isValidUser(loggedInUser)) {
                // 사용자가 DB에 존재하지 않는 경우
                rollbackUploadedFiles(uploadedFiles);
                
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "로그인 정보가 올바르지 않습니다. 다시 로그인해주세요.");
                
                System.err.println("Invalid user ID: " + loggedInUser + " not found in users table");
                
                out.print(gson.toJson(jsonResponse));
                out.flush();
                return;
            }
            
            // 2단계: 데이터베이스 저장 처리
            boolean dbSaveSuccess = false;
            String dbErrorMessage = "";
            
            try {
                // 저장 전 디버깅 로그
                System.out.println("Attempting to save restaurant: " + restaurant.getName() + 
                                 " by user: " + restaurant.getPosterUserId());
                
                // 맛집 정보를 데이터베이스에 삽입하고 결과 반환
                int result = restaurantDAO.insertRestaurant(restaurant);
                
                if (result > 0) {
                    dbSaveSuccess = true;
                    System.out.println("Database save successful. Rows affected: " + result);
                } else {
                    dbSaveSuccess = false;
                    dbErrorMessage = "데이터베이스에 저장되지 않았습니다. (반환값: " + result + ")";
                    System.err.println("Database save failed. No rows affected.");
                }
                
            } catch (SQLException sqlEx) {
                // SQL 예외 발생 시 - 상세한 에러 분석
                dbSaveSuccess = false;
                
                String errorCode = sqlEx.getSQLState();
                String errorMessage = sqlEx.getMessage();
                
                if (errorMessage.contains("foreign key constraint fails")) {
                    if (errorMessage.contains("fk_restaurants_users")) {
                        dbErrorMessage = "로그인 정보가 유효하지 않습니다. 다시 로그인 후 시도해주세요.";
                    } else {
                        dbErrorMessage = "데이터 연관성 오류가 발생했습니다.";
                    }
                } else if (errorMessage.contains("Duplicate entry")) {
                    dbErrorMessage = "중복된 데이터가 있습니다.";
                } else if (errorMessage.contains("Connection")) {
                    dbErrorMessage = "데이터베이스 연결에 실패했습니다.";
                } else {
                    dbErrorMessage = "데이터베이스 오류: " + errorMessage;
                }
                
                System.err.println("SQLException during restaurant save: " + errorMessage);
                System.err.println("SQL State: " + errorCode);
                sqlEx.printStackTrace();
                
            } catch (Exception dbEx) {
                // 기타 데이터베이스 관련 예외
                dbSaveSuccess = false;
                dbErrorMessage = "데이터베이스 처리 중 오류: " + dbEx.getMessage();
                System.err.println("Database error during restaurant save: " + dbEx.getMessage());
                dbEx.printStackTrace();
            }

            // ★ 결과에 따른 명확한 응답 처리
            if (dbSaveSuccess) {
                // DB 저장 성공한 경우
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "맛집이 성공적으로 등록되었습니다.");
                
                // 디버깅용 정보 추가
                jsonResponse.addProperty("uploadedFiles", imageFileNames.size());
                if (!imageFileNames.isEmpty()) {
                    jsonResponse.addProperty("mainImage", imageFileNames.get(0));
                }
                jsonResponse.addProperty("registeredBy", loggedInUser);
                
                System.out.println("Restaurant registration completed successfully for user: " + loggedInUser);
                
            } else {
                // DB 저장 실패한 경우 - 업로드된 파일들 삭제 (롤백)
                rollbackUploadedFiles(uploadedFiles);
                
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "맛집 등록에 실패했습니다: " + dbErrorMessage);
                
                System.err.println("Restaurant registration failed for user: " + loggedInUser + 
                                 ". Reason: " + dbErrorMessage);
            }

        } catch (Exception ex) {
            // 파일 업로드나 기타 처리 중 예외 발생 시
            
            // 업로드된 파일들 삭제 (롤백)
            rollbackUploadedFiles(uploadedFiles);
            
            // 서버 콘솔에 스택 트레이스 출력 (디버깅용)
            ex.printStackTrace();
            
            // 클라이언트에게 에러 응답 전송
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "서버 처리 중 오류가 발생했습니다: " + ex.getMessage());
            
            System.err.println("Unexpected error during restaurant registration: " + ex.getMessage());
            
        } finally {
            // try-catch 블록 실행 후 반드시 실행되는 블록
            
            // 생성된 JSON 응답을 클라이언트에게 전송
            out.print(gson.toJson(jsonResponse));
            
            // 출력 스트림 버퍼를 강제로 비워서 즉시 전송
            out.flush();
        }
    }
    
    /**
     * 사용자 ID가 유효한지 확인하는 메서드
     * @param userId 확인할 사용자 ID
     * @return 유효한 사용자면 true, 아니면 false
     */
    private boolean isValidUser(String userId) {
        if (userId == null || userId.trim().isEmpty()) {
            return false;
        }
        
        // UserDAO를 사용하여 사용자 존재 여부 확인
        // 만약 UserDAO가 없다면 직접 DB 확인
        try {
            // 간단한 사용자 존재 확인 쿼리
            java.sql.Connection conn = com.foodspot.util.DBConnection.getConnection();
            java.sql.PreparedStatement pstmt = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE user_id = ?");
            pstmt.setString(1, userId);
            java.sql.ResultSet rs = pstmt.executeQuery();
            
            boolean exists = false;
            if (rs.next()) {
                exists = rs.getInt(1) > 0;
            }
            
            rs.close();
            pstmt.close();
            conn.close();
            
            System.out.println("User validation for '" + userId + "': " + (exists ? "VALID" : "INVALID"));
            return exists;
            
        } catch (Exception e) {
            System.err.println("Error validating user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * DB 저장 실패 시 업로드된 파일들을 삭제하는 롤백 메서드
     * @param uploadedFiles 삭제할 파일 목록
     */
    private void rollbackUploadedFiles(List<File> uploadedFiles) {
        if (uploadedFiles != null && !uploadedFiles.isEmpty()) {
            System.out.println("Rolling back " + uploadedFiles.size() + " uploaded files due to DB save failure...");
            
            for (File file : uploadedFiles) {
                try {
                    if (file.exists() && file.delete()) {
                        System.out.println("Rollback: Successfully deleted file - " + file.getAbsolutePath());
                    } else {
                        System.err.println("Rollback: Failed to delete file - " + file.getAbsolutePath());
                    }
                } catch (Exception e) {
                    System.err.println("Rollback: Error deleting file " + file.getAbsolutePath() + ": " + e.getMessage());
                }
            }
        }
    }
}