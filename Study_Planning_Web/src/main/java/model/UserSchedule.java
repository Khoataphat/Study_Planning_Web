package model;

import java.sql.Time;
import java.sql.Timestamp;

/**
 * Model class representing user_schedule table
 */
public class UserSchedule {
    private int scheduleId;
    // user_id removed as per schema change (linked via collection_id)
    private int collectionId;
    private String dayOfWeek; // Mon, Tue, Wed, Thu, Fri, Sat, Sun
    private Time startTime;
    private Time endTime;
    private String subject;
    private String type; // class, break, self-study, activity
    private String description; // Added for Smart Schedule details
    private Timestamp createdAt;
    private int taskId; //khoa
    
    // Constructors
    public UserSchedule() {
    }

    public UserSchedule(int collectionId, String dayOfWeek, Time startTime, Time endTime, String subject,
            String type) {
        this.collectionId = collectionId;
        this.dayOfWeek = dayOfWeek;
        this.startTime = startTime;
        this.endTime = endTime;
        this.subject = subject;
        this.type = type;
    }

    public UserSchedule(int scheduleId, int collectionId, String dayOfWeek, Time startTime, Time endTime,
            String subject, String type, Timestamp createdAt) {
        this.scheduleId = scheduleId;
        this.collectionId = collectionId;
        this.dayOfWeek = dayOfWeek;
        this.startTime = startTime;
        this.endTime = endTime;
        this.subject = subject;
        this.type = type;
        this.createdAt = createdAt;
    }
    
        // Constructor mới với taskId
    public UserSchedule(int scheduleId, int collectionId, int taskId, String dayOfWeek, 
                       Time startTime, Time endTime, String subject, 
                       String type, Timestamp createdAt) {
        this.scheduleId = scheduleId;
        this.collectionId = collectionId;
        this.taskId = taskId;
        this.dayOfWeek = dayOfWeek;
        this.startTime = startTime;
        this.endTime = endTime;
        this.subject = subject;
        this.type = type;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public int getCollectionId() {
        return collectionId;
    }

    public void setCollectionId(int collectionId) {
        this.collectionId = collectionId;
    }

    public String getDayOfWeek() {
        return dayOfWeek;
    }

    public void setDayOfWeek(String dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public Time getStartTime() {
        return startTime;
    }

    public void setStartTime(Time startTime) {
        this.startTime = startTime;
    }

    public Time getEndTime() {
        return endTime;
    }

    public void setEndTime(Time endTime) {
        this.endTime = endTime;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    //khoa
        // Getter và Setter cho taskId
    public int getTaskId() {
        return taskId;
    }
    
    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }

    @Override
    public String toString() {
        return "UserSchedule{" +
                "scheduleId=" + scheduleId +
                ", collectionId=" + collectionId +
                ", dayOfWeek='" + dayOfWeek + '\'' +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", subject='" + subject + '\'' +
                ", type='" + type + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
