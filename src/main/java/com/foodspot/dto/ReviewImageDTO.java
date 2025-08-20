package com.foodspot.dto;

/**
 * 리뷰 이미지 정보를 담는 DTO 클래스
 */
public class ReviewImageDTO {
    private int imageId;        // 이미지 고유 ID
    private int reviewId;       // 이미지가 속한 리뷰 ID
    private String imagePath;   // 이미지 파일 경로
    
    // 기본 생성자
    public ReviewImageDTO() {}
    
    // 전체 필드 생성자
    public ReviewImageDTO(int imageId, int reviewId, String imagePath) {
        this.imageId = imageId;
        this.reviewId = reviewId;
        this.imagePath = imagePath;
    }
    
    // reviewId와 imagePath만 사용하는 생성자 (새 이미지 등록시)
    public ReviewImageDTO(int reviewId, String imagePath) {
        this.reviewId = reviewId;
        this.imagePath = imagePath;
    }
    
    // Getter and Setter methods
    public int getImageId() {
        return imageId;
    }
    
    public void setImageId(int imageId) {
        this.imageId = imageId;
    }
    
    public int getReviewId() {
        return reviewId;
    }
    
    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }
    
    public String getImagePath() {
        return imagePath;
    }
    
    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
    
    // 유틸리티 메서드들
    
    /**
     * 이미지 경로가 유효한지 확인
     * @return 유효성 여부
     */
    public boolean hasValidPath() {
        return imagePath != null && !imagePath.trim().isEmpty();
    }
    
    /**
     * 파일 확장자 반환
     * @return 파일 확장자 (예: ".jpg", ".png")
     */
    public String getFileExtension() {
        if (imagePath != null && imagePath.contains(".")) {
            return imagePath.substring(imagePath.lastIndexOf(".")).toLowerCase();
        }
        return "";
    }
    
    /**
     * 파일명만 반환 (경로 제외)
     * @return 파일명
     */
    public String getFileName() {
        if (imagePath != null && imagePath.contains("/")) {
            return imagePath.substring(imagePath.lastIndexOf("/") + 1);
        } else if (imagePath != null && imagePath.contains("\\")) {
            return imagePath.substring(imagePath.lastIndexOf("\\") + 1);
        }
        return imagePath;
    }
    
    /**
     * 이미지가 웹 URL인지 확인
     * @return URL 여부
     */
    public boolean isWebUrl() {
        return imagePath != null && 
               (imagePath.startsWith("http://") || imagePath.startsWith("https://"));
    }
    
    /**
     * 지원되는 이미지 형식인지 확인
     * @return 지원 여부
     */
    public boolean isSupportedImageFormat() {
        String extension = getFileExtension();
        return extension.equals(".jpg") || extension.equals(".jpeg") || 
               extension.equals(".png") || extension.equals(".gif") || 
               extension.equals(".bmp") || extension.equals(".webp");
    }
    
    @Override
    public String toString() {
        return "ReviewImageDTO{" +
                "imageId=" + imageId +
                ", reviewId=" + reviewId +
                ", imagePath='" + imagePath + '\'' +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        ReviewImageDTO that = (ReviewImageDTO) obj;
        return imageId == that.imageId;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(imageId);
    }
}