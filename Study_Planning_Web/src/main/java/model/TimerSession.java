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

public class TimerSession {
    private int id;
    private int userId;
    private TimerType timerType;
    private int workDuration; // phút
    private int breakDuration; // phút
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private TimerStatus status;
    private String notes;
    private LocalDateTime createdAt;
    
    // Enum cho loại timer
    public enum TimerType {
        POMODORO, DEEP_WORK, WORK_52_17
    }
    
    // Enum cho trạng thái
    public enum TimerStatus {
        ACTIVE, COMPLETED, PAUSED, CANCELLED
    }
    
    // Constructor mặc định
    public TimerSession() {}
    
    // Constructor đầy đủ
    public TimerSession(int userId, TimerType timerType, int workDuration, 
                       int breakDuration) {
        this.userId = userId;
        this.timerType = timerType;
        this.workDuration = workDuration;
        this.breakDuration = breakDuration;
        this.startTime = LocalDateTime.now();
        this.status = TimerStatus.ACTIVE;
    }
    
    // --- GETTERS & SETTERS ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public TimerType getTimerType() { return timerType; }
    public void setTimerType(TimerType timerType) { this.timerType = timerType; }
    
    public int getWorkDuration() { return workDuration; }
    public void setWorkDuration(int workDuration) { this.workDuration = workDuration; }
    
    public int getBreakDuration() { return breakDuration; }
    public void setBreakDuration(int breakDuration) { this.breakDuration = breakDuration; }
    
    public LocalDateTime getStartTime() { return startTime; }
    public void setStartTime(LocalDateTime startTime) { this.startTime = startTime; }
    
    public LocalDateTime getEndTime() { return endTime; }
    public void setEndTime(LocalDateTime endTime) { this.endTime = endTime; }
    
    public TimerStatus getStatus() { return status; }
    public void setStatus(TimerStatus status) { this.status = status; }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
