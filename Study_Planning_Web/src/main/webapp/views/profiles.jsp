<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    // ==================== LẤY THÔNG TIN USER TỪ SESSION ====================
    User user = (User) session.getAttribute("user");
    
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String username = user.getUsername();
    String email = user.getEmail();
    int userId = user.getUserId();
    
    // Có thể lấy thêm từ database nếu đã có profile
    // Hoặc dùng username làm tên hiển thị
    String displayName = username; 
    String displayDescription = "Email: " + email;
    
    // Kiểm tra nếu có lỗi từ quá trình submit trước đó
    String error = (String) request.getAttribute("error");
    
    // Lấy lại giá trị đã nhập nếu có (để hiển thị lại khi có lỗi)
    String savedFullName = (String) request.getAttribute("fullName");
    String savedDescription = (String) request.getAttribute("description");
    String savedLearningStyle = (String) request.getAttribute("learningStyle");
    String savedWorkStyle = (String) request.getAttribute("workStyle");
    String savedInterests = (String) request.getAttribute("interests");
    String savedProductiveTime = (String) request.getAttribute("productiveTime");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hoàn thiện hồ sơ của bạn</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        primary: "#A5B4FC",
                        "background-light": "#F8FAFC",
                        "background-dark": "#1E293B",
                    },
                    fontFamily: {
                        display: ["Be Vietnam Pro", "sans-serif"],
                    },
                    borderRadius: {
                        DEFAULT: "1rem",
                    },
                },
            },
        };
    </script>
    <style>
        body {
            font-family: 'Be Vietnam Pro', sans-serif;
        }
        .error-message {
            background-color: #fee2e2;
            border: 1px solid #fca5a5;
            color: #dc2626;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body class="bg-background-light dark:bg-background-dark text-slate-800 dark:text-slate-200">
    <div class="flex h-screen">
        <!-- Sidebar -->
        <aside class="w-20 flex flex-col items-center space-y-8 py-8 bg-white/50 dark:bg-slate-900/50 border-r border-slate-200 dark:border-slate-800">
            <div class="w-12 h-12 bg-primary rounded-full flex items-center justify-center">
                <span class="text-2xl font-bold text-white">G</span>
            </div>
            <nav class="flex flex-col items-center space-y-6">
                <a class="p-3 bg-primary/20 text-primary rounded-lg" href="#">
                    <span class="material-icons-outlined">dashboard</span>
                </a>
                <a class="p-3 text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg" href="#">
                    <span class="material-icons-outlined">calendar_today</span>
                </a>
                <a class="p-3 text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg" href="#">
                    <span class="material-icons-outlined">analytics</span>
                </a>
                <a class="p-3 text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg" href="#">
                    <span class="material-icons-outlined">school</span>
                </a>
                <a class="p-3 text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg" href="#">
                    <span class="material-icons-outlined">groups</span>
                </a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="flex-1 flex flex-col overflow-hidden">
            <!-- Header -->
            <header class="flex items-center justify-between p-6 border-b border-slate-200 dark:border-slate-800 bg-background-light dark:bg-background-dark">
                <div>
                    <h1 class="text-2xl font-bold text-slate-900 dark:text-white">Hoàn thiện hồ sơ của bạn</h1>
                    <p class="text-slate-500 dark:text-slate-400">Cung cấp thêm thông tin để nhận được gợi ý tốt nhất nhé!</p>
                </div>
                <div class="flex items-center space-x-4">
                    <button class="p-2 text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-full">
                        <span class="material-icons-outlined">settings</span>
                    </button>
                    <button type="submit" form="profileForm" class="flex items-center space-x-2 px-6 py-3 bg-primary text-white font-semibold rounded-lg shadow-sm hover:opacity-90 transition-opacity">
                        <span>Tiếp theo</span>
                        <span class="material-icons-outlined">arrow_forward</span>
                    </button>
                </div>
            </header>

            <!-- Form Content -->
            <div class="flex-1 overflow-y-auto p-8">
                <!-- Hiển thị lỗi nếu có -->
                <% if (error != null && !error.isEmpty()) { %>
                    <div class="error-message mb-6">
                        <%= error %>
                    </div>
                <% } %>
                
                <form id="profileForm" action="processProfile.jsp" method="post">
                    <!-- Hidden fields để lưu thông tin user -->
                    <input type="hidden" name="user_id" value="<%= userId %>">
                    <input type="hidden" name="username" value="<%= username %>">
                    
                    <!-- User Info Card -->
                    <div class="bg-white dark:bg-slate-900 p-6 rounded-lg shadow-sm flex items-center space-x-6 mb-8 border border-slate-200 dark:border-slate-800">
                        <img alt="Ảnh đại diện của người dùng" class="w-20 h-20 rounded-full object-cover border-4 border-slate-200 dark:border-slate-700" src="https://lh3.googleusercontent.com/aida-public/AB6AXuB_ycgGVB1Wi3HDnD6aH-GEcjvfaG-oMYIvS_ESqjCpjTVJFkWgKEV-a1uD5Xy6nHWbOx8-pmnVk5bC_gficwvD3n_i9TMmcNiS2HLA3ueu4EGRIv7C4n9uBm_unJZqpLCzNA-4ckFA-fdSm9YZdPJjke2eoQj44K0ReBogPSZIMt8Lre1jGLUyBNaO7eLHfM3eIvMKm2EXD7k7bUrKu4H4c4DpsB9XQXk-w97W-D5hJ5jOWoN07SXsEi6h4tXPqsdtwmq9neXZpCI"/>
                        <div>
                            <h2 class="text-xl font-bold text-slate-900 dark:text-white"><%= displayName %></h2>
                            <p class="text-slate-500 dark:text-slate-400"><%= displayDescription %></p>
                        </div>
                    </div>

                    <!-- Form Sections Grid -->
                    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-8">
                        
                        <!-- Learning Style Section -->
                        <div class="bg-white dark:bg-slate-900 p-6 rounded-lg shadow-sm border border-slate-200 dark:border-slate-800">
                            <div class="flex items-center space-x-3 mb-4">
                                <div class="w-10 h-10 bg-indigo-100 dark:bg-indigo-900/50 rounded-lg flex items-center justify-center">
                                    <span class="material-icons-outlined text-indigo-500 dark:text-indigo-400">psychology</span>
                                </div>
                                <h3 class="font-semibold text-lg text-slate-800 dark:text-slate-200">Phong cách học tập</h3>
                            </div>
                            <p class="text-slate-500 dark:text-slate-400 mb-4 text-sm">Bạn tiếp thu kiến thức hiệu quả nhất qua hình thức nào?</p>
                            <div class="space-y-3">
                                <label class="flex items-center p-3 rounded-md border border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800/50 cursor-pointer">
                                    <input class="form-radio text-primary focus:ring-primary/50" 
                                           name="learning_style" 
                                           value="visual" 
                                           type="radio"
                                           <%= "visual".equals(savedLearningStyle) ? "checked" : "" %>/>
                                    <span class="ml-3 text-slate-700 dark:text-slate-300">Nhìn (Visual)</span>
                                </label>
                                <label class="flex items-center p-3 rounded-md border border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800/50 cursor-pointer">
                                    <input class="form-radio text-primary focus:ring-primary/50" 
                                           name="learning_style" 
                                           value="auditory" 
                                           type="radio"
                                           <%= "auditory".equals(savedLearningStyle) ? "checked" : "" %>/>
                                    <span class="ml-3 text-slate-700 dark:text-slate-300">Nghe (Auditory)</span>
                                </label>
                                <label class="flex items-center p-3 rounded-md border border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800/50 cursor-pointer">
                                    <input class="form-radio text-primary focus:ring-primary/50" 
                                           name="learning_style" 
                                           value="kinesthetic" 
                                           type="radio"
                                           <%= "kinesthetic".equals(savedLearningStyle) ? "checked" : "" %>/>
                                    <span class="ml-3 text-slate-700 dark:text-slate-300">Vận động (Kinesthetic)</span>
                                </label>
                            </div>
                        </div>

                        <!-- Work Style Section -->
                        <div class="bg-white dark:bg-slate-900 p-6 rounded-lg shadow-sm border border-slate-200 dark:border-slate-800">
                            <div class="flex items-center space-x-3 mb-4">
                                <div class="w-10 h-10 bg-pink-100 dark:bg-pink-900/50 rounded-lg flex items-center justify-center">
                                    <span class="material-icons-outlined text-pink-500 dark:text-pink-400">groups</span>
                                </div>
                                <h3 class="font-semibold text-lg text-slate-800 dark:text-slate-200">Phong cách làm việc</h3>
                            </div>
                            <p class="text-slate-500 dark:text-slate-400 mb-4 text-sm">Bạn thích làm việc một mình hay theo nhóm?</p>
                            <div class="flex space-x-3">
                                <button type="button" class="work-style-btn flex-1 py-3 bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 font-medium rounded-md hover:bg-slate-200 dark:hover:bg-slate-700" 
                                        data-value="alone"
                                        id="btn-alone">Một mình</button>
                                <button type="button" class="work-style-btn flex-1 py-3 bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 font-medium rounded-md hover:bg-slate-200 dark:hover:bg-slate-700" 
                                        data-value="group"
                                        id="btn-group">Theo nhóm</button>
                            </div>
                            <input type="hidden" name="work_style" id="work_style" value="<%= savedWorkStyle != null ? savedWorkStyle : "alone" %>">
                        </div>

                        <!-- Interests Section -->
                        <div class="bg-white dark:bg-slate-900 p-6 rounded-lg shadow-sm border border-slate-200 dark:border-slate-800">
                            <div class="flex items-center space-x-3 mb-4">
                                <div class="w-10 h-10 bg-amber-100 dark:bg-amber-900/50 rounded-lg flex items-center justify-center">
                                    <span class="material-icons-outlined text-amber-500 dark:text-amber-400">sports_esports</span>
                                </div>
                                <h3 class="font-semibold text-lg text-slate-800 dark:text-slate-200">Sở thích đặc biệt</h3>
                            </div>
                            <p class="text-slate-500 dark:text-slate-400 mb-4 text-sm">Hãy chia sẻ 3 sở thích bạn đam mê nhất (ngăn cách bởi dấu phẩy).</p>
                            <input class="w-full form-input bg-slate-50 dark:bg-slate-800 border-slate-200 dark:border-slate-700 rounded-md focus:ring-primary/50 focus:border-primary" 
                                   name="interests" 
                                   placeholder="VD: Đọc sách, chơi game, du lịch" 
                                   type="text"
                                   value="<%= savedInterests != null ? savedInterests : "" %>"/>
                        </div>

                        <!-- Productive Time Section -->
                        <div class="bg-white dark:bg-slate-900 p-6 rounded-lg shadow-sm border border-slate-200 dark:border-slate-800">
                            <div class="flex items-center space-x-3 mb-4">
                                <div class="w-10 h-10 bg-teal-100 dark:bg-teal-900/50 rounded-lg flex items-center justify-center">
                                    <span class="material-icons-outlined text-teal-500 dark:text-teal-400">rocket_launch</span>
                                </div>
                                <h3 class="font-semibold text-lg text-slate-800 dark:text-slate-200">Thời gian năng suất</h3>
                            </div>
                            <p class="text-slate-500 dark:text-slate-400 mb-4 text-sm">Bạn cảm thấy tập trung và hiệu quả nhất vào khoảng thời gian nào trong ngày?</p>
                            <select class="w-full form-select bg-slate-50 dark:bg-slate-800 border-slate-200 dark:border-slate-700 rounded-md focus:ring-primary/50 focus:border-primary" name="productive_time" id="productive_time">
                                <option value="morning" <%= "morning".equals(savedProductiveTime) ? "selected" : "" %>>Buổi sáng (6h-12h)</option>
                                <option value="afternoon" <%= "afternoon".equals(savedProductiveTime) ? "selected" : "" %>>Buổi chiều (12h-18h)</option>
                                <option value="evening" <%= "evening".equals(savedProductiveTime) ? "selected" : "" %>>Buổi tối (18h-24h)</option>
                                <option value="night" <%= "night".equals(savedProductiveTime) ? "selected" : "" %>>Ban đêm (0h-6h)</option>
                            </select>
                        </div>
                    </div>
                    <form id="profileForm" action="processProfile.jsp" method="post">
                        <!-- Thêm hidden field để xác định đây là form 1 -->
                            <input type="hidden" name="form_type" value="basic_profile">        
                    
                    <!-- Additional fields -->
                    <input type="hidden" name="full_name" id="full_name" value="<%= savedFullName != null ? savedFullName : username %>">
                    <textarea name="description" style="display:none;" id="description"><%= savedDescription != null ? savedDescription : "" %></textarea>
                </form>
            </div>
        </main>
    </div>

    <script>
        // Xử lý chọn phong cách làm việc
        document.querySelectorAll('.work-style-btn').forEach(button => {
            button.addEventListener('click', function() {
                // Xóa trạng thái active của tất cả các nút
                document.querySelectorAll('.work-style-btn').forEach(btn => {
                    btn.classList.remove('bg-pink-50', 'dark:bg-pink-900/40', 'text-pink-600', 'dark:text-pink-300');
                    btn.classList.add('bg-slate-100', 'dark:bg-slate-800', 'text-slate-600', 'dark:text-slate-300');
                });
                
                // Thêm trạng thái active cho nút được chọn
                this.classList.remove('bg-slate-100', 'dark:bg-slate-800', 'text-slate-600', 'dark:text-slate-300');
                this.classList.add('bg-pink-50', 'dark:bg-pink-900/40', 'text-pink-600', 'dark:text-pink-300');
                
                // Cập nhật giá trị hidden input
                const selectedValue = this.getAttribute('data-value');
                document.getElementById('work_style').value = selectedValue;
            });
        });

        // Thiết lập giá trị mặc định cho phong cách làm việc
        // Dựa vào giá trị đã lưu hoặc mặc định là "alone"
        const savedWorkStyle = '<%= savedWorkStyle != null ? savedWorkStyle : "alone" %>';
        if (savedWorkStyle === 'group') {
            document.getElementById('btn-group').click();
        } else {
            document.getElementById('btn-alone').click();
        }
        
        // Xử lý khi form submit
        document.getElementById('profileForm').addEventListener('submit', function(e) {
            // Validate các field bắt buộc
            const learningStyle = document.querySelector('input[name="learning_style"]:checked');
            const workStyle = document.getElementById('work_style').value;
            
            if (!learningStyle) {
                e.preventDefault();
                alert('Vui lòng chọn phong cách học tập!');
                return false;
            }
            
            if (!workStyle) {
                e.preventDefault();
                alert('Vui lòng chọn phong cách làm việc!');
                return false;
            }
            
            // Có thể thêm các validate khác ở đây
            return true;
        });
    </script>
</body>
</html>