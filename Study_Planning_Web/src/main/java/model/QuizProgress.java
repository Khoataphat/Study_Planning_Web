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

public class QuizProgress {
    private int id;
    private int userId;
    private String quizType; // MBTI, WORK_STYLE, LEARNING, CAREER
    private String status; // NOT_STARTED, IN_PROGRESS, COMPLETED
    private Date startedAt;
    private Date completedAt;
    private Date lastUpdated;
    
    // Constructors
    public QuizProgress() {}
    
    public QuizProgress(int userId, String quizType, String status) {
        this.userId = userId;
        this.quizType = quizType;
        this.status = status;
        this.lastUpdated = new Date();
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getQuizType() { return quizType; }
    public void setQuizType(String quizType) { this.quizType = quizType; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Date getStartedAt() { return startedAt; }
    public void setStartedAt(Date startedAt) { this.startedAt = startedAt; }
    
    public Date getCompletedAt() { return completedAt; }
    public void setCompletedAt(Date completedAt) { this.completedAt = completedAt; }
    
    public Date getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(Date lastUpdated) { this.lastUpdated = lastUpdated; }
    
    // Helper methods
    public boolean isNotStarted() {
        return "NOT_STARTED".equals(status);
    }
    
    public boolean isInProgress() {
        return "IN_PROGRESS".equals(status);
    }
    
    public boolean isCompleted() {
        return "COMPLETED".equals(status);
    }
    
    public String getStatusText() {
        switch (status) {
            case "NOT_STARTED": return "Chưa bắt đầu";
            case "IN_PROGRESS": return "Đang làm";
            case "COMPLETED": return "Đã hoàn thành";
            default: return status;
        }
    }
    
    public String getQuizTypeText() {
        switch (quizType) {
            case "MBTI": return "Trắc nghiệm Tính cách";
            case "WORK_STYLE": return "Phong cách Làm việc";
            case "LEARNING": return "Phong cách Học tập";
            case "CAREER": return "Định hướng Nghề nghiệp";
            default: return quizType;
        }
    }
    
    public String getIcon() {
        switch (quizType) {
            case "MBTI": return "🎭";
            case "WORK_STYLE": return "💼";
            case "LEARNING": return "📚";
            case "CAREER": return "🎯";
            default: return "📝";
        }
    }
    
    public long getDuration() {
        if (startedAt == null || completedAt == null) {
            return 0;
        }
        return completedAt.getTime() - startedAt.getTime();
    }
    
    public String getFormattedDuration() {
        long duration = getDuration();
        if (duration == 0) return "N/A";
        
        long minutes = duration / (60 * 1000);
        long seconds = (duration % (60 * 1000)) / 1000;
        
        return minutes + " phút " + seconds + " giây";
    }
}
