package controller;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import model.User;
import model.UserSchedule;
import service.ScheduleService;
import utils.JsonUtil;
import utils.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Time;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Task;
import service.TaskService;

/**
 * Controller for handling schedule-related HTTP requests
 */
@WebServlet(name = "ScheduleController", urlPatterns = { "/user/schedule" })
public class ScheduleController extends HttpServlet {

    private final ScheduleService scheduleService = new ScheduleService();

    /**
     * Handle GET requests - action=list: Get all schedules for user -
     * action=get&id=X: Get specific schedule - action=weekly: Get weekly
     * schedule grouped by day
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // Get user ID from session
            // Get user ID from session
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;

            if (user == null) {
                sendErrorResponse(response, "User not logged in", 401);
                return;
            }

            int userId = user.getUserId();
            String action = request.getParameter("action");

            if (action == null) {
                action = "list";
            }

            switch (action) {
                case "list":
                    handleListSchedules(userId, out);
                    break;
                case "get":
                    handleGetSchedule(request, out);
                    break;
                case "weekly":
                    String collectionIdParam = request.getParameter("collectionId");
                    if (collectionIdParam == null) {
                        sendErrorResponse(response, "Collection ID is required", 400);
                        return;
                    }
                    int collectionId = Integer.parseInt(collectionIdParam);
                    handleWeeklySchedule(collectionId, out);
                    break;
                case "count":
                    String countCollectionIdParam = request.getParameter("collectionId");
                    if (countCollectionIdParam == null) {
                        sendErrorResponse(response, "Collection ID is required", 400);
                        return;
                    }
                    int countCollectionId = Integer.parseInt(countCollectionIdParam);
                    handleCountSchedules(countCollectionId, out);
                    break;
                default:
                    sendErrorResponse(response, "Invalid action", 400);
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Server error: " + e.getMessage(), 500);
        }
    }

    /**
     * Handle POST requests - Create or update schedules (batch operation)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // 1. Kiểm tra trạng thái đăng nhập của User
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;

            if (user == null) {
                sendErrorResponse(response, "User not logged in", 401);
                return;
            }

            int userId = user.getUserId();
            String action = request.getParameter("action");

            // Define Gson for all operations (Sử dụng tên đầy đủ trong khi khai báo)
            Gson gson = new com.google.gson.GsonBuilder()
                    .registerTypeAdapter(java.sql.Time.class, new utils.SqlTimeAdapter())
                    .create();

            // 2. Đọc JSON body từ request
            StringBuilder sb = new StringBuilder();
            try (BufferedReader reader = request.getReader()) { // Sử dụng try-with-resources để tự đóng reader
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
            }
            String jsonData = sb.toString();

            // 3. Xử lý Cập nhật (action=update)
            if ("update".equals(action)) {
                UserSchedule schedule = gson.fromJson(jsonData, UserSchedule.class);

                if (schedule == null || schedule.getScheduleId() <= 0) {
                    sendErrorResponse(response, "Schedule ID and data are required for update", 400);
                    return;
                }

                // GỌI SERVICE (Đã sửa đúng tham số userId)
                boolean success = scheduleService.updateSchedule(userId, schedule);

                Map<String, Object> result = new HashMap<>();
                result.put("success", success);
                result.put("message",
                        success ? "Schedule updated successfully"
                                : "Failed to update schedule (Time conflict or DB error)");

                try (PrintWriter out = response.getWriter()) {
                    out.print(JsonUtil.toJson(result));
                    out.flush();
                }
                return;
            }

            // 4. Xử lý Tạo mới (action=add)
            if ("add".equals(action)) {
                System.out.println("=== ADD SCHEDULE REQUEST ===");
                System.out.println("JSON Data: " + jsonData);

                UserSchedule schedule = gson.fromJson(jsonData, UserSchedule.class);

                // Debug log chi tiết
                System.out.println("Parsed Schedule:");
                System.out.println("  CollectionId: " + schedule.getCollectionId());
                System.out.println("  TaskId: " + schedule.getTaskId());
                System.out.println("  DayOfWeek: " + schedule.getDayOfWeek());
                System.out.println("  StartTime: " + schedule.getStartTime());
                System.out.println("  EndTime: " + schedule.getEndTime());
                System.out.println("  Subject: " + schedule.getSubject());
                System.out.println("  Type: " + schedule.getType());

                // ⭐️ QUAN TRỌNG: Kiểm tra xem taskId đã có hay chưa
                // Nếu taskId đã có (khác 0), chỉ tạo schedule, KHÔNG tạo task mới
                if (schedule.getTaskId() > 0) {
                    System.out.println("📌 TaskId đã tồn tại: " + schedule.getTaskId()
                            + ", chỉ tạo schedule liên kết");

                    // Kiểm tra xem task có tồn tại không
                    TaskService taskService = new TaskService();
                    Task existingTask = taskService.getTaskById(schedule.getTaskId());

                    if (existingTask == null) {
                        sendErrorResponse(response, "Task không tồn tại với ID: " + schedule.getTaskId(), 400);
                        return;
                    }
                }

                // Gọi service để tạo schedule
                int newId = scheduleService.createSchedule(userId, schedule);
                boolean success = newId > 0;

                System.out.println("Service result - success: " + success + ", newId: " + newId);

                Map<String, Object> result = new HashMap<>();
                result.put("success", success);
                result.put("message",
                        success ? "Schedule added successfully" : "Failed to add schedule (Time conflict or DB error)");
                if (success) {
                    result.put("scheduleId", newId);
                }

                System.out.println("Response: " + JsonUtil.toJson(result));
                System.out.println("=== END ADD SCHEDULE ===");

                try (PrintWriter out = response.getWriter()) {
                    out.print(JsonUtil.toJson(result));
                    out.flush();
                }
                return;
            }

            // 5. Hành vi Mặc định: Batch save
            String collectionIdParam = request.getParameter("collectionId");
            if (collectionIdParam == null) {
                sendErrorResponse(response, "Collection ID is required", 400);
                return;
            }
            int collectionId = Integer.parseInt(collectionIdParam);

            // Parse JSON to List<UserSchedule>
            java.lang.reflect.Type listType = new com.google.gson.reflect.TypeToken<List<UserSchedule>>() {
            }.getType();
            List<UserSchedule> schedules = gson.fromJson(jsonData, listType);

            boolean success = scheduleService.saveSchedules(userId, collectionId, schedules);

            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            result.put("message", success ? "Schedules saved successfully" : "Failed to save schedules");

            try (PrintWriter out = response.getWriter()) {
                out.print(JsonUtil.toJson(result));
                out.flush();
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            sendErrorResponse(response, "Invalid Collection ID format", 400);
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Server error: " + e.getMessage(), 500);
        }
    }

    /**
     * Handle DELETE requests - Delete specific schedule by ID
     */
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String idParam = request.getParameter("id");
            if (idParam == null) {
                sendErrorResponse(response, "Schedule ID is required", 400);
                return;
            }

            int scheduleId = Integer.parseInt(idParam);
            boolean success = scheduleService.deleteSchedule(scheduleId);

            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            result.put("message", success ? "Schedule deleted successfully" : "Failed to delete schedule");

            PrintWriter out = response.getWriter();
            out.print(JsonUtil.toJson(result));
            out.flush();

        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid schedule ID", 400);
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Server error: " + e.getMessage(), 500);
        }
    }

    /**
     * Handle list all schedules
     */
    private void handleListSchedules(int userId, PrintWriter out) {
        List<UserSchedule> schedules = scheduleService.getUserSchedules(userId);
        out.print(JsonUtil.toJson(schedules));
        out.flush();
    }

    /**
     * Handle get specific schedule
     */
    private void handleGetSchedule(HttpServletRequest request, PrintWriter out) {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            int scheduleId = Integer.parseInt(idParam);
            UserSchedule schedule = scheduleService.getScheduleById(scheduleId);
            out.print(JsonUtil.toJson(schedule));
        } else {
            out.print(JsonUtil.toJson(null));
        }
        out.flush();
    }

    /**
     * Handle get weekly schedule
     */
    private void handleWeeklySchedule(int collectionId, PrintWriter out) {
        System.out.println("[ScheduleController] Getting weekly schedule for collection: " + collectionId);

        Map<String, List<UserSchedule>> weeklySchedule = scheduleService.getWeeklySchedule(collectionId);

        // Debug log
        System.out.println("[ScheduleController] Weekly schedule data:");
        for (Map.Entry<String, List<UserSchedule>> entry : weeklySchedule.entrySet()) {
            System.out.println("  " + entry.getKey() + ": " + entry.getValue().size() + " events");
            for (UserSchedule schedule : entry.getValue()) {
                System.out.println("    - ID:" + schedule.getScheduleId() +
                        ", TaskID:" + schedule.getTaskId() +
                        ", " + schedule.getSubject());
            }
        }

        out.print(JsonUtil.toJson(weeklySchedule));
        out.flush();
    }

    /**
     * Handle count schedules
     */
    private void handleCountSchedules(int collectionId, PrintWriter out) {
        int count = scheduleService.countSchedules(collectionId);
        Map<String, Integer> result = new HashMap<>();
        result.put("count", count);
        out.print(JsonUtil.toJson(result));
        out.flush();
    }

    /**
     * Send error response
     */
    private void sendErrorResponse(HttpServletResponse response, String message, int status) throws IOException {
        response.setStatus(status);
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("error", message);
        PrintWriter out = response.getWriter();
        out.print(JsonUtil.toJson(error));
        out.flush();
    }
}
