package com.studyplanning.controller;

import com.google.gson.Gson;
import com.studyplanning.model.ScheduleCollection;
import com.studyplanning.service.ScheduleCollectionService;
import com.studyplanning.utils.JsonUtil;

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

/**
 * Controller for handling schedule collection HTTP requests
 */
@WebServlet(name = "ScheduleCollectionController", urlPatterns = {"/user/collections"})
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
            int userId = 1; // Default for testing
            if (session != null && session.getAttribute("userId") != null) {
                userId = (int) session.getAttribute("userId");
            }

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
            int userId = 1; // Default for testing
            if (session != null && session.getAttribute("userId") != null) {
                userId = (int) session.getAttribute("userId");
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
                sendErrorResponse(response, "Collection name is required", 400);
                return;
            }

            int collectionId = collectionService.createCollection(userId, collectionName);

            Map<String, Object> result = new HashMap<>();
            if (collectionId > 0) {
                result.put("success", true);
                result.put("collectionId", collectionId);
                result.put("message", "Collection created successfully");
            } else {
                result.put("success", false);
                result.put("message", "Failed to create collection");
            }

            PrintWriter out = response.getWriter();
            out.print(JsonUtil.toJson(result));
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Server error: " + e.getMessage(), 500);
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
            int userId = 1; // Default for testing
            if (session != null && session.getAttribute("userId") != null) {
                userId = (int) session.getAttribute("userId");
            }

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
