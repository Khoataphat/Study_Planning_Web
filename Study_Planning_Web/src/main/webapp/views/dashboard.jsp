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

                        <%-- Các thẻ chỉ số chính --%>
                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-6">
                            <div class="bg-white dark:bg-slate-800 p-5 rounded-lg shadow-md border-t-4 border-pastel-purple">
                                <p class="text-sm font-medium text-slate-500 dark:text-slate-400">Tổng giờ học</p>
                                <p class="text-3xl font-bold text-text-color dark:text-white mt-1">
                                    <fmt:formatNumber value="${dash.studyHours}" pattern="#.#" /> giờ
                                </p>
                                <c:choose>
                                    <c:when test="${dash.weeklyChange >= 0}">
                                        <p class="text-xs text-green-500 mt-1 flex items-center">
                                            <span class="material-icons-outlined text-lg">arrow_upward</span>
                                            <fmt:formatNumber value="${dash.weeklyChange}" pattern="#.#" />% so với tuần trước
                                        </p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-xs text-red-500 mt-1 flex items-center">
                                            <span class="material-icons-outlined text-lg">arrow_downward</span>
                                            <fmt:formatNumber value="${-dash.weeklyChange}" pattern="#.#" />% so với tuần trước
                                        </p>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="bg-white dark:bg-slate-800 p-5 rounded-lg shadow-md border-t-4 border-pastel-pink">
                                <p class="text-sm font-medium text-slate-500 dark:text-slate-400">Nhiệm vụ xong</p>
                                <p class="text-3xl font-bold text-text-color dark:text-white mt-1">
                                    ${dash.completedTasks}/${dash.totalTasks}
                                </p>
                                <p class="text-xs text-slate-500 dark:text-slate-400 mt-1">
                                    Tỷ lệ hoàn thành <fmt:formatNumber value="${dash.completionRate}" pattern="#.#" />%
                                </p>
                            </div>

                            <div class="bg-white dark:bg-slate-800 p-5 rounded-lg shadow-md border-t-4 border-pastel-yellow">
                                <p class="text-sm font-medium text-slate-500 dark:text-slate-400">Sự kiện sắp tới</p>
                                <p class="text-3xl font-bold text-text-color dark:text-white mt-1">
                                    ${dash.upcomingEventCount}
                                </p>
                                <p class="text-xs text-slate-500 dark:text-slate-400 mt-1">
                                    Trong 7 ngày tới
                                </p>
                            </div>
                        </div>

                        <%-- Thời khóa biểu 7 ngày --%>
                        <div class="bg-white dark:bg-slate-800 p-4 rounded-lg shadow-sm flex-grow">
                            <div class="flex justify-between items-center mb-3">
                                <h3 class="font-bold text-lg text-text-color dark:text-white">📅 Thời khóa biểu Tuần</h3>
                                <div class="flex flex-wrap gap-1">
                                    <div class="flex items-center">
                                        <div class="w-2 h-2 rounded-full bg-type-class mr-1"></div>
                                        <span class="text-xs">Lớp học</span>
                                    </div>
                                    <div class="flex items-center">
                                        <div class="w-2 h-2 rounded-full bg-type-study mr-1"></div>
                                        <span class="text-xs">Tự học</span>
                                    </div>
                                </div>
                            </div>

                            <div class="border border-slate-200 dark:border-slate-700 rounded-lg overflow-hidden">
                                <%-- QUAN TRỌNG: Sửa grid layout --%>
                                <div class="grid grid-cols-7 bg-white dark:bg-slate-800/50">
                                    <%-- Tiêu đề các ngày --%>
                                    <div class="p-2 text-center font-semibold text-xs text-text-color dark:text-white border-b border-r border-slate-200 dark:border-slate-700">Thứ 2</div>
                                    <div class="p-2 text-center font-semibold text-xs text-text-color dark:text-white border-b border-r border-slate-200 dark:border-slate-700">Thứ 3</div>
                                    <div class="p-2 text-center font-semibold text-xs text-text-color dark:text-white border-b border-r border-slate-200 dark:border-slate-700">Thứ 4</div>
                                    <div class="p-2 text-center font-semibold text-xs text-text-color dark:text-white border-b border-r border-slate-200 dark:border-slate-700">Thứ 5</div>
                                    <div class="p-2 text-center font-semibold text-xs text-text-color dark:text-white border-b border-r border-slate-200 dark:border-slate-700">Thứ 6</div>
                                    <div class="p-2 text-center font-semibold text-xs text-text-color dark:text-white border-b border-r border-slate-200 dark:border-slate-700">Thứ 7</div>
                                    <div class="p-2 text-center font-semibold text-xs text-text-color dark:text-white border-b border-slate-200 dark:border-slate-700">Chủ nhật</div>

                                    <%-- QUAN TRỌNG: Tạo các dòng cho khung giờ --%>
                                    <c:set var="timeSlots" value="${['07:00', '09:00', '11:00', '13:00', '15:00', '17:00', '19:00', '21:00']}" />

                                    <c:forEach var="i" begin="0" end="${fn:length(timeSlots)-2}">
                                        <c:set var="timeStart" value="${timeSlots[i]}" />
                                        <c:set var="timeEnd" value="${timeSlots[i+1]}" />

                                        <c:forEach var="dayIndex" begin="0" end="6">
                                            <c:set var="dayName" value="${['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'][dayIndex]}" />
                                            <c:set var="foundSlot" value="${null}" />

                                            <%-- Tìm slot phù hợp --%>
                                            <c:forEach var="slot" items="${dash.timetableList}">
                                                <c:if test="${slot.dayOfWeek.name() == dayName}">
                                                    <%-- Kiểm tra xem slot có nằm trong khung giờ này không --%>
                                                    <c:set var="slotStart" value="${fn:substring(slot.startTime.toString(), 0, 5)}" />
                                                    <c:set var="slotEnd" value="${fn:substring(slot.endTime.toString(), 0, 5)}" />

                                                    <c:if test="${slotStart >= timeStart && slotEnd <= timeEnd}">
                                                        <c:set var="foundSlot" value="${slot}" />
                                                    </c:if>
                                                </c:if>
                                            </c:forEach>

                                            <div class="p-0.5 border-b ${dayIndex < 6 ? 'border-r' : ''} border-slate-200 dark:border-slate-700 min-h-[50px]">
                                                <c:if test="${foundSlot != null}">
                                                    <%-- Xác định màu sắc theo type --%>
                                                    <c:choose>
                                                        <c:when test="${foundSlot.type == 'class'}">
                                                            <c:set var="bgColor" value="#A5B4FC" />
                                                        </c:when>
                                                        <c:when test="${foundSlot.type == 'self-study'}">
                                                            <c:set var="bgColor" value="#C7D2FE" />
                                                        </c:when>
                                                        <c:when test="${foundSlot.type == 'activity'}">
                                                            <c:set var="bgColor" value="#F9A8D4" />
                                                        </c:when>
                                                        <c:when test="${foundSlot.type == 'break'}">
                                                            <c:set var="bgColor" value="#FDE68A" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="bgColor" value="#E5E7EB" />
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <div class="p-1 rounded text-white shadow-sm h-full cursor-pointer hover:opacity-90 transition-all text-xs" 
                                                         style="background-color: ${bgColor};">
                                                        <p class="font-bold truncate">${foundSlot.subject}</p>
                                                        <p class="opacity-90">${fn:substring(foundSlot.startTime.toString(), 0, 5)}-${fn:substring(foundSlot.endTime.toString(), 0, 5)}</p>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </c:forEach>
                                    </c:forEach>

                                    <c:if test="${empty dash.timetableList}">
                                        <div class="col-span-7 text-center p-4 text-slate-500 dark:text-slate-400 border-b border-slate-200 dark:border-slate-700">
                                            Chưa có thời khóa biểu nào.
                                        </div>
                                    </c:if>
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

                                    <div class="absolute inset-0 flex items-center justify-center">
                                        <div class="w-20 h-20 bg-white dark:bg-slate-900 rounded-full flex flex-col items-center justify-center border-2 border-slate-200 dark:border-slate-700">
                                            <span class="text-2xl font-bold text-text-color dark:text-white">
                                                <fmt:formatNumber value="${timeAllocation.getOrDefault('Học tập', 0)}" pattern="#.#" />%
                                            </span>
                                            <span class="text-xs text-slate-500 dark:text-slate-400">Học tập</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="space-y-3">
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <div class="w-3 h-3 rounded-full bg-pastel-purple mr-3"></div>
                                            <span class="text-sm font-medium text-text-color dark:text-slate-300">Học tập</span>
                                        </div>
                                        <span class="text-sm font-bold text-text-color dark:text-white">
                                            <fmt:formatNumber value="${timeAllocation.getOrDefault('Học tập', 0)}" pattern="#.#" />%
                                        </span>
                                    </div>
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <div class="w-3 h-3 rounded-full bg-pastel-pink mr-3"></div>
                                            <span class="text-sm font-medium text-text-color dark:text-slate-300">Giải trí</span>
                                        </div>
                                        <span class="text-sm font-bold text-text-color dark:text-white">
                                            <fmt:formatNumber value="${timeAllocation.getOrDefault('Giải trí', 0)}" pattern="#.#" />%
                                        </span>
                                    </div>
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <div class="w-3 h-3 rounded-full bg-pastel-yellow mr-3"></div>
                                            <span class="text-sm font-medium text-text-color dark:text-slate-300">Nghỉ ngơi</span>
                                        </div>
                                        <span class="text-sm font-bold text-text-color dark:text-white">
                                            <fmt:formatNumber value="${timeAllocation.getOrDefault('Nghỉ ngơi', 0)}" pattern="#.#" />%
                                        </span>
                                    </div>
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <div class="w-3 h-3 rounded-full bg-pastel-light-purple mr-3"></div>
                                            <span class="text-sm font-medium text-text-color dark:text-slate-300">Khác</span>
                                        </div>
                                        <span class="text-sm font-bold text-text-color dark:text-white">
                                            <fmt:formatNumber value="${timeAllocation.getOrDefault('Khác', 0)}" pattern="#.#" />%
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
                                                    <p class="font-medium text-text-color dark:text-white truncate">${task.title}</p>
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
                                                          ${task.priority}
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
                                                <c:forEach var="slot" items="${dash.timetableList}">
                                                    <c:if test="${slot.type == 'class'}">
                                                        <c:set var="classCount" value="${classCount + 1}" />
                                                    </c:if>
                                                </c:forEach>
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
                                                <c:forEach var="slot" items="${dash.timetableList}">
                                                    <c:if test="${slot.type == 'self-study'}">
                                                        <c:set var="studyCount" value="${studyCount + 1}" />
                                                    </c:if>
                                                </c:forEach>
                                                ${studyCount} slot
                                            </span>
                                        </div>
                                    </div>

                                    <%-- Thống kê chung --%>
                                    <div class="border-t border-slate-200 dark:border-slate-700 pt-4 mt-2">
                                        <div class="grid grid-cols-2 gap-4">
                                            <div class="text-center">
                                                <p class="text-2xl font-bold text-text-color dark:text-white">${fn:length(dash.timetableList)}</p>
                                                <p class="text-xs text-slate-500 dark:text-slate-400">Tổng slot</p>
                                            </div>
                                            <div class="text-center">
                                                <p class="text-2xl font-bold text-text-color dark:text-white">${dash.completedTasks}</p>
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
            <script>
                            // Tooltip cho các slot timetable
                            document.addEventListener('DOMContentLoaded', function () {
                                const slots = document.querySelectorAll('.time-slot > div');
                                slots.forEach(slot => {
                                    slot.addEventListener('mouseenter', function (e) {
                                        const title = this.getAttribute('title');
                                        if (title) {
                                            const tooltip = document.createElement('div');
                                            tooltip.className = 'fixed z-50 bg-slate-900 text-white p-2 rounded text-sm shadow-lg';
                                            tooltip.textContent = title;
                                            tooltip.style.left = (e.clientX + 10) + 'px';
                                            tooltip.style.top = (e.clientY + 10) + 'px';
                                            document.body.appendChild(tooltip);
                                            this._tooltip = tooltip;
                                        }
                                    });

                                    slot.addEventListener('mousemove', function (e) {
                                        if (this._tooltip) {
                                            this._tooltip.style.left = (e.clientX + 10) + 'px';
                                            this._tooltip.style.top = (e.clientY + 10) + 'px';
                                        }
                                    });

                                    slot.addEventListener('mouseleave', function () {
                                        if (this._tooltip) {
                                            this._tooltip.remove();
                                            delete this._tooltip;
                                        }
                                    });
                                });

                                // Tự động refresh dữ liệu mỗi 5 phút
                                setInterval(() => {
                                    window.location.reload();
                                }, 300000); // 5 phút
                            });
            </script>

        </body>

    </html>