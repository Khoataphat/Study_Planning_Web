package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import model.User;
import service.SmartScheduleService;
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
import java.util.Map;

/**
 * Controller for Smart Schedule Generation API
 */
@WebServlet(name = "SmartScheduleController", urlPatterns = { "/api/smart-schedule/generate" })
public class SmartScheduleController extends HttpServlet {

    private final SmartScheduleService smartService = new SmartScheduleService();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // 1. Auth Check
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;

            if (user == null) {
                sendErrorResponse(response, "User not logged in", 401);
                return;
            }

            // 2. Read Request Body
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            // 3. Parse JSON
            JsonObject jsonBody = gson.fromJson(sb.toString(), JsonObject.class);

            // Check Action: "preview" (default) or "save"
            String action = jsonBody.has("action") ? jsonBody.get("action").getAsString() : "preview";

            Map<String, Object> result = new HashMap<>();

            if ("save".equalsIgnoreCase(action)) {
                // SAVE ACTION
                // Retrieve scheduled from Session
                java.util.List<model.UserSchedule> proposedSchedule = (java.util.List<model.UserSchedule>) session
                        .getAttribute("PROPOSED_SCHEDULE");

                int collectionId = jsonBody.has("collectionId") ? jsonBody.get("collectionId").getAsInt() : -1;

                if (proposedSchedule == null || proposedSchedule.isEmpty()) {
                    result.put("success", false);
                    result.put("message", "No schedule to save. Please generate a preview first.");
                } else {
                    boolean saved = smartService.saveSchedules(user.getUserId(), collectionId, proposedSchedule);
                    result.put("success", saved);
                    result.put("message", saved ? "Schedule saved successfully!" : "Failed to save schedule.");
                    // Clear session after save
                    if (saved)
                        session.removeAttribute("PROPOSED_SCHEDULE");
                }

            } else {
                // PREVIEW ACTION (Default)
                int collectionId = jsonBody.get("collectionId").getAsInt();
                String startTime = jsonBody.get("startTime").getAsString();
                String endTime = jsonBody.get("endTime").getAsString();
                boolean includeWeekends = jsonBody.has("includeWeekends")
                        && jsonBody.get("includeWeekends").getAsBoolean();

                // Generate but DO NOT SAVE yet
                java.util.List<model.UserSchedule> generatedSchedules = smartService.calculateSchedule(user.getUserId(),
                        collectionId, startTime, endTime, includeWeekends);

                // Store in Session
                session.setAttribute("PROPOSED_SCHEDULE", generatedSchedules);

                result.put("success", true);
                result.put("message", "Preview generated.");
                result.put("previewData", generatedSchedules); // Send back to frontend for rendering
            }

            PrintWriter out = response.getWriter();
            out.print(JsonUtil.toJson(result));
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Server error: " + e.getMessage(), 500);
        }
    }

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
