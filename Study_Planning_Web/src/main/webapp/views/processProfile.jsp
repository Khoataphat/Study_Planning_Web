<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, service.UserProfileService, java.time.LocalDateTime" %>
<%
    // ==================== 1. KIỂM TRA ĐĂNG NHẬP ====================
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    int userId = user.getUserId();
    request.setCharacterEncoding("UTF-8");
    
    // ==================== 2. XÁC ĐỊNH FORM TYPE ====================
    String formType = request.getParameter("form_type");
    
    if (formType == null || formType.isEmpty()) {
        // Nếu không có form_type, coi như là form cơ bản
        formType = "basic_profile";
    }
    
    System.out.println("=== DEBUG processProfile.jsp ===");
    System.out.println("Form Type: " + formType);
    System.out.println("User ID: " + userId);
    
    // ==================== 3. XỬ LÝ THEO TỪNG LOẠI FORM ====================
    
    if ("basic_profile".equals(formType)) {
        // ========== XỬ LÝ FORM 1: HOÀN THIỆN HỒ SƠ CƠ BẢN ==========
        handleBasicProfile(request, response, user);
        
    } else if ("learning_style_quiz".equals(formType)) {
        // ========== XỬ LÝ FORM 2: TRẮC NGHIỆM PHƯƠNG PHÁP HỌC ==========
        handleLearningStyleQuiz(request, response, user);
        
    } else {
        // Form type không hợp lệ
        response.sendRedirect("profile.jsp?error=invalid_form_type");
    }
%>

<%!
    // ==================== METHOD XỬ LÝ FORM 1 ====================
    private void handleBasicProfile(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        int userId = user.getUserId();
        
        // Lấy dữ liệu từ form
        String fullName = request.getParameter("full_name");
        String description = request.getParameter("description");
        String learningStyle = request.getParameter("learning_style");
        String workStyle = request.getParameter("work_style");
        String interests = request.getParameter("interests");
        String productiveTime = request.getParameter("productive_time");
        
        // Debug
        System.out.println("=== BASIC PROFILE DATA ===");
        System.out.println("Full Name: " + fullName);
        System.out.println("Description: " + description);
        System.out.println("Learning Style: " + learningStyle);
        System.out.println("Work Style: " + workStyle);
        System.out.println("Interests: " + interests);
        System.out.println("Productive Time: " + productiveTime);
        
        // Validate
        boolean hasError = false;
        StringBuilder errorMessage = new StringBuilder();
        
        if (fullName == null || fullName.trim().isEmpty()) {
            hasError = true;
            errorMessage.append("Vui lòng nhập họ tên.<br>");
        }
        
        if (learningStyle == null || learningStyle.trim().isEmpty()) {
            hasError = true;
            errorMessage.append("Vui lòng chọn phong cách học tập.<br>");
        }
        
        if (workStyle == null || workStyle.trim().isEmpty()) {
            hasError = true;
            errorMessage.append("Vui lòng chọn phong cách làm việc.<br>");
        }
        
        if (productiveTime == null || productiveTime.trim().isEmpty()) {
            productiveTime = "morning";
        }
        
        // Nếu có lỗi, quay lại form
        if (hasError) {
            request.setAttribute("error", errorMessage.toString());
            request.setAttribute("fullName", fullName);
            request.setAttribute("description", description);
            request.setAttribute("learningStyle", learningStyle);
            request.setAttribute("workStyle", workStyle);
            request.setAttribute("interests", interests);
            request.setAttribute("productiveTime", productiveTime);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        // Xử lý lưu vào database
        try {
            UserProfileService profileService = new UserProfileService();
            
            // Kiểm tra xem user đã có profile chưa
            boolean hasProfile = profileService.hasUserProfile(userId);
            
            boolean success;
            if (hasProfile) {
                // Update profile cơ bản
                success = profileService.updateUserProfile(
                    userId, fullName, description, learningStyle, 
                    workStyle, interests, productiveTime
                );
            } else {
                // Tạo profile mới
                success = profileService.createUserProfile(
                    userId, fullName, description, learningStyle, 
                    workStyle, interests, productiveTime
                );
            }
            
            if (success) {
                // Lưu vào session để sử dụng sau
                request.getSession().setAttribute("userFullName", fullName);
                request.getSession().setAttribute("basicProfileCompleted", true);
                
                // Debug
                System.out.println("Basic profile saved successfully!");
                System.out.println("Redirecting to learning-style-setup.jsp");
                
                // Chuyển hướng sang form trắc nghiệm
                response.sendRedirect("learning-style-setup.jsp");
                
            } else {
                throw new Exception("Không thể lưu thông tin hồ sơ vào database.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            
            // Hiển thị lỗi và quay lại form
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.setAttribute("fullName", fullName);
            request.setAttribute("description", description);
            request.setAttribute("learningStyle", learningStyle);
            request.setAttribute("workStyle", workStyle);
            request.setAttribute("interests", interests);
            request.setAttribute("productiveTime", productiveTime);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    // ==================== METHOD XỬ LÝ FORM 2 ====================
    private void handleLearningStyleQuiz(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        int userId = user.getUserId();
        
        // Lấy dữ liệu từ form trắc nghiệm
        String studyMethodVisual = request.getParameter("study_method_visual");
        String studyMethodAuditory = request.getParameter("study_method_auditory");
        String studyMethodReading = request.getParameter("study_method_reading");
        String studyMethodPractice = request.getParameter("study_method_practice");
        String productiveTime = request.getParameter("productive_time");
        String groupStudyPreferenceStr = request.getParameter("group_study_preference");
        
        // Debug
        System.out.println("=== LEARNING STYLE QUIZ DATA ===");
        System.out.println("Study Visual: " + studyMethodVisual);
        System.out.println("Study Auditory: " + studyMethodAuditory);
        System.out.println("Study Reading: " + studyMethodReading);
        System.out.println("Study Practice: " + studyMethodPractice);
        System.out.println("Productive Time: " + productiveTime);
        System.out.println("Group Preference: " + groupStudyPreferenceStr);
        
        // Validate
        if (productiveTime == null || productiveTime.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn thời gian năng suất.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("learning-style-setup.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        if (groupStudyPreferenceStr == null || groupStudyPreferenceStr.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng đánh giá mức độ yêu thích học nhóm.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("learning-style-setup.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        int groupStudyPreference;
        try {
            groupStudyPreference = Integer.parseInt(groupStudyPreferenceStr);
        } catch (NumberFormatException e) {
            groupStudyPreference = 3; // Giá trị mặc định
        }
        
        // Xử lý lưu vào database
        try {
            UserProfileService profileService = new UserProfileService();
            
            // Lấy profile hiện tại
            boolean hasProfile = profileService.hasUserProfile(userId);
            
            if (!hasProfile) {
                // Nếu chưa có profile cơ bản, yêu cầu người dùng quay lại
                response.sendRedirect("profile.jsp?error=complete_basic_profile_first");
                return;
            }
            
            // Cập nhật kết quả trắc nghiệm
            boolean success = profileService.updateLearningStyleQuiz(
                userId, 
                studyMethodVisual != null ? "selected" : "",
                studyMethodAuditory != null ? "selected" : "",
                studyMethodReading != null ? "selected" : "",
                studyMethodPractice != null ? "selected" : "",
                productiveTime,
                groupStudyPreference
            );
            
            if (success) {
                // Lấy kết quả phân tích
                String suggestions = profileService.analyzeProfileAndSuggest(userId);
                request.getSession().setAttribute("learningSuggestions", suggestions);
                request.getSession().setAttribute("learningStyleCompleted", true);
                
                // Debug
                System.out.println("Learning style quiz saved successfully!");
                System.out.println("Redirecting to dashboard.jsp");
                
                // Chuyển hướng sang dashboard
                response.sendRedirect("dashboard.jsp?completed=true");
                
            } else {
                throw new Exception("Không thể lưu kết quả trắc nghiệm.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("learning-style-setup.jsp");
            dispatcher.forward(request, response);
        }
    }
%>