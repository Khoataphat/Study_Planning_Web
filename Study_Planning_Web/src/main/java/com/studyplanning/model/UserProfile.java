package com.studyplanning.model;

import java.sql.Timestamp;

/**
 * Model class representing user_profiles table
 */
public class UserProfile {
    private int profileId;
    private int userId;
    private Integer yearOfStudy; // 1-10
    private String personalityType; // e.g., MBTI types
    private String preferredStudyTime; // morning, afternoon, evening, night
    private String learningStyle; // visual, auditory, kinesthetic
    private int focusDuration; // in minutes, default 90
    private String goal;
    private Timestamp createdAt;

    // Constructors
    public UserProfile() {
    }

    public UserProfile(int userId, Integer yearOfStudy, String personalityType, String preferredStudyTime, 
                      String learningStyle, int focusDuration, String goal) {
        this.userId = userId;
        this.yearOfStudy = yearOfStudy;
        this.personalityType = personalityType;
        this.preferredStudyTime = preferredStudyTime;
        this.learningStyle = learningStyle;
        this.focusDuration = focusDuration;
        this.goal = goal;
    }

    // Getters and Setters
    public int getProfileId() {
        return profileId;
    }

    public void setProfileId(int profileId) {
        this.profileId = profileId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
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

    public int getFocusDuration() {
        return focusDuration;
    }

    public void setFocusDuration(int focusDuration) {
        this.focusDuration = focusDuration;
    }

    public String getGoal() {
        return goal;
    }

    public void setGoal(String goal) {
        this.goal = goal;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "UserProfile{" +
                "profileId=" + profileId +
                ", userId=" + userId +
                ", yearOfStudy=" + yearOfStudy +
                ", personalityType='" + personalityType + '\'' +
                ", preferredStudyTime='" + preferredStudyTime + '\'' +
                ", learningStyle='" + learningStyle + '\'' +
                ", focusDuration=" + focusDuration +
                ", goal='" + goal + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
