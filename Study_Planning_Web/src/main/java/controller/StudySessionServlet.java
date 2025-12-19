package controller;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import dao.StudySessionDAO;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.BufferedReader;

@WebServlet("/StudySessionServlet")
public class StudySessionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        try {
            BufferedReader reader = req.getReader();
            JsonObject json = JsonParser.parseReader(reader).getAsJsonObject();

            int minutes = json.get("minutes").getAsInt();
            boolean finished = json.get("finished").getAsBoolean();

            // Lưu vào DB
            StudySessionDAO.saveSession(minutes, finished);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
