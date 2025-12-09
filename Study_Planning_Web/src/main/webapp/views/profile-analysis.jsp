<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.UserProfiles" %>
<%@ page import="service.UserProfilesService" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    UserProfilesService profileService = new UserProfilesService();
    UserProfiles profile = profileService.getUserProfile(user.getUserId());
    
    String suggestions = (String) session.getAttribute("learningSuggestions");
    if (suggestions == null && profile != null) {
        suggestions = profileService.analyzeProfileAndSuggest(user.getUserId());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Kết quả phân tích</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet">
</head>
<body class="bg-gray-100 min-h-screen">
    <div class="container mx-auto p-8">
        <div class="flex justify-between items-center mb-8">
            <h1 class="text-3xl font-bold text-gray-800">Dashboard - Kết quả phân tích</h1>
            <div class="flex items-center space-x-4">
                <span class="text-gray-600">Xin chào, <%= user.getUsername() %>!</span>
                <a href="logout.jsp" class="text-red-600 hover:text-red-800">
                    <span class="material-icons-outlined">logout</span>
                </a>
            </div>
        </div>
        
        <% if (request.getParameter("completed") != null) { %>
            <div class="mb-6 p-4 bg-green-100 border border-green-400 text-green-700 rounded-lg">
                ✅ Bạn đã hoàn thành cả 2 form! Dưới đây là kết quả phân tích của bạn.
            </div>
        <% } %>
        
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Thông tin profile -->
            <div class="col-span-1">
                <div class="bg-white rounded-lg shadow-md p-6">
                    <h2 class="text-xl font-semibold mb-4">📋 Thông tin hồ sơ của bạn</h2>
                    
                    <% if (profile != null) { %>
                        <div class="space-y-4">
                            <div>
                                <p class="text-gray-500 text-sm">Họ tên</p>
                                <p class="font-medium"><%= profile.getFullName() != null ? profile.getFullName() : "Chưa cập nhật" %></p>
                            </div>
                            <div>
                                <p class="text-gray-500 text-sm">Mô tả</p>
                                <p class="font-medium"><%= profile.getDescription() != null ? profile.getDescription() : "Chưa cập nhật" %></p>
                            </div>
                            <div>
                                <p class="text-gray-500 text-sm">Phong cách học</p>
                                <p class="font-medium">
                                    <% if ("visual".equals(profile.getLearningStyle())) { %>
                                        🎨 Hình ảnh (Visual)
                                    <% } else if ("auditory".equals(profile.getLearningStyle())) { %>
                                        🎧 Âm thanh (Auditory)
                                    <% } else if ("kinesthetic".equals(profile.getLearningStyle())) { %>
                                        🖐️ Vận động (Kinesthetic)
                                    <% } else { %>
                                        Chưa cập nhật
                                    <% } %>
                                </p>
                            </div>
                            <div>
                                <p class="text-gray-500 text-sm">Phong cách làm việc</p>
                                <p class="font-medium">
                                    <% if ("alone".equals(profile.getWorkStyle())) { %>
                                        🧘 Một mình
                                    <% } else if ("group".equals(profile.getWorkStyle())) { %>
                                        👥 Theo nhóm
                                    <% } else { %>
                                        Chưa cập nhật
                                    <% } %>
                                </p>
                            </div>
                            <div>
                                <p class="text-gray-500 text-sm">Sở thích</p>
                                <p class="font-medium"><%= profile.getInterests() != null ? profile.getInterests() : "Chưa cập nhật" %></p>
                            </div>
                        </div>
                    <% } else { %>
                        <p class="text-gray-500">Bạn chưa hoàn thành hồ sơ. <a href="profile.jsp" class="text-blue-600 hover:underline">Hoàn thiện ngay</a></p>
                    <% } %>
                </div>
            </div>
            
            <!-- Gợi ý học tập -->
            <div class="col-span-2">
                <div class="bg-white rounded-lg shadow-md p-6">
                    <h2 class="text-xl font-semibold mb-4">🎯 Gợi ý học tập cá nhân hóa</h2>
                    
                    <% if (suggestions != null && !suggestions.isEmpty()) { %>
                        <div class="prose max-w-none">
                            <%= suggestions %>
                        </div>
                    <% } else { %>
                        <p class="text-gray-500">Chưa có gợi ý nào. Vui lòng hoàn thành các bài trắc nghiệm.</p>
                        <div class="mt-4">
                            <a href="profile.jsp" class="inline-block px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                                Hoàn thiện hồ sơ
                            </a>
                            <% if (profile != null) { %>
                                <a href="learning-style-setup.jsp" class="inline-block px-6 py-3 bg-green-600 text-white rounded-lg hover:bg-green-700 ml-3">
                                    Làm trắc nghiệm
                                </a>
                            <% } %>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</body>
</html>