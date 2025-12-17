package model;

import java.sql.Timestamp;

/**
 * Model class representing tasks table
 */
public class Task {
    private int taskId;
    private int userId;
    private String title;
    private String description;
    private String priority; // low, medium, high
    private int duration; // in minutes
    private Timestamp deadline;
    
    private Timestamp startTime;
    private String status; // pending, in_progress, done
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructors
    public Task() {
    }

    public Task(int userId, String title, String description, String priority, int duration, Timestamp deadline, String status) {
        this.userId = userId;
        this.title = title;
        this.description = description;
        this.priority = priority;
        this.duration = duration;
        this.deadline = deadline;
        this.status = status;
    }
    
    public Timestamp getStartTime() { return startTime; } // ⭐️ THÊM
    public void setStartTime(Timestamp startTime) { this.startTime = startTime; } // ⭐️ THÊM

    // Getters and Setters
    public int getTaskId() {
        return taskId;
    }

    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public Timestamp getDeadline() {
        return deadline;
    }

    public void setDeadline(Timestamp deadline) {
        this.deadline = deadline;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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
        return "Task{" +
                "taskId=" + taskId +
                ", userId=" + userId +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", priority='" + priority + '\'' +
                ", duration=" + duration +
                ", deadline=" + deadline +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
