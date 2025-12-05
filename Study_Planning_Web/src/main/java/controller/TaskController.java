package controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import model.Task;
import model.User;
import service.TaskService;
import utils.JsonUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller for handling task-related HTTP requests
 */
@WebServlet(name = "TaskController", urlPatterns = { "/user/tasks" })
public class TaskController extends HttpServlet {
    private final TaskService taskService = new TaskService();

    /**
     * Handle GET requests
     * - action=list: Get all tasks for user
     * - action=get&id=X: Get specific task
     * - action=status&status=X: Get tasks by status
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
                    handleListTasks(userId, out);
                    break;
                case "get":
                    handleGetTask(request, out);
                    break;
                case "status":
                    handleGetTasksByStatus(userId, request, out);
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
     * - Create new task
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Get user ID from session
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;

            if (user == null) {
                sendErrorResponse(response, "User not logged in", 401);
                return;
            }

            int userId = user.getUserId();

            // Read JSON body
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            String jsonData = sb.toString();

            // Parse JSON to Task with Timestamp deserializer
            Gson gson = new GsonBuilder()
                    .setDateFormat("yyyy-MM-dd HH:mm:ss")
                    .create();

            Task task = gson.fromJson(jsonData, Task.class);
            task.setUserId(userId);

            // Create task
            int taskId = taskService.createTask(task);

            Map<String, Object> result = new HashMap<>();
            if (taskId > 0) {
                result.put("success", true);
                result.put("taskId", taskId);
                result.put("message", "Task created successfully");
            } else {
                result.put("success", false);
                result.put("message", "Failed to create task");
            }

            PrintWriter out = response.getWriter();
            out.print(JsonUtil.toJson(result));
            out.flush();

        } catch (IllegalArgumentException e) {
            sendErrorResponse(response, e.getMessage(), 400);
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Server error: " + e.getMessage(), 500);
        }
    }

    /**
     * Handle PUT requests
     * - Update existing task
     */
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Get user ID from session
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;

            if (user == null) {
                sendErrorResponse(response, "User not logged in", 401);
                return;
            }

            String idParam = request.getParameter("id");
            if (idParam == null) {
                sendErrorResponse(response, "Task ID is required", 400);
                return;
            }

            int taskId = Integer.parseInt(idParam);

            // Read JSON body
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            String jsonData = sb.toString();

            // Parse JSON to Task
            Gson gson = new GsonBuilder()
                    .setDateFormat("yyyy-MM-dd HH:mm:ss")
                    .create();

            Task task = gson.fromJson(jsonData, Task.class);
            task.setTaskId(taskId);

            // Update task
            boolean success = taskService.updateTask(task);

            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            result.put("message", success ? "Task updated successfully" : "Failed to update task");

            PrintWriter out = response.getWriter();
            out.print(JsonUtil.toJson(result));
            out.flush();

        } catch (IllegalArgumentException e) {
            sendErrorResponse(response, e.getMessage(), 400);
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Server error: " + e.getMessage(), 500);
        }
    }

    /**
     * Handle DELETE requests
     * - Delete specific task by ID
     */
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Get user ID from session
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;

            if (user == null) {
                sendErrorResponse(response, "User not logged in", 401);
                return;
            }

            String idParam = request.getParameter("id");
            if (idParam == null) {
                sendErrorResponse(response, "Task ID is required", 400);
                return;
            }

            int taskId = Integer.parseInt(idParam);
            boolean success = taskService.deleteTask(taskId);

            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            result.put("message", success ? "Task deleted successfully" : "Failed to delete task");

            PrintWriter out = response.getWriter();
            out.print(JsonUtil.toJson(result));
            out.flush();

        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid task ID", 400);
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Server error: " + e.getMessage(), 500);
        }
    }

    /**
     * Handle list all tasks
     */
    private void handleListTasks(int userId, PrintWriter out) {
        List<Task> tasks = taskService.getAllTasksByUserId(userId);
        out.print(JsonUtil.toJson(tasks));
        out.flush();
    }

    /**
     * Handle get specific task
     */
    private void handleGetTask(HttpServletRequest request, PrintWriter out) {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            int taskId = Integer.parseInt(idParam);
            Task task = taskService.getTaskById(taskId);
            out.print(JsonUtil.toJson(task));
        } else {
            out.print(JsonUtil.toJson(null));
        }
        out.flush();
    }

    /**
     * Handle get tasks by status
     */
    private void handleGetTasksByStatus(int userId, HttpServletRequest request, PrintWriter out) {
        String status = request.getParameter("status");
        if (status != null) {
            List<Task> tasks = taskService.getTasksByStatus(userId, status);
            out.print(JsonUtil.toJson(tasks));
        } else {
            out.print(JsonUtil.toJson(null));
        }
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
