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
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.TimerStats;

public class TimerServiceImplSimple implements TimerService {
    
    // Lưu trong memory (tạm thời)
    private Map<Integer, TimerSession> activeSessions = new HashMap<>();
    private Map<Integer, TimerSettings> userSettings = new HashMap<>();
    
    @Override
    public TimerSession startTimer(int userId, TimerSession.TimerType type) {
        System.out.println("TIMER: Starting timer for user " + userId + ", type: " + type);
        
        TimerSession session = new TimerSession();
        session.setId((int) System.currentTimeMillis()); // ID tạm
        session.setUserId(userId);
        session.setTimerType(type);
        session.setStartTime(LocalDateTime.now());
        session.setStatus(TimerSession.TimerStatus.ACTIVE);
        
        // Set duration
        switch (type) {
            case POMODORO:
                session.setWorkDuration(25);
                session.setBreakDuration(5);
                break;
            case DEEP_WORK:
                session.setWorkDuration(90);
                session.setBreakDuration(0);
                break;
            case WORK_52_17:
                session.setWorkDuration(52);
                session.setBreakDuration(17);
                break;
        }
        
        activeSessions.put(userId, session);
        return session;
    }
    
    @Override
    public TimerSession getActiveSession(int userId) {
        System.out.println("TIMER: Getting active session for user " + userId);
        TimerSession session = activeSessions.get(userId);
        System.out.println("TIMER: Found session: " + (session != null ? "Yes" : "No"));
        return session;
    }
    
    @Override
    public TimerSettings getUserSettings(int userId) {
        System.out.println("TIMER: Getting settings for user " + userId);
        
        if (!userSettings.containsKey(userId)) {
            TimerSettings settings = new TimerSettings();
            settings.setUserId(userId);
            userSettings.put(userId, settings);
            System.out.println("TIMER: Created new default settings for user " + userId);
        }
        
        return userSettings.get(userId);
    }
    
    @Override
    public Map<String, Object> getTodayStatistics(int userId) {
        System.out.println("TIMER: Getting today stats for user " + userId);
        
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalFocusMinutes", 120);
        stats.put("completedSessions", 3);
        stats.put("pomodoroCount", 2);
        stats.put("deepWorkCount", 1);
        stats.put("work5217Count", 0);
        stats.put("dailyGoal", 240);
        stats.put("goalPercentage", 50);
        stats.put("goalStatus", "Chưa đạt");
        
        return stats;
    }
    
    @Override
    public boolean saveSettings(int userId, TimerSettings settings) {
        System.out.println("TIMER: Saving settings for user " + userId);
        userSettings.put(userId, settings);
        return true;
    }
    
    @Override
    public TimerSettings getDefaultSettings() {
        return new TimerSettings();
    }
    
    // Các phương thức khác với implementation đơn giản
    @Override
    public boolean pauseTimer(int sessionId) {
        System.out.println("TIMER: Pausing session " + sessionId);
        return true;
    }
    
    @Override
    public boolean resumeTimer(int sessionId) {
        System.out.println("TIMER: Resuming session " + sessionId);
        return true;
    }
    
    @Override
    public boolean stopTimer(int sessionId) {
        System.out.println("TIMER: Stopping session " + sessionId);
        return true;
    }
    
    @Override
    public boolean completeTimer(int sessionId) {
        System.out.println("TIMER: Completing session " + sessionId);
        return true;
    }
    
    @Override
    public java.util.List<TimerSession> getUserSessions(int userId) {
        return new java.util.ArrayList<>();
    }
    
    @Override
    public java.util.List<TimerSession> getTodaySessions(int userId) {
        return new java.util.ArrayList<>();
    }
    
    @Override
    public Map<String, Object> getWeeklyStatistics(int userId) {
        return new HashMap<>();
    }
    
    @Override
    public boolean validateTimerSettings(TimerSettings settings) {
        return true;
    }
    
    @Override
    public void sendTimerNotification(int userId, String message) {
        System.out.println("NOTIFICATION for user " + userId + ": " + message);
    }
     @Override
    public TimerSession startSession(int userId, String type) {
        TimerSession.TimerType timerType;
        try {
            timerType = TimerSession.TimerType.valueOf(type);
        } catch (IllegalArgumentException e) {
            timerType = TimerSession.TimerType.POMODORO;
        }
        return startTimer(userId, timerType);
    }
    
    @Override
    public boolean pauseSession(long sessionId, int userId) {
        System.out.println("TIMER: Pausing session " + sessionId + " for user " + userId);
        return true;
    }
    
    @Override
    public boolean resumeSession(long sessionId, int userId) {
        System.out.println("TIMER: Resuming session " + sessionId + " for user " + userId);
        return true;
    }
    
    @Override
    public boolean stopSession(long sessionId, int userId) {
        System.out.println("TIMER: Stopping session " + sessionId + " for user " + userId);
        return true;
    }
    
    @Override
    public boolean completeSession(long sessionId, int userId) {
        System.out.println("TIMER: Completing session " + sessionId + " for user " + userId);
        return true;
    }
    
    @Override
    public TimerStats getTodayStats(int userId) {
        TimerStats stats = new TimerStats("DAY");
        stats.setTotalFocusMinutes(120);
        stats.setCompletedSessions(3);
        stats.setGoalPercentage(50);
        return stats;
    }
    
    @Override
    public TimerStats getWeeklyStats(int userId) {
        TimerStats stats = new TimerStats("WEEK");
        stats.setTotalFocusMinutes(840);
        stats.setCompletedSessions(21);
        stats.setGoalPercentage(70);
        return stats;
    }
    
    @Override
    public TimerStats getMonthlyStats(int userId) {
        TimerStats stats = new TimerStats("MONTH");
        stats.setTotalFocusMinutes(3600);
        stats.setCompletedSessions(90);
        stats.setGoalPercentage(85);
        return stats;
    }
    
    @Override
    public TimerStats getLifetimeStats(int userId) {
        TimerStats stats = new TimerStats("LIFETIME");
        stats.setTotalFocusMinutes(15000);
        stats.setCompletedSessions(375);
        stats.setGoalPercentage(95);
        return stats;
    }
    
    @Override
    public List<TimerStats> getTrendStats(int userId, int days) {
        List<TimerStats> trend = new ArrayList<>();
        for (int i = days; i >= 0; i--) {
            TimerStats dayStat = new TimerStats("DAY_" + i);
            dayStat.setTotalFocusMinutes(120 + (i * 10));
            dayStat.setCompletedSessions(3);
            dayStat.setGoalPercentage(50 + (i * 5));
            trend.add(dayStat);
        }
        return trend;
    }
    
    @Override
    public List<TimerSession> getUserHistory(int userId, int days) {
        List<TimerSession> history = new ArrayList<>();
        
        // Tạo dữ liệu mẫu
        for (int i = 0; i < 15; i++) {
            TimerSession session = new TimerSession();
            session.setId(i + 1);
            session.setUserId(userId);
            session.setTimerType(i % 3 == 0 ? TimerSession.TimerType.POMODORO : 
                              i % 3 == 1 ? TimerSession.TimerType.DEEP_WORK : 
                              TimerSession.TimerType.WORK_52_17);
            session.setWorkDuration(25 * (i % 4 + 1));
            session.setStatus(TimerSession.TimerStatus.COMPLETED);
            history.add(session);
        }
        
        return history;
    }
}
