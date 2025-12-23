/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

/**
 *
 * @author Admin
 */
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class TimerUtils {
    
    private static final DateTimeFormatter TIME_FORMATTER = 
        DateTimeFormatter.ofPattern("HH:mm");
    private static final DateTimeFormatter DATE_FORMATTER = 
        DateTimeFormatter.ofPattern("dd/MM/yyyy");
    
    // Format duration to readable string
    public static String formatDuration(Duration duration) {
        long hours = duration.toHours();
        long minutes = duration.toMinutesPart();
        long seconds = duration.toSecondsPart();
        
        if (hours > 0) {
            return String.format("%d giờ %02d phút %02d giây", hours, minutes, seconds);
        } else if (minutes > 0) {
            return String.format("%d phút %02d giây", minutes, seconds);
        } else {
            return String.format("%d giây", seconds);
        }
    }
    
    // Format duration to minutes only
    public static String formatMinutes(int totalMinutes) {
        int hours = totalMinutes / 60;
        int minutes = totalMinutes % 60;
        
        if (hours > 0) {
            return String.format("%d giờ %02d phút", hours, minutes);
        } else {
            return String.format("%d phút", minutes);
        }
    }
    
    // Calculate productivity score
    public static int calculateProductivityScore(int focusMinutes, int goalMinutes) {
        if (goalMinutes <= 0) return 0;
        int percentage = (focusMinutes * 100) / goalMinutes;
        
        if (percentage >= 100) return 5;
        else if (percentage >= 80) return 4;
        else if (percentage >= 60) return 3;
        else if (percentage >= 40) return 2;
        else if (percentage >= 20) return 1;
        else return 0;
    }
    
    // Get greeting based on time of day
    public static String getTimeGreeting() {
        int hour = LocalDateTime.now().getHour();
        
        if (hour < 12) return "Chào buổi sáng";
        else if (hour < 18) return "Chào buổi chiều";
        else return "Chào buổi tối";
    }
    
    // Validate timer settings
    public static boolean validateSettings(int workTime, int breakTime) {
        return workTime > 0 && breakTime >= 0 && workTime > breakTime;
    }
    
    // Calculate end time
    public static LocalDateTime calculateEndTime(LocalDateTime startTime, int durationMinutes) {
        return startTime.plusMinutes(durationMinutes);
    }
    
    // Format time for display
    public static String formatTime(LocalDateTime time) {
        if (time == null) return "";
        return time.format(TIME_FORMATTER);
    }
    
    // Format date for display
    public static String formatDate(LocalDateTime time) {
        if (time == null) return "";
        return time.format(DATE_FORMATTER);
    }
}