/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class UserSetting {
    
    private int userId;
    private String theme;               // Chủ đề giao diện (ví dụ: "Light", "Dark")
    private String language;            // Ngôn ngữ hiển thị (ví dụ: "vi", "en")
    private String notificationLevel;   // Mức độ thông báo (ví dụ: "High", "Low", "Muted")
    private String preferredStudyTime;  // Thời gian học ưa thích (ví dụ: "Morning", "Evening")
    private String focusLevel;          // Mức độ tập trung (ví dụ: "Deep Work", "Quick Study")
    private boolean aiEnabled;          // Bật/Tắt tính năng AI

    // Constructor mặc định (cần thiết cho nhiều Framework và ORM)
    public UserSetting() {
    }

    // Constructor đầy đủ
    public UserSetting(int userId, String theme, String language, String notificationLevel, String preferredStudyTime, String focusLevel, boolean aiEnabled) {
        this.userId = userId;
        this.theme = theme;
        this.language = language;
        this.notificationLevel = notificationLevel;
        this.preferredStudyTime = preferredStudyTime;
        this.focusLevel = focusLevel;
        this.aiEnabled = aiEnabled;
    }
    
    // ==========================================================
    // GETTERS VÀ SETTERS
    // ==========================================================

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTheme() {
        return theme;
    }

    public void setTheme(String theme) {
        this.theme = theme;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getNotificationLevel() {
        return notificationLevel;
    }

    public void setNotificationLevel(String notificationLevel) {
        this.notificationLevel = notificationLevel;
    }

    public String getPreferredStudyTime() {
        return preferredStudyTime;
    }

    public void setPreferredStudyTime(String preferredStudyTime) {
        this.preferredStudyTime = preferredStudyTime;
    }

    public String getFocusLevel() {
        return focusLevel;
    }

    public void setFocusLevel(String focusLevel) {
        this.focusLevel = focusLevel;
    }

    public boolean isAiEnabled() {
        return aiEnabled;
    }

    public void setAiEnabled(boolean aiEnabled) {
        this.aiEnabled = aiEnabled;
    }
    
    // Thêm phương thức toString() để hỗ trợ gỡ lỗi (Debugging)
    @Override
    public String toString() {
        return "UserSetting{" +
               "userId=" + userId +
               ", theme='" + theme + '\'' +
               ", language='" + language + '\'' +
               ", notificationLevel='" + notificationLevel + '\'' +
               ", preferredStudyTime='" + preferredStudyTime + '\'' +
               ", focusLevel='" + focusLevel + '\'' +
               ", aiEnabled=" + aiEnabled +
               '}';
    }
}