package com.studyplanning.model;

import java.sql.Timestamp;

/**
 * Model class representing user_preferences table
 */
public class UserPreference {
    private int prefId;
    private int userId;
    private String subjectInterest;
    private String dislikeSubject;
    private String hobby;
    private Integer stressLevel; // 1-10
    private Timestamp createdAt;

    // Constructors
    public UserPreference() {
    }

    public UserPreference(int userId, String subjectInterest, String dislikeSubject, 
                         String hobby, Integer stressLevel) {
        this.userId = userId;
        this.subjectInterest = subjectInterest;
        this.dislikeSubject = dislikeSubject;
        this.hobby = hobby;
        this.stressLevel = stressLevel;
    }

    // Getters and Setters
    public int getPrefId() {
        return prefId;
    }

    public void setPrefId(int prefId) {
        this.prefId = prefId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getSubjectInterest() {
        return subjectInterest;
    }

    public void setSubjectInterest(String subjectInterest) {
        this.subjectInterest = subjectInterest;
    }

    public String getDislikeSubject() {
        return dislikeSubject;
    }

    public void setDislikeSubject(String dislikeSubject) {
        this.dislikeSubject = dislikeSubject;
    }

    public String getHobby() {
        return hobby;
    }

    public void setHobby(String hobby) {
        this.hobby = hobby;
    }

    public Integer getStressLevel() {
        return stressLevel;
    }

    public void setStressLevel(Integer stressLevel) {
        this.stressLevel = stressLevel;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "UserPreference{" +
                "prefId=" + prefId +
                ", userId=" + userId +
                ", subjectInterest='" + subjectInterest + '\'' +
                ", dislikeSubject='" + dislikeSubject + '\'' +
                ", hobby='" + hobby + '\'' +
                ", stressLevel=" + stressLevel +
                ", createdAt=" + createdAt +
                '}';
    }
}
