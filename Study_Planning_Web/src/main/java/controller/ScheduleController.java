package controller;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
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

/**
 * Controller for handling schedule-related HTTP requests
 */
@WebServlet(name = "ScheduleController", urlPatterns = {"/user/schedule"})
public class ScheduleController extends HttpServlet {
    private final ScheduleService scheduleService = new ScheduleService();

    /**
     * Handle GET requests
     * - action=list: Get all schedules for user
     * - action=get&id=X: Get specific schedule
     * - action=weekly: Get weekly schedule grouped by day
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // Get user ID from session
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                sendErrorResponse(response, "User not logged in", 401);
                return;
            }

            int userId = (int) session.getAttribute("userId");
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
     * Handle POST requests
     * - Create or update schedules (batch operation)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Get user ID from session
            // Get user ID from session
            HttpSession session = request.getSession(false);
            // TEMPORARY: Bypass login check for testing
            int userId = 1;
            if (session != null && session.getAttribute("userId") != null) {
                userId = (int) session.getAttribute("userId");
            }

            // Get collection ID from parameter
            String collectionIdParam = request.getParameter("collectionId");
            if (collectionIdParam == null) {
                sendErrorResponse(response, "Collection ID is required", 400);
                return;
            }
            int collectionId = Integer.parseInt(collectionIdParam);

            // Read JSON body
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            String jsonData = sb.toString();
            
            // Parse JSON to List<UserSchedule> with custom Time deserializer
            Gson gson = new com.google.gson.GsonBuilder()
                .registerTypeAdapter(java.sql.Time.class, new utils.SqlTimeDeserializer())
                .create();
            
            java.lang.reflect.Type listType = new com.google.gson.reflect.TypeToken<List<UserSchedule>>(){}.getType();
            List<UserSchedule> schedules = gson.fromJson(jsonData, listType);
            
            boolean success = scheduleService.saveSchedules(userId, collectionId, schedules);

            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            result.put("message", success ? "Schedules saved successfully" : "Failed to save schedules");

            PrintWriter out = response.getWriter();
            out.print(JsonUtil.toJson(result));
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Server error: " + e.getMessage(), 500);
        }
    }

    /**
     * Handle DELETE requests
     * - Delete specific schedule by ID
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
        Map<String, List<UserSchedule>> weeklySchedule = scheduleService.getWeeklySchedule(collectionId);
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
