package model;

import java.time.LocalDateTime;

public class UserProfiles {

    private Integer profileId;
    private Integer userId;

    // Personal Info
    private String fullName;
    private String description;

    // Learning & Working styles
    private String learningStyle; // visual,auditory,kinesthetic
    private String workStyle;     // individual / team
    private String hobbies;
    private String preferredStudyTime; // morning / afternoon / evening

    // Academic info
    private Integer yearOfStudy;
    private String personalityType;
    private Integer focusDuration;
    private String goal;
    
    // Thêm các field mới cho form khám phá
    private String studyMethodVisual;    // Hình ảnh, sơ đồ
    private String studyMethodAuditory;  // Nghe giảng, podcast
    private String studyMethodReading;   // Đọc sách, tài liệu
    private String studyMethodPractice;  // Tự thực hành
    private String productiveTime;       // Buổi sáng/chiều/tối
    private Integer groupStudyPreference; // 1-5
    
    // Timestamps
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public UserProfiles() {}

    // Getters & Setters
    public Integer getProfileId() { return profileId; }
    public void setProfileId(Integer profileId) { this.profileId = profileId; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getLearningStyle() { return learningStyle; }
    public void setLearningStyle(String learningStyle) { this.learningStyle = learningStyle; }

    public String getWorkStyle() { return workStyle; }
    public void setWorkStyle(String workStyle) { this.workStyle = workStyle; }

    public String getHobbies() { return hobbies; }
    public void setHobbies(String hobbies) { this.hobbies = hobbies; }

    public String getPreferredStudyTime() { return preferredStudyTime; }
    public void setPreferredStudyTime(String preferredStudyTime) { this.preferredStudyTime = preferredStudyTime; }

    public Integer getYearOfStudy() { return yearOfStudy; }
    public void setYearOfStudy(Integer yearOfStudy) { this.yearOfStudy = yearOfStudy; }

    public String getPersonalityType() { return personalityType; }
    public void setPersonalityType(String personalityType) { this.personalityType = personalityType; }

    public Integer getFocusDuration() { return focusDuration; }
    public void setFocusDuration(Integer focusDuration) { this.focusDuration = focusDuration; }

    public String getGoal() { return goal; }
    public void setGoal(String goal) { this.goal = goal; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
     public String getStudyMethodVisual() { return studyMethodVisual; }
    public void setStudyMethodVisual(String studyMethodVisual) { this.studyMethodVisual = studyMethodVisual; }

    public String getStudyMethodAuditory() { return studyMethodAuditory; }
    public void setStudyMethodAuditory(String studyMethodAuditory) { this.studyMethodAuditory = studyMethodAuditory; }

    public String getStudyMethodReading() { return studyMethodReading; }
    public void setStudyMethodReading(String studyMethodReading) { this.studyMethodReading = studyMethodReading; }

    public String getStudyMethodPractice() { return studyMethodPractice; }
    public void setStudyMethodPractice(String studyMethodPractice) { this.studyMethodPractice = studyMethodPractice; }

    public String getProductiveTime() { return productiveTime; }
    public void setProductiveTime(String productiveTime) { this.productiveTime = productiveTime; }

    public Integer getGroupStudyPreference() { return groupStudyPreference; }
    public void setGroupStudyPreference(Integer groupStudyPreference) { this.groupStudyPreference = groupStudyPreference; }
}
