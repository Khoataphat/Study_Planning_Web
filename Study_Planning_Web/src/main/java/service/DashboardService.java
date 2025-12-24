/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dao.TaskDAO;
import dao.TimetableDAO;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.DashboardData;
import model.Task;
import model.TimetableSlot;

/**
 *
 * @author Admin
 */
public class DashboardService {
    private TimetableDAO timetableDAO;
    private TaskDAO taskDAO;
    
    public DashboardService(TimetableDAO timetableDAO, TaskDAO taskDAO) {
        this.timetableDAO = timetableDAO;
        this.taskDAO = taskDAO;
    }

    public DashboardData loadDashboard(int userId) throws Exception {
        DashboardData data = new DashboardData();
        
        // 1. Thời khóa biểu (từ user_schedule)
        List<TimetableSlot> timetableList = timetableDAO.getUserTimetable(userId);
        Collections.sort(timetableList, Comparator
            .comparing(TimetableSlot::getDayOfWeek)
            .thenComparing(TimetableSlot::getStartTime)
        );
        data.setTimetableList(timetableList);
        
        // 2. Thống kê nhiệm vụ (từ tasks thông qua user_schedule)
        List<Task> tasks = taskDAO.getAllByUserId(userId);
        data.setTotalTasks(tasks.size());
        
        // Đếm số task đã hoàn thành (status = 'completed')
        int completedCount = 0;
        for (Task task : tasks) {
            if ("done".equalsIgnoreCase(task.getStatus())) {
                completedCount++;
            }
        }
        data.setCompletedTasks(completedCount);
        
        // 3. Tính tổng giờ học từ user_schedule
        double totalStudyHours = calculateTotalStudyHours(timetableList);
        data.setStudyHours(totalStudyHours);
        
        // 4. Tính phần trăm thay đổi so với tuần trước (tạm thời hardcode hoặc tính từ DB)
        data.setWeeklyChange(calculateWeeklyChange(userId, totalStudyHours));
        
        // 5. Đếm sự kiện sắp tới (trong 7 ngày tới)
        int upcomingEvents = countUpcomingEvents(timetableList);
        data.setUpcomingEventCount(upcomingEvents);
        
        // 6. Phân bổ thời gian theo type
        Map<String, Double> timeAllocation = calculateTimeAllocation(timetableList);
        data.setTimeAllocation(timeAllocation);
        
        // 7. Lấy danh sách task sắp deadline
        List<Task> upcomingTasks = getUpcomingTasks(tasks);
        data.setUpcomingTasks(upcomingTasks);
        
        return data;
    }
    
    // Helper method: Tính tổng giờ học
    private double calculateTotalStudyHours(List<TimetableSlot> timetableList) {
        double totalHours = 0;
        for (TimetableSlot slot : timetableList) {
            // Chỉ tính các slot học tập
            if (slot.getType() != null && 
                (slot.getType().equals("class") || slot.getType().equals("self-study"))) {
                // Tính khoảng thời gian giữa startTime và endTime (tính bằng giờ)
                if (slot.getStartTime() != null && slot.getEndTime() != null) {
                    long minutes = java.time.Duration.between(
                        slot.getStartTime(), slot.getEndTime()
                    ).toMinutes();
                    totalHours += minutes / 60.0;
                }
            }
        }
        return Math.round(totalHours * 10.0) / 10.0; // Làm tròn 1 số thập phân
    }
    
    // Helper method: Tính % thay đổi so với tuần trước
    private double calculateWeeklyChange(int userId, double currentHours) {
        // Tạm thời hardcode hoặc thêm logic tính toán từ DB
        // Nếu có bảng lưu lịch sử, có thể query ở đây
        return 8.0; // Giả sử tăng 8%
    }
    
    // Helper method: Đếm sự kiện sắp tới
    private int countUpcomingEvents(List<TimetableSlot> timetableList) {
        int count = 0;
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, 7); // 7 ngày tới
        
        for (TimetableSlot slot : timetableList) {
            if (slot.getScheduleDate() != null) {
                // Kiểm tra nếu schedule_date trong vòng 7 ngày tới
                java.time.LocalDate today = java.time.LocalDate.now();
                java.time.LocalDate scheduleDate = slot.getScheduleDate();
                
                if (!scheduleDate.isBefore(today) && 
                    scheduleDate.isBefore(today.plusDays(7))) {
                    count++;
                }
            }
        }
        return count;
    }
    
    // Helper method: Tính phân bổ thời gian
    private Map<String, Double> calculateTimeAllocation(List<TimetableSlot> timetableList) {
        Map<String, Double> allocation = new HashMap<>();
        double totalMinutes = 0;
        Map<String, Double> typeMinutes = new HashMap<>();
        
        // Nhóm các type thành 4 loại chính
        Map<String, String> typeCategories = new HashMap<>();
        typeCategories.put("class", "Học tập");
        typeCategories.put("self-study", "Học tập");
        typeCategories.put("activity", "Giải trí");
        typeCategories.put("break", "Nghỉ ngơi");
        
        for (TimetableSlot slot : timetableList) {
            if (slot.getStartTime() != null && slot.getEndTime() != null) {
                long minutes = java.time.Duration.between(
                    slot.getStartTime(), slot.getEndTime()
                ).toMinutes();
                
                String category = "Khác";
                if (slot.getType() != null) {
                    category = typeCategories.getOrDefault(slot.getType(), "Khác");
                }
                
                typeMinutes.put(category, 
                    typeMinutes.getOrDefault(category, 0.0) + minutes);
                totalMinutes += minutes;
            }
        }
        
        // Tính phần trăm
        if (totalMinutes > 0) {
            for (Map.Entry<String, Double> entry : typeMinutes.entrySet()) {
                double percentage = (entry.getValue() / totalMinutes) * 100;
                allocation.put(entry.getKey(), Math.round(percentage * 10.0) / 10.0);
            }
        }
        
        // Đảm bảo có đủ 4 loại
        allocation.putIfAbsent("Học tập", 0.0);
        allocation.putIfAbsent("Giải trí", 0.0);
        allocation.putIfAbsent("Nghỉ ngơi", 0.0);
        allocation.putIfAbsent("Khác", 0.0);
        
        return allocation;
    }
    
    // Helper method: Lấy task sắp deadline
    private List<Task> getUpcomingTasks(List<Task> tasks) {
        List<Task> upcoming = new ArrayList<>();
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, 3); // 3 ngày tới
        
        for (Task task : tasks) {
            if (task.getDeadline() != null && 
                !"completed".equalsIgnoreCase(task.getStatus())) {
                // Kiểm tra nếu deadline trong vòng 3 ngày tới
                if (task.getDeadline().after(new Timestamp(System.currentTimeMillis())) &&
                    task.getDeadline().before(new Timestamp(cal.getTimeInMillis()))) {
                    upcoming.add(task);
                }
            }
        }
        
        // Sắp xếp theo deadline gần nhất
        upcoming.sort(Comparator.comparing(Task::getDeadline));
        
        return upcoming.size() > 5 ? upcoming.subList(0, 5) : upcoming;
    }
}
