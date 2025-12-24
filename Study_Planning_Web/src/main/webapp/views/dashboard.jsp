<%-- 
    Document   : dashboard
    Created on : 28 thg 11, 2025, 22:43:37
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="currentTheme" value="${empty theme ? 'light' : theme}" />
<!DOCTYPE html>
<html lang="vi" class="${currentTheme == 'dark' ? 'dark' : ''}">

    <head>
        <meta charset="utf-8" />
        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
        <title>Tổng quan (Dashboard)</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
        <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300..700&display=swap" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet" />
        <!-- new -->
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet"/>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;700&amp;display=swap"
              rel="stylesheet" />
        <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
        <style>
            .circular-chart {
                display: block;
                margin: 10px auto;
                max-width: 80%;
                max-height: 250px;
            }

            .circle {
                fill: none;
                stroke-width: 3;
                stroke-linecap: round;
                animation: progress 1s ease-out forwards;
            }

            @keyframes progress {
                0% {
                    stroke-dasharray: 0, 100;
                }
            }

            .min-h-\[50px\] {
                min-height: 50px;
            }
            
            /* Thêm style cho lịch dashboard */
            .calendar-day-cell {
                min-height: 50px;
                position: relative;
            }
            
            .schedule-event {
                position: absolute;
                left: 1px;
                right: 1px;
                border-radius: 4px;
                padding: 2px 4px;
                font-size: 11px;
                overflow: hidden;
                z-index: 10;
                cursor: pointer;
                transition: all 0.2s;
            }
            
            .schedule-event:hover {
                opacity: 0.9;
                transform: translateY(-1px);
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            
            .temp-event {
                border-style: dashed;
                opacity: 0.8;
            }
        </style>
        <script>
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        colors: {
                            // Đã thay đổi primary về một màu nổi hơn cho dễ nhìn
                            primary: "#4F46E5", // Thay #A5B4FC bằng Indigo 600
                            "background-light": "#F8FAFC",
                            "background-dark": "#0F172A",
                            // New pastel colors
                            "pastel-purple": "#A5B4FC",
                            "pastel-light-purple": "#C7D2FE",
                            "pastel-pink": "#F9A8D4",
                            "pastel-yellow": "#FDE68A",
                            "text-color": "#1E293B",

                            //new
                            "surface-light": "#FFFFFF",
                            "surface-dark": "#293548",
                            "text-light": "#1E293B",
                            "text-dark": "#E2E8F0",
                            "border-light": "#E5E7EB",
                            "border-dark": "#475569",
                            "secondary-pink": "#F9A8D4",
                            "secondary-indigo-light": "#C7D2FE",
                            "secondary-yellow": "#FDE68A",

                            // Type colors
                            "type-class": "#A5B4FC",
                            "type-study": "#C7D2FE",
                            "type-activity": "#F9A8D4",
                            "type-break": "#FDE68A",
                        },
                        fontFamily: {
                            display: ["Be Vietnam Pro", "Quicksand", "sans-serif"],
                        },
                        borderRadius: {
                            DEFAULT: "0.75rem",
                        },
                    },
                },
            };
        </script>
        <link rel="stylesheet" href="/resources/css/sidebar.css">
        <link rel="stylesheet" href="/resources/css/setting.css">
        
        <!-- Thêm Font Awesome cho dashboard -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    </head>

    <body class="font-display bg-background-light dark:bg-background-dark text-text-color dark:text-slate-200">
        <div class="flex h-screen">
            <aside 
                id="sidebar"
                class="bg-white dark:bg-slate-900 flex flex-col py-6 space-y-8 border-r border-slate-200 dark:border-slate-800 
                h-screen fixed top-0 left-0 transition-all duration-500 z-40 cursor-pointer"
                >

                <div class="w-14 h-14 bg-primary rounded-full flex items-center justify-center shrink-0 mx-auto">
                    <span class="material-icons-outlined text-white text-3xl">face</span>
                </div>

                <nav class="flex flex-col space-y-2 flex-grow w-full">

                    <%-- [ĐÃ SỬA ĐỔI] Đặt trạng thái active cho Bảng điều khiển --%>
                    <a class="nav-link w-full rounded-lg transition-colors bg-primary shadow-md shadow-primary/30 text-white"
                       href="/dashboard">
                        <span class="material-icons-outlined text-3xl shrink-0">dashboard</span>
                        <span class="ml-4 whitespace-nowrap sidebar-text">Bảng điều khiển</span>
                    </a>

                    <%-- [ĐÃ SỬA ĐỔI] Lịch của tôi không còn active --%>
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
                    <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300"
                       href="${pageContext.request.contextPath}/QuizResultController">
                        <span class="material-icons-outlined text-3xl shrink-0">psychology</span>
                        <span class="ml-4 whitespace-nowrap sidebar-text">Khám phá bản thân</span>
                    </a>

                    <%-- Timer --%>
                    <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300"
                       href="${pageContext.request.contextPath}/timer">
                        <span class="material-icons-outlined text-3xl shrink-0">timer</span>
                        <span class="ml-4 whitespace-nowrap sidebar-text">Bộ hẹn giờ</span>
                    </a>

                </nav>
            </aside>

            <main id="mainContent" class="flex-1 flex flex-col p-6 lg:p-8 overflow-y-auto">
                <header class="flex justify-between items-center mb-6">
                    <div>
                        <c:set var="hour" value="<%= java.time.LocalTime.now().getHour()%>" />
                        <c:choose>
                            <c:when test="${hour >= 5 && hour < 12}">
                                <h1 class="text-2xl font-bold text-text-color dark:text-white">Chào buổi sáng, ${user.username}!</h1>
                            </c:when>
                            <c:when test="${hour >= 12 && hour < 18}">
                                <h1 class="text-2xl font-bold text-text-color dark:text-white">Chào buổi chiều, ${user.username}!</h1>
                            </c:when>
                            <c:otherwise>
                                <h1 class="text-2xl font-bold text-text-color dark:text-white">Chào buổi tối, ${user.username}!</h1>
                            </c:otherwise>
                        </c:choose>
                        <p class="text-slate-500 dark:text-slate-400">Đây là tổng quan các hoạt động của bạn.</p>
                    </div>
                    <div class="flex items-center space-x-4">
                        <!-- Thêm dropdown chọn schedule -->
                        <div class="relative">
                            <select id="dashboardScheduleSelect" onchange="changeDashboardSchedule()" 
                                    class="appearance-none bg-white dark:bg-slate-800 border border-slate-300 dark:border-slate-600 rounded-lg px-4 py-2 pr-8 text-sm focus:outline-none focus:ring-2 focus:ring-primary cursor-pointer">
                                <option value="">Chọn lịch trình...</option>
                            </select>
                        </div>
                        
                        <button class="p-2 rounded-full hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors" aria-label="Settings" onclick="loadSettingsAndOpen()">
                            <span class="material-icons-outlined text-slate-600 dark:text-slate-300">settings</span>
                        </button>
                        <a href="/logout" class="p-2 rounded-full hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors" aria-label="Logout">
                            <span class="material-icons-outlined text-slate-600 dark:text-slate-300">logout</span>
                        </a>
                    </div>
                </header>  
                
                <div class="flex-1 grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <div class="lg:col-span-2 flex flex-col gap-6">

                        <%-- Các thẻ chỉ số chính - ĐÃ SỬA LỖI --%>
                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-6">
                            <div class="bg-white dark:bg-slate-800 p-5 rounded-lg shadow-md border-t-4 border-pastel-purple">
                                <p class="text-sm font-medium text-slate-500 dark:text-slate-400">Tổng giờ học</p>
                                <p class="text-3xl font-bold text-text-color dark:text-white mt-1">
                                    <c:choose>
                                        <c:when test="${dash.studyHours != null}">
                                            <fmt:formatNumber value="${dash.studyHours}" pattern="#.#" /> giờ
                                        </c:when>
                                        <c:otherwise>
                                            0 giờ
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <c:choose>
                                    <c:when test="${dash.weeklyChange >= 0}">
                                        <p class="text-xs text-green-500 mt-1 flex items-center">
                                            <span class="material-icons-outlined text-lg">arrow_upward</span>
                                            <fmt:formatNumber value="${dash.weeklyChange}" pattern="#.#" />% so với tuần trước
                                        </p>
                                    </c:when>
                                    <c:otherwise>
                                        <c:choose>
                                            <c:when test="${dash.weeklyChange != null}">
                                                <p class="text-xs text-red-500 mt-1 flex items-center">
                                                    <span class="material-icons-outlined text-lg">arrow_downward</span>
                                                    <fmt:formatNumber value="${dash.weeklyChange < 0 ? -dash.weeklyChange : dash.weeklyChange}" pattern="#.#" />% so với tuần trước
                                                </p>
                                            </c:when>
                                            <c:otherwise>
                                                <p class="text-xs text-gray-500 mt-1 flex items-center">
                                                    <span class="material-icons-outlined text-lg">remove</span>
                                                    Không có dữ liệu tuần trước
                                                </p>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="bg-white dark:bg-slate-800 p-5 rounded-lg shadow-md border-t-4 border-pastel-pink">
                                <p class="text-sm font-medium text-slate-500 dark:text-slate-400">Nhiệm vụ xong</p>
                                <p class="text-3xl font-bold text-text-color dark:text-white mt-1">
                                    <c:choose>
                                        <c:when test="${dash.completedTasks != null && dash.totalTasks != null}">
                                            ${dash.completedTasks}/${dash.totalTasks}
                                        </c:when>
                                        <c:otherwise>
                                            0/0
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <p class="text-xs text-slate-500 dark:text-slate-400 mt-1">
                                    Tỷ lệ hoàn thành 
                                    <c:choose>
                                        <c:when test="${dash.completionRate != null}">
                                            <fmt:formatNumber value="${dash.completionRate}" pattern="#.#" />%
                                        </c:when>
                                        <c:otherwise>
                                            0%
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>

                            <div class="bg-white dark:bg-slate-800 p-5 rounded-lg shadow-md border-t-4 border-pastel-yellow">
                                <p class="text-sm font-medium text-slate-500 dark:text-slate-400">Sự kiện sắp tới</p>
                                <p class="text-3xl font-bold text-text-color dark:text-white mt-1">
                                    <c:choose>
                                        <c:when test="${dash.upcomingEventCount != null}">
                                            ${dash.upcomingEventCount}
                                        </c:when>
                                        <c:otherwise>
                                            0
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <p class="text-xs text-slate-500 dark:text-slate-400 mt-1">
                                    Trong 7 ngày tới
                                </p>
                            </div>
                        </div>

                        <%-- Thời khóa biểu 7 ngày - SỬA LẠI HOÀN TOÀN --%>
                        <div class="bg-white dark:bg-slate-800 p-6 rounded-lg shadow-sm flex-grow">
                            <div class="flex justify-between items-center mb-4">
                                <h3 class="font-bold text-lg text-text-color dark:text-white">📅 Thời khóa biểu Tuần</h3>
                                <div class="flex items-center gap-2 text-sm">
                                    <span id="dashboardWeekLabel" class="font-medium">Tuần này</span>
                                    <span class="text-slate-400">|</span>
                                    <span class="text-xs text-slate-500">Chọn lịch trình ở trên để xem</span>
                                </div>
                            </div>

                            <div class="border border-slate-200 dark:border-slate-700 rounded-lg overflow-hidden">
                                <table class="w-full border-collapse">
                                    <thead>
                                        <tr class="bg-slate-50 dark:bg-slate-900 border-b border-slate-200 dark:border-slate-700">
                                            <th class="p-2 text-left text-xs font-semibold text-slate-500 dark:text-slate-400 border-r border-slate-200 dark:border-slate-700 w-16">Giờ</th>
                                            <th class="p-2 text-center text-xs font-semibold text-slate-700 dark:text-slate-300 border-r border-slate-200 dark:border-slate-700">Thứ 2</th>
                                            <th class="p-2 text-center text-xs font-semibold text-slate-700 dark:text-slate-300 border-r border-slate-200 dark:border-slate-700">Thứ 3</th>
                                            <th class="p-2 text-center text-xs font-semibold text-slate-700 dark:text-slate-300 border-r border-slate-200 dark:border-slate-700">Thứ 4</th>
                                            <th class="p-2 text-center text-xs font-semibold text-slate-700 dark:text-slate-300 border-r border-slate-200 dark:border-slate-700">Thứ 5</th>
                                            <th class="p-2 text-center text-xs font-semibold text-slate-700 dark:text-slate-300 border-r border-slate-200 dark:border-slate-700">Thứ 6</th>
                                            <th class="p-2 text-center text-xs font-semibold text-slate-700 dark:text-slate-300 border-r border-slate-200 dark:border-slate-700">Thứ 7</th>
                                            <th class="p-2 text-center text-xs font-semibold text-slate-700 dark:text-slate-300">Chủ nhật</th>
                                        </tr>
                                    </thead>
                                    <tbody id="dashboardCalendarGrid">
                                        <!-- Calendar sẽ được render bằng JavaScript -->
                                    </tbody>
                                </table>
                            </div>
                            
                            <div class="flex flex-wrap gap-3 mt-4 text-xs">
                                <div class="flex items-center">
                                    <div class="w-3 h-3 rounded-full bg-type-class mr-1"></div>
                                    <span class="text-slate-600 dark:text-slate-400">Lớp học</span>
                                </div>
                                <div class="flex items-center">
                                    <div class="w-3 h-3 rounded-full bg-type-study mr-1"></div>
                                    <span class="text-slate-600 dark:text-slate-400">Tự học</span>
                                </div>
                                <div class="flex items-center">
                                    <div class="w-3 h-3 rounded-full bg-type-activity mr-1"></div>
                                    <span class="text-slate-600 dark:text-slate-400">Hoạt động</span>
                                </div>
                                <div class="flex items-center">
                                    <div class="w-3 h-3 rounded-full bg-type-break mr-1"></div>
                                    <span class="text-slate-600 dark:text-slate-400">Nghỉ ngơi</span>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div class="lg:col-span-1 flex flex-col gap-6">
                        <%-- Thẻ Phân bổ thời gian --%>
                        <div class="bg-white dark:bg-slate-800 p-6 rounded-lg shadow-sm">
                            <h3 class="font-bold text-lg mb-4 text-text-color dark:text-white">📊 Phân bổ thời gian</h3>
                            <div class="flex flex-col sm:flex-row gap-6 sm:items-center">
                                <div class="relative w-36 h-36 flex-shrink-0 mx-auto sm:mx-0">
                                    <%-- Biểu đồ tròn --%>
                                    <c:set var="totalPercent" value="0" />
                                    <svg viewBox="0 0 36 36" class="circular-chart">
                                    <c:set var="colors" value="#A5B4FC,#F9A8D4,#FDE68A,#C7D2FE" />
                                    <c:set var="labels" value="Học tập,Giải trí,Nghỉ ngơi,Khác" />
                                    <c:set var="percentValues" value="0,0,0,0" />

                                    <c:if test="${not empty timeAllocation}">
                                        <c:set var="percentValues" 
                                               value="${timeAllocation.getOrDefault('Học tập', 0)},
                                               ${timeAllocation.getOrDefault('Giải trí', 0)},
                                               ${timeAllocation.getOrDefault('Nghỉ ngơi', 0)},
                                               ${timeAllocation.getOrDefault('Khác', 0)}" />
                                    </c:if>

                                    <c:forEach var="i" begin="0" end="3">
                                        <c:set var="percent" value="${fn:split(percentValues, ',')[i]}" />
                                        <c:set var="color" value="${fn:split(colors, ',')[i]}" />

                                        <c:if test="${(percent + 0) > 0}">
                                            <path class="circle"
                                                  stroke="${color}"
                                                  stroke-width="3"
                                                  stroke-dasharray="${percent}, 100"
                                                  d="M18 2.0845
                                                  a 15.9155 15.9155 0 0 1 0 31.831
                                                  a 15.9155 15.9155 0 0 1 0 -31.831"
                                                  transform="rotate(${totalPercent * 3.6 - 90}, 18, 18)"/>
                                            <c:set var="totalPercent" value="${totalPercent + percent}" />
                                        </c:if>
                                    </c:forEach>
                                    </svg>

                              
                                </div>

                                <div class="space-y-3">
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <div class="w-3 h-3 rounded-full bg-pastel-purple mr-3"></div>
                                            <span class="text-sm font-medium text-text-color dark:text-slate-300">Học tập</span>
                                        </div>
                                        <span class="text-sm font-bold text-text-color dark:text-white">
                                            <c:choose>
                                                <c:when test="${timeAllocation != null && timeAllocation.getOrDefault('Học tập', 0) != null}">
                                                    <fmt:formatNumber value="${timeAllocation.getOrDefault('Học tập', 0)}" pattern="#.#" />%
                                                </c:when>
                                                <c:otherwise>
                                                    0%
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <div class="w-3 h-3 rounded-full bg-pastel-pink mr-3"></div>
                                            <span class="text-sm font-medium text-text-color dark:text-slate-300">Giải trí</span>
                                        </div>
                                        <span class="text-sm font-bold text-text-color dark:text-white">
                                            <c:choose>
                                                <c:when test="${timeAllocation != null && timeAllocation.getOrDefault('Giải trí', 0) != null}">
                                                    <fmt:formatNumber value="${timeAllocation.getOrDefault('Giải trí', 0)}" pattern="#.#" />%
                                                </c:when>
                                                <c:otherwise>
                                                    0%
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <div class="w-3 h-3 rounded-full bg-pastel-yellow mr-3"></div>
                                            <span class="text-sm font-medium text-text-color dark:text-slate-300">Nghỉ ngơi</span>
                                        </div>
                                        <span class="text-sm font-bold text-text-color dark:text-white">
                                            <c:choose>
                                                <c:when test="${timeAllocation != null && timeAllocation.getOrDefault('Nghỉ ngơi', 0) != null}">
                                                    <fmt:formatNumber value="${timeAllocation.getOrDefault('Nghỉ ngơi', 0)}" pattern="#.#" />%
                                                </c:when>
                                                <c:otherwise>
                                                    0%
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <div class="w-3 h-3 rounded-full bg-pastel-light-purple mr-3"></div>
                                            <span class="text-sm font-medium text-text-color dark:text-slate-300">Khác</span>
                                        </div>
                                        <span class="text-sm font-bold text-text-color dark:text-white">
                                            <c:choose>
                                                <c:when test="${timeAllocation != null && timeAllocation.getOrDefault('Khác', 0) != null}">
                                                    <fmt:formatNumber value="${timeAllocation.getOrDefault('Khác', 0)}" pattern="#.#" />%
                                                </c:when>
                                                <c:otherwise>
                                                    0%
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- Task sắp deadline --%>
                        <div class="bg-white dark:bg-slate-800 p-6 rounded-lg shadow-sm">
                            <h3 class="font-bold text-lg mb-4 text-text-color dark:text-white">📝 Task sắp deadline</h3>
                            <div class="space-y-3">
                                <c:choose>
                                    <c:when test="${not empty dash.upcomingTasks && fn:length(dash.upcomingTasks) > 0}">
                                        <c:forEach var="task" items="${dash.upcomingTasks}" varStatus="status" end="4">
                                            <div class="flex items-center justify-between p-3 bg-slate-50 dark:bg-slate-900 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors">
                                                <div class="flex-1">
                                                    <p class="font-medium text-text-color dark:text-white truncate">
                                                        <c:choose>
                                                            <c:when test="${task.title != null}">
                                                                ${task.title}
                                                            </c:when>
                                                            <c:otherwise>
                                                                Không có tiêu đề
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </p>
                                                    <div class="flex items-center mt-1 text-xs text-slate-500 dark:text-slate-400">
                                                        <span class="material-icons-outlined text-sm align-middle mr-1">schedule</span>
                                                        <c:choose>
                                                            <c:when test="${task.deadline != null}">
                                                                <fmt:formatDate value="${task.deadline}" pattern="dd/MM HH:mm" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                Không có deadline
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                                <span class="px-2 py-1 text-xs rounded-full ml-2 flex-shrink-0
                                                      ${task.priority == 'HIGH' ? 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200' : 
                                                        task.priority == 'MEDIUM' ? 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200' : 
                                                        'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200'}">
                                                          <c:choose>
                                                            <c:when test="${task.priority != null}">
                                                                ${task.priority}
                                                            </c:when>
                                                            <c:otherwise>
                                                                MEDIUM
                                                            </c:otherwise>
                                                        </c:choose>
                                                      </span>
                                                </div>
                                            </c:forEach>
                                            <c:if test="${fn:length(dash.upcomingTasks) > 5}">
                                                <div class="text-center pt-2">
                                                    <a href="${pageContext.request.contextPath}/tasks" class="text-primary hover:text-primary-dark text-sm font-medium">
                                                        + ${fn:length(dash.upcomingTasks) - 5} task khác
                                                    </a>
                                                </div>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center py-4">
                                                <span class="material-icons-outlined text-slate-400 text-4xl mb-2">task_alt</span>
                                                <p class="text-slate-500 dark:text-slate-400">Không có task nào sắp deadline</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <%-- Thống kê hoạt động theo tuần --%>
                            <div class="bg-white dark:bg-slate-800 p-6 rounded-lg shadow-sm">
                                <h3 class="font-bold text-lg mb-4 text-text-color dark:text-white">📈 Thống kê hoạt động</h3>
                                <div class="space-y-4">
                                    <%-- Thống kê theo type --%>
                                    <div class="space-y-2">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center">
                                                <div class="w-3 h-3 rounded-full bg-type-class mr-2"></div>
                                                <span class="text-sm">Lớp học</span>
                                            </div>
                                            <span class="text-sm font-bold">
                                                <c:set var="classCount" value="0" />
                                                <c:if test="${not empty dash.timetableList}">
                                                    <c:forEach var="slot" items="${dash.timetableList}">
                                                        <c:if test="${slot.type == 'class'}">
                                                            <c:set var="classCount" value="${classCount + 1}" />
                                                        </c:if>
                                                    </c:forEach>
                                                </c:if>
                                                ${classCount} slot
                                            </span>
                                        </div>
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center">
                                                <div class="w-3 h-3 rounded-full bg-type-study mr-2"></div>
                                                <span class="text-sm">Tự học</span>
                                            </div>
                                            <span class="text-sm font-bold">
                                                <c:set var="studyCount" value="0" />
                                                <c:if test="${not empty dash.timetableList}">
                                                    <c:forEach var="slot" items="${dash.timetableList}">
                                                        <c:if test="${slot.type == 'self-study'}">
                                                            <c:set var="studyCount" value="${studyCount + 1}" />
                                                        </c:if>
                                                    </c:forEach>
                                                </c:if>
                                                ${studyCount} slot
                                            </span>
                                        </div>
                                    </div>

                                    <%-- Thống kê chung --%>
                                    <div class="border-t border-slate-200 dark:border-slate-700 pt-4 mt-2">
                                        <div class="grid grid-cols-2 gap-4">
                                            <div class="text-center">
                                                <p class="text-2xl font-bold text-text-color dark:text-white">
                                                    <c:choose>
                                                        <c:when test="${not empty dash.timetableList}">
                                                            ${fn:length(dash.timetableList)}
                                                        </c:when>
                                                        <c:otherwise>
                                                            0
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                                <p class="text-xs text-slate-500 dark:text-slate-400">Tổng slot</p>
                                            </div>
                                            <div class="text-center">
                                                <p class="text-2xl font-bold text-text-color dark:text-white">
                                                    <c:choose>
                                                        <c:when test="${dash.completedTasks != null}">
                                                            ${dash.completedTasks}
                                                        </c:when>
                                                        <c:otherwise>
                                                            0
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                                <p class="text-xs text-slate-500 dark:text-slate-400">Task hoàn thành</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </main>
            </div>

            <%-- 1. THÊM LỚP PHỦ CÀI ĐẶT TẠI ĐÂY --%>
            <%@ include file="settings-overlay.jsp" %>

            <script src="/resources/js/sidebar.js"></script>
            <script src="/resources/js/setting.js"></script>
            
            <!-- Thêm JavaScript cho dashboard calendar -->
            <script>
                // Biến toàn cục cho dashboard
                let dashboardWeeklySchedule = {};
                let dashboardCurrentCollectionId = null;
                const DAYS_OF_WEEK = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

                // Hàm load schedule collections cho dashboard
                function loadDashboardScheduleCollections() {
                    console.log('🔍 loadDashboardScheduleCollections...');

                    fetch('/user/collections?action=list')
                        .then(response => response.json())
                        .then(collections => {
                            console.log('✅ Collections loaded:', collections);

                            const select = document.getElementById('dashboardScheduleSelect');
                            select.innerHTML = '<option value="">Chọn lịch trình...</option>';

                            if (collections && collections.length > 0) {
                                collections.forEach(collection => {
                                    const option = document.createElement('option');
                                    option.value = collection.collectionId;
                                    option.textContent = collection.collectionName;
                                    select.appendChild(option);
                                });

                                // ⭐️ SỬA QUAN TRỌNG: Đảm bảo có giá trị trước khi gọi
                                const firstCollectionId = String(collections[0].collectionId);
                                console.log('🎯 Setting first collection:', firstCollectionId);

                                // Cập nhật UI
                                select.value = firstCollectionId;
                                dashboardCurrentCollectionId = firstCollectionId;

                                // ⭐️ THÊM: Gọi với delay nhỏ để đảm bảo DOM đã update
                                setTimeout(() => {
                                    console.log('⏰ Delayed load with:', dashboardCurrentCollectionId);
                                    loadDashboardSchedule(firstCollectionId);
                                }, 100);

                            }
                        })
                        .catch(error => {
                            console.error('❌ Error loading collections:', error);
                        });
                }

                // Hàm xử lý khi thay đổi schedule
                function changeDashboardSchedule() {
                    const select = document.getElementById('dashboardScheduleSelect');
                    dashboardCurrentCollectionId = select.value;
                    console.log('🔄 Đã chọn collectionId:', dashboardCurrentCollectionId);
                    if (dashboardCurrentCollectionId) {
                        loadDashboardSchedule(dashboardCurrentCollectionId);
                    } else {
                        // Xóa lịch nếu không chọn gì
                        dashboardWeeklySchedule = {
                            'Mon': [], 'Tue': [], 'Wed': [], 'Thu': [], 'Fri': [], 'Sat': [], 'Sun': []
                        };
                        renderDashboardCalendar();
                    }
                }

                // Hàm load schedule cho dashboard - SỬA LẠI để xử lý lỗi tốt hơn
                async function loadDashboardSchedule(collectionId) {
                    if (!collectionId) {
                        console.warn('⚠️ Không có collectionId');
                        return;
                    }
                   
                    console.log('🔍 Original collectionId:', collectionId);
                   

                    let endpoint = '/user/schedule?action=weekly&collectionId=' + collectionId;

                    try {
                        // Thử endpoint mới nếu endpoint cũ không hoạt động
                        let endpoint = '/user/schedule?action=weekly&collectionId=' + collectionId;
                        console.log('🌐 Gọi API:', endpoint);
                        
                        const response = await fetch(endpoint);
                        
                        console.log('📥 Response status:', response.status, response.statusText);
                        
                        if (!response.ok) {
                            // Thử endpoint khác nếu cần
                            if (response.status === 500) {
                                console.warn('⚠️ Endpoint /user/schedule trả về 500, thử endpoint khác...');
                                // Thử endpoint khác dựa trên tasks.js
                                const alternativeEndpoint = `/user/schedule/weekly&collectionId=${collectionId}`;
                                console.log('🔄 Thử endpoint khác:', alternativeEndpoint);
                                
                                const altResponse = await fetch(alternativeEndpoint);
                                if (!altResponse.ok) {
                                    throw new Error(`Alternative endpoint failed: HTTP ${altResponse.status}`);
                                }
                                const data = await altResponse.json();
                                processScheduleData(data);
                                return;
                            }
                            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                        }
                        
                        const data = await response.json();
                        processScheduleData(data);
                        
                    } catch (error) {
                        console.error('❌ Lỗi tải schedule:', error);
                        
                        // Hiển thị thông báo cho người dùng
                        const calendarGrid = document.getElementById('dashboardCalendarGrid');
                        if (calendarGrid) {
                            calendarGrid.innerHTML = `
                                <tr>
                                    <td colspan="8" class="p-4 text-center">
                                        <div class="text-yellow-600 dark:text-yellow-400 mb-2">
                                            <i class="fa-solid fa-exclamation-triangle text-xl"></i>
                                        </div>
                                        <p class="text-sm">Không thể tải dữ liệu lịch trình</p>
                                        <p class="text-xs text-slate-500 mt-1">Vui lòng thử lại sau hoặc kiểm tra kết nối</p>
                                    </td>
                                </tr>
                            `;
                        }
                        
                        dashboardWeeklySchedule = {
                            'Mon': [], 'Tue': [], 'Wed': [], 'Thu': [], 'Fri': [], 'Sat': [], 'Sun': []
                        };
                    }
                }

                // Hàm xử lý dữ liệu schedule
                function processScheduleData(data) {
                    console.log('📊 Dữ liệu schedule nhận được:', data);
                    
                    // Khởi tạo lại cấu trúc weeklySchedule
                    dashboardWeeklySchedule = {
                        'Mon': [], 'Tue': [], 'Wed': [], 'Thu': [], 'Fri': [], 'Sat': [], 'Sun': []
                    };

                    // Kiểm tra cấu trúc dữ liệu
                    if (data && typeof data === 'object') {
                        // Cập nhật dữ liệu mới từ server
                        Object.keys(data).forEach(day => {
                            if (dashboardWeeklySchedule.hasOwnProperty(day)) {
                                dashboardWeeklySchedule[day] = Array.isArray(data[day])
                                    ? [...data[day]]
                                    : [];
                                console.log(`📅 ${day}: ${dashboardWeeklySchedule[day].length} sự kiện`);
                            }
                        });
                    } else if (Array.isArray(data)) {
                        // Nếu data là mảng, xử lý khác
                        console.log('📋 Data là mảng, xử lý đặc biệt...');
                        data.forEach(event => {
                            if (event.dayOfWeek && dashboardWeeklySchedule.hasOwnProperty(event.dayOfWeek)) {
                                dashboardWeeklySchedule[event.dayOfWeek].push(event);
                            }
                        });
                    }

                    console.log('✅ Dữ liệu schedule đã xử lý:', dashboardWeeklySchedule);
                    renderDashboardCalendar();
                }

                // Hàm chuyển đổi thời gian thành phút
                function timeToMinutes(timeStr) {
                    if (!timeStr) return 0;

                    const parts = timeStr.split(' ');
                    let timePart = parts[0];
                    let ampm = parts.length > 1 ? parts[1] : '';

                    const [h, m, s] = timePart.split(':').map(Number);
                    let hours = h || 0;
                    const minutes = m || 0;

                    // Xử lý AM/PM tiếng Việt
                    if (ampm === 'CH' || ampm === 'PM') {
                        if (hours < 12) {
                            hours += 12;
                        }
                    } else if (ampm === 'SA' || ampm === 'AM') {
                        if (hours === 12) {
                            hours = 0;
                        }
                    }

                    return hours * 60 + minutes;
                }

                // Hàm render calendar cho dashboard
                function renderDashboardCalendar() {
                    const calendarGrid = document.getElementById('dashboardCalendarGrid');
                    if (!calendarGrid) return;

                    calendarGrid.innerHTML = '';

                    // Kiểm tra xem có dữ liệu không
                    let hasEvents = false;
                    Object.values(dashboardWeeklySchedule).forEach(events => {
                        if (events && events.length > 0) {
                            hasEvents = true;
                        }
                    });

                    if (!hasEvents) {
                        // Hiển thị thông báo không có sự kiện
                        const row = document.createElement('tr');
                        const cell = document.createElement('td');
                        cell.colSpan = 8;
                        cell.className = 'p-8 text-center';
                        cell.innerHTML = `
                            <div class="text-slate-400 dark:text-slate-500 mb-3">
                                <i class="fa-solid fa-calendar-day text-3xl"></i>
                            </div>
                            <p class="text-sm text-slate-600 dark:text-slate-400">Không có sự kiện nào trong tuần này</p>
                            <p class="text-xs text-slate-500 dark:text-slate-500 mt-1">Hãy thêm sự kiện vào lịch trình của bạn</p>
                        `;
                        row.appendChild(cell);
                        calendarGrid.appendChild(row);
                        return;
                    }

                    // Tạo các dòng cho khung giờ (0h - 23h)
                    for (let hour = 0; hour <= 23; hour++) {
                        const row = document.createElement('tr');
                        row.className = 'border-b border-slate-100 dark:border-slate-700 hover:bg-slate-50/50 dark:hover:bg-slate-800/50 transition-colors';

                        // Cột giờ
                        const timeCell = document.createElement('td');
                        timeCell.className = 'p-2 text-xs text-slate-400 dark:text-slate-500 font-medium border-r border-slate-200 dark:border-slate-700 align-top text-center';
                        timeCell.textContent = formatHourForDisplay(hour);
                        row.appendChild(timeCell);

                        // Các cột ngày
                        DAYS_OF_WEEK.forEach((day, index) => {
                            const cell = document.createElement('td');
                            const borderClass = index < DAYS_OF_WEEK.length - 1 ? 'border-r border-slate-100 dark:border-slate-700' : '';
                            cell.className = `p-1 ${borderClass} relative align-top calendar-day-cell`;
                            cell.dataset.day = day;
                            cell.dataset.hour = hour;

                            // Hiển thị sự kiện nếu có
                            if (dashboardWeeklySchedule[day] && dashboardWeeklySchedule[day].length > 0) {
                                const events = dashboardWeeklySchedule[day].filter(e => {
                                    if (!e.startTime || !e.endTime) return false;
                                    
                                    const startMinutes = timeToMinutes(e.startTime);
                                    const endMinutes = timeToMinutes(e.endTime);
                                    const eventStartHour = Math.floor(startMinutes / 60);
                                    const eventEndHour = Math.ceil(endMinutes / 60);
                                    
                                    // Kiểm tra xem sự kiện có nằm trong giờ hiện tại không
                                    return hour >= eventStartHour && hour < eventEndHour;
                                });

                                events.forEach(event => {
                                    const startMinutes = timeToMinutes(event.startTime);
                                    const endMinutes = timeToMinutes(event.endTime);
                                    const duration = endMinutes - startMinutes;
                                    
                                    // Chỉ tạo sự kiện ở ô bắt đầu
                                    const eventStartHour = Math.floor(startMinutes / 60);
                                    if (eventStartHour === hour) {
                                        const eventDiv = createDashboardEventDiv(event, startMinutes, duration);
                                        cell.appendChild(eventDiv);
                                    }
                                });
                            }

                            row.appendChild(cell);
                        });

                        calendarGrid.appendChild(row);
                    }
                }

                // Hàm tạo div sự kiện cho dashboard - ĐÃ SỬA LỖI Math.max
                function createDashboardEventDiv(event, startMinutes, duration) {
                    const eventDiv = document.createElement('div');
                    eventDiv.className = 'schedule-event absolute left-1 right-1 rounded px-2 py-1 text-xs font-medium truncate shadow-sm';
                    
                    // Xác định màu sắc theo type
                    let bgColor = '#E5E7EB'; // Màu mặc định
                    let textColor = '#1F2937';
                    
                    switch(event.type) {
                        case 'class':
                            bgColor = '#A5B4FC'; // pastel-purple
                            textColor = '#3730A3';
                            break;
                        case 'self-study':
                            bgColor = '#C7D2FE'; // pastel-light-purple
                            textColor = '#3730A3';
                            break;
                        case 'activity':
                            bgColor = '#F9A8D4'; // pastel-pink
                            textColor = '#831843';
                            break;
                        case 'break':
                            bgColor = '#FDE68A'; // pastel-yellow
                            textColor = '#92400E';
                            break;
                    }
                    
                    eventDiv.style.backgroundColor = bgColor;
                    eventDiv.style.color = textColor;
                    eventDiv.style.top = '2px';
                    
                    // Tính chiều cao - SỬA LỖI: Không dùng Math.max trong template string
                    var calculatedHeight = duration / 60 * 50 - 4;
                    var finalHeight = calculatedHeight < 20 ? 20 : calculatedHeight;
                    eventDiv.style.height = finalHeight + 'px';
                    
                    const startHour = Math.floor(startMinutes / 60);
                    const startMinute = startMinutes % 60;
                    const endMinutes = startMinutes + duration;
                    const endHour = Math.floor(endMinutes / 60);
                    const endMinute = endMinutes % 60;
                    
                    const displayStart = startHour.toString().padStart(2, '0') + ':' + startMinute.toString().padStart(2, '0');
                    const displayEnd = endHour.toString().padStart(2, '0') + ':' + endMinute.toString().padStart(2, '0');
                    
                    eventDiv.innerHTML = '<div class="font-semibold truncate">' + (event.subject || 'Không có tiêu đề') + '</div>' +
                                         '<div class="text-xs opacity-75">' + displayStart + ' - ' + displayEnd + '</div>';
                    
                    eventDiv.title = (event.subject || 'Không có tiêu đề') + '\n' + displayStart + ' - ' + displayEnd + '\n' + (event.type || 'Không có loại');
                    
                    return eventDiv;
                }

                // Hàm format giờ cho hiển thị
                function formatHourForDisplay(hour) {
                    let displayHour = hour;
                    let ampm = 'SA';
                    
                    if (hour === 0) {
                        displayHour = 12;
                        ampm = 'SA';
                    } else if (hour < 12) {
                        displayHour = hour;
                        ampm = 'SA';
                    } else if (hour === 12) {
                        displayHour = 12;
                        ampm = 'CH';
                    } else {
                        displayHour = hour - 12;
                        ampm = 'CH';
                    }
                    
                    return displayHour + ':00 ' + ampm;
                }

                // Khởi tạo khi trang load
                document.addEventListener('DOMContentLoaded', function() {
                    console.log('🚀 Dashboard đang khởi tạo...');
                    loadDashboardScheduleCollections();
                    
                    // Tự động refresh dữ liệu mỗi 5 phút
                    setInterval(() => {
                        if (dashboardCurrentCollectionId) {
                            console.log('🔄 Tự động refresh schedule...');
                            loadDashboardSchedule(dashboardCurrentCollectionId);
                        }
                    }, 300000); // 5 phút
                });
            </script>

        </body>

</html>