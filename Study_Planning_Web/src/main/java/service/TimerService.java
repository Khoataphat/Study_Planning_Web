/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

/**
 *
 * @author Admin
 */
import model.TimerSession;
import model.TimerSettings;
import java.util.List;
import java.util.Map;
import model.TimerStats;

public interface TimerService {
    
    // Timer operations
    TimerSession startTimer(int userId, TimerSession.TimerType type);
    boolean pauseTimer(int sessionId);
    boolean resumeTimer(int sessionId);
    boolean stopTimer(int sessionId);
    boolean completeTimer(int sessionId);
    
    // Settings operations
    TimerSettings getUserSettings(int userId);
    boolean saveSettings(int userId, TimerSettings settings);
    TimerSettings getDefaultSettings();
    
    // Statistics & data
    TimerSession getActiveSession(int userId);
    List<TimerSession> getUserSessions(int userId);
    List<TimerSession> getTodaySessions(int userId);
    Map<String, Object> getTodayStatistics(int userId);
    Map<String, Object> getWeeklyStatistics(int userId);
    
    // Utility methods
    boolean validateTimerSettings(TimerSettings settings);
    void sendTimerNotification(int userId, String message);
    
        // Thêm các method mới
    TimerSession startSession(int userId, String type);
    boolean pauseSession(long sessionId, int userId);
    boolean resumeSession(long sessionId, int userId);
    boolean stopSession(long sessionId, int userId);
    boolean completeSession(long sessionId, int userId);
    
    // Thống kê mới
    TimerStats getTodayStats(int userId);
    TimerStats getWeeklyStats(int userId);
    TimerStats getMonthlyStats(int userId);
    TimerStats getLifetimeStats(int userId);
    List<TimerStats> getTrendStats(int userId, int days);
    
    // Lịch sử
    List<TimerSession> getUserHistory(int userId, int days);
}