/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
import java.time.LocalDateTime;

public class UserProfiles {
    
    // Khóa chính: profile_id INT
    private Integer profileId; 
    
    // Khóa ngoại: user_id INT
    private Integer userId; 
    
    // year_of_study INT
    private Integer yearOfStudy; 
    
    // personality_type VARCHAR(10)
    private String personalityType; 
    
    // preferred_study_time ENUM(...)
    private String preferredStudyTime; 
    
    // learning_style ENUM(...) (Tương ứng với các lựa chọn "Phong cách học" trên giao diện)
    private String learningStyle; 
    
    // focus_duration INT (Thời gian tập trung - chưa rõ đơn vị, dùng Integer)
    private Integer focusDuration; 
    
    // goal TEXT (Tương ứng với các lựa chọn "Mục tiêu học tập" trên giao diện)
    private String goal; 
    
    // created_at DATETIME
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Personal Info 
    private String fullName;
    private String description;
    
    // Learning & working styles
    private String workStyle;
    private String hobbies;
    
    //Thêm các fields mới cho form khám phá
    private String studyMethodVisual;
    private String studyMethodAuditory;
    private String studyMethodReading;
    private String studyMethodPractice;
    private String productiveTime;
    private Integer groupStudyPreference;
    private String interests;

    // --- Constructor ---
    
    // Constructor mặc định
    public UserProfiles() {
    }

    // Constructor đầy đủ (có thể thêm/bớt tùy nhu cầu)
    public UserProfiles(Integer profileId, Integer userId, Integer yearOfStudy, String personalityType, String preferredStudyTime, String learningStyle, Integer focusDuration, String goal, LocalDateTime createdAt, String fullName, String description, String workStyle, String hobbies, String studyMethodVisual, String studyMethodAuditory, String studyMethodReading, String studyMethodPractice, String productiveTime, Integer groupStudyPreference, LocalDateTime updatedAt, String interests) {
        this.profileId = profileId;
        this.userId = userId;
        this.yearOfStudy = yearOfStudy;
        this.personalityType = personalityType;
        this.preferredStudyTime = preferredStudyTime;
        this.learningStyle = learningStyle;
        this.focusDuration = focusDuration;
        this.goal = goal;
        this.createdAt = createdAt;
        this.fullName = fullName;
        this.description = description;
        this.workStyle = workStyle;
        this.hobbies = hobbies;
        this.studyMethodVisual = studyMethodVisual;
        this.studyMethodAuditory = studyMethodAuditory;
        this.studyMethodReading = studyMethodReading;
        this.studyMethodPractice = studyMethodPractice;
        this.productiveTime = productiveTime;
        this.groupStudyPreference = groupStudyPreference;
        this.updatedAt = updatedAt;
        this.interests = interests;
        
    }

    // --- Getters và Setters ---

    public Integer getProfileId() {
        return profileId;
    }

    public void setProfileId(Integer profileId) {
        this.profileId = profileId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getYearOfStudy() {
        return yearOfStudy;
    }

    public void setYearOfStudy(Integer yearOfStudy) {
        this.yearOfStudy = yearOfStudy;
    }

    public String getPersonalityType() {
        return personalityType;
    }

    public void setPersonalityType(String personalityType) {
        this.personalityType = personalityType;
    }

    public String getPreferredStudyTime() {
        return preferredStudyTime;
    }

    public void setPreferredStudyTime(String preferredStudyTime) {
        this.preferredStudyTime = preferredStudyTime;
    }

    public String getLearningStyle() {
        return learningStyle;
    }

    public void setLearningStyle(String learningStyle) {
        this.learningStyle = learningStyle;
    }

    public Integer getFocusDuration() {
        return focusDuration;
    }

    public void setFocusDuration(Integer focusDuration) {
        this.focusDuration = focusDuration;
    }

    public String getGoal() {
        return goal;
    }

    public void setGoal(String goal) {
        this.goal = goal;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getFullName(){
        return fullName;
    }
    
    public void setFullName(String fullName){
        this.fullName = fullName;
    }
    
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getWorkStyle() {
        return workStyle;
    }

    public void setWorkStyle(String workStyle) {
        this.workStyle = workStyle;
    }

    public String getHobbies() {
        return hobbies;
    }

    public void setHobbies(String hobbies) {
        this.hobbies = hobbies;
    }
    
    public String getStudyMethodVisual() {
        return studyMethodVisual;
    }

    public void setStudyMethodVisual(String studyMethodVisual) {
        this.studyMethodVisual = studyMethodVisual;
    }

    public String getStudyMethodAuditory() {
        return studyMethodAuditory;
    }

    public void setStudyMethodAuditory(String studyMethodAuditory) {
        this.studyMethodAuditory = studyMethodAuditory;
    }
    
    public String getStudyMethodReading() {
        return studyMethodReading;
    }

    public void setStudyMethodReading(String studyMethodReading) {
        this.studyMethodReading = studyMethodReading;
    }

    public String getStudyMethodPractice() {
        return studyMethodPractice;
    }

    public void setStudyMethodPractice(String studyMethodPractice) {
        this.studyMethodPractice = studyMethodPractice;
    }
    
    public String getProductiveTime() {
        return productiveTime;
    }

    public void setProductiveTime(String productiveTime) {
        this.productiveTime = productiveTime;
    }

    public Integer getGroupStudyPreference() {
        return groupStudyPreference;
    }

    public void setGroupStudyPreference(Integer groupStudyPreference) {
        this.groupStudyPreference = groupStudyPreference;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public String getInterests() {
        return interests;
    }

    public void setInterests(String interests) {
        this.interests = interests;
    }    
    
    

    // Bạn có thể thêm phương thức toString() để dễ dàng debug
    @Override
    public String toString() {
        return '}' +
                "UserProfiles{" +
                "profileId=" + profileId +
                ", userId=" + userId +
                ", yearOfStudy=" + yearOfStudy +
                ", personalityType='" + personalityType + '\'' +
                ", preferredStudyTime='" + preferredStudyTime + '\'' +
                ", learningStyle='" + learningStyle + '\'' +
                ", focusDuration=" + focusDuration +
                ", goal='" + goal + '\'' +
                ", createdAt=" + createdAt +
                ", fullName='" + fullName + '\'' +
                ", description='" + description + '\'' +
                ", workStyle='" + workStyle + '\'' +
                ", hobbies='" + hobbies + '\'' +
                ", studyMethodVisual='" + studyMethodVisual + '\'' +
                ", studyMethodAuditory='" + studyMethodAuditory + '\'' +
                ", studyMethodReading='" + studyMethodReading + '\'' +
                ", studyMethodPractice='" + studyMethodPractice + '\'' +
                ", productiveTime='" + productiveTime + '\'' +
                ", groupStudyPreference=" + groupStudyPreference +
                ", updatedAt=" + updatedAt + 
                ", interests='" + interests + '\'' +
                '}';        
    }
}    