package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import model.User;
import model.TimerSession;
import model.TimerSettings;
import model.TimerStats;
import service.TimerService;
import java.util.List;
import service.TimerServiceImplSimple;

@WebServlet(name = "TimerController", urlPatterns = {
    "/timer",
    "/timer/start",
    "/timer/pause",
    "/timer/resume",
    "/timer/stop",
    "/timer/complete",
    "/timer/settings",
    "/timer/settings/quick",
    "/timer/history",
    "/timer/stats"
})
public class TimerController extends HttpServlet {
    
    private TimerService timerService;
    
    @Override
    public void init() {
        // Sử dụng implementation đơn giản cho testing
        this.timerService = new TimerServiceImplSimple();
        
        // Hoặc sử dụng implementation đầy đủ (khi đã có DAO)
        // this.timerService = new TimerServiceImpl(timerSessionDAO, timerSettingsDAO);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        switch (path) {
            case "/timer":
                showTimerPage(request, response, user);
                break;
            case "/timer/settings":
                showSettingsPage(request, response, user);
                break;
            case "/timer/history":
                showHistoryPage(request, response, user);
                break;
            case "/timer/stats":
                showStatsPage(request, response, user);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        switch (path) {
            case "/timer/start":
                startTimer(request, response, user);
                break;
            case "/timer/pause":
                pauseTimer(request, response, user);
                break;
            case "/timer/resume":
                resumeTimer(request, response, user);
                break;
            case "/timer/stop":
                stopTimer(request, response, user);
                break;
            case "/timer/complete":
                completeTimer(request, response, user);
                break;
            case "/timer/settings/quick":
                updateQuickSettings(request, response, user);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    // Phương thức hiển thị trang timer chính
    private void showTimerPage(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        try {
            // Lấy session đang hoạt động
            TimerSession activeSession = timerService.getActiveSession(user.getUserId());
            if (activeSession != null) {
                request.setAttribute("activeSession", activeSession);
            }
            
            // Lấy thống kê hôm nay
            TimerStats todayStats = timerService.getTodayStats(user.getUserId());
            if (todayStats != null) {
                request.setAttribute("todayStats", todayStats);
            } else {
                // Tạo thống kê mặc định
                TimerStats defaultStats = new TimerStats();
                defaultStats.setTotalFocusMinutes(0);
                defaultStats.setCompletedSessions(0);
                defaultStats.setGoalPercentage(0);
                request.setAttribute("todayStats", defaultStats);
            }
            
            // Lấy cài đặt
            TimerSettings settings = timerService.getUserSettings(user.getUserId());
            if (settings != null) {
                request.setAttribute("settings", settings);
            } else {
                // Tạo cài đặt mặc định
                TimerSettings defaultSettings = new TimerSettings();
                defaultSettings.setPomodoroWork(25);
                defaultSettings.setPomodoroBreak(5);
                defaultSettings.setDeepWorkDuration(90);
                defaultSettings.setWork52Duration(52);
                defaultSettings.setSoundEnabled(true);
                defaultSettings.setAutoStartBreaks(true);
                request.setAttribute("settings", defaultSettings);
                // Lưu cài đặt mặc định
                timerService.saveSettings(user.getUserId(), defaultSettings);
            }
            
            // Chuyển đến trang JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/timer.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải trang timer: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/error.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    // Phương thức hiển thị trang cài đặt
    private void showSettingsPage(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        try {
            TimerSettings settings = timerService.getUserSettings(user.getUserId());
            if (settings == null) {
                settings = new TimerSettings();
                settings.setPomodoroWork(25);
                settings.setPomodoroBreak(5);
                settings.setDeepWorkDuration(90);
                settings.setWork52Duration(52);
                settings.setSoundEnabled(true);
                settings.setAutoStartBreaks(true);
                timerService.saveSettings(user.getUserId(), settings);
            }
            
            request.setAttribute("settings", settings);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/timer-settings.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải trang cài đặt: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/error.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    // Phương thức hiển thị lịch sử
    private void showHistoryPage(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        try {
            List<TimerSession> history = timerService.getUserHistory(user.getUserId(), 30); // 30 ngày gần nhất
            
            // Lấy tham số phân trang
            String pageParam = request.getParameter("page");
            String sizeParam = request.getParameter("size");
            int page = pageParam != null ? Integer.parseInt(pageParam) : 1;
            int size = sizeParam != null ? Integer.parseInt(sizeParam) : 10;
            
            // Tính toán phân trang
            int startIndex = (page - 1) * size;
            int endIndex = Math.min(startIndex + size, history.size());
            List<TimerSession> paginatedHistory = history.subList(startIndex, endIndex);
            
            request.setAttribute("history", paginatedHistory);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", size);
            request.setAttribute("totalItems", history.size());
            request.setAttribute("totalPages", (int) Math.ceil((double) history.size() / size));
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/timer-history.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải lịch sử: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/error.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    // Phương thức hiển thị thống kê
    private void showStatsPage(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        try {
            // Thống kê theo tuần
            TimerStats weeklyStats = timerService.getWeeklyStats(user.getUserId());
            request.setAttribute("weeklyStats", weeklyStats);
            
            // Thống kê theo tháng
            TimerStats monthlyStats = timerService.getMonthlyStats(user.getUserId());
            request.setAttribute("monthlyStats", monthlyStats);
            
            // Thống kê toàn thời gian
            TimerStats lifetimeStats = timerService.getLifetimeStats(user.getUserId());
            request.setAttribute("lifetimeStats", lifetimeStats);
            
            // Xu hướng 7 ngày gần nhất
            List<TimerStats> trendStats = timerService.getTrendStats(user.getUserId(), 7);
            request.setAttribute("trendStats", trendStats);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/timer-stats.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải thống kê: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/error.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    // Phương thức bắt đầu timer
    private void startTimer(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        
        try {
            String type = request.getParameter("type");
            if (type == null || type.trim().isEmpty()) {
                type = "POMODORO";
            }
            
            TimerSession session = timerService.startSession(user.getUserId(), type);
            
            response.setContentType("application/json");
            response.getWriter().write(String.format(
                "{\"success\": true, \"sessionId\": %d, \"workDuration\": %d}",
                session.getId(),
                session.getWorkDuration()
            ));
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write(
                "{\"success\": false, \"message\": \"Lỗi khi bắt đầu timer: " + e.getMessage() + "\"}"
            );
        }
    }
    
    // Phương thức tạm dừng timer
    private void pauseTimer(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        
        try {
            String sessionIdParam = request.getParameter("sessionId");
            if (sessionIdParam == null) {
                throw new IllegalArgumentException("Session ID không được để trống");
            }
            
            long sessionId = Long.parseLong(sessionIdParam);
            boolean success = timerService.pauseSession(sessionId, user.getUserId());
            
            response.setContentType("application/json");
            if (success) {
                response.getWriter().write("{\"success\": true}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Không tìm thấy session hoặc không có quyền\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write(
                "{\"success\": false, \"message\": \"Lỗi khi tạm dừng timer: " + e.getMessage() + "\"}"
            );
        }
    }
    
    // Phương thức tiếp tục timer
    private void resumeTimer(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        
        try {
            String sessionIdParam = request.getParameter("sessionId");
            if (sessionIdParam == null) {
                throw new IllegalArgumentException("Session ID không được để trống");
            }
            
            long sessionId = Long.parseLong(sessionIdParam);
            boolean success = timerService.resumeSession(sessionId, user.getUserId());
            
            response.setContentType("application/json");
            if (success) {
                response.getWriter().write("{\"success\": true}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Không tìm thấy session hoặc không có quyền\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write(
                "{\"success\": false, \"message\": \"Lỗi khi tiếp tục timer: " + e.getMessage() + "\"}"
            );
        }
    }
    
    // Phương thức dừng timer
    private void stopTimer(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        
        try {
            String sessionIdParam = request.getParameter("sessionId");
            if (sessionIdParam == null) {
                throw new IllegalArgumentException("Session ID không được để trống");
            }
            
            long sessionId = Long.parseLong(sessionIdParam);
            boolean success = timerService.stopSession(sessionId, user.getUserId());
            
            response.setContentType("application/json");
            if (success) {
                response.getWriter().write("{\"success\": true}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Không tìm thấy session hoặc không có quyền\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write(
                "{\"success\": false, \"message\": \"Lỗi khi dừng timer: " + e.getMessage() + "\"}"
            );
        }
    }
    
    // Phương thức hoàn thành timer
    private void completeTimer(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        
        try {
            String sessionIdParam = request.getParameter("sessionId");
            if (sessionIdParam == null) {
                throw new IllegalArgumentException("Session ID không được để trống");
            }
            
            long sessionId = Long.parseLong(sessionIdParam);
            boolean success = timerService.completeSession(sessionId, user.getUserId());
            
            response.setContentType("application/json");
            if (success) {
                response.getWriter().write("{\"success\": true}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Không tìm thấy session hoặc không có quyền\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write(
                "{\"success\": false, \"message\": \"Lỗi khi hoàn thành timer: " + e.getMessage() + "\"}"
            );
        }
    }
    
    // Phương thức cập nhật cài đặt nhanh
    private void updateQuickSettings(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        
        try {
            // Đọc JSON từ request body
            StringBuilder jsonBuilder = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                jsonBuilder.append(line);
            }
            String json = jsonBuilder.toString();
            
            // Parse JSON đơn giản (trong thực tế nên dùng thư viện như Jackson)
            String setting = extractJsonValue(json, "setting");
            String value = extractJsonValue(json, "value");
            
            if (setting == null || value == null) {
                throw new IllegalArgumentException("Thiếu tham số setting hoặc value");
            }
            
            // Lấy cài đặt hiện tại
            TimerSettings settings = timerService.getUserSettings(user.getUserId());
            if (settings == null) {
                settings = new TimerSettings();
            }
            
            // Cập nhật giá trị
            switch (setting) {
                case "pomodoroWork":
                    settings.setPomodoroWork(Integer.parseInt(value));
                    break;
                case "pomodoroBreak":
                    settings.setPomodoroBreak(Integer.parseInt(value));
                    break;
                case "soundEnabled":
                    settings.setSoundEnabled(Boolean.parseBoolean(value));
                    break;
                case "autoStartBreaks":
                    settings.setAutoStartBreaks(Boolean.parseBoolean(value));
                    break;
                default:
                    throw new IllegalArgumentException("Cài đặt không hợp lệ: " + setting);
            }
            
            // Lưu cài đặt
            timerService.saveSettings(user.getUserId(), settings);
            
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true}");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write(
                "{\"success\": false, \"message\": \"Lỗi khi cập nhật cài đặt: " + e.getMessage() + "\"}"
            );
        }
    }
    
    // Phương thức trích xuất giá trị từ JSON đơn giản
    private String extractJsonValue(String json, String key) {
        try {
            String pattern = "\"" + key + "\":\"([^\"]+)\"";
            java.util.regex.Pattern p = java.util.regex.Pattern.compile(pattern);
            java.util.regex.Matcher m = p.matcher(json);
            if (m.find()) {
                return m.group(1);
            }
            
            // Thử pattern khác cho boolean và number
            pattern = "\"" + key + "\":(true|false|\\d+)";
            p = java.util.regex.Pattern.compile(pattern);
            m = p.matcher(json);
            if (m.find()) {
                return m.group(1);
            }
            
            return null;
        } catch (Exception e) {
            return null;
        }
    }
}