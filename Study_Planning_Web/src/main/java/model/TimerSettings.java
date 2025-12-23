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

public class TimerSettings {
    private int userId;
    
    // Pomodoro settings
    private int pomodoroWork = 25;
    private int pomodoroBreak = 5;
    private int pomodoroLongBreak = 15;
    private int pomodoroSessionsBeforeLongBreak = 4;
    
    // Other methods
    private int deepWorkDuration = 90;
    private int work52Duration = 52;
    private int break17Duration = 17;
    
    // Notification settings
    private boolean soundEnabled = true;
    private boolean notificationEnabled = true;
    
    // Auto settings
    private boolean autoStartBreaks = true;
    private boolean autoStartPomodoros = false;
    
    // Strict mode
    private boolean strictMode = false;
    
    // Goals
    private int dailyGoalMinutes = 240;
    private int weeklyGoalHours = 20;
    
    // Theme
    private boolean darkMode = false;
    
    // Timestamps
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Constructor
    public TimerSettings() {}
    
    public TimerSettings(int userId) {
        this.userId = userId;
    }
    
    // --- GETTERS & SETTERS ---
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getPomodoroWork() { return pomodoroWork; }
    public void setPomodoroWork(int pomodoroWork) { 
        this.pomodoroWork = pomodoroWork; 
    }
    
    public int getPomodoroBreak() { return pomodoroBreak; }
    public void setPomodoroBreak(int pomodoroBreak) { 
        this.pomodoroBreak = pomodoroBreak; 
    }
    
    public int getPomodoroLongBreak() { return pomodoroLongBreak; }
    public void setPomodoroLongBreak(int pomodoroLongBreak) { 
        this.pomodoroLongBreak = pomodoroLongBreak; 
    }
    
    public int getPomodoroSessionsBeforeLongBreak() { return pomodoroSessionsBeforeLongBreak; }
    public void setPomodoroSessionsBeforeLongBreak(int pomodoroSessionsBeforeLongBreak) { 
        this.pomodoroSessionsBeforeLongBreak = pomodoroSessionsBeforeLongBreak; 
    }
    
    public int getDeepWorkDuration() { return deepWorkDuration; }
    public void setDeepWorkDuration(int deepWorkDuration) { 
        this.deepWorkDuration = deepWorkDuration; 
    }
    
    public int getWork52Duration() { return work52Duration; }
    public void setWork52Duration(int work52Duration) { 
        this.work52Duration = work52Duration; 
    }
    
    public int getBreak17Duration() { return break17Duration; }
    public void setBreak17Duration(int break17Duration) { 
        this.break17Duration = break17Duration; 
    }
    
    public boolean isSoundEnabled() { return soundEnabled; }
    public void setSoundEnabled(boolean soundEnabled) { 
        this.soundEnabled = soundEnabled; 
    }
    
    public boolean isNotificationEnabled() { return notificationEnabled; }
    public void setNotificationEnabled(boolean notificationEnabled) { 
        this.notificationEnabled = notificationEnabled; 
    }
    
    public boolean isAutoStartBreaks() { return autoStartBreaks; }
    public void setAutoStartBreaks(boolean autoStartBreaks) { 
        this.autoStartBreaks = autoStartBreaks; 
    }
    
    public boolean isAutoStartPomodoros() { return autoStartPomodoros; }
    public void setAutoStartPomodoros(boolean autoStartPomodoros) { 
        this.autoStartPomodoros = autoStartPomodoros; 
    }
    
    public boolean isStrictMode() { return strictMode; }
    public void setStrictMode(boolean strictMode) { 
        this.strictMode = strictMode; 
    }
    
    public int getDailyGoalMinutes() { return dailyGoalMinutes; }
    public void setDailyGoalMinutes(int dailyGoalMinutes) { 
        this.dailyGoalMinutes = dailyGoalMinutes; 
    }
    
    public int getWeeklyGoalHours() { return weeklyGoalHours; }
    public void setWeeklyGoalHours(int weeklyGoalHours) { 
        this.weeklyGoalHours = weeklyGoalHours; 
    }
    
    public boolean isDarkMode() { return darkMode; }
    public void setDarkMode(boolean darkMode) { 
        this.darkMode = darkMode; 
    }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { 
        this.createdAt = createdAt; 
    }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { 
        this.updatedAt = updatedAt; 
    }
    
    // Helper method - tính tổng thời gian 1 chu kỳ Pomodoro
    public int getTotalPomodoroCycleMinutes() {
        return (pomodoroWork * pomodoroSessionsBeforeLongBreak) + 
               (pomodoroBreak * (pomodoroSessionsBeforeLongBreak - 1)) + 
               pomodoroLongBreak;
    }
}