package com.studyplanning.model;

import java.sql.Timestamp;

/**
 * Model class representing schedule_collection table
 */
public class ScheduleCollection {
    private int collectionId;
    private int userId;
    private String collectionName;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructors
    public ScheduleCollection() {
    }

    public ScheduleCollection(int userId, String collectionName) {
        this.userId = userId;
        this.collectionName = collectionName;
    }

    public ScheduleCollection(int collectionId, int userId, String collectionName, Timestamp createdAt, Timestamp updatedAt) {
        this.collectionId = collectionId;
        this.userId = userId;
        this.collectionName = collectionName;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public int getCollectionId() {
        return collectionId;
    }

    public void setCollectionId(int collectionId) {
        this.collectionId = collectionId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getCollectionName() {
        return collectionName;
    }

    public void setCollectionName(String collectionName) {
        this.collectionName = collectionName;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "ScheduleCollection{" +
                "collectionId=" + collectionId +
                ", userId=" + userId +
                ", collectionName='" + collectionName + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
