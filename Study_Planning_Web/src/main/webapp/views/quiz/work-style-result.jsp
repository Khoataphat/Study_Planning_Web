<%-- 
    Document   : work-style-result
    Created on : 22 thg 12, 2025, 12:04:48
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="currentTheme" value="${empty theme ? 'light' : theme}" />
<!DOCTYPE html>
<html lang="vi" class="${currentTheme == 'dark' ? 'dark' : ''}">

<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Kết quả Phong cách Làm việc - ${workStyleResult.primaryStyle}</title>
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
        
        .work-gradient {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .leader-gradient {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .supporter-gradient {
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
        }
        
        .analyzer-gradient {
            background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%);
        }
        
        .innovator-gradient {
            background: linear-gradient(135deg, #d69e2e 0%, #b7791f 100%);
        }
        
        .balanced-gradient {
            background: linear-gradient(135deg, #805ad5 0%, #6b46c1 100%);
        }
        
        .communication-gradient {
            background: linear-gradient(135deg, #e53e3e 0%, #c53030 100%);
        }
        
        .teamwork-gradient {
            background: linear-gradient(135deg, #805ad5 0%, #6b46c1 100%);
        }
        
        .creativity-gradient {
            background: linear-gradient(135deg, #d69e2e 0%, #b7791f 100%);
        }
        
        .work-style-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
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
                        "leader-light": "#667eea",
                        "leader-dark": "#764ba2",
                        "supporter-light": "#48bb78",
                        "supporter-dark": "#38a169",
                        "analyzer-light": "#ed8936",
                        "analyzer-dark": "#dd6b20",
                        "innovator-light": "#d69e2e",
                        "innovator-dark": "#b7791f",
                        "communication-light": "#e53e3e",
                        "communication-dark": "#c53030",
                        "teamwork-light": "#805ad5",
                        "teamwork-dark": "#6b46c1",
                        "creativity-light": "#d69e2e",
                        "creativity-dark": "#b7791f",
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
            </nav>
        </aside>

        <main id="mainContent" class="flex-1 flex flex-col p-6 lg:p-8 ml-20 overflow-y-auto">
            <!-- Header -->
            <header class="flex justify-between items-center mb-8">
                <div>
                    <h1 class="text-3xl font-bold text-slate-900 dark:text-white flex items-center">
                        <span class="material-symbols-outlined mr-3 text-purple-500 dark:text-purple-400">work</span>
                        Kết quả Phong cách Làm việc
                    </h1>
                    <p class="text-slate-500 dark:text-slate-400 mt-2">Khám phá cách bạn làm việc hiệu quả nhất</p>
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
                <c:when test="${not empty workStyleResult}">
                    <!-- Main Result Card -->
                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-xl p-8 mb-8 animate-fade-in">
                        <div class="text-center mb-8">
                            <div class="text-6xl mb-4 animate-pulse-slow">
                                <c:choose>
                                    <c:when test="${workStyleResult.primaryStyle == 'LEADER'}">&#x1f451;</c:when>
                                    <c:when test="${workStyleResult.primaryStyle == 'SUPPORTER'}">&#x1f91d;</c:when>
                                    <c:when test="${workStyleResult.primaryStyle == 'ANALYZER'}">&#x1f50e;</c:when>
                                    <c:when test="${workStyleResult.primaryStyle == 'INNOVATOR'}">&#x1f4a1;</c:when>
                                    <c:otherwise>&#x2696;</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="inline-block px-4 py-2 work-gradient text-white font-semibold rounded-full mb-4">
                                Hoàn thành <fmt:formatDate value="${workStyleResult.completedAt}" pattern="dd/MM/yyyy HH:mm" />
                            </div>
                            <h2 class="text-2xl font-bold text-slate-900 dark:text-white mb-4">
                                <c:choose>
                                    <c:when test="${workStyleResult.primaryStyle == 'LEADER'}">Người Lãnh đạo</c:when>
                                    <c:when test="${workStyleResult.primaryStyle == 'SUPPORTER'}">Người Hỗ trợ</c:when>
                                    <c:when test="${workStyleResult.primaryStyle == 'ANALYZER'}">Nhà Phân tích</c:when>
                                    <c:when test="${workStyleResult.primaryStyle == 'INNOVATOR'}">Người Sáng tạo</c:when>
                                    <c:otherwise>Phong cách Cân bằng</c:otherwise>
                                </c:choose>
                            </h2>
                            <div class="text-4xl font-black work-style-badge mb-3">${workStyleResult.primaryStyle}</div>
                            <p class="text-lg text-slate-600 dark:text-slate-300 max-w-3xl mx-auto">
                                <c:choose>
                                    <c:when test="${workStyleResult.primaryStyle == 'LEADER'}">
                                        Bạn có khả năng dẫn dắt, định hướng và truyền cảm hứng cho nhóm. 
                                        Phong cách này giúp bạn tỏa sáng trong vai trò quản lý và lãnh đạo.
                                    </c:when>
                                    <c:when test="${workStyleResult.primaryStyle == 'SUPPORTER'}">
                                        Bạn là người hỗ trợ đắc lực, luôn sẵn sàng giúp đỡ đồng nghiệp. 
                                        Sự đồng cảm và kiên nhẫn là điểm mạnh của bạn.
                                    </c:when>
                                    <c:when test="${workStyleResult.primaryStyle == 'ANALYZER'}">
                                        Bạn có tư duy logic và khả năng phân tích sâu sắc. 
                                        Phong cách này giúp bạn giải quyết vấn đề một cách hệ thống và chính xác.
                                    </c:when>
                                    <c:when test="${workStyleResult.primaryStyle == 'INNOVATOR'}">
                                        Bạn có tư duy sáng tạo và luôn tìm kiếm giải pháp mới. 
                                        Sự đổi mới và thích nghi là thế mạnh của bạn.
                                    </c:when>
                                    <c:otherwise>
                                        Bạn có sự cân bằng giữa các phong cách làm việc, 
                                        giúp bạn linh hoạt trong nhiều tình huống khác nhau.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>

                    <!-- Key Features Grid -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                        <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border-t-4 border-purple-500 animate-slide-in">
                            <div class="text-3xl mb-4">⭐</div>
                            <h3 class="font-bold text-lg text-slate-900 dark:text-white mb-3">Điểm mạnh</h3>
                            <p class="text-slate-600 dark:text-slate-300">
                                <c:choose>
                                    <c:when test="${workStyleResult.primaryStyle == 'LEADER'}">
                                        Quyết đoán, tầm nhìn, truyền cảm hứng, khả năng ra quyết định
                                    </c:when>
                                    <c:when test="${workStyleResult.primaryStyle == 'SUPPORTER'}">
                                        Đồng cảm, kiên nhẫn, hợp tác, lắng nghe tích cực
                                    </c:when>
                                    <c:when test="${workStyleResult.primaryStyle == 'ANALYZER'}">
                                        Logic, chi tiết, tập trung, tư duy hệ thống
                                    </c:when>
                                    <c:when test="${workStyleResult.primaryStyle == 'INNOVATOR'}">
                                        Sáng tạo, linh hoạt, tưởng tượng, thích nghi nhanh
                                    </c:when>
                                    <c:otherwise>
                                        Linh hoạt, thích nghi, toàn diện, đa kỹ năng
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border-t-4 border-green-500 animate-slide-in" style="animation-delay: 0.1s">
                            <div class="text-3xl mb-4">🎯</div>
                            <h3 class="font-bold text-lg text-slate-900 dark:text-white mb-3">Phù hợp với</h3>
                            <p class="text-slate-600 dark:text-slate-300">
                                <c:choose>
                                    <c:when test="${workStyleResult.primaryStyle == 'LEADER'}">
                                        Vai trò quản lý, lãnh đạo dự án, định hướng chiến lược
                                    </c:when>
                                    <c:when test="${workStyleResult.primaryStyle == 'SUPPORTER'}">
                                        Công việc hỗ trợ, tư vấn, chăm sóc, phát triển nhân sự
                                    </c:when>
                                    <c:when test="${workStyleResult.primaryStyle == 'ANALYZER'}">
                                        Phân tích dữ liệu, nghiên cứu, kiểm toán, quản lý rủi ro
                                    </c:when>
                                    <c:when test="${workStyleResult.primaryStyle == 'INNOVATOR'}">
                                        Sáng tạo, thiết kế, phát triển sản phẩm mới, R&D
                                    </c:when>
                                    <c:otherwise>
                                        Đa dạng lĩnh vực và vai trò, quản lý đa nhiệm
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border-t-4 border-orange-500 animate-slide-in" style="animation-delay: 0.2s">
                            <div class="text-3xl mb-4">📈</div>
                            <h3 class="font-bold text-lg text-slate-900 dark:text-white mb-3">Phát triển</h3>
                            <p class="text-slate-600 dark:text-slate-300">
                                <c:choose>
                                    <c:when test="${workStyleResult.primaryStyle == 'LEADER'}">
                                        Kỹ năng giao tiếp, quản lý xung đột, coaching, chiến lược
                                    </c:when>
                                    <c:when test="${workStyleResult.primaryStyle == 'SUPPORTER'}">
                                        Đặt giới hạn, quản lý thời gian, ra quyết định, tư duy phản biện
                                    </c:when>
                                    <c:when test="${workStyleResult.primaryStyle == 'ANALYZER'}">
                                        Tư duy sáng tạo, làm việc nhóm, thuyết trình, lãnh đạo
                                    </c:when>
                                    <c:when test="${workStyleResult.primaryStyle == 'INNOVATOR'}">
                                        Kỹ năng tổ chức, quản lý dự án, phân tích, thực thi
                                    </c:when>
                                    <c:otherwise>
                                        Chuyên sâu kỹ năng, phát triển chuyên môn, lãnh đạo
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>

                    <!-- Score Breakdown -->
                    <div class="mb-8">
                        <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-6 flex items-center">
                            <span class="material-symbols-outlined mr-3 text-blue-500 dark:text-blue-400">analytics</span>
                            Điểm số chi tiết các kỹ năng làm việc
                        </h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                            <!-- Leadership -->
                            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border-l-4 border-leader-light animate-slide-in">
                                <div class="flex items-center justify-between mb-4">
                                    <div class="flex items-center">
                                        <span class="text-2xl mr-3">&#x1f451;</span>
                                        <h4 class="font-bold text-lg">Lãnh đạo</h4>
                                    </div>
                                    <span class="text-2xl font-bold text-leader-light" id="leadership-score">${workStyleResult.leadershipScore}</span>
                                </div>
                                <p class="text-slate-600 dark:text-slate-300 text-sm mb-4">
                                    Khả năng dẫn dắt, ra quyết định và định hướng nhóm
                                </p>
                                <div class="h-2 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                                    <div class="h-full leader-gradient rounded-full" id="leadership-bar"></div>
                                </div>
                            </div>

                            <!-- Support -->
                            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border-l-4 border-supporter-light animate-slide-in" style="animation-delay: 0.1s">
                                <div class="flex items-center justify-between mb-4">
                                    <div class="flex items-center">
                                        <span class="text-2xl mr-3">&#x1f91d;</span>
                                        <h4 class="font-bold text-lg">Hỗ trợ</h4>
                                    </div>
                                    <span class="text-2xl font-bold text-supporter-light" id="support-score">${workStyleResult.supportScore}</span>
                                </div>
                                <p class="text-slate-600 dark:text-slate-300 text-sm mb-4">
                                    Khả năng hỗ trợ, đồng cảm và hợp tác với đồng nghiệp
                                </p>
                                <div class="h-2 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                                    <div class="h-full supporter-gradient rounded-full" id="support-bar"></div>
                                </div>
                            </div>

                            <!-- Analysis -->
                            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border-l-4 border-analyzer-light animate-slide-in" style="animation-delay: 0.2s">
                                <div class="flex items-center justify-between mb-4">
                                    <div class="flex items-center">
                                        <span class="text-2xl mr-3">&#x1f50e;</span>
                                        <h4 class="font-bold text-lg">Phân tích</h4>
                                    </div>
                                    <span class="text-2xl font-bold text-analyzer-light" id="analysis-score">${workStyleResult.analysisScore}</span>
                                </div>
                                <p class="text-slate-600 dark:text-slate-300 text-sm mb-4">
                                    Khả năng phân tích dữ liệu và giải quyết vấn đề logic
                                </p>
                                <div class="h-2 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                                    <div class="h-full analyzer-gradient rounded-full" id="analysis-bar"></div>
                                </div>
                            </div>

                            <!-- Communication -->
                            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border-l-4 border-communication-light animate-slide-in" style="animation-delay: 0.3s">
                                <div class="flex items-center justify-between mb-4">
                                    <div class="flex items-center">
                                        <span class="text-2xl mr-3">&#x1f4ac;</span>
                                        <h4 class="font-bold text-lg">Giao tiếp</h4>
                                    </div>
                                    <span class="text-2xl font-bold text-communication-light" id="communication-score">${workStyleResult.communicationScore}</span>
                                </div>
                                <p class="text-slate-600 dark:text-slate-300 text-sm mb-4">
                                    Khả năng truyền đạt ý tưởng và thông tin hiệu quả
                                </p>
                                <div class="h-2 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                                    <div class="h-full communication-gradient rounded-full" id="communication-bar"></div>
                                </div>
                            </div>

                            <!-- Teamwork -->
                            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border-l-4 border-teamwork-light animate-slide-in" style="animation-delay: 0.4s">
                                <div class="flex items-center justify-between mb-4">
                                    <div class="flex items-center">
                                        <span class="text-2xl mr-3">&#x1f465;</span>
                                        <h4 class="font-bold text-lg">Làm việc nhóm</h4>
                                    </div>
                                    <span class="text-2xl font-bold text-teamwork-light" id="teamwork-score">${workStyleResult.teamworkScore}</span>
                                </div>
                                <p class="text-slate-600 dark:text-slate-300 text-sm mb-4">
                                    Khả năng làm việc hiệu quả trong môi trường nhóm
                                </p>
                                <div class="h-2 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                                    <div class="h-full teamwork-gradient rounded-full" id="teamwork-bar"></div>
                                </div>
                            </div>

                            <!-- Creativity -->
                            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border-l-4 border-creativity-light animate-slide-in" style="animation-delay: 0.5s">
                                <div class="flex items-center justify-between mb-4">
                                    <div class="flex items-center">
                                        <span class="text-2xl mr-3">&#x1f4a1;</span>
                                        <h4 class="font-bold text-lg">Sáng tạo</h4>
                                    </div>
                                    <span class="text-2xl font-bold text-creativity-light" id="creativity-score">${workStyleResult.creativityScore}</span>
                                </div>
                                <p class="text-slate-600 dark:text-slate-300 text-sm mb-4">
                                    Khả năng tư duy sáng tạo và đổi mới trong công việc
                                </p>
                                <div class="h-2 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                                    <div class="h-full creativity-gradient rounded-full" id="creativity-bar"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Career Recommendations -->
                    <div class="mb-8">
                        <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-6 flex items-center">
                            <span class="material-symbols-outlined mr-3 text-green-500 dark:text-green-400">business_center</span>
                            Công việc phù hợp với phong cách của bạn
                        </h3>
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <c:choose>
                                <c:when test="${workStyleResult.primaryStyle == 'LEADER'}">
                                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 hover:shadow-xl transition-shadow">
                                        <div class="text-3xl mb-4">&#x1f454;</div>
                                        <h4 class="font-bold text-lg text-slate-900 dark:text-white mb-3">Quản lý dự án</h4>
                                        <p class="text-slate-600 dark:text-slate-300 text-sm">
                                            Dẫn dắt team và quản lý timeline dự án, đảm bảo mục tiêu được hoàn thành đúng hạn.
                                        </p>
                                    </div>
                                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 hover:shadow-xl transition-shadow">
                                        <div class="text-3xl mb-4">&#x1f680;</div>
                                        <h4 class="font-bold text-lg text-slate-900 dark:text-white mb-3">Startup Founder</h4>
                                        <p class="text-slate-600 dark:text-slate-300 text-sm">
                                            Xây dựng và phát triển doanh nghiệp mới với tầm nhìn và chiến lược rõ ràng.
                                        </p>
                                    </div>
                                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 hover:shadow-xl transition-shadow">
                                        <div class="text-3xl mb-4">&#x1f3e2;</div>
                                        <h4 class="font-bold text-lg text-slate-900 dark:text-white mb-3">Trưởng phòng</h4>
                                        <p class="text-slate-600 dark:text-slate-300 text-sm">
                                            Quản lý phòng ban và định hướng chiến lược phát triển cho tổ chức.
                                        </p>
                                    </div>
                                </c:when>
                                <c:when test="${workStyleResult.primaryStyle == 'SUPPORTER'}">
                                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 hover:shadow-xl transition-shadow">
                                        <div class="text-3xl mb-4">&#x1f468;&#x200d;&#x1f4bc;</div>
                                        <h4 class="font-bold text-lg text-slate-900 dark:text-white mb-3">Chuyên viên HR</h4>
                                        <p class="text-slate-600 dark:text-slate-300 text-sm">
                                            Quản lý nhân sự và phát triển tổ chức, hỗ trợ phát triển nghề nghiệp.
                                        </p>
                                    </div>
                                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 hover:shadow-xl transition-shadow">
                                        <div class="text-3xl mb-4">&#x1f917;</div>
                                        <h4 class="font-bold text-lg text-slate-900 dark:text-white mb-3">Tư vấn viên</h4>
                                        <p class="text-slate-600 dark:text-slate-300 text-sm">
                                            Hỗ trợ và tư vấn cho cá nhân và tổ chức, giải quyết vấn đề tâm lý và nghề nghiệp.
                                        </p>
                                    </div>
                                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 hover:shadow-xl transition-shadow">
                                        <div class="text-3xl mb-4">&#x1f4de;</div>
                                        <h4 class="font-bold text-lg text-slate-900 dark:text-white mb-3">Hỗ trợ khách hàng</h4>
                                        <p class="text-slate-600 dark:text-slate-300 text-sm">
                                            Giải quyết vấn đề và hỗ trợ khách hàng, xây dựng mối quan hệ lâu dài.
                                        </p>
                                    </div>
                                </c:when>
                                <c:when test="${workStyleResult.primaryStyle == 'ANALYZER'}">
                                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 hover:shadow-xl transition-shadow">
                                        <div class="text-3xl mb-4">&#x1f4ca;</div>
                                        <h4 class="font-bold text-lg text-slate-900 dark:text-white mb-3">Data Analyst</h4>
                                        <p class="text-slate-600 dark:text-slate-300 text-sm">
                                            Phân tích dữ liệu và đưa ra insights có giá trị cho việc ra quyết định kinh doanh.
                                        </p>
                                    </div>
                                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 hover:shadow-xl transition-shadow">
                                        <div class="text-3xl mb-4">&#x1f52c;</div>
                                        <h4 class="font-bold text-lg text-slate-900 dark:text-white mb-3">Nhà nghiên cứu</h4>
                                        <p class="text-slate-600 dark:text-slate-300 text-sm">
                                            Nghiên cứu và phân tích chuyên sâu trong các lĩnh vực khoa học và công nghệ.
                                        </p>
                                    </div>
                                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 hover:shadow-xl transition-shadow">
                                        <div class="text-3xl mb-4">&#x1f4b5;</div>
                                        <h4 class="font-bold text-lg text-slate-900 dark:text-white mb-3">Kế toán/Kiểm toán</h4>
                                        <p class="text-slate-600 dark:text-slate-300 text-sm">
                                            Phân tích tài chính và kiểm soát số liệu, đảm bảo tính chính xác và minh bạch.
                                        </p>
                                    </div>
                                </c:when>
                                <c:when test="${workStyleResult.primaryStyle == 'INNOVATOR'}">
                                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 hover:shadow-xl transition-shadow">
                                        <div class="text-3xl mb-4">&#x1f3a8;</div>
                                        <h4 class="font-bold text-lg text-slate-900 dark:text-white mb-3">UI/UX Designer</h4>
                                        <p class="text-slate-600 dark:text-slate-300 text-sm">
                                            Thiết kế trải nghiệm người dùng sáng tạo và thân thiện với người dùng.
                                        </p>
                                    </div>
                                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 hover:shadow-xl transition-shadow">
                                        <div class="text-3xl mb-4">&#x1f4f8;</div>
                                        <h4 class="font-bold text-lg text-slate-900 dark:text-white mb-3">Content Creator</h4>
                                        <p class="text-slate-600 dark:text-slate-300 text-sm">
                                            Sáng tạo nội dung đa phương tiện thu hút và truyền cảm hứng cho khán giả.
                                        </p>
                                    </div>
                                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 hover:shadow-xl transition-shadow">
                                        <div class="text-3xl mb-4">&#x1f680;</div>
                                        <h4 class="font-bold text-lg text-slate-900 dark:text-white mb-3">R&D Specialist</h4>
                                        <p class="text-slate-600 dark:text-slate-300 text-sm">
                                            Nghiên cứu và phát triển sản phẩm mới với tư duy đổi mới và sáng tạo.
                                        </p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 hover:shadow-xl transition-shadow">
                                        <div class="text-3xl mb-4">&#x1f504;</div>
                                        <h4 class="font-bold text-lg text-slate-900 dark:text-white mb-3">Project Coordinator</h4>
                                        <p class="text-slate-600 dark:text-slate-300 text-sm">
                                            Phối hợp và quản lý dự án linh hoạt, kết nối các bên liên quan hiệu quả.
                                        </p>
                                    </div>
                                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 hover:shadow-xl transition-shadow">
                                        <div class="text-3xl mb-4">&#x1f91d;</div>
                                        <h4 class="font-bold text-lg text-slate-900 dark:text-white mb-3">Business Developer</h4>
                                        <p class="text-slate-600 dark:text-slate-300 text-sm">
                                            Phát triển kinh doanh đa chiều, xây dựng quan hệ đối tác và mở rộng thị trường.
                                        </p>
                                    </div>
                                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 hover:shadow-xl transition-shadow">
                                        <div class="text-3xl mb-4">&#x1f31f;</div>
                                        <h4 class="font-bold text-lg text-slate-900 dark:text-white mb-3">General Manager</h4>
                                        <p class="text-slate-600 dark:text-slate-300 text-sm">
                                            Quản lý tổng thể với góc nhìn đa chiều, điều phối hoạt động toàn diện.
                                        </p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Insights -->
                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 mb-8">
                        <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-6 flex items-center">
                            <span class="material-symbols-outlined mr-3 text-yellow-500 dark:text-yellow-400">lightbulb</span>
                            Nhận xét và đề xuất phát triển
                        </h3>
                        <div class="space-y-6">
                            <div class="flex items-start">
                                <span class="material-symbols-outlined text-green-500 dark:text-green-400 mr-4 mt-1">check_circle</span>
                                <div>
                                    <h4 class="font-bold text-slate-900 dark:text-white mb-2">Cách làm việc hiệu quả</h4>
                                    <p class="text-slate-600 dark:text-slate-300">
                                        <c:choose>
                                            <c:when test="${workStyleResult.primaryStyle == 'LEADER'}">
                                                • Đặt mục tiêu rõ ràng cho bản thân và team<br>
                                                • Giao tiếp cởi mở và thường xuyên với thành viên<br>
                                                • Trao quyền và tin tưởng để phát triển năng lực team<br>
                                                • Dẫn dắt bằng ví dụ và hành động cụ thể
                                            </c:when>
                                            <c:when test="${workStyleResult.primaryStyle == 'SUPPORTER'}">
                                                • Lắng nghe tích cực và thấu hiểu nhu cầu<br>
                                                • Cung cấp phản hồi xây dựng và kịp thời<br>
                                                • Tạo môi trường làm việc thoải mái và an toàn<br>
                                                • Hỗ trợ kịp thời và hiệu quả khi cần thiết
                                            </c:when>
                                            <c:otherwise>
                                                • Kết hợp điểm mạnh của các phong cách khác nhau<br>
                                                • Linh hoạt thay đổi cách tiếp cận theo tình huống<br>
                                                • Học hỏi từ các phong cách làm việc đa dạng<br>
                                                • Phát triển kỹ năng toàn diện và chuyên sâu
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                            
                            <div class="flex items-start">
                                <span class="material-symbols-outlined text-blue-500 dark:text-blue-400 mr-4 mt-1">trending_up</span>
                                <div>
                                    <h4 class="font-bold text-slate-900 dark:text-white mb-2">Kế hoạch phát triển bản thân</h4>
                                    <p class="text-slate-600 dark:text-slate-300">
                                        <c:choose>
                                            <c:when test="${workStyleResult.primaryStyle == 'LEADER'}">
                                                1. Tham gia khóa học về quản lý xung đột và đàm phán<br>
                                                2. Phát triển kỹ năng coaching và mentoring cho team<br>
                                                3. Học về tâm lý lãnh đạo và động lực làm việc<br>
                                                4. Tham gia khóa quản trị chiến lược và quản lý thay đổi
                                            </c:when>
                                            <c:when test="${workStyleResult.primaryStyle == 'SUPPORTER'}">
                                                1. Học về đặt giới hạn lành mạnh trong công việc<br>
                                                2. Phát triển kỹ năng ra quyết định độc lập<br>
                                                3. Tham gia khóa quản lý thời gian và ưu tiên công việc<br>
                                                4. Học về tâm lý học tích cực và phát triển cá nhân
                                            </c:when>
                                            <c:otherwise>
                                                1. Phát triển chuyên sâu 1-2 kỹ năng cốt lõi<br>
                                                2. Học thêm kỹ năng liên ngành để mở rộng cơ hội<br>
                                                3. Tham gia các dự án đa dạng để tích lũy kinh nghiệm<br>
                                                4. Xây dựng network đa lĩnh vực để học hỏi và phát triển
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

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
                            <a href="${pageContext.request.contextPath}/quiz/work-style" 
                               class="flex items-center px-6 py-3 bg-red-500 hover:bg-red-600 text-white font-semibold rounded-xl transition-colors">
                                <span class="material-symbols-outlined mr-2">refresh</span>
                                Làm lại quiz
                            </a>
                            <a href="${pageContext.request.contextPath}/resources?type=work-style" 
                               class="flex items-center px-6 py-3 work-gradient hover:opacity-90 text-white font-semibold rounded-xl transition-opacity">
                                Xem tài nguyên phát triển
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
                            <a href="${pageContext.request.contextPath}/quiz/work-style" 
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
            <div class="mt-8 p-6 work-gradient rounded-2xl text-white">
                <div class="flex flex-col md:flex-row items-center justify-between">
                    <div class="mb-4 md:mb-0">
                        <h4 class="text-lg font-semibold mb-2">🚀 Nâng cao kỹ năng làm việc của bạn</h4>
                        <p class="text-purple-100">Khám phá các khóa học và tài nguyên phát triển kỹ năng chuyên nghiệp</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/QuizResultController"
                       class="flex items-center px-6 py-3 bg-white text-purple-600 font-semibold rounded-xl hover:bg-purple-50 transition-colors">
                        Xem tất cả quiz
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
                    leadership: ${workStyleResult.leadershipScore},
                    support: ${workStyleResult.supportScore},
                    analysis: ${workStyleResult.analysisScore},
                    communication: ${workStyleResult.communicationScore},
                    teamwork: ${workStyleResult.teamworkScore},
                    creativity: ${workStyleResult.creativityScore}
                };
                
                // Animate each score and progress bar
                Object.keys(scores).forEach(skill => {
                    const scoreElement = document.getElementById(`${skill}-score`);
                    const barElement = document.getElementById(`${skill}-bar`);
                    const score = scores[skill];
                    
                    if (scoreElement) {
                        animateValue(`${skill}-score`, 0, score, 1000);
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
            const primaryStyle = '${workStyleResult.primaryStyle}'.toLowerCase();
            const confettiColors = {
                leader: ['#667eea', '#764ba2', '#4F46E5'],
                supporter: ['#48bb78', '#38a169', '#2F855A'],
                analyzer: ['#ed8936', '#dd6b20', '#C05621'],
                innovator: ['#d69e2e', '#b7791f', '#975A16'],
                balanced: ['#805ad5', '#6b46c1', '#553C9A']
            };
            
            const colors = confettiColors[primaryStyle] || confettiColors.leader;
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
            const primaryStyle = '${workStyleResult.primaryStyle}';
            const styleName = 
                primaryStyle === 'LEADER' ? 'Người Lãnh đạo' :
                primaryStyle === 'SUPPORTER' ? 'Người Hỗ trợ' :
                primaryStyle === 'ANALYZER' ? 'Nhà Phân tích' :
                primaryStyle === 'INNOVATOR' ? 'Người Sáng tạo' : 'Phong cách Cân bằng';
            
            const shareText = `Tôi vừa khám phá phong cách làm việc của mình: ${styleName} (${primaryStyle})! 🚀 Khám phá ngay bạn nhé!`;
            
            if (navigator.share) {
                navigator.share({
                    title: 'Kết quả Phong cách Làm việc',
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
            const primaryStyle = '${workStyleResult.primaryStyle}';
            const styleName = 
                primaryStyle === 'LEADER' ? 'Người Lãnh đạo' :
                primaryStyle === 'SUPPORTER' ? 'Người Hỗ trợ' :
                primaryStyle === 'ANALYZER' ? 'Nhà Phân tích' :
                primaryStyle === 'INNOVATOR' ? 'Người Sáng tạo' : 'Phong cách Cân bằng';
            
            const resultText = `🏢 Kết quả Phong cách Làm việc của tôi: ${styleName} (${primaryStyle})\n\nĐiểm số chi tiết:\n• Lãnh đạo: ${workStyleResult.leadershipScore}\n• Hỗ trợ: ${workStyleResult.supportScore}\n• Phân tích: ${workStyleResult.analysisScore}\n• Giao tiếp: ${workStyleResult.communicationScore}\n• Teamwork: ${workStyleResult.teamworkScore}\n• Sáng tạo: ${workStyleResult.creativityScore}\n\nKhám phá phong cách làm việc của bạn tại: ${window.location.origin}`;
            
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