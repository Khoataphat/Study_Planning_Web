package controller;

import com.google.gson.Gson;
import model.ScheduleCollection;
import service.ScheduleCollectionService;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.User;

/**
 * Controller for handling schedule collection HTTP requests
 */
@WebServlet(name = "ScheduleCollectionController", urlPatterns = { "/user/collections" })
public class ScheduleCollectionController extends HttpServlet {
    private final ScheduleCollectionService collectionService = new ScheduleCollectionService();

    /**
     * Handle GET requests
     * - action=list: Get all collections for user
     * - action=get&id=X: Get specific collection
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
                    handleListCollections(userId, out);
                    break;
                case "get":
                    handleGetCollection(request, out);
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
     * Handle POST requests - Create new collection
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
                sendErrorResponse(response, "Bạn chưa đăng nhập. Vui lòng đăng nhập lại.", 401);
                return;
            }

            int userId = user.getUserId();
            System.out.println("DEBUG: User from session: " + user);
            System.out.println("DEBUG: User ID from session: " + userId);

            // VALIDATION: Check if user still exists in database
            dao.UserDAO userDAO = new dao.UserDAO();
            if (!userDAO.userExists(userId)) {
                System.out.println("ERROR: User ID " + userId + " does not exist in database!");
                // Invalidate session since user doesn't exist
                session.invalidate();
                sendErrorResponse(response, "Tài khoản của bạn không tồn tại trong hệ thống. Vui lòng đăng nhập lại.",
                        401);
                return;
            }

            // Read JSON body
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            String jsonData = sb.toString();
            Gson gson = new Gson();
            Map<String, Object> data = gson.fromJson(jsonData, Map.class);

            String collectionName = (String) data.get("name");
            if (collectionName == null || collectionName.trim().isEmpty()) {
                sendErrorResponse(response, "Tên bộ sưu tập không được để trống", 400);
                return;
            }

            System.out.println("============ IMPORTANT DEBUG ============");
            System.out.println(
                    "About to call createCollection with userId=" + userId + ", collectionName=" + collectionName);
            System.out.println("=========================================");
            int collectionId = collectionService.createCollection(userId, collectionName);

            Map<String, Object> result = new HashMap<>();
            if (collectionId > 0) {
                result.put("success", true);
                result.put("collectionId", collectionId);
                result.put("message", "Tạo bộ sưu tập thành công");
            } else {
                result.put("success", false);
                result.put("message", "Không thể tạo bộ sưu tập");
            }

            PrintWriter out = response.getWriter();
            out.print(JsonUtil.toJson(result));
            out.flush();

        } catch (java.sql.SQLIntegrityConstraintViolationException e) {
            e.printStackTrace();
            sendErrorResponse(response, "Lỗi database: Tài khoản không hợp lệ. Vui lòng đăng xuất và đăng nhập lại.",
                    400);
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Lỗi server: " + e.getMessage(), 500);
        }
    }

    /**
     * Handle PUT requests - Rename collection
     */
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String idParam = request.getParameter("id");
            if (idParam == null) {
                sendErrorResponse(response, "Collection ID is required", 400);
                return;
            }

            int collectionId = Integer.parseInt(idParam);

            // Read JSON body
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            String jsonData = sb.toString();
            Gson gson = new Gson();
            Map<String, Object> data = gson.fromJson(jsonData, Map.class);

            String newName = (String) data.get("name");
            if (newName == null || newName.trim().isEmpty()) {
                sendErrorResponse(response, "Collection name is required", 400);
                return;
            }

            boolean success = collectionService.renameCollection(collectionId, newName);

            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            result.put("message", success ? "Collection renamed successfully" : "Failed to rename collection");

            PrintWriter out = response.getWriter();
            out.print(JsonUtil.toJson(result));
            out.flush();

        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid collection ID", 400);
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Server error: " + e.getMessage(), 500);
        }
    }

    /**
     * Handle DELETE requests - Delete collection
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

            int userId = user.getUserId();

            String idParam = request.getParameter("id");
            if (idParam == null) {
                sendErrorResponse(response, "Collection ID is required", 400);
                return;
            }

            int collectionId = Integer.parseInt(idParam);
            boolean success = collectionService.deleteCollection(collectionId, userId);

            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            result.put("message", success ? "Collection deleted successfully" : "Cannot delete the last collection");

            PrintWriter out = response.getWriter();
            out.print(JsonUtil.toJson(result));
            out.flush();

        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid collection ID", 400);
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Server error: " + e.getMessage(), 500);
        }
    }

    /**
     * Handle list all collections
     */
    private void handleListCollections(int userId, PrintWriter out) {
        List<ScheduleCollection> collections = collectionService.getUserCollections(userId);
        out.print(JsonUtil.toJson(collections));
        out.flush();
    }

    /**
     * Handle get specific collection
     */
    private void handleGetCollection(HttpServletRequest request, PrintWriter out) {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            int collectionId = Integer.parseInt(idParam);
            ScheduleCollection collection = collectionService.getCollectionById(collectionId);
            out.print(JsonUtil.toJson(collection));
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
