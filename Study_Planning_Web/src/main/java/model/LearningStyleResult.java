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

public class LearningStyleResult {
    private int id;
    private int userId;
    private int visualPercentage;
    private int auditoryPercentage;
    private int kinestheticPercentage;
    private String primaryStyle;
    private Date completedAt;
    
    // Constructors
    public LearningStyleResult() {}
    
    public LearningStyleResult(int userId, int visualPercentage, int auditoryPercentage, 
                              int kinestheticPercentage, String primaryStyle) {
        this.userId = userId;
        this.visualPercentage = visualPercentage;
        this.auditoryPercentage = auditoryPercentage;
        this.kinestheticPercentage = kinestheticPercentage;
        this.primaryStyle = primaryStyle;
        this.completedAt = new Date();
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getVisualPercentage() { return visualPercentage; }
    public void setVisualPercentage(int visualPercentage) { 
        this.visualPercentage = visualPercentage; 
    }
    
    public int getAuditoryPercentage() { return auditoryPercentage; }
    public void setAuditoryPercentage(int auditoryPercentage) { 
        this.auditoryPercentage = auditoryPercentage; 
    }
    
    public int getKinestheticPercentage() { return kinestheticPercentage; }
    public void setKinestheticPercentage(int kinestheticPercentage) { 
        this.kinestheticPercentage = kinestheticPercentage; 
    }
    
    public String getPrimaryStyle() { return primaryStyle; }
    public void setPrimaryStyle(String primaryStyle) { 
        this.primaryStyle = primaryStyle; 
    }
    
    public Date getCompletedAt() { return completedAt; }
    public void setCompletedAt(Date completedAt) { this.completedAt = completedAt; }
    
    // Helper methods
    public String getStyleDescription() {
        switch (primaryStyle) {
            case "VISUAL":
                return "Học qua hình ảnh, biểu đồ, video";
            case "AUDITORY":
                return "Học qua âm thanh, thảo luận, giảng bài";
            case "KINESTHETIC":
                return "Học qua thực hành, trải nghiệm thực tế";
            case "VISUAL_PRIMARY":
                return "Chủ yếu học qua hình ảnh, kết hợp các phương pháp khác";
            case "AUDITORY_PRIMARY":
                return "Chủ yếu học qua âm thanh, kết hợp các phương pháp khác";
            case "KINESTHETIC_PRIMARY":
                return "Chủ yếu học qua thực hành, kết hợp các phương pháp khác";
            default:
                return "Cân bằng giữa các phương pháp học tập";
        }
    }
    
    public String getLearningTips() {
        switch (primaryStyle) {
            case "VISUAL":
            case "VISUAL_PRIMARY":
                return "• Sử dụng mindmap và biểu đồ\n" +
                       "• Xem video tutorial\n" +
                       "• Ghi chú bằng highlight màu sắc";
            case "AUDITORY":
            case "AUDITORY_PRIMARY":
                return "• Ghi âm bài giảng\n" +
                       "• Tham gia thảo luận nhóm\n" +
                       "• Đọc to khi học";
            case "KINESTHETIC":
            case "KINESTHETIC_PRIMARY":
                return "• Thực hành ngay sau khi học lý thuyết\n" +
                       "• Sử dụng flashcards\n" +
                       "• Học qua trò chơi và hoạt động";
            default:
                return "• Kết hợp cả 3 phương pháp\n" +
                       "• Đa dạng hóa cách học\n" +
                       "• Tìm phương pháp phù hợp với từng môn";
        }
    }
}
