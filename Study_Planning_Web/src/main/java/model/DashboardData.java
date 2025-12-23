/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.List;
import java.util.Map;
/**
 *
 * @author Admin
 */
public class DashboardData {
    private List<TimetableSlot> timetableList;
    private int totalTasks;
    private int completedTasks;
    private double studyHours;
    private double weeklyChange;
    private int upcomingEventCount;
    private Map<String, Double> timeAllocation;
    private List<Task> upcomingTasks;
    
    // Getters và Setters
    public List<TimetableSlot> getTimetableList() { return timetableList; }
    public void setTimetableList(List<TimetableSlot> timetableList) { 
        this.timetableList = timetableList; 
    }
    
    public int getTotalTasks() { return totalTasks; }
    public void setTotalTasks(int totalTasks) { this.totalTasks = totalTasks; }
    
    public int getCompletedTasks() { return completedTasks; }
    public void setCompletedTasks(int completedTasks) { this.completedTasks = completedTasks; }
    
    public double getStudyHours() { return studyHours; }
    public void setStudyHours(double studyHours) { this.studyHours = studyHours; }
    
    public double getWeeklyChange() { return weeklyChange; }
    public void setWeeklyChange(double weeklyChange) { this.weeklyChange = weeklyChange; }
    
    public int getUpcomingEventCount() { return upcomingEventCount; }
    public void setUpcomingEventCount(int upcomingEventCount) { 
        this.upcomingEventCount = upcomingEventCount; 
    }
    
    public Map<String, Double> getTimeAllocation() { return timeAllocation; }
    public void setTimeAllocation(Map<String, Double> timeAllocation) { 
        this.timeAllocation = timeAllocation; 
    }
    
    public List<Task> getUpcomingTasks() { return upcomingTasks; }
    public void setUpcomingTasks(List<Task> upcomingTasks) { 
        this.upcomingTasks = upcomingTasks; 
    }
    
    // Helper methods
    public double getCompletionRate() {
        return totalTasks > 0 ? Math.round((completedTasks * 100.0 / totalTasks) * 10.0) / 10.0 : 0;
    }
}
