/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dao.TimetableDAO;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import model.DashboardData;
import model.TimetableSlot;

/**
 *
 * @author Admin
 */
public class DashboardService {

    //private UserActivityDAO activityDAO;
    //private TaskDAO taskDAO;
    private TimetableDAO timetableDAO;

//    public DashboardService(UserActivityDAO aDao, TaskDAO tDao){
//        this.activityDAO = aDao;
//        this.taskDAO = tDao;
//    }
    public DashboardService(TimetableDAO tiDAO) {
        this.timetableDAO = tiDAO;

    }

    public DashboardData loadDashboard(int userId) throws Exception {

        DashboardData data = new DashboardData();
//
//        // 1. Thống kê hoạt động gần đây
//        data.setRecentActivities(
//                activityDAO.getRecentActivities(userId)
//        );
//
//        // 2. Thống kê phân bổ thời gian
//        data.setTimeStats(
//                activityDAO.getTimeStat(userId)
//        );
//
//        // 3. Tiến độ công việc
//        data.setProgressTasks(
//                taskDAO.getTasksByUser(userId)
//        );

// 1. Lấy dữ liệu chưa sắp xếp (hoặc sắp xếp theo chuỗi)
        List<TimetableSlot> timetableList = timetableDAO.getUserTimetable(userId);

        // 2. SẮP XẾP LẠI THEO THỨ TỰ NGÀY TRONG TUẦN (DayOfWeek.ordinal)
        Collections.sort(timetableList, Comparator
            .comparing(TimetableSlot::getDayOfWeek, Comparator.nullsLast(Comparator.naturalOrder()))
            .thenComparing(TimetableSlot::getStartTime)
        );

        data.setTimetableList(timetableList);

        return data;
    }
}
