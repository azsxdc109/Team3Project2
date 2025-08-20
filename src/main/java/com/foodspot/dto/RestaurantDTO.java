package com.foodspot.dto;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * 맛집 정보를 담는 데이터 전송 객체(DTO)입니다.
 * DB 테이블 `restaurants`의 한 레코드를 나타내며, 계층 간 데이터 전달을 위해 사용됩니다.
 */
public class RestaurantDTO implements Serializable {
    
    private static final long serialVersionUID = 1L;

    // DB 테이블 컬럼과 매핑되는 필드들
    private int restaurantId;
    private String name;
    private String category;
    private String address;
    private String phone;
    private String operatingHours;
    private String menu;
    private String description;
    private String imageUrl; // 첫 번째 이미지 URL
    private double rating;
    private int reviewCount;
    private Timestamp postDate;
    private String posterUserId;
    private String hotspotRegion;  // 추가한 핫플 지역 카테고리
    // Getter 및 Setter 메소드
    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getOperatingHours() { return operatingHours; }
    public void setOperatingHours(String operatingHours) { this.operatingHours = operatingHours; }

    public String getMenu() { return menu; }
    public void setMenu(String menu) { this.menu = menu; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }

    public Timestamp getPostDate() { return postDate; }
    public void setPostDate(Timestamp postDate) { this.postDate = postDate; }

    public String getPosterUserId() { return posterUserId; }
    public void setPosterUserId(String posterUserId) { this.posterUserId = posterUserId; }
    
    public String getHotspotRegion() { return hotspotRegion; }
    public void setHotspotRegion(String hotspotRegion) { this.hotspotRegion = hotspotRegion; }
    
    /**
     * 메뉴 문자열을 리스트로 변환하여 반환
     * JSP에서 사용하기 위한 메서드
     */
    public List<String> getMenuList() {
        if (menu == null || menu.trim().isEmpty()) {
            return new ArrayList<>();
        }
        
        List<String> menuList = new ArrayList<>();
        String[] lines = menu.split("\\n");
        
        for (String line : lines) {
            if (line != null && !line.trim().isEmpty()) {
                menuList.add(line.trim());
            }
        }
        
        return menuList;
    }
}
