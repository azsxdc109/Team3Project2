package com.foodspot.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.foodspot.dao.ReviewDAO;
import com.foodspot.dao.ReviewImageDAO;
import com.foodspot.dto.ReviewDTO;
import com.foodspot.dto.ReviewImageDTO;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

/**
 * 리뷰 관련 요청을 처리하는 서블릿입니다.
 * - POST: 새로운 리뷰 등록
 * - GET: 특정 식당의 리뷰 목록 조회
 */
@WebServlet("/ReviewServlet")
public class ReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 파일 업로드 설정
    private static final String UPLOAD_DIRECTORY = "C:\\lx\\images";
    private static final int MEMORY_THRESHOLD = 1024 * 1024 * 3;  // 3MB
    private static final int MAX_FILE_SIZE = 1024 * 1024 * 5;    // 5MB
    private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 50; // 50MB
    
    // GET 요청 처리: 리뷰 목록 조회
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        JsonArray jsonReviews = new JsonArray();

        int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));

        ReviewDAO reviewDAO = new ReviewDAO();
        ReviewImageDAO reviewImageDAO = new ReviewImageDAO();

        try {
            List<ReviewDTO> reviews = reviewDAO.getReviewsByRestaurantId(restaurantId);
            
            for (ReviewDTO review : reviews) {
                // 각 리뷰의 이미지 목록을 조회하여 DTO에 추가
                List<String> imageUrls = reviewImageDAO.getReviewImagesByReviewId(review.getReviewId());
                review.setImageUrls(imageUrls);
                
                // DTO를 JSON 객체로 변환
                JsonObject reviewJson = new JsonObject();
                reviewJson.addProperty("reviewId", review.getReviewId());
                reviewJson.addProperty("restaurantId", review.getRestaurantId());
                reviewJson.addProperty("userId", review.getUserId());
                reviewJson.addProperty("userName", review.getUserName());
                reviewJson.addProperty("rating", review.getRating());
                reviewJson.addProperty("content", review.getContent());
                
                // 날짜 포맷 변경
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                reviewJson.addProperty("createdDate", sdf.format(review.getCreatedDate()));

                // 이미지 URL 목록을 JSON 배열로 추가
                JsonArray imagesArray = new JsonArray();
                for(String url : imageUrls) {
                    imagesArray.add(url);
                }
                reviewJson.add("images", imagesArray);
                
                jsonReviews.add(reviewJson);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            out.print(gson.toJson(jsonReviews));
            out.flush();
        }
    }
    
    // POST 요청 처리: 새로운 리뷰 등록
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 응답 타입을 JSON으로 설정
        response.setContentType("application/json; charset=UTF-8");
        // 클라이언트로 응답을 보내기 위한 PrintWriter 객체 생성
        PrintWriter out = response.getWriter();
        // JSON 응답을 생성하기 위한 Gson 라이브러리 객체
        Gson gson = new Gson();
        // 클라이언트에게 전송할 JSON 응답 객체
        JsonObject jsonResponse = new JsonObject();
        // 작성자 정보를 담기 위해 세션에서 user 정보 가져옴
        HttpSession session = request.getSession();
        // 세션에서 로그인된 사용자 ID 추출
        String loggedInUser = (String) session.getAttribute("loggedInUser");

        // 로그인 상태 확인
        if (loggedInUser == null) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "로그인이 필요한 서비스입니다.");
            out.print(gson.toJson(jsonResponse));
            out.flush();
            return;
        }

        // 멀티파트 폼 데이터인지 확인
        if (!ServletFileUpload.isMultipartContent(request)) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "파일 업로드를 위해 multipart/form-data 형식으로 전송해야 합니다.");
            out.print(gson.toJson(jsonResponse));
            out.flush();
            return;
        }
        
        // 파일 업로드를 위한 DiskFileItemFactory 설정
        DiskFileItemFactory factory = new DiskFileItemFactory();
        
        // 메모리 임계값 설정
        factory.setSizeThreshold(MEMORY_THRESHOLD);
        
        // 임시 파일 저장 경로 설정
        factory.setRepository(new File(System.getProperty("java.io.tmpdir")));

        // ServletFileUpload 객체 생성 및 크기 제한 설정
        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setFileSizeMax(MAX_FILE_SIZE);
        upload.setSizeMax(MAX_REQUEST_SIZE);
        
        // ★ 수정: 서버 외부의 고정 경로로 업로드 디렉토리 설정
        String uploadPath = UPLOAD_DIRECTORY;
        
        File uploadDir = new File(uploadPath);
        
        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs();
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
            List<FileItem> formItems = upload.parseRequest(request);
            
            ReviewDTO review = new ReviewDTO();
            
            // ★ 수정: DB에 저장할 파일명 리스트
            List<String> savedImageNames = new ArrayList<>();
            
            if (formItems != null && formItems.size() > 0) {
                for (FileItem item : formItems) {
                    if (!item.isFormField()) {
                        // 파일 데이터인 경우 처리
                        if (item.getName() == null || item.getName().trim().isEmpty() || item.getSize() == 0) {
                            continue;
                        }
                    
                        String fileName = new File(item.getName()).getName();
                        String fileExtension = "";
                        int lastDotIndex = fileName.lastIndexOf(".");
                        if (lastDotIndex > 0) {
                            fileExtension = fileName.substring(lastDotIndex).toLowerCase();
                        }
                        
                        if (!isValidImageExtension(fileExtension)) {
                            continue;
                        }

                        // UUID만 사용하여 파일명 생성
                        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
                        
                        // 파일이 저장될 전체 경로 생성
                        String filePath = uploadPath + File.separator + uniqueFileName;
                    
                        File storeFile = new File(filePath);
                        
                        item.write(storeFile);
                        uploadedFiles.add(storeFile);

                        // ★ 수정: DB에는 파일명만 저장
                        savedImageNames.add(uniqueFileName);
                               
                    } else {
                        // 폼 필드 데이터 처리
                        String fieldName = item.getFieldName();
                        String fieldValue = item.getString("UTF-8");
                        
                        switch (fieldName) {
                            case "restaurantId":
                                review.setRestaurantId(Integer.parseInt(fieldValue));
                                break;
                            case "rating":
                                review.setRating(Integer.parseInt(fieldValue));
                                break;
                            case "content":
                                review.setContent(fieldValue);
                                break;
                        }
                    }
                }
            }
            
            if (review.getRestaurantId() == 0 || review.getRating() == 0 || 
                review.getContent() == null || review.getContent().trim().isEmpty()) {
                
                rollbackUploadedFiles(uploadedFiles);
                
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "리뷰 작성에 필요한 정보가 부족합니다.");
                out.print(gson.toJson(jsonResponse));
                out.flush();
                return;
            }
            
            review.setUserId(loggedInUser);

            ReviewDAO reviewDAO = new ReviewDAO();
            ReviewImageDAO reviewImageDAO = new ReviewImageDAO();
            
            boolean dbSaveSuccess = false;
            
            try {
                // 1. 리뷰 정보 DB에 저장
                int reviewId = reviewDAO.insertReview(review);

                if (reviewId > 0) {
                    // 2. 리뷰 이미지 정보 DB에 저장
                    // ★ 수정: DB에 파일명만 저장하도록 변경
                    for (String imageName : savedImageNames) {                  
                        ReviewImageDTO reviewImage = new ReviewImageDTO();
                        reviewImage.setReviewId(reviewId);
                        // imagePath 대신 imageName을 사용
                        reviewImage.setImagePath(imageName); 
                        reviewImageDAO.insertReviewImage(reviewImage);
                    }
                    dbSaveSuccess = true;
                }
            } catch (Exception dbEx) {
                dbEx.printStackTrace();
                dbSaveSuccess = false;
            }

            if (dbSaveSuccess) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "리뷰가 성공적으로 등록되었습니다.");
            } else {
                // 리뷰 등록 실패 시 업로드된 파일들 삭제
                rollbackUploadedFiles(uploadedFiles);
                
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "리뷰 등록에 실패했습니다.");
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            
            // 예외 발생 시 업로드된 파일들 삭제
            rollbackUploadedFiles(uploadedFiles);
            
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "서버 오류: " + ex.getMessage());
            
        } finally {
            out.print(gson.toJson(jsonResponse));
            out.flush();
        }
    }
	
	/**
	 * 지원되는 이미지 확장자인지 확인
	 */
	private boolean isValidImageExtension(String extension) {
	    String[] validExtensions = {".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp"};
	    for (String validExt : validExtensions) {
	        if (validExt.equals(extension)) {
	            return true;
	        }
	    }
	    return false;
	}
	
	/**
	 * 업로드된 파일들을 삭제하는 롤백 메서드
	 */
	private void rollbackUploadedFiles(List<File> uploadedFiles) {
	    for (File file : uploadedFiles) {
	        try {
	            if (file.exists() && file.delete()) {
	                System.out.println("Rollback: File deleted - " + file.getAbsolutePath());
	            }
	        } catch (Exception e) {
	            System.err.println("Failed to delete file during rollback: " + file.getAbsolutePath());
	            e.printStackTrace();
	        }
	    }
	}
}
