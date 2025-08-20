package com.foodspot.dto;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * 리뷰 정보를 담는 DTO 클래스
 */
public class ReviewDTO {
    private int reviewId;           // 리뷰 고유 ID
    private int restaurantId;       // 리뷰가 작성된 맛집 ID
    private String userId;          // 리뷰 작성자 ID
    private String userName;        // 리뷰 작성자 이름
    private String restaurantName;  // 식당 이름 (사용자 리뷰 목록에서 사용)
    private int rating;             // 별점 (1-5점)
    private String content;         // 리뷰 내용
    private Timestamp createdDate;  // 작성일
    private List<ReviewImageDTO> images; // 첨부된 이미지들
    private List<String> imageUrls; // 이미지 URL 목록 (간단한 조회용)
    // ★ 추가: 식당 정보를 리뷰 DTO에 직접 포함
    private String restaurantImage; // 식당 대표 이미지 URL
    private String restaurantCategory; // 식당 카테고리
    private String restaurantAddress; // 식당 주소
    
    // 기본 생성자
    public ReviewDTO() {}
    
    // ★ 수정: 생성자에 새로 추가된 필드들 포함
    public ReviewDTO(int reviewId, int restaurantId, String userId, String userName,
                     String restaurantName, String restaurantImage, String restaurantCategory,
                     String restaurantAddress, int rating, String content, Timestamp createdDate) {
        this.reviewId = reviewId;
        this.restaurantId = restaurantId;
        this.userId = userId;
        this.userName = userName;
        this.restaurantName = restaurantName;
        this.setRestaurantImage(restaurantImage);
        this.setRestaurantCategory(restaurantCategory);
        this.setRestaurantAddress(restaurantAddress);
        this.rating = rating;
        this.content = content;
        this.createdDate = createdDate;
    }
    
    // Getter and Setter methods
    public int getReviewId() {
        return reviewId;
    }
    
    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }
    
    public int getRestaurantId() {
        return restaurantId;
    }
    
    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }
    
    public String getUserId() {
        return userId;
    }
    
    public void setUserId(String userId) {
        this.userId = userId;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
    
    public String getRestaurantName() {
        return restaurantName;
    }
    
    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }
    
    public int getRating() {
        return rating;
    }
    
    public void setRating(int rating) {
        this.rating = rating;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public Timestamp getCreatedDate() {
        return createdDate;
    }
    
    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }
    
    public List<ReviewImageDTO> getImages() {
        return images;
    }
    
    public void setImages(List<ReviewImageDTO> images) {
        this.images = images;
    }
    
    public List<String> getImageUrls() {
        return imageUrls;
    }
    
    public void setImageUrls(List<String> imageUrls) {
        this.imageUrls = imageUrls;
    }
    
    // 유틸리티 메서드들
    
    /**
     * 이미지가 있는지 확인
     * @return 이미지 존재 여부
     */
    public boolean hasImages() {
        return (images != null && !images.isEmpty()) || 
               (imageUrls != null && !imageUrls.isEmpty());
    }
    
    /**
     * 이미지 개수 반환
     * @return 이미지 개수
     */
    public int getImageCount() {
        if (images != null) {
            return images.size();
        } else if (imageUrls != null) {
            return imageUrls.size();
        }
        return 0;
    }
    
    /**
     * 평점이 유효한 범위인지 확인
     * @return 유효성 여부
     */
    public boolean isValidRating() {
        return rating >= 1 && rating <= 5;
    }
    
    /**
     * 리뷰 내용이 비어있지 않은지 확인
     * @return 내용 존재 여부
     */
    public boolean hasContent() {
        return content != null && !content.trim().isEmpty();
    }
    
    /**
     * ReviewImageDTO 리스트를 String URL 리스트로 변환
     * @return URL 문자열 리스트
     */
    public List<String> convertImagesToUrls() {
        if (images == null || images.isEmpty()) {
            return new ArrayList<>();
        }
        
        List<String> urls = new ArrayList<>();
        for (ReviewImageDTO image : images) {
            if (image.getImagePath() != null) {
                urls.add(image.getImagePath());
            }
        }
        return urls;
    }
    
    /**
     * String URL 리스트를 ReviewImageDTO 리스트로 변환
     * @return ReviewImageDTO 리스트
     */
    public List<ReviewImageDTO> convertUrlsToImages() {
        if (imageUrls == null || imageUrls.isEmpty()) {
            return new ArrayList<>();
        }
        
        List<ReviewImageDTO> imageList = new ArrayList<>();
        for (String url : imageUrls) {
            if (url != null && !url.trim().isEmpty()) {
                ReviewImageDTO imageDTO = new ReviewImageDTO();
                imageDTO.setReviewId(this.reviewId);
                imageDTO.setImagePath(url);
                imageList.add(imageDTO);
            }
        }
        return imageList;
    }
    
    /**
     * 작성자 이름의 첫 글자 반환 (아바타 표시용)
     * @return 첫 글자
     */
    public String getFirstLetter() {
        if (userName != null && !userName.isEmpty()) {
            return userName.substring(0, 1).toUpperCase();
        }
        return "?";
    }
    
    @Override
    public String toString() {
        return "ReviewDTO{" +
                "reviewId=" + reviewId +
                ", restaurantId=" + restaurantId +
                ", userId='" + userId + '\'' +
                ", userName='" + userName + '\'' +
                ", rating=" + rating +
                ", content='" + content + '\'' +
                ", createdDate=" + createdDate +
                ", imageCount=" + getImageCount() +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        ReviewDTO reviewDTO = (ReviewDTO) obj;
        return reviewId == reviewDTO.reviewId;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(reviewId);
    }

	public String getRestaurantImage() {
		return restaurantImage;
	}

	public void setRestaurantImage(String restaurantImage) {
		this.restaurantImage = restaurantImage;
	}

	public String getRestaurantCategory() {
		return restaurantCategory;
	}

	public void setRestaurantCategory(String restaurantCategory) {
		this.restaurantCategory = restaurantCategory;
	}

	public String getRestaurantAddress() {
		return restaurantAddress;
	}

	public void setRestaurantAddress(String restaurantAddress) {
		this.restaurantAddress = restaurantAddress;
	}
}