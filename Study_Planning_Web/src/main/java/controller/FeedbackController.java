package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.FeedbackDAO;
import model.Feedback;
import model.User;
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

@WebServlet(name = "FeedbackController", urlPatterns = { "/api/feedback/submit" })
public class FeedbackController extends HttpServlet {

    private final FeedbackDAO feedbackDAO = new FeedbackDAO();
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
                sendResponse(response, false, "User not logged in");
                return;
            }

            // 2. Read Request
            BufferedReader reader = request.getReader();
            JsonObject jsonBody = gson.fromJson(reader, JsonObject.class);

            int rating = jsonBody.has("rating") ? jsonBody.get("rating").getAsInt() : 0;
            String comment = jsonBody.has("comment") ? jsonBody.get("comment").getAsString() : "";
            int collectionId = jsonBody.has("collectionId") ? jsonBody.get("collectionId").getAsInt() : -1;

            if (rating < 1 || rating > 5) {
                sendResponse(response, false, "Invalid rating (1-5)");
                return;
            }

            // 3. Save
            Feedback feedback = new Feedback(user.getUserId(), rating, comment, collectionId);
            boolean saved = feedbackDAO.save(feedback);

            sendResponse(response, saved, saved ? "Feedback submitted successfully" : "Failed to save feedback");

        } catch (Exception e) {
            e.printStackTrace();
            sendResponse(response, false, "Server error: " + e.getMessage());
        }
    }

    private void sendResponse(HttpServletResponse response, boolean success, String message) throws IOException {
        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        result.put("message", message);
        PrintWriter out = response.getWriter();
        out.print(JsonUtil.toJson(result));
        out.flush();
    }
}
