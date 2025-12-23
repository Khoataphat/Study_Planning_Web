<%-- 
    Document   : quizpage
    Created on : 21 thg 12, 2025, 18:23:14
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="currentTheme" value="${empty theme ? 'light' : theme}" />
<!DOCTYPE html>
<html lang="vi" class="${currentTheme == 'dark' ? 'dark' : ''}">

    <head>
        <meta charset="utf-8" />
        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
        <title>Quiz Home - Khám phá bản thân</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
        <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300..700&display=swap" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet"/>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;700&amp;display=swap" rel="stylesheet" />

        <style>
            .gradient-bg {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            }

            .progress-fill {
                background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
                height: 100%;
                border-radius: 0.5rem;
                transition: width 0.5s ease;
            }

            .quiz-card-hover {
                transition: all 0.3s ease;
            }

            .quiz-card-hover:hover {
                transform: translateY(-0.25rem);
                box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
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
                            "pastel-purple": "#A5B4FC",
                            "pastel-light-purple": "#C7D2FE",
                            "pastel-pink": "#F9A8D4",
                            "pastel-yellow": "#FDE68A",
                            "text-color": "#1E293B",
                            "surface-light": "#FFFFFF",
                            "surface-dark": "#293548",
                            "text-light": "#1E293B",
                            "text-dark": "#E2E8F0",
                            "border-light": "#E5E7EB",
                            "border-dark": "#475569",
                            "secondary-pink": "#F9A8D4",
                            "secondary-indigo-light": "#C7D2FE",
                            "secondary-yellow": "#FDE68A",
                            "quiz-purple": "#667eea",
                            "quiz-dark-purple": "#764ba2",
                        },
                        fontFamily: {
                            display: ["Be Vietnam Pro", "Quicksand", "sans-serif"],
                        },
                        borderRadius: {
                            DEFAULT: "0.75rem",
                            "2xl": "1rem",
                            "3xl": "1.5rem",
                        },
                        animation: {
                            'fade-in': 'fadeIn 0.5s ease-in-out',
                            'slide-up': 'slideUp 0.3s ease-out',
                        },
                        keyframes: {
                            fadeIn: {
                                '0%': {opacity: '0'},
                                '100%': {opacity: '1'},
                            },
                            slideUp: {
                                '0%': {transform: 'translateY(10px)', opacity: '0'},
                                '100%': {transform: 'translateY(0)', opacity: '1'},
                            }
                        }
                    },
                },
            };
        </script>
        <link rel="stylesheet" href="/resources/css/sidebar.css">
        <link rel="stylesheet" href="/resources/css/setting.css">
    </head>

    <body class="font-display bg-background-light dark:bg-background-dark text-text-color dark:text-slate-200">
        <div class="flex min-h-screen">
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

                    <%-- Active state for Quiz Home --%>
                    <a class="nav-link w-full rounded-lg transition-colors bg-primary shadow-md shadow-primary/30 text-white"
                       href="${pageContext.request.contextPath}/QuizResultController">
                        <span class="material-icons-outlined text-3xl shrink-0">psychology</span>
                        <span class="ml-4 whitespace-nowrap sidebar-text">Khám phá bản thân</span>
                    </a>
                </nav>
            </aside>

            <main id="mainContent" class="flex-1 flex flex-col p-6 lg:p-8 ml-20 overflow-y-auto">
                <header class="flex justify-between items-center mb-8">
                    <div>
                        <h1 class="text-3xl font-bold text-slate-900 dark:text-white">Khám phá bản thân</h1>
                        <p class="text-slate-500 dark:text-slate-400 mt-2">Hoàn thành các bài quiz để hiểu rõ hơn về bản thân và nhận insights cá nhân hóa</p>
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

                <!-- User Progress Section -->
                <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 mb-8 animate-fade-in">
                    <div class="flex flex-col md:flex-row items-center gap-6">
                        <div class="flex-1">
                            <!-- Insights Section -->
                            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6">
                                <div class="flex items-center justify-between mb-6">
                                    <h2 class="text-2xl font-bold text-slate-900 dark:text-white flex items-center">
                                        <span class="material-symbols-outlined mr-3 text-quiz-purple dark:text-pastel-purple">insights</span>
                                        Insights cá nhân hóa
                                    </h2>
                                    <c:if test="${not empty dashboardData.insights}">
                                        <span class="text-sm text-slate-500 dark:text-slate-400">
                                            ${fn:length(dashboardData.insights)} insights
                                        </span>
                                    </c:if>
                                </div>

                                <c:choose>
                                    <c:when test="${not empty dashboardData.insights}">
                                        <div class="space-y-4">
                                            <c:forEach var="insight" items="${dashboardData.insights}" varStatus="status">
                                                <div class="flex items-start p-4 bg-slate-50 dark:bg-slate-700/50 rounded-xl border-l-4 border-quiz-purple dark:border-pastel-purple animate-slide-up" 
                                                     style="animation-delay: ${status.index * 0.1}s">
                                                    <span class="material-symbols-outlined text-quiz-purple dark:text-pastel-purple mr-3 mt-0.5">lightbulb</span>
                                                    <p class="text-slate-700 dark:text-slate-300">${insight}</p>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-12">
                                            <div class="w-20 h-20 mx-auto mb-4 rounded-full bg-slate-100 dark:bg-slate-700 flex items-center justify-center">
                                                <span class="material-symbols-outlined text-slate-400 dark:text-slate-500 text-4xl">psychology</span>
                                            </div>
                                            <h3 class="text-lg font-semibold text-slate-600 dark:text-slate-400 mb-2">Chưa có insights</h3>
                                            <p class="text-slate-500 dark:text-slate-500 mb-6 max-w-md mx-auto">
                                                Hoàn thành các bài quiz để nhận insights cá nhân hóa về tính cách, phong cách học tập và định hướng nghề nghiệp của bạn!
                                            </p>
                                            <a href="#quiz-grid" class="inline-flex items-center px-6 py-3 gradient-bg text-white font-semibold rounded-xl hover:opacity-90 transition-opacity">
                                                <span class="material-symbols-outlined mr-2">rocket_launch</span>
                                                Bắt đầu khám phá ngay
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="mt-6">
                                <div class="flex justify-between items-center mb-2">
                                    <h3 class="text-lg font-semibold text-slate-900 dark:text-white">Tiến độ hoàn thành quiz</h3>
                                    <span class="text-2xl font-bold text-quiz-purple dark:text-pastel-purple">
                                        ${dashboardData.completionPercentage}%
                                    </span>
                                </div>
                                <div class="h-3 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                                    <div class="progress-fill" style="width: ${dashboardData.completionPercentage}%"></div>
                                </div>
                                <p class="text-slate-500 dark:text-slate-400 mt-2 text-sm">
                                    ${dashboardData.completedQuizzes} / ${dashboardData.totalQuizzes} quiz đã hoàn thành
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quiz Grid -->
                <div class="mb-8">
                    <h2 class="text-2xl font-bold text-slate-900 dark:text-white mb-6 flex items-center">
                        <span class="material-symbols-outlined mr-3 text-quiz-purple dark:text-pastel-purple">psychology</span>
                        Các bài quiz khám phá
                    </h2>

                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                        <!-- MBTI Quiz Card -->
                        <div class="quiz-card-hover bg-white dark:bg-slate-800 rounded-2xl p-6 shadow-md border-2 
                             ${dashboardData.mbtiResult != null ? 'border-green-500 dark:border-green-400' : 'border-transparent'} 
                             hover:border-quiz-purple dark:hover:border-pastel-purple animate-slide-up">
                            <div class="flex items-center justify-between mb-4">
                                <div class="w-12 h-12 rounded-xl bg-gradient-to-br from-purple-400 to-purple-600 flex items-center justify-center">
                                    <span class="material-symbols-outlined text-white text-2xl">sentiment_satisfied</span>
                                </div>
                                <c:choose>
                                    <c:when test="${dashboardData.mbtiResult != null}">
                                        <span class="px-3 py-1 rounded-full bg-green-100 dark:bg-green-900/30 text-green-800 dark:text-green-300 text-sm font-semibold">
                                            ${dashboardData.mbtiResult.mbtiType}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="px-3 py-1 rounded-full bg-red-100 dark:bg-red-900/30 text-red-800 dark:text-red-300 text-sm font-semibold">
                                            Chưa làm
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-2">🎭 Trắc nghiệm Tính cách</h3>
                            <p class="text-slate-500 dark:text-slate-400 mb-6">Khám phá MBTI của bạn để hiểu rõ điểm mạnh và điểm yếu.</p>
                            <a href="${pageContext.request.contextPath}/quiz/mbti" 
                               class="w-full inline-flex items-center justify-center px-4 py-3 gradient-bg text-white font-semibold rounded-xl hover:opacity-90 transition-opacity">
                                <c:choose>
                                    <c:when test="${dashboardData.mbtiResult != null}">
                                        Xem kết quả
                                    </c:when>
                                    <c:otherwise>
                                        Bắt đầu ngay
                                    </c:otherwise>
                                </c:choose>
                                <span class="material-symbols-outlined ml-2">arrow_forward</span>
                            </a>
                        </div>

                        <!-- Work Style Quiz Card -->
                        <div class="quiz-card-hover bg-white dark:bg-slate-800 rounded-2xl p-6 shadow-md border-2 
                             ${dashboardData.workStyleResult != null ? 'border-green-500 dark:border-green-400' : 'border-transparent'} 
                             hover:border-quiz-purple dark:hover:border-pastel-purple animate-slide-up" style="animation-delay: 0.1s">
                            <div class="flex items-center justify-between mb-4">
                                <div class="w-12 h-12 rounded-xl bg-gradient-to-br from-blue-400 to-blue-600 flex items-center justify-center">
                                    <span class="material-symbols-outlined text-white text-2xl">group_work</span>
                                </div>
                                <c:choose>
                                    <c:when test="${dashboardData.workStyleResult != null}">
                                        <span class="px-3 py-1 rounded-full bg-green-100 dark:bg-green-900/30 text-green-800 dark:text-green-300 text-sm font-semibold">
                                            ${dashboardData.workStyleResult.primaryStyle}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="px-3 py-1 rounded-full bg-red-100 dark:bg-red-900/30 text-red-800 dark:text-red-300 text-sm font-semibold">
                                            Chưa làm
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-2">💼 Phong cách Làm việc</h3>
                            <p class="text-slate-500 dark:text-slate-400 mb-6">Bạn là người dẫn đầu hay người hỗ trợ tuyệt vời trong team?</p>
                            <a href="${pageContext.request.contextPath}/quiz/work-style" 
                               class="w-full inline-flex items-center justify-center px-4 py-3 gradient-bg text-white font-semibold rounded-xl hover:opacity-90 transition-opacity">
                                <c:choose>
                                    <c:when test="${dashboardData.workStyleResult != null}">
                                        Xem kết quả
                                    </c:when>
                                    <c:otherwise>
                                        Bắt đầu ngay
                                    </c:otherwise>
                                </c:choose>
                                <span class="material-symbols-outlined ml-2">arrow_forward</span>
                            </a>
                        </div>

                        <!-- Learning Style Quiz Card -->
                        <div class="quiz-card-hover bg-white dark:bg-slate-800 rounded-2xl p-6 shadow-md border-2 
                             ${dashboardData.learningStyleResult != null ? 'border-green-500 dark:border-green-400' : 'border-transparent'} 
                             hover:border-quiz-purple dark:hover:border-pastel-purple animate-slide-up" style="animation-delay: 0.2s">
                            <div class="flex items-center justify-between mb-4">
                                <div class="w-12 h-12 rounded-xl bg-gradient-to-br from-indigo-400 to-indigo-600 flex items-center justify-center">
                                    <span class="material-symbols-outlined text-white text-2xl">menu_book</span>
                                </div>
                                <c:choose>
                                    <c:when test="${dashboardData.learningStyleResult != null}">
                                        <span class="px-3 py-1 rounded-full bg-green-100 dark:bg-green-900/30 text-green-800 dark:text-green-300 text-sm font-semibold">
                                            ${dashboardData.learningStyleResult.primaryStyle}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="px-3 py-1 rounded-full bg-red-100 dark:bg-red-900/30 text-red-800 dark:text-red-300 text-sm font-semibold">
                                            Chưa làm
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-2">📚 Phong cách Học tập</h3>
                            <p class="text-slate-500 dark:text-slate-400 mb-6">Tìm ra phương pháp học tập tối ưu: VAK (Visual, Auditory, Kinesthetic).</p>
                            <a href="${pageContext.request.contextPath}/quiz/learning-style" 
                               class="w-full inline-flex items-center justify-center px-4 py-3 gradient-bg text-white font-semibold rounded-xl hover:opacity-90 transition-opacity">
                                <c:choose>
                                    <c:when test="${dashboardData.learningStyleResult != null}">
                                        Xem kết quả
                                    </c:when>
                                    <c:otherwise>
                                        Bắt đầu ngay
                                    </c:otherwise>
                                </c:choose>
                                <span class="material-symbols-outlined ml-2">arrow_forward</span>
                            </a>
                        </div>

                        <!-- Career Quiz Card -->
                        <div class="quiz-card-hover bg-white dark:bg-slate-800 rounded-2xl p-6 shadow-md border-2 
                             ${dashboardData.careerResult != null ? 'border-green-500 dark:border-green-400' : 'border-transparent'} 
                             hover:border-quiz-purple dark:hover:border-pastel-purple animate-slide-up" style="animation-delay: 0.3s">
                            <div class="flex items-center justify-between mb-4">
                                <div class="w-12 h-12 rounded-xl bg-gradient-to-br from-pink-400 to-pink-600 flex items-center justify-center">
                                    <span class="material-symbols-outlined text-white text-2xl">work_outline</span>
                                </div>
                                <c:choose>
                                    <c:when test="${dashboardData.careerResult != null}">
                                        <span class="px-3 py-1 rounded-full bg-green-100 dark:bg-green-900/30 text-green-800 dark:text-green-300 text-sm font-semibold">
                                            Hoàn thành
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="px-3 py-1 rounded-full bg-red-100 dark:bg-red-900/30 text-red-800 dark:text-red-300 text-sm font-semibold">
                                            Chưa làm
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-2">🎯 Định hướng Nghề nghiệp</h3>
                            <p class="text-slate-500 dark:text-slate-400 mb-6">Xác định nghề nghiệp phù hợp dựa trên sở thích và năng lực.</p>
                            <a href="${pageContext.request.contextPath}/quiz/career" 
                               class="w-full inline-flex items-center justify-center px-4 py-3 gradient-bg text-white font-semibold rounded-xl hover:opacity-90 transition-opacity">
                                <c:choose>
                                    <c:when test="${dashboardData.careerResult != null}">
                                        Xem kết quả
                                    </c:when>
                                    <c:otherwise>
                                        Bắt đầu ngay
                                    </c:otherwise>
                                </c:choose>
                                <span class="material-symbols-outlined ml-2">arrow_forward</span>
                            </a>
                        </div>
                    </div>
                </div>


            </main>
        </div>

        <%-- Settings Overlay --%>
        <%@ include file="settings-overlay.jsp" %>

        <script src="/resources/js/sidebar.js"></script>
        <script src="/resources/js/setting.js"></script>

        <script>
                            // Smooth scroll to quiz grid
                            document.querySelectorAll('a[href="#quiz-grid"]').forEach(link => {
                                link.addEventListener('click', (e) => {
                                    e.preventDefault();
                                    const quizGrid = document.querySelector('.grid.grid-cols-1.md\\:grid-cols-2.lg\\:grid-cols-4');
                                    if (quizGrid) {
                                        quizGrid.scrollIntoView({behavior: 'smooth'});
                                    }
                                });
                            });
        </script>
    </body>
</html>