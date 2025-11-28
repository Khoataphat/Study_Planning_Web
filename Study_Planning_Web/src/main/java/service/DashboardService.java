/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dao.TimetableDAO;
import model.DashboardData;

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
        data.setTimetable(timetableDAO.getUserTimetable(userId));  // thêm nè

        return data;
    }
}
