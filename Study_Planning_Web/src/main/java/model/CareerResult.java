/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
import java.sql.Timestamp;
import java.util.Date;

public class CareerResult {
    private int id;
    private int userId;
    private int technologyScore;
    private int businessScore;
    private int creativeScore;
    private int scienceScore;
    private int educationScore;
    private int socialScore;
    private String topCareers; // JSON string
    private Date completedAt;
    
    // Constructors
    public CareerResult() {}
    
    public CareerResult(int userId, int techScore, int businessScore, int creativeScore,
                       int scienceScore, int eduScore, int socialScore, String topCareers) {
        this.userId = userId;
        this.technologyScore = techScore;
        this.businessScore = businessScore;
        this.creativeScore = creativeScore;
        this.scienceScore = scienceScore;
        this.educationScore = eduScore;
        this.socialScore = socialScore;
        this.topCareers = topCareers;
        this.completedAt = new Date();
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getTechnologyScore() { return technologyScore; }
    public void setTechnologyScore(int technologyScore) { 
        this.technologyScore = technologyScore; 
    }
    
    public int getBusinessScore() { return businessScore; }
    public void setBusinessScore(int businessScore) { 
        this.businessScore = businessScore; 
    }
    
    public int getCreativeScore() { return creativeScore; }
    public void setCreativeScore(int creativeScore) { 
        this.creativeScore = creativeScore; 
    }
    
    public int getScienceScore() { return scienceScore; }
    public void setScienceScore(int scienceScore) { 
        this.scienceScore = scienceScore; 
    }
    
    public int getEducationScore() { return educationScore; }
    public void setEducationScore(int educationScore) { 
        this.educationScore = educationScore; 
    }
    
    public int getSocialScore() { return socialScore; }
    public void setSocialScore(int socialScore) { 
        this.socialScore = socialScore; 
    }
    
    public String getTopCareers() { return topCareers; }
    public void setTopCareers(String topCareers) { 
        this.topCareers = topCareers; 
    }
    
    public Date getCompletedAt() { return completedAt; }
    public void setCompletedAt(Date completedAt) { this.completedAt = completedAt; }
    
    // Helper methods
    public int getTotalScore() {
        return technologyScore + businessScore + creativeScore + 
               scienceScore + educationScore + socialScore;
    }
    
    public String getTopCategory() {
        int maxScore = Math.max(technologyScore, Math.max(businessScore, 
                           Math.max(creativeScore, Math.max(scienceScore, 
                           Math.max(educationScore, socialScore)))));
        
        if (maxScore == technologyScore) return "TECHNOLOGY";
        if (maxScore == businessScore) return "BUSINESS";
        if (maxScore == creativeScore) return "CREATIVE";
        if (maxScore == scienceScore) return "SCIENCE";
        if (maxScore == educationScore) return "EDUCATION";
        return "SOCIAL";
    }
    
    public String getCategoryDescription(String category) {
        switch (category.toUpperCase()) {
            case "TECHNOLOGY":
                return "Công nghệ thông tin, lập trình, AI, Data Science";
            case "BUSINESS":
                return "Kinh doanh, marketing, tài chính, quản lý";
            case "CREATIVE":
                return "Thiết kế, nghệ thuật, sáng tạo nội dung";
            case "SCIENCE":
                return "Nghiên cứu khoa học, y tế, kỹ thuật";
            case "EDUCATION":
                return "Giáo dục, đào tạo, phát triển con người";
            case "SOCIAL":
                return "Công tác xã hội, tâm lý, nhân sự";
            default:
                return "Đa dạng lĩnh vực";
        }
    }
}