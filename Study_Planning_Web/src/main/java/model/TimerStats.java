/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class TimerStats {
    private int totalFocusMinutes;
    private int completedSessions;
    private int goalPercentage;
    private String period; // DAY, WEEK, MONTH, LIFETIME
    
    // Constructors
    public TimerStats() {}
    
    public TimerStats(String period) {
        this.period = period;
    }
    
    // Getters and setters
    public int getTotalFocusMinutes() { return totalFocusMinutes; }
    public void setTotalFocusMinutes(int totalFocusMinutes) { 
        this.totalFocusMinutes = totalFocusMinutes; 
    }
    
    public int getCompletedSessions() { return completedSessions; }
    public void setCompletedSessions(int completedSessions) { 
        this.completedSessions = completedSessions; 
    }
    
    public int getGoalPercentage() { return goalPercentage; }
    public void setGoalPercentage(int goalPercentage) { 
        this.goalPercentage = goalPercentage; 
    }
    
    public String getPeriod() { return period; }
    public void setPeriod(String period) { this.period = period; }
}