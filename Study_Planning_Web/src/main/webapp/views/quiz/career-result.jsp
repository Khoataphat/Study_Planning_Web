<%-- 
    Document   : career-result.jsp
    Created on : 21 thg 12, 2025, 23:28:30
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="currentTheme" value="${empty theme ? 'light' : theme}" />
<!DOCTYPE html>
<html lang="vi" class="${currentTheme == 'dark' ? 'dark' : ''}">

<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Kết quả Định hướng Nghề nghiệp</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300..700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;700&amp;display=swap" rel="stylesheet" />
    
    <style>
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes slideIn {
            from { opacity: 0; transform: translateX(-20px); }
            to { opacity: 1; transform: translateX(0); }
        }
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
        
        .animate-fade-in {
            animation: fadeIn 0.6s ease-out;
        }
        
        .animate-slide-in {
            animation: slideIn 0.4s ease-out;
        }
        
        .animate-pulse-slow {
            animation: pulse 2s infinite;
        }
        
        .tech-gradient {
            background: linear-gradient(135deg, #2575fc 0%, #6a11cb 100%);
        }
        
        .business-gradient {
            background: linear-gradient(135deg, #00b09b 0%, #96c93d 100%);
        }
        
        .creative-gradient {
            background: linear-gradient(135deg, #ff5e62 0%, #ff9966 100%);
        }
        
        .science-gradient {
            background: linear-gradient(135deg, #8e44ad 0%, #9b59b6 100%);
        }
        
        .education-gradient {
            background: linear-gradient(135deg, #f39c12 0%, #f1c40f 100%);
        }
        
        .social-gradient {
            background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%);
        }
        
        .career-gradient {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        
        .category-indicator {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            margin-right: 8px;
        }
        
        .tech-indicator { background: #2575fc; }
        .business-indicator { background: #00b09b; }
        .creative-indicator { background: #ff5e62; }
        .science-indicator { background: #8e44ad; }
        .education-indicator { background: #f39c12; }
        .social-indicator { background: #27ae60; }
    </style>
    
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        primary: "#4F46E5",
                        "background-light": "#F8FAFC",
                        "background-dark": "#0F172A",
                        "surface-light": "#FFFFFF",
                        "surface-dark": "#293548",
                        "text-light": "#1E293B",
                        "text-dark": "#E2E8F0",
                        "border-light": "#E5E7EB",
                        "border-dark": "#475569",
                        "tech-light": "#2575fc",
                        "tech-dark": "#6a11cb",
                        "business-light": "#00b09b",
                        "business-dark": "#96c93d",
                        "creative-light": "#ff5e62",
                        "creative-dark": "#ff9966",
                        "science-light": "#8e44ad",
                        "science-dark": "#9b59b6",
                        "education-light": "#f39c12",
                        "education-dark": "#f1c40f",
                        "social-light": "#27ae60",
                        "social-dark": "#2ecc71",
                    },
                    fontFamily: {
                        display: ["Be Vietnam Pro", "Quicksand", "sans-serif"],
                    },
                    borderRadius: {
                        DEFAULT: "0.75rem",
                        "2xl": "1rem",
                        "3xl": "1.5rem",
                    },
                },
            },
        };
    </script>
    <link rel="stylesheet" href="/resources/css/sidebar.css">
    <link rel="stylesheet" href="/resources/css/setting.css">
</head>

<body class="font-display bg-background-light dark:bg-background-dark text-text-color dark:text-slate-200">
    <div class="flex min-h-screen">
        <!-- Sidebar -->
        <aside 
            id="sidebar"
            class="bg-white dark:bg-slate-900 flex flex-col py-6 space-y-8 border-r border-slate-200 dark:border-slate-800 
            h-screen fixed top-0 left-0 transition-all duration-500 z-40 cursor-pointer"
            >
            <div class="w-14 h-14 bg-primary rounded-full flex items-center justify-center shrink-0 mx-auto">
                <span class="material-icons-outlined text-white text-3xl">face</span>
            </div>

            <nav class="flex flex-col space-y-2 flex-grow w-full">
                <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300"
                   href="/dashboard">
                    <span class="material-icons-outlined text-3xl shrink-0">dashboard</span>
                    <span class="ml-4 whitespace-nowrap sidebar-text">Bảng điều khiển</span>
                </a>

                <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300"
                   href="${pageContext.request.contextPath}/schedule">
                    <span class="material-icons-outlined text-3xl shrink-0">event</span>
                    <span class="ml-4 whitespace-nowrap sidebar-text">Lịch của tôi</span>
                </a>

                <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300"
                   href="${pageContext.request.contextPath}/tasks">
                    <span class="material-icons-outlined text-3xl shrink-0">add_task</span>
                    <span class="ml-4 whitespace-nowrap sidebar-text">Nhiệm vụ</span>
                </a>

                <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300" 
                   href="${pageContext.request.contextPath}/smart-schedule">
                    <span class="material-icons-outlined text-3xl shrink-0">auto_awesome</span>
                    <span class="ml-4 whitespace-nowrap sidebar-text">Tạo lịch AI</span>
                </a>

                <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300"
                   href="${pageContext.request.contextPath}/statistics">
                    <span class="material-icons-outlined text-3xl shrink-0">interests</span>
                    <span class="ml-4 whitespace-nowrap sidebar-text">Thống kê</span>
                </a>

                <%-- Active state for Quiz --%>
                <a class="nav-link w-full rounded-lg transition-colors bg-primary shadow-md shadow-primary/30 text-white"
                   href="${pageContext.request.contextPath}/QuizResultController">
                    <span class="material-icons-outlined text-3xl shrink-0">psychology</span>
                    <span class="ml-4 whitespace-nowrap sidebar-text">Khám phá bản thân</span>
                </a>

                <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300"
                   href="${pageContext.request.contextPath}/profile-settings">
                    <span class="material-icons-outlined text-3xl shrink-0">manage_accounts</span>
                    <span class="ml-4 whitespace-nowrap sidebar-text">Thiết lập hồ sơ</span>
                </a>
            </nav>
        </aside>

        <main id="mainContent" class="flex-1 flex flex-col p-6 lg:p-8 ml-20 overflow-y-auto">
            <!-- Header -->
            <header class="flex justify-between items-center mb-8">
                <div>
                    <h1 class="text-3xl font-bold text-slate-900 dark:text-white flex items-center">
                        <span class="material-symbols-outlined mr-3 text-pink-500 dark:text-pink-400">work</span>
                        Kết quả Định hướng Nghề nghiệp
                    </h1>
                    <p class="text-slate-500 dark:text-slate-400 mt-2">Khám phá nghề nghiệp phù hợp với tính cách của bạn</p>
                </div>
                <div class="flex items-center space-x-4">
                    <button class="p-2 rounded-full hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors" aria-label="Settings" onclick="loadSettingsAndOpen()">
                        <span class="material-icons-outlined text-slate-600 dark:text-slate-300">settings</span>
                    </button>
                    <a href="/logout" class="p-2 rounded-full hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors" aria-label="Logout">
                        <span class="material-icons-outlined text-slate-600 dark:text-slate-300">logout</span>
                    </a>
                </div>
            </header>

            <c:choose>
                <c:when test="${not empty careerResult}">
                    <!-- Main Result Card -->
                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-xl p-8 mb-8 animate-fade-in">
                        <div class="text-center mb-8">
                            <div class="text-6xl mb-4 animate-pulse-slow">🎉</div>
                            <div class="inline-block px-4 py-2 career-gradient text-white font-semibold rounded-full mb-4">
                                Hoàn thành <fmt:formatDate value="${careerResult.completedAt}" pattern="dd/MM/yyyy HH:mm" />
                            </div>
                                <h2 class="text-2xl font-bold text-slate-900 dark:text-white mb-4">
                                    Chúc mừng bạn đã hoàn thành bài đánh giá nghề nghiệp!
                                </h2>
                                <p class="text-lg text-slate-600 dark:text-slate-300 max-w-3xl mx-auto">
                                    Dựa trên phân tích sở thích và năng lực của bạn, đây là những lĩnh vực nghề nghiệp phù hợp nhất.
                                    Kết quả này sẽ giúp bạn có cái nhìn rõ ràng hơn về con đường sự nghiệp tương lai.
                                </p>
                        </div>
                    </div>

                    <!-- Top Category Highlight -->
                    <c:set var="topCategoryName" value="${careerResult.topCategory}" />
                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-8 mb-8 career-gradient text-white">
                        <div class="flex flex-col md:flex-row items-center gap-6">
                            <div class="text-5xl">
                                <c:choose>
                                    <c:when test="${topCategoryName == 'TECHNOLOGY'}">
                                        &#x1f4bb; <!-- 💻 -->
                                    </c:when>
                                    <c:when test="${topCategoryName == 'BUSINESS'}">
                                        &#x1f4ca; <!-- 📊 -->
                                    </c:when>
                                    <c:when test="${topCategoryName == 'CREATIVE'}">
                                        &#x1f3a8; <!-- 🎨 -->
                                    </c:when>
                                    <c:when test="${topCategoryName == 'SCIENCE'}">
                                        &#x1f52c; <!-- 🔬 -->
                                    </c:when>
                                    <c:when test="${topCategoryName == 'EDUCATION'}">
                                        &#x1f4da; <!-- 📚 -->
                                    </c:when>
                                    <c:when test="${topCategoryName == 'SOCIAL'}">
                                        &#x1f91d; <!-- 🤝 -->
                                    </c:when>
                                    <c:otherwise>
                                        &#x2b50; <!-- ⭐ -->
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="flex-1">
                                <h3 class="text-xl font-bold mb-2">Lĩnh vực nổi bật nhất của bạn</h3>
                                <h2 class="text-3xl font-bold mb-4">
                                    <c:choose>
                                        <c:when test="${topCategoryName == 'TECHNOLOGY'}">Nhóm Công nghệ</c:when>
                                        <c:when test="${topCategoryName == 'BUSINESS'}">Nhóm Kinh doanh</c:when>
                                        <c:when test="${topCategoryName == 'CREATIVE'}">Nhóm Sáng tạo</c:when>
                                        <c:when test="${topCategoryName == 'SCIENCE'}">Nhóm Khoa học</c:when>
                                        <c:when test="${topCategoryName == 'EDUCATION'}">Nhóm Giáo dục</c:when>
                                        <c:when test="${topCategoryName == 'SOCIAL'}">Nhóm Xã hội</c:when>
                                        <c:otherwise>Đa dạng lĩnh vực</c:otherwise>
                                    </c:choose>
                                </h2>
                                <p class="text-blue-100">
                                    <c:choose>
                                        <c:when test="${topCategoryName == 'TECHNOLOGY'}">
                                            Bạn có xu hướng phù hợp với các công việc liên quan đến công nghệ, 
                                            phân tích và giải quyết vấn đề. Đây là lĩnh vực đang phát triển mạnh với nhiều cơ hội nghề nghiệp.
                                        </c:when>
                                        <c:when test="${topCategoryName == 'BUSINESS'}">
                                            Bạn có tố chất trong lĩnh vực kinh doanh, quản lý và chiến lược. 
                                            Khả năng lãnh đạo và tư duy kinh doanh sẽ giúp bạn thành công trong môi trường doanh nghiệp.
                                        </c:when>
                                        <c:when test="${topCategoryName == 'CREATIVE'}">
                                            Bạn có khả năng sáng tạo và nghệ thuật độc đáo. 
                                            Trí tưởng tượng phong phú và khả năng thể hiện ý tưởng sẽ giúp bạn tỏa sáng trong lĩnh vực sáng tạo.
                                        </c:when>
                                        <c:when test="${topCategoryName == 'SCIENCE'}">
                                            Bạn có tư duy phân tích và niềm đam mê khám phá. 
                                            Khả năng nghiên cứu và giải quyết các vấn đề khoa học sẽ giúp bạn thành công trong lĩnh vực này.
                                        </c:when>
                                        <c:otherwise>
                                            Bạn có khả năng đa dạng và linh hoạt trong nhiều lĩnh vực khác nhau.
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Score Breakdown Grid -->
                    <div class="mb-8">
                        <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-6 flex items-center">
                            <span class="material-symbols-outlined mr-3 text-blue-500 dark:text-blue-400">analytics</span>
                            Điểm số chi tiết theo lĩnh vực
                        </h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                            <!-- Technology -->
                            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border-l-4 border-tech-light animate-slide-in">
                                <div class="flex items-center justify-between mb-4">
                                    <div class="flex items-center">
                                        <span class="text-2xl mr-3">💻</span>
                                        <h4 class="font-bold text-lg">Công nghệ</h4>
                                    </div>
                                    <span class="text-2xl font-bold text-tech-light" id="tech-score">${careerResult.technologyScore}</span>
                                </div>
                                <p class="text-slate-600 dark:text-slate-300 text-sm mb-4">
                                    Lập trình, AI, Data Science, Cybersecurity, Kỹ thuật phần mềm
                                </p>
                                <div class="h-2 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                                    <div class="h-full tech-gradient rounded-full" id="tech-bar"></div>
                                </div>
                            </div>

                            <!-- Business -->
                            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border-l-4 border-business-light animate-slide-in" style="animation-delay: 0.1s">
                                <div class="flex items-center justify-between mb-4">
                                    <div class="flex items-center">
                                        <span class="text-2xl mr-3">📊</span>
                                        <h4 class="font-bold text-lg">Kinh doanh</h4>
                                    </div>
                                    <span class="text-2xl font-bold text-business-light" id="business-score">${careerResult.businessScore}</span>
                                </div>
                                <p class="text-slate-600 dark:text-slate-300 text-sm mb-4">
                                    Marketing, Tài chính, Quản lý, Khởi nghiệp, Kinh doanh quốc tế
                                </p>
                                <div class="h-2 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                                    <div class="h-full business-gradient rounded-full" id="business-bar"></div>
                                </div>
                            </div>

                            <!-- Creative -->
                            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border-l-4 border-creative-light animate-slide-in" style="animation-delay: 0.2s">
                                <div class="flex items-center justify-between mb-4">
                                    <div class="flex items-center">
                                        <span class="text-2xl mr-3">🎨</span>
                                        <h4 class="font-bold text-lg">Sáng tạo</h4>
                                    </div>
                                    <span class="text-2xl font-bold text-creative-light" id="creative-score">${careerResult.creativeScore}</span>
                                </div>
                                <p class="text-slate-600 dark:text-slate-300 text-sm mb-4">
                                    Thiết kế, Nghệ thuật, Nội dung, Kiến trúc, Sản xuất phim
                                </p>
                                <div class="h-2 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                                    <div class="h-full creative-gradient rounded-full" id="creative-bar"></div>
                                </div>
                            </div>

                            <!-- Science -->
                            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border-l-4 border-science-light animate-slide-in" style="animation-delay: 0.3s">
                                <div class="flex items-center justify-between mb-4">
                                    <div class="flex items-center">
                                        <span class="text-2xl mr-3">🔬</span>
                                        <h4 class="font-bold text-lg">Khoa học</h4>
                                    </div>
                                    <span class="text-2xl font-bold text-science-light" id="science-score">${careerResult.scienceScore}</span>
                                </div>
                                <p class="text-slate-600 dark:text-slate-300 text-sm mb-4">
                                    Nghiên cứu, Y tế, Môi trường, Kỹ thuật, Dược phẩm
                                </p>
                                <div class="h-2 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                                    <div class="h-full science-gradient rounded-full" id="science-bar"></div>
                                </div>
                            </div>

                            <!-- Education -->
                            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border-l-4 border-education-light animate-slide-in" style="animation-delay: 0.4s">
                                <div class="flex items-center justify-between mb-4">
                                    <div class="flex items-center">
                                        <span class="text-2xl mr-3">📚</span>
                                        <h4 class="font-bold text-lg">Giáo dục</h4>
                                    </div>
                                    <span class="text-2xl font-bold text-education-light" id="education-score">${careerResult.educationScore}</span>
                                </div>
                                <p class="text-slate-600 dark:text-slate-300 text-sm mb-4">
                                    Giảng dạy, Đào tạo, Tư vấn, Nghiên cứu giáo dục
                                </p>
                                <div class="h-2 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                                    <div class="h-full education-gradient rounded-full" id="education-bar"></div>
                                </div>
                            </div>

                            <!-- Social -->
                            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border-l-4 border-social-light animate-slide-in" style="animation-delay: 0.5s">
                                <div class="flex items-center justify-between mb-4">
                                    <div class="flex items-center">
                                        <span class="text-2xl mr-3">🤝</span>
                                        <h4 class="font-bold text-lg">Xã hội</h4>
                                    </div>
                                    <span class="text-2xl font-bold text-social-light" id="social-score">${careerResult.socialScore}</span>
                                </div>
                                <p class="text-slate-600 dark:text-slate-300 text-sm mb-4">
                                    Tâm lý, Công tác XH, Nhân sự, PR, Quan hệ công chúng
                                </p>
                                <div class="h-2 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                                    <div class="h-full social-gradient rounded-full" id="social-bar"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Career Recommendations -->
                    <c:if test="${not empty careerRecommendations}">
                        <div class="mb-8">
                            <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-6 flex items-center">
                                <span class="material-symbols-outlined mr-3 text-green-500 dark:text-green-400">recommend</span>
                                Gợi ý nghề nghiệp phù hợp
                            </h3>
                            <div class="space-y-6">
                                <c:forEach var="category" items="${careerRecommendations}" varStatus="status">
                                    <c:set var="categoryName" value="${category.categoryName}" />
                                    <c:set var="categoryKey" value="${fn:toLowerCase(categoryName)}" />

                                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border-l-4 border-${categoryKey}-light">
                                        <div class="flex items-center justify-between mb-6">
                                            <div class="flex items-center">
                                                <span class="text-2xl mr-3">
                                                    <c:choose>
                                                        <c:when test="${categoryName == 'TECHNOLOGY'}">
                                                            &#x1f4bb; <!-- 💻 -->
                                                        </c:when>
                                                        <c:when test="${categoryName == 'BUSINESS'}">
                                                            &#x1f4ca; <!-- 📊 -->
                                                        </c:when>
                                                        <c:when test="${categoryName == 'CREATIVE'}">
                                                            &#x1f3a8; <!-- 🎨 -->
                                                        </c:when>
                                                        <c:when test="${categoryName == 'SCIENCE'}">
                                                            &#x1f52c; <!-- 🔬 -->
                                                        </c:when>
                                                        <c:when test="${categoryName == 'EDUCATION'}">
                                                            &#x1f4da; <!-- 📚 -->
                                                        </c:when>
                                                        <c:when test="${categoryName == 'SOCIAL'}">
                                                            &#x1f91d; <!-- 🤝 -->
                                                        </c:when>
                                                        <c:otherwise>
                                                            &#x2b50; <!-- ⭐ -->
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                                <div>
                                                    <h4 class="font-bold text-lg">
                                                        <c:choose>
                                                            <c:when test="${categoryName == 'TECHNOLOGY'}">Công nghệ</c:when>
                                                            <c:when test="${categoryName == 'BUSINESS'}">Kinh doanh</c:when>
                                                            <c:when test="${categoryName == 'CREATIVE'}">Sáng tạo</c:when>
                                                            <c:when test="${categoryName == 'SCIENCE'}">Khoa học</c:when>
                                                            <c:when test="${categoryName == 'EDUCATION'}">Giáo dục</c:when>
                                                            <c:when test="${categoryName == 'SOCIAL'}">Xã hội</c:when>
                                                            <c:otherwise>${categoryName}</c:otherwise>
                                                        </c:choose>
                                                    </h4>
                                                    <p class="text-sm text-slate-500 dark:text-slate-400">
                                                        <c:choose>
                                                            <c:when test="${categoryName == 'TECHNOLOGY'}">Phù hợp với kỹ năng công nghệ và tư duy logic</c:when>
                                                            <c:when test="${categoryName == 'BUSINESS'}">Phù hợp với tư duy kinh doanh và quản lý</c:when>
                                                            <c:when test="${categoryName == 'CREATIVE'}">Phù hợp với khả năng sáng tạo và nghệ thuật</c:when>
                                                            <c:when test="${categoryName == 'SCIENCE'}">Phù hợp với tư duy phân tích và nghiên cứu</c:when>
                                                            <c:when test="${categoryName == 'EDUCATION'}">Phù hợp với kỹ năng giảng dạy và truyền đạt</c:when>
                                                            <c:when test="${categoryName == 'SOCIAL'}">Phù hợp với kỹ năng giao tiếp và thấu hiểu</c:when>
                                                            <c:otherwise>Phù hợp với năng lực và sở thích của bạn</c:otherwise>
                                                        </c:choose>
                                                    </p>
                                                </div>
                                            </div>
                                            <span class="px-4 py-2 bg-${categoryKey}-light/10 text-${categoryKey}-light font-semibold rounded-full">
                                                Điểm: ${category.score}
                                            </span>
                                        </div>
                                        
                                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                                            <c:forEach var="career" items="${category.careers}">
                                                <div class="bg-slate-50 dark:bg-slate-700 hover:bg-slate-100 dark:hover:bg-slate-600 rounded-xl p-4 transition-colors">
                                                    <h5 class="font-semibold text-slate-900 dark:text-white mb-2">${career}</h5>
                                                    <p class="text-sm text-slate-600 dark:text-slate-300">
                                                        <c:choose>
                                                            <c:when test="${categoryName == 'TECHNOLOGY'}">Đòi hỏi tư duy logic và kỹ năng công nghệ</c:when>
                                                            <c:when test="${categoryName == 'BUSINESS'}">Đòi hỏi tư duy chiến lược và kỹ năng quản lý</c:when>
                                                            <c:when test="${categoryName == 'CREATIVE'}">Đòi hỏi khả năng sáng tạo và thẩm mỹ</c:when>
                                                            <c:otherwise>Phù hợp với hồ sơ năng lực của bạn</c:otherwise>
                                                        </c:choose>
                                                    </p>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <!-- Action Buttons -->
                    <div class="flex flex-col sm:flex-row justify-between items-center gap-4 mt-8">
                        <div class="flex flex-wrap gap-3">
                            <a href="#" class="flex items-center px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-lg transition-colors"
                               onclick="shareResults()">
                                <span class="material-symbols-outlined mr-2">share</span>
                                Chia sẻ
                            </a>
                            <a href="#" class="flex items-center px-4 py-2 bg-slate-200 dark:bg-slate-700 hover:bg-slate-300 dark:hover:bg-slate-600 text-slate-800 dark:text-slate-200 font-medium rounded-lg transition-colors"
                               onclick="copyResultToClipboard()">
                                <span class="material-symbols-outlined mr-2">content_copy</span>
                                Sao chép kết quả
                            </a>
                        </div>
                        
                        <div class="flex flex-wrap gap-3">
                            <a href="${pageContext.request.contextPath}/dashboard" 
                               class="flex items-center px-6 py-3 bg-slate-200 dark:bg-slate-700 hover:bg-slate-300 dark:hover:bg-slate-600 text-slate-800 dark:text-slate-200 font-semibold rounded-xl transition-colors">
                                <span class="material-symbols-outlined mr-2">arrow_back</span>
                                Quay lại Dashboard
                            </a>
                            <a href="${pageContext.request.contextPath}/quiz/career" 
                               class="flex items-center px-6 py-3 bg-red-500 hover:bg-red-600 text-white font-semibold rounded-xl transition-colors">
                                <span class="material-symbols-outlined mr-2">refresh</span>
                                Làm lại quiz
                            </a>
                            <a href="${pageContext.request.contextPath}/resources" 
                               class="flex items-center px-6 py-3 career-gradient hover:opacity-90 text-white font-semibold rounded-xl transition-opacity">
                                Xem tài nguyên học tập
                                <span class="material-symbols-outlined ml-2">arrow_forward</span>
                            </a>
                        </div>
                    </div>

                </c:when>
                <c:otherwise>
                    <!-- Loading/Error State -->
                    <div class="flex flex-col items-center justify-center min-h-[400px]">
                        <div class="w-16 h-16 border-4 border-primary border-t-transparent rounded-full animate-spin mb-6"></div>
                        <h2 class="text-xl font-bold text-slate-900 dark:text-white mb-3">Đang tải kết quả...</h2>
                        <p class="text-slate-600 dark:text-slate-400 mb-8">Vui lòng chờ trong giây lát hoặc quay lại làm quiz.</p>
                        <div class="flex gap-4">
                            <a href="${pageContext.request.contextPath}/quiz/career" 
                               class="flex items-center px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white font-semibold rounded-xl transition-colors">
                                <span class="material-symbols-outlined mr-2">refresh</span>
                                Quay lại làm quiz
                            </a>
                            <a href="${pageContext.request.contextPath}/dashboard" 
                               class="flex items-center px-6 py-3 bg-slate-200 dark:bg-slate-700 hover:bg-slate-300 dark:hover:bg-slate-600 text-slate-800 dark:text-slate-200 font-semibold rounded-xl transition-colors">
                                <span class="material-symbols-outlined mr-2">home</span>
                                Về trang chủ
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- Share Section -->
            <div class="mt-8 p-6 career-gradient rounded-2xl text-white">
                <div class="flex flex-col md:flex-row items-center justify-between">
                    <div class="mb-4 md:mb-0">
                        <h4 class="text-lg font-semibold mb-2">🚀 Bắt đầu hành trình nghề nghiệp của bạn</h4>
                        <p class="text-pink-100">Tìm hiểu thêm về các nghề nghiệp và phát triển kỹ năng cần thiết</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/QuizResultController"
                       class="flex items-center px-6 py-3 bg-white text-pink-600 font-semibold rounded-xl hover:bg-pink-50 transition-colors">
                        Khám phá thêm quiz
                        <span class="material-symbols-outlined ml-2">chevron_right</span>
                    </a>
                </div>
            </div>
        </main>
    </div>

    <%-- Settings Overlay --%>
    <%@ include file="../settings-overlay.jsp" %>

    <script src="/resources/js/sidebar.js"></script>
    <script src="/resources/js/setting.js"></script>
    
    <script>
        // Animate scores and progress bars on page load
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(() => {
                // Define all scores
                const scores = {
                    tech: ${careerResult.technologyScore},
                    business: ${careerResult.businessScore},
                    creative: ${careerResult.creativeScore},
                    science: ${careerResult.scienceScore},
                    education: ${careerResult.educationScore},
                    social: ${careerResult.socialScore}
                };
                
                // Find max score for percentage calculation
                const maxScore = Math.max(...Object.values(scores));
                
                // Animate each score and progress bar
                Object.keys(scores).forEach(category => {
                    const scoreElement = document.getElementById(`${category}-score`);
                    const barElement = document.getElementById(`${category}-bar`);
                    const score = scores[category];
                    
                    if (scoreElement) {
                        animateValue(`${category}-score`, 0, score, 1000);
                    }
                    
                    if (barElement) {
                        const percentage = (score / 100) * 100; // Assuming max score is 100
                        setTimeout(() => {
                            barElement.style.width = '0%';
                            barElement.style.transition = 'width 1s ease-out';
                            setTimeout(() => {
                                barElement.style.width = percentage + '%';
                            }, 100);
                        }, 300);
                    }
                });
                
                // Create confetti effect
                createConfetti();
            }, 500);
        });
        
        function animateValue(elementId, start, end, duration) {
            const element = document.getElementById(elementId);
            if (!element) return;
            
            let startTimestamp = null;
            const step = (timestamp) => {
                if (!startTimestamp) startTimestamp = timestamp;
                const progress = Math.min((timestamp - startTimestamp) / duration, 1);
                const value = Math.floor(progress * (end - start) + start);
                element.textContent = value;
                
                if (progress < 1) {
                    window.requestAnimationFrame(step);
                }
            };
            window.requestAnimationFrame(step);
        }
        
        function createConfetti() {
            const colors = ['#f093fb', '#f5576c', '#2575fc', '#00b09b', '#ff5e62', '#8e44ad'];
            const confettiCount = 80;
            
            for (let i = 0; i < confettiCount; i++) {
                const confetti = document.createElement('div');
                confetti.className = 'fixed w-2 h-2 rounded-full z-50';
                confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                confetti.style.left = Math.random() * 100 + 'vw';
                confetti.style.top = '-10px';
                confetti.style.opacity = '0.8';
                
                document.body.appendChild(confetti);
                
                // Animation
                const animation = confetti.animate([
                    { transform: 'translateY(0) rotate(0deg)', opacity: 0.8 },
                    { transform: `translateY(${window.innerHeight + 10}px) rotate(${360 + Math.random() * 360}deg)`, opacity: 0 }
                ], {
                    duration: 2000 + Math.random() * 3000,
                    easing: 'cubic-bezier(0.215, 0.61, 0.355, 1)'
                });
                
                animation.onfinish = () => confetti.remove();
            }
        }
        
        function shareResults() {
            const topCategory = '${careerResult.topCategory}';
            const shareText = `Tôi vừa khám phá định hướng nghề nghiệp của mình với nhóm ${topCategory} nổi bật nhất! 🚀 Khám phá ngay bạn nhé!`;
            
            if (navigator.share) {
                navigator.share({
                    title: 'Kết quả Định hướng Nghề nghiệp',
                    text: shareText,
                    url: window.location.href
                });
            } else {
                navigator.clipboard.writeText(shareText + '\n' + window.location.href)
                    .then(() => alert('Đã sao chép kết quả vào clipboard!'))
                    .catch(err => alert('Không thể chia sẻ: ' + err));
            }
        }
        
        function copyResultToClipboard() {
            const topCategory = '${careerResult.topCategory}';
            const techScore = ${careerResult.technologyScore};
            const businessScore = ${careerResult.businessScore};
            const creativeScore = ${careerResult.creativeScore};
            
            const resultText = `🚀 Kết quả Định hướng Nghề nghiệp\nLĩnh vực nổi bật: ${topCategory}\n\nĐiểm số chi tiết:\n• Công nghệ: ${techScore}\n• Kinh doanh: ${businessScore}\n• Sáng tạo: ${creativeScore}\n\nKhám phá nghề nghiệp phù hợp với bạn tại: ${window.location.origin}`;
            
            navigator.clipboard.writeText(resultText)
                .then(() => alert('Đã sao chép kết quả vào clipboard!'))
                .catch(err => {
                    console.error('Failed to copy: ', err);
                    alert('Không thể sao chép, vui lòng thử lại.');
                });
        }
    </script>
</body>
</html>