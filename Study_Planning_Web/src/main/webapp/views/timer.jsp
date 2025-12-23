<%-- 
    Document   : timer
    Created on : 21 thg 12, 2025, 18:25:11
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Xử lý tất cả ở server-side để tránh EL functions
    String currentTheme = "light";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("theme".equals(cookie.getName())) {
                currentTheme = cookie.getValue();
                break;
            }
        }
    }
    
    // Lấy các attribute từ request/session
    Object settingsObj = session.getAttribute("timerSettings");
    Object activeSessionObj = session.getAttribute("activeTimerSession");
    
    // Timer type display
    String timerTypeDisplay = "";
    Integer workDuration = 25;
    String startTimeDisplay = "";
    
    if (activeSessionObj != null) {
        try {
            // Lấy timer type
            java.lang.reflect.Method getTimerTypeMethod = activeSessionObj.getClass().getMethod("getTimerType");
            Object typeObj = getTimerTypeMethod.invoke(activeSessionObj);
            if (typeObj != null) {
                String typeStr = typeObj.toString();
                if ("POMODORO".equals(typeStr)) timerTypeDisplay = "Pomodoro";
                else if ("DEEP_WORK".equals(typeStr)) timerTypeDisplay = "Deep Work";
                else if ("WORK_52_17".equals(typeStr)) timerTypeDisplay = "52/17 Method";
                else timerTypeDisplay = typeStr;
            }
            
            // Lấy work duration
            java.lang.reflect.Method getWorkDurationMethod = activeSessionObj.getClass().getMethod("getWorkDuration");
            Object durationObj = getWorkDurationMethod.invoke(activeSessionObj);
            if (durationObj != null) {
                workDuration = Integer.parseInt(durationObj.toString());
            }
            
            // Lấy start time
            java.lang.reflect.Method getStartTimeMethod = activeSessionObj.getClass().getMethod("getStartTime");
            Object startTimeObj = getStartTimeMethod.invoke(activeSessionObj);
            if (startTimeObj != null) {
                if (startTimeObj instanceof java.time.LocalDateTime) {
                    java.time.LocalDateTime startTime = (java.time.LocalDateTime) startTimeObj;
                    startTimeDisplay = startTime.format(java.time.format.DateTimeFormatter.ofPattern("HH:mm"));
                } else if (startTimeObj instanceof java.util.Date) {
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("HH:mm");
                    startTimeDisplay = sdf.format((java.util.Date) startTimeObj);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // Cài đặt mặc định
    int pomodoroWork = 25;
    int pomodoroBreak = 5;
    int deepWorkDuration = 90;
    int work52Duration = 52;
    boolean soundEnabled = true;
    boolean autoStartBreaks = true;
    
    if (settingsObj != null) {
        try {
            java.lang.reflect.Method getPomodoroWorkMethod = settingsObj.getClass().getMethod("getPomodoroWork");
            Object pomodoroWorkObj = getPomodoroWorkMethod.invoke(settingsObj);
            if (pomodoroWorkObj != null) pomodoroWork = (Integer) pomodoroWorkObj;
            
            java.lang.reflect.Method getPomodoroBreakMethod = settingsObj.getClass().getMethod("getPomodoroBreak");
            Object pomodoroBreakObj = getPomodoroBreakMethod.invoke(settingsObj);
            if (pomodoroBreakObj != null) pomodoroBreak = (Integer) pomodoroBreakObj;
            
            java.lang.reflect.Method getDeepWorkDurationMethod = settingsObj.getClass().getMethod("getDeepWorkDuration");
            Object deepWorkDurationObj = getDeepWorkDurationMethod.invoke(settingsObj);
            if (deepWorkDurationObj != null) deepWorkDuration = (Integer) deepWorkDurationObj;
            
            java.lang.reflect.Method getWork52DurationMethod = settingsObj.getClass().getMethod("getWork52Duration");
            Object work52DurationObj = getWork52DurationMethod.invoke(settingsObj);
            if (work52DurationObj != null) work52Duration = (Integer) work52DurationObj;
            
            java.lang.reflect.Method getSoundEnabledMethod = settingsObj.getClass().getMethod("isSoundEnabled");
            Object soundEnabledObj = getSoundEnabledMethod.invoke(settingsObj);
            if (soundEnabledObj != null) soundEnabled = (Boolean) soundEnabledObj;
            
            java.lang.reflect.Method getAutoStartBreaksMethod = settingsObj.getClass().getMethod("isAutoStartBreaks");
            Object autoStartBreaksObj = getAutoStartBreaksMethod.invoke(settingsObj);
            if (autoStartBreaksObj != null) autoStartBreaks = (Boolean) autoStartBreaksObj;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // Thống kê - đơn giản hóa
    int totalFocusMinutes = 0;
    int completedSessions = 0;
    int goalPercentage = 0;
%>

<!DOCTYPE html>
<html lang="vi" class="<%= "dark".equals(currentTheme) ? "dark" : "" %>">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Bộ hẹn giờ làm việc</title>

        <!-- Stylesheets and Scripts -->
        <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;700&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300..700&display=swap" rel="stylesheet">

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
                            "secondary-pink": "#F9A8D4",
                            "secondary-indigo-light": "#C7D2FE",
                            "secondary-yellow": "#FDE68A",
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

        <style>
            .material-symbols-outlined,
            .material-icons-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            }

            .timer-circle {
                position: relative;
                width: 320px;
                height: 320px;
            }

            .timer-progress {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                border-radius: 50%;
                background: conic-gradient(
                    #4f46e5 var(--progress, 0%),
                    #e2e8f0 0%
                );
            }

            .timer-inner {
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                width: 85%;
                height: 85%;
                background: #FFFFFF;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            }

            .dark .timer-inner {
                background: #293548;
            }
        </style>
        <link rel="stylesheet" href="/resources/css/sidebar.css">
        <link rel="stylesheet" href="/resources/css/setting.css">

    </head>

    <body class="font-display bg-background-light dark:bg-background-dark text-text-light dark:text-text-dark min-h-screen">
        <div class="flex h-screen">
            <!-- Sidebar (giống như dashboard) -->
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
                    <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300"
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
                    <a class="nav-link w-full rounded-lg transition-colors bg-primary shadow-md shadow-primary/30 text-white"
                       href="${pageContext.request.contextPath}/timer">
                        <span class="material-icons-outlined text-3xl shrink-0">timer</span>
                        <span class="ml-4 whitespace-nowrap sidebar-text">Bộ hẹn giờ</span>
                    </a>

                </nav>
            </aside>

            <!-- Main Content -->
            <main id="mainContent" class="flex-1 flex flex-col p-6 lg:p-8 overflow-y-auto ml-20 lg:ml-64">
                <!-- Header -->
                <header class="flex justify-between items-center mb-8">
                    <div>
                        <h1 class="text-2xl lg:text-3xl font-bold text-text-light dark:text-white flex items-center">
                            <span class="material-symbols-outlined mr-3 text-primary">timer</span>
                            Bộ hẹn giờ làm việc
                        </h1>
                        <p class="text-slate-500 dark:text-slate-400 mt-2">Tối ưu năng suất với các phương pháp làm việc hiệu quả</p>
                    </div>
                    <div class="flex items-center space-x-4">
                        <button class="p-3 rounded-full hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors" aria-label="Settings" onclick="loadSettingsAndOpen()">
                            <span class="material-icons-outlined text-slate-600 dark:text-slate-300">settings</span>
                        </button>
                        <a href="/logout" class="p-3 rounded-full hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors" aria-label="Logout">
                            <span class="material-icons-outlined text-slate-600 dark:text-slate-300">logout</span>
                        </a>
                    </div>
                </header>

                <div class="flex-1 grid grid-cols-1 lg:grid-cols-3 gap-8">
                    <!-- Left Column: Timer Display & Controls -->
                    <div class="lg:col-span-2">
                        <!-- Timer Card -->
                        <div class="bg-surface-light dark:bg-surface-dark rounded-2xl shadow-lg p-6 lg:p-8 mb-6">
                            <div class="flex flex-col items-center">
                                <!-- Circular Timer -->
                                <div class="timer-circle mb-8">
                                    <div class="timer-progress" id="timerProgress"></div>
                                    <div class="timer-inner">
                                        <div class="text-center">
                                            <div id="timerDisplay" class="text-5xl lg:text-6xl font-bold text-text-light dark:text-white mb-3">
                                                25:00
                                            </div>
                                            <div id="timerStatus" class="text-slate-500 dark:text-slate-400 text-lg">
                                                Sẵn sàng
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Timer Type Selection -->
                                <div class="flex flex-wrap gap-3 mb-8 justify-center">
                                    <button onclick="selectTimerType('POMODORO')" id="pomodoroBtn"
                                            class="group px-6 py-3 bg-primary text-white rounded-full font-semibold hover:bg-indigo-700 transition-all hover:scale-105 flex items-center">
                                        <span class="material-symbols-outlined mr-2">timelapse</span>
                                        Pomodoro <%= pomodoroWork %>/<%= pomodoroBreak %>
                                    </button>
                                    <button onclick="selectTimerType('DEEP_WORK')" id="deepWorkBtn"
                                            class="group px-6 py-3 bg-slate-200 dark:bg-slate-700 text-slate-800 dark:text-slate-200 rounded-full font-semibold hover:bg-slate-300 dark:hover:bg-slate-600 transition-all hover:scale-105 flex items-center">
                                        <span class="material-symbols-outlined mr-2">brightness_5</span>
                                        Deep Work <%= deepWorkDuration %> phút
                                    </button>
                                    <button onclick="selectTimerType('WORK_52_17')" id="work52Btn"
                                            class="group px-6 py-3 bg-slate-200 dark:bg-slate-700 text-slate-800 dark:text-slate-200 rounded-full font-semibold hover:bg-slate-300 dark:hover:bg-slate-600 transition-all hover:scale-105 flex items-center">
                                        <span class="material-symbols-outlined mr-2">restore</span>
                                        52/17 Method
                                    </button>
                                </div>

                                <!-- Timer Controls -->
                                <div class="flex flex-wrap gap-4 mb-8 justify-center" id="timerControls">
                                    <button onclick="startTimer()" id="startBtn"
                                            class="group px-8 py-3 bg-green-600 text-white rounded-lg font-semibold hover:bg-green-700 transition-all hover:scale-105 flex items-center">
                                        <span class="material-symbols-outlined mr-2 group-hover:animate-pulse">play_arrow</span>
                                        Bắt đầu
                                    </button>
                                    <button onclick="pauseTimer()" id="pauseBtn" disabled
                                            class="group px-8 py-3 bg-yellow-600 text-white rounded-lg font-semibold hover:bg-yellow-700 transition-all hover:scale-105 flex items-center">
                                        <span class="material-symbols-outlined mr-2">pause</span>
                                        Tạm dừng
                                    </button>
                                    <button onclick="stopTimer()" id="stopBtn" disabled
                                            class="group px-8 py-3 bg-red-600 text-white rounded-lg font-semibold hover:bg-red-700 transition-all hover:scale-105 flex items-center">
                                        <span class="material-symbols-outlined mr-2">stop</span>
                                        Dừng
                                    </button>
                                </div>

                                <!-- Current Session Info -->
                                <div id="sessionInfo" class="text-center text-slate-600 dark:text-slate-400 bg-slate-100 dark:bg-slate-800/50 rounded-xl p-4 w-full max-w-md">
                                    <% if (activeSessionObj != null) { %>
                                        <p class="font-medium text-primary dark:text-primary"><%= timerTypeDisplay %> đang chạy</p>
                                        <p class="text-sm mt-1"><%= workDuration %> phút làm việc</p>
                                        <% if (!startTimeDisplay.isEmpty()) { %>
                                            <p class="text-xs mt-2 text-slate-500">Bắt đầu lúc: <%= startTimeDisplay %></p>
                                        <% } %>
                                    <% } else { %>
                                        <p class="text-slate-500">Chưa có phiên làm việc nào</p>
                                        <p class="text-xs mt-1">Chọn phương pháp và bắt đầu</p>
                                    <% } %>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Stats -->
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div class="bg-surface-light dark:bg-surface-dark p-6 rounded-2xl shadow group hover:shadow-lg transition-all">
                                <div class="flex items-center mb-4">
                                    <div class="w-12 h-12 bg-secondary-indigo-light rounded-xl flex items-center justify-center mr-4">
                                        <span class="material-symbols-outlined text-primary text-2xl">schedule</span>
                                    </div>
                                    <div>
                                        <div class="text-2xl font-bold text-text-light dark:text-white" id="todayMinutes">
                                            <%= totalFocusMinutes %>
                                        </div>
                                        <div class="text-slate-500 dark:text-slate-400 text-sm">Phút hôm nay</div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="bg-surface-light dark:bg-surface-dark p-6 rounded-2xl shadow group hover:shadow-lg transition-all">
                                <div class="flex items-center mb-4">
                                    <div class="w-12 h-12 bg-secondary-pink rounded-xl flex items-center justify-center mr-4">
                                        <span class="material-symbols-outlined text-pink-600 text-2xl">check_circle</span>
                                    </div>
                                    <div>
                                        <div class="text-2xl font-bold text-text-light dark:text-white" id="todaySessions">
                                            <%= completedSessions %>
                                        </div>
                                        <div class="text-slate-500 dark:text-slate-400 text-sm">Phiên hoàn thành</div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="bg-surface-light dark:bg-surface-dark p-6 rounded-2xl shadow group hover:shadow-lg transition-all">
                                <div class="flex items-center mb-4">
                                    <div class="w-12 h-12 bg-secondary-yellow rounded-xl flex items-center justify-center mr-4">
                                        <span class="material-symbols-outlined text-amber-600 text-2xl">flag</span>
                                    </div>
                                    <div>
                                        <div class="text-2xl font-bold text-text-light dark:text-white" id="todayGoal">
                                            <%= goalPercentage %>%
                                        </div>
                                        <div class="text-slate-500 dark:text-slate-400 text-sm">Mục tiêu ngày</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column: Settings & Tips -->
                    <div class="lg:col-span-1">
                        <!-- Settings Card -->
                        <div class="bg-surface-light dark:bg-surface-dark rounded-2xl shadow-lg p-6 mb-6">
                            <h3 class="text-xl font-bold text-text-light dark:text-white mb-6 flex items-center">
                                <span class="material-symbols-outlined mr-2 text-primary">settings</span>
                                Cài đặt nhanh
                            </h3>

                            <div class="space-y-6">
                                <div>
                                    <div class="flex justify-between items-center mb-3">
                                        <label class="block text-sm font-medium text-slate-700 dark:text-slate-300">
                                            Pomodoro Work
                                        </label>
                                        <span class="text-primary font-semibold" id="pomoWorkValue"><%= pomodoroWork %>p</span>
                                    </div>
                                    <input type="range" min="15" max="60" step="5" 
                                           value="<%= pomodoroWork %>" 
                                           class="w-full h-2 bg-slate-200 dark:bg-slate-700 rounded-lg appearance-none cursor-pointer [&::-webkit-slider-thumb]:appearance-none [&::-webkit-slider-thumb]:h-5 [&::-webkit-slider-thumb]:w-5 [&::-webkit-slider-thumb]:rounded-full [&::-webkit-slider-thumb]:bg-primary"
                                           id="pomoWorkSlider"
                                           onchange="updateQuickSetting('pomodoroWork', this.value)">
                                    <div class="flex justify-between text-xs text-slate-500 dark:text-slate-400 mt-2">
                                        <span>15p</span>
                                        <span>60p</span>
                                    </div>
                                </div>

                                <div>
                                    <div class="flex justify-between items-center mb-3">
                                        <label class="block text-sm font-medium text-slate-700 dark:text-slate-300">
                                            Pomodoro Break
                                        </label>
                                        <span class="text-primary font-semibold" id="pomoBreakValue"><%= pomodoroBreak %>p</span>
                                    </div>
                                    <input type="range" min="1" max="15" step="1" 
                                           value="<%= pomodoroBreak %>" 
                                           class="w-full h-2 bg-slate-200 dark:bg-slate-700 rounded-lg appearance-none cursor-pointer [&::-webkit-slider-thumb]:appearance-none [&::-webkit-slider-thumb]:h-5 [&::-webkit-slider-thumb]:w-5 [&::-webkit-slider-thumb]:rounded-full [&::-webkit-slider-thumb]:bg-primary"
                                           id="pomoBreakSlider"
                                           onchange="updateQuickSetting('pomodoroBreak', this.value)">
                                    <div class="flex justify-between text-xs text-slate-500 dark:text-slate-400 mt-2">
                                        <span>1p</span>
                                        <span>15p</span>
                                    </div>
                                </div>

                                <div class="pt-6 border-t border-slate-200 dark:border-slate-700">
                                    <div class="flex items-center justify-between mb-4">
                                        <div class="flex items-center">
                                            <span class="material-symbols-outlined mr-3 text-slate-600 dark:text-slate-400">volume_up</span>
                                            <span class="text-slate-700 dark:text-slate-300">Âm thanh thông báo</span>
                                        </div>
                                        <label class="relative inline-flex items-center cursor-pointer">
                                            <input type="checkbox" 
                                                   <%= soundEnabled ? "checked" : "" %>
                                                   class="sr-only peer"
                                                   onchange="updateQuickSetting('soundEnabled', this.checked)">
                                            <div class="w-11 h-6 bg-slate-200 peer-focus:outline-none rounded-full peer dark:bg-slate-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-slate-600 peer-checked:bg-primary"></div>
                                        </label>
                                    </div>
                                    
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center">
                                            <span class="material-symbols-outlined mr-3 text-slate-600 dark:text-slate-400">autorenew</span>
                                            <span class="text-slate-700 dark:text-slate-300">Tự động bắt đầu nghỉ</span>
                                        </div>
                                        <label class="relative inline-flex items-center cursor-pointer">
                                            <input type="checkbox" 
                                                   <%= autoStartBreaks ? "checked" : "" %>
                                                   class="sr-only peer"
                                                   onchange="updateQuickSetting('autoStartBreaks', this.checked)">
                                            <div class="w-11 h-6 bg-slate-200 peer-focus:outline-none rounded-full peer dark:bg-slate-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-slate-600 peer-checked:bg-primary"></div>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Tips & Notifications -->
                        <div class="space-y-4">
                            <div class="bg-amber-50 dark:bg-amber-900/20 border border-amber-200 dark:border-amber-800 rounded-2xl p-5 group hover:shadow-md transition-all">
                                <div class="flex items-start">
                                    <div class="w-10 h-10 bg-amber-100 dark:bg-amber-800/50 rounded-xl flex items-center justify-center mr-4">
                                        <span class="material-symbols-outlined text-amber-600 dark:text-amber-400">psychology</span>
                                    </div>
                                    <div>
                                        <h4 class="font-semibold text-amber-800 dark:text-amber-300 mb-2">Mẹo tập trung</h4>
                                        <p class="text-sm text-amber-700 dark:text-amber-400">
                                            Tắt thông báo và đóng các tab không cần thiết để tối ưu hiệu suất làm việc.
                                        </p>
                                    </div>
                                </div>
                            </div>

                            <div class="bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-2xl p-5 group hover:shadow-md transition-all">
                                <div class="flex items-start">
                                    <div class="w-10 h-10 bg-blue-100 dark:bg-blue-800/50 rounded-xl flex items-center justify-center mr-4">
                                        <span class="material-symbols-outlined text-blue-600 dark:text-blue-400">alarm</span>
                                    </div>
                                    <div>
                                        <h4 class="font-semibold text-blue-800 dark:text-blue-300 mb-2">Lịch nghỉ tiếp theo</h4>
                                        <p class="text-sm text-blue-700 dark:text-blue-400">
                                            Thời gian nghỉ sau: <span class="font-bold" id="nextBreakTime"><%= pomodoroWork %></span> phút
                                        </p>
                                    </div>
                                </div>
                            </div>

                            <div class="bg-emerald-50 dark:bg-emerald-900/20 border border-emerald-200 dark:border-emerald-800 rounded-2xl p-5 group hover:shadow-md transition-all">
                                <div class="flex items-start">
                                    <div class="w-10 h-10 bg-emerald-100 dark:bg-emerald-800/50 rounded-xl flex items-center justify-center mr-4">
                                        <span class="material-symbols-outlined text-emerald-600 dark:text-emerald-400">insights</span>
                                    </div>
                                    <div>
                                        <h4 class="font-semibold text-emerald-800 dark:text-emerald-300 mb-2">Hiệu suất tốt nhất</h4>
                                        <p class="text-sm text-emerald-700 dark:text-emerald-400">
                                            Các phiên làm việc ngắn 25 phút thường mang lại hiệu quả cao nhất.
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <!-- JavaScript -->
        <script>
            // ===== GLOBAL VARIABLES =====
            let timerInterval = null;
            let timeLeft = 25 * 60;
            let totalTime = 25 * 60;
            let isRunning = false;
            let currentSessionId = null;
            let timerType = 'POMODORO';
            let selectedTimerType = 'POMODORO'; // Loại timer đang được chọn

            // Lấy cài đặt từ server với giá trị mặc định
            const settings = {
                pomodoroWork: <%= pomodoroWork %>,
                pomodoroBreak: <%= pomodoroBreak %>,
                deepWorkDuration: <%= deepWorkDuration %>,
                work52Duration: <%= work52Duration %>,
                soundEnabled: <%= soundEnabled %>,
                autoStartBreaks: <%= autoStartBreaks %>
            };

            // DOM Elements
            const timerDisplay = document.getElementById('timerDisplay');
            const timerProgress = document.getElementById('timerProgress');
            const timerStatus = document.getElementById('timerStatus');
            const startBtn = document.getElementById('startBtn');
            const pauseBtn = document.getElementById('pauseBtn');
            const stopBtn = document.getElementById('stopBtn');
            const sessionInfo = document.getElementById('sessionInfo');
            
            // Button elements
            const pomodoroBtn = document.getElementById('pomodoroBtn');
            const deepWorkBtn = document.getElementById('deepWorkBtn');
            const work52Btn = document.getElementById('work52Btn');

            // ===== HELPER FUNCTIONS =====
            
            function updateTimerDisplay() {
                if (!timerDisplay) return;

                const minutes = Math.floor(timeLeft / 60);
                const seconds = timeLeft % 60;
                timerDisplay.textContent =
                    minutes.toString().padStart(2, '0') + ':' + seconds.toString().padStart(2, '0');

                // Update progress circle
                if (timerProgress) {
                    const progress = ((totalTime - timeLeft) / totalTime) * 100;
                    timerProgress.style.setProperty('--progress', progress + '%');
                }
            }

            function getTypeName(type) {
                switch (type) {
                    case 'POMODORO':
                        return 'Pomodoro';
                    case 'DEEP_WORK':
                        return 'Deep Work';
                    case 'WORK_52_17':
                        return '52/17 Method';
                    case 'BREAK':
                        return 'Nghỉ ngơi';
                    default:
                        return 'Unknown';
                }
            }

            function showSessionInfo(type, duration) {
                if (!sessionInfo) return;

                const now = new Date();
                const hours = now.getHours().toString().padStart(2, '0');
                const minutes = now.getMinutes().toString().padStart(2, '0');
                const timeString = hours + ':' + minutes;
                
                const typeName = getTypeName(type);
                
                sessionInfo.innerHTML = 
                    '<p class="font-medium text-primary dark:text-primary">' + typeName + ' đang chạy</p>' +
                    '<p class="text-sm mt-1">' + duration + ' phút làm việc</p>' +
                    '<p class="text-xs mt-2 text-slate-500">Bắt đầu lúc: ' + timeString + '</p>';
            }

            function playCompletionSound() {
                try {
                    const audio = new Audio('data:audio/wav;base64,UklGRigAAABXQVZFZm10IBIAAAABAAEAQB8AAEAfAAABAAgAZGF0YQ');
                    audio.volume = 0.3;
                    audio.play().catch(e => console.log('Cannot play sound:', e));
                } catch (e) {
                    console.log('Audio error:', e);
                }
            }

            function showNotification(message) {
                try {
                    if ('Notification' in window && Notification.permission === 'granted') {
                        new Notification('Bộ hẹn giờ', {
                            body: message,
                            icon: 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEyIDIyQzE3LjUyMjggMjIgMjIgMTcuNTIyOCAyMiAxMkMyMiA2LjQ3NzE1IDE3LjUyMjggMiAxMiAyQzYuNDc3MTUgMiAyIDYuNDc3MTUgMiAxMkMyIDE3LjUyMjggNi40NzcxNSAyMiAxMiAyMloiIGZpbGw9IiM0RjQ2RTUiLz4KPHBhdGggZD0iTTEyIDZWMTRMMTYgMTAuNUgxM1Y2SDEyWiIgZmlsbD0id2hpdGUiLz4KPC9zdmc+Cg=='
                        });
                    }
                } catch (e) {
                    console.log('Notification error:', e);
                }
            }

            // Hàm chỉ chọn loại timer (KHÔNG tự động bắt đầu)
            function selectTimerType(type) {
                console.log('selectTimerType called with type:', type);
                
                // Nếu timer đang chạy, không cho phép đổi loại
                if (isRunning) {
                    alert('Vui lòng dừng timer trước khi đổi phương pháp!');
                    return;
                }
                
                // Cập nhật loại timer được chọn
                selectedTimerType = type;
                timerType = type;
                
                // Cập nhật thời gian hiển thị dựa trên loại timer
                updateTimeDisplayForSelectedType();
                
                // Cập nhật giao diện các nút
                updateTimerButtons();
                
                // Cập nhật thông tin session
                updateSessionInfoForSelection();
            }

            // Hàm cập nhật thời gian hiển thị dựa trên loại timer được chọn
            function updateTimeDisplayForSelectedType() {
                var newTotalTime = 25 * 60;
                switch (selectedTimerType) {
                    case 'POMODORO':
                        newTotalTime = (settings.pomodoroWork || 25) * 60;
                        break;
                    case 'DEEP_WORK':
                        newTotalTime = (settings.deepWorkDuration || 90) * 60;
                        break;
                    case 'WORK_52_17':
                        newTotalTime = (settings.work52Duration || 52) * 60;
                        break;
                    default:
                        newTotalTime = 25 * 60;
                }

                totalTime = newTotalTime;
                timeLeft = totalTime;
                updateTimerDisplay();
                
                // Cập nhật trạng thái
                if (timerStatus) {
                    timerStatus.textContent = 'Sẵn sàng - ' + getTypeName(selectedTimerType);
                    timerStatus.className = 'text-slate-500 dark:text-slate-400 text-lg';
                }
            }

            // Hàm cập nhật thông tin session khi chọn phương pháp
            function updateSessionInfoForSelection() {
                if (!sessionInfo) return;
                
                const typeName = getTypeName(selectedTimerType);
                let duration = 25;
                
                switch (selectedTimerType) {
                    case 'POMODORO':
                        duration = settings.pomodoroWork || 25;
                        break;
                    case 'DEEP_WORK':
                        duration = settings.deepWorkDuration || 90;
                        break;
                    case 'WORK_52_17':
                        duration = settings.work52Duration || 52;
                        break;
                }
                
                sessionInfo.innerHTML = 
                    '<p class="font-medium text-primary dark:text-primary">Đã chọn: ' + typeName + '</p>' +
                    '<p class="text-sm mt-1">' + duration + ' phút làm việc</p>' +
                    '<p class="text-xs mt-2 text-slate-500">Nhấn "Bắt đầu" để bắt đầu</p>';
            }

            // Hàm cập nhật màu sắc các nút timer type
            function updateTimerButtons() {
                // Reset tất cả các nút về màu mặc định
                if (pomodoroBtn) {
                    pomodoroBtn.className = 'group px-6 py-3 bg-slate-200 dark:bg-slate-700 text-slate-800 dark:text-slate-200 rounded-full font-semibold hover:bg-slate-300 dark:hover:bg-slate-600 transition-all hover:scale-105 flex items-center';
                }
                if (deepWorkBtn) {
                    deepWorkBtn.className = 'group px-6 py-3 bg-slate-200 dark:bg-slate-700 text-slate-800 dark:text-slate-200 rounded-full font-semibold hover:bg-slate-300 dark:hover:bg-slate-600 transition-all hover:scale-105 flex items-center';
                }
                if (work52Btn) {
                    work52Btn.className = 'group px-6 py-3 bg-slate-200 dark:bg-slate-700 text-slate-800 dark:text-slate-200 rounded-full font-semibold hover:bg-slate-300 dark:hover:bg-slate-600 transition-all hover:scale-105 flex items-center';
                }
                
                // Đổi màu nút được chọn dựa trên loại timer
                switch (selectedTimerType) {
                    case 'POMODORO':
                        if (pomodoroBtn) {
                            pomodoroBtn.className = 'group px-6 py-3 bg-primary text-white rounded-full font-semibold hover:bg-indigo-700 transition-all hover:scale-105 flex items-center';
                        }
                        break;
                    case 'DEEP_WORK':
                        if (deepWorkBtn) {
                            deepWorkBtn.className = 'group px-6 py-3 bg-blue-600 text-white rounded-full font-semibold hover:bg-blue-700 transition-all hover:scale-105 flex items-center';
                        }
                        break;
                    case 'WORK_52_17':
                        if (work52Btn) {
                            work52Btn.className = 'group px-6 py-3 bg-emerald-600 text-white rounded-full font-semibold hover:bg-emerald-700 transition-all hover:scale-105 flex items-center';
                        }
                        break;
                }
            }

            // ===== MAIN TIMER FUNCTIONS =====
            
            // Start timer - sử dụng selectedTimerType
            function startTimer() {
                const type = selectedTimerType;
                
                console.log('startTimer called with type:', type);
                
                if (isRunning) {
                    console.log('Timer is already running');
                    return;
                }

                timerType = type;

                // Set time based on type với fallback an toàn
                var newTotalTime = 25 * 60;
                switch (type) {
                    case 'POMODORO':
                        newTotalTime = (settings.pomodoroWork || 25) * 60;
                        break;
                    case 'DEEP_WORK':
                        newTotalTime = (settings.deepWorkDuration || 90) * 60;
                        break;
                    case 'WORK_52_17':
                        newTotalTime = (settings.work52Duration || 52) * 60;
                        break;
                    default:
                        newTotalTime = 25 * 60;
                }

                totalTime = newTotalTime;
                timeLeft = totalTime;
                isRunning = true;

                // Update UI
                if (timerStatus) {
                    timerStatus.textContent = 'Đang chạy - ' + getTypeName(type);
                    timerStatus.className = 'text-green-600 dark:text-green-400 text-lg font-medium';
                }
                if (startBtn) startBtn.disabled = true;
                if (pauseBtn) {
                    pauseBtn.disabled = false;
                    pauseBtn.textContent = 'Tạm dừng';
                }
                if (stopBtn) stopBtn.disabled = false;

                updateTimerDisplay();

                // Start interval
                timerInterval = setInterval(function() {
                    timeLeft--;
                    updateTimerDisplay();

                    if (timeLeft <= 0) {
                        clearInterval(timerInterval);
                        isRunning = false;
                        timerComplete();
                    }
                }, 1000);

                // Send request to server
                fetch('<%= request.getContextPath() %>/timer/start', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'type=' + encodeURIComponent(type)
                })
                .then(function(response) {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(function(data) {
                    console.log('Start response:', data);
                    if (data && data.success) {
                        currentSessionId = data.sessionId || null;
                        showSessionInfo(type, data.workDuration || (totalTime / 60));
                    }
                })
                .catch(function(error) {
                    console.error('Error starting timer:', error);
                    // Vẫn cho phép timer chạy local nếu server fail
                    showSessionInfo(type, totalTime / 60);
                });
            }

            // Pause timer
            function pauseTimer() {
                console.log('pauseTimer called');
                if (!isRunning || !timerInterval) return;

                clearInterval(timerInterval);
                isRunning = false;
                if (timerStatus) {
                    timerStatus.textContent = 'Tạm dừng';
                    timerStatus.className = 'text-yellow-600 dark:text-yellow-400 text-lg font-medium';
                }
                if (pauseBtn) {
                    pauseBtn.textContent = 'Tiếp tục';
                    pauseBtn.onclick = resumeTimer;
                }

                // Send pause request to server nếu có session
                if (currentSessionId) {
                    fetch('<%= request.getContextPath() %>/timer/pause', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'sessionId=' + encodeURIComponent(currentSessionId)
                    }).catch(function(error) { console.error('Pause error:', error); });
                }
            }

            // Resume timer
            function resumeTimer() {
                console.log('resumeTimer called');
                if (isRunning) return;

                isRunning = true;
                if (timerStatus) {
                    timerStatus.textContent = 'Đang chạy - ' + getTypeName(timerType);
                    timerStatus.className = 'text-green-600 dark:text-green-400 text-lg font-medium';
                }
                if (pauseBtn) {
                    pauseBtn.textContent = 'Tạm dừng';
                    pauseBtn.onclick = pauseTimer;
                }

                timerInterval = setInterval(function() {
                    timeLeft--;
                    updateTimerDisplay();

                    if (timeLeft <= 0) {
                        clearInterval(timerInterval);
                        isRunning = false;
                        timerComplete();
                    }
                }, 1000);

                // Send resume request
                if (currentSessionId) {
                    fetch('<%= request.getContextPath() %>/timer/resume', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'sessionId=' + encodeURIComponent(currentSessionId)
                    }).catch(function(error) { console.error('Resume error:', error); });
                }
            }

            // Stop timer
            function stopTimer() {
                console.log('stopTimer called');
                if (timerInterval) {
                    clearInterval(timerInterval);
                }
                isRunning = false;
                timeLeft = totalTime;
                updateTimerDisplay();

                if (timerStatus) {
                    timerStatus.textContent = 'Đã dừng';
                    timerStatus.className = 'text-red-600 dark:text-red-400 text-lg font-medium';
                }
                if (startBtn) startBtn.disabled = false;
                if (pauseBtn) {
                    pauseBtn.disabled = true;
                    pauseBtn.textContent = 'Tạm dừng';
                    pauseBtn.onclick = pauseTimer;
                }
                if (stopBtn) stopBtn.disabled = true;

                // Khi dừng, hiển thị thông tin phương pháp đang được chọn
                updateSessionInfoForSelection();

                // Send stop request
                if (currentSessionId) {
                    fetch('<%= request.getContextPath() %>/timer/stop', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'sessionId=' + encodeURIComponent(currentSessionId)
                    }).catch(function(error) { console.error('Stop error:', error); });
                    currentSessionId = null;
                }
            }

            // Timer complete
            function timerComplete() {
                console.log('Timer completed');
                if (timerStatus) {
                    timerStatus.textContent = 'Hoàn thành!';
                    timerStatus.className = 'text-emerald-600 dark:text-emerald-400 text-lg font-medium animate-pulse';
                }
                if (startBtn) startBtn.disabled = false;
                if (pauseBtn) pauseBtn.disabled = true;
                if (stopBtn) stopBtn.disabled = true;

                // Thêm hiệu ứng hoàn thành
                if (timerProgress) {
                    timerProgress.style.background = 'conic-gradient(#10b981 var(--progress, 100%), #e2e8f0 0%)';
                }

                // Play sound if enabled
                if (settings.soundEnabled) {
                    playCompletionSound();
                }

                // Show notification
                showNotification('Timer hoàn thành! Đến lúc nghỉ ngơi.');

                // Auto-start break if enabled
                if (settings.autoStartBreaks && timerType === 'POMODORO') {
                    setTimeout(function() {
                        startBreak();
                    }, 2000);
                }

                // Complete session on server
                if (currentSessionId) {
                    fetch('<%= request.getContextPath() %>/timer/complete', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'sessionId=' + encodeURIComponent(currentSessionId)
                    }).catch(function(error) { console.error('Complete error:', error); });
                    currentSessionId = null;
                }
            }

            // Start break timer
            function startBreak() {
                console.log('Starting break timer');
                totalTime = (settings.pomodoroBreak || 5) * 60;
                timeLeft = totalTime;
                isRunning = true;
                timerType = 'BREAK';

                if (timerStatus) {
                    timerStatus.textContent = 'Nghỉ ngơi';
                    timerStatus.className = 'text-blue-600 dark:text-blue-400 text-lg font-medium';
                }
                if (startBtn) startBtn.disabled = true;
                if (pauseBtn) {
                    pauseBtn.disabled = false;
                    pauseBtn.textContent = 'Tạm dừng';
                    pauseBtn.onclick = pauseTimer;
                }
                if (stopBtn) stopBtn.disabled = false;

                // Reset progress circle color
                if (timerProgress) {
                    timerProgress.style.background = 'conic-gradient(#4f46e5 var(--progress, 0%), #e2e8f0 0%)';
                }

                updateTimerDisplay();

                timerInterval = setInterval(function() {
                    timeLeft--;
                    updateTimerDisplay();

                    if (timeLeft <= 0) {
                        clearInterval(timerInterval);
                        isRunning = false;
                        showNotification('Hết giờ nghỉ! Sẵn sàng cho phiên tiếp theo.');
                        if (timerStatus) {
                            timerStatus.textContent = 'Sẵn sàng';
                            timerStatus.className = 'text-slate-500 dark:text-slate-400 text-lg';
                        }
                        if (startBtn) startBtn.disabled = false;
                        if (pauseBtn) pauseBtn.disabled = true;
                        if (stopBtn) stopBtn.disabled = true;
                        if (timerProgress) {
                            timerProgress.style.background = 'conic-gradient(#4f46e5 var(--progress, 0%), #e2e8f0 0%)';
                        }
                    }
                }, 1000);
            }

            // Update quick settings
            function updateQuickSetting(setting, value) {
                console.log('Updating setting:', setting, 'value:', value);
                
                // Update display for sliders
                if (setting === 'pomodoroWork') {
                    const elem = document.getElementById('pomoWorkValue');
                    if (elem) elem.textContent = value + 'p';
                    settings.pomodoroWork = parseInt(value);
                    
                    // Update next break time display
                    const nextBreakElem = document.getElementById('nextBreakTime');
                    if (nextBreakElem) nextBreakElem.textContent = value;
                    
                    // Update Pomodoro button text
                    const pomoBtn = document.getElementById('pomodoroBtn');
                    if (pomoBtn) {
                        pomoBtn.innerHTML = '<span class="material-symbols-outlined mr-2">timelapse</span>Pomodoro ' + value + '/' + settings.pomodoroBreak;
                    }
                    
                    // Nếu đang chọn Pomodoro, cập nhật thời gian hiển thị
                    if (selectedTimerType === 'POMODORO' && !isRunning) {
                        updateTimeDisplayForSelectedType();
                        updateSessionInfoForSelection();
                    }
                } else if (setting === 'pomodoroBreak') {
                    const elem = document.getElementById('pomoBreakValue');
                    if (elem) elem.textContent = value + 'p';
                    settings.pomodoroBreak = parseInt(value);
                    
                    // Update Pomodoro button text
                    const pomoBtn = document.getElementById('pomodoroBtn');
                    if (pomoBtn) {
                        pomoBtn.innerHTML = '<span class="material-symbols-outlined mr-2">timelapse</span>Pomodoro ' + settings.pomodoroWork + '/' + value;
                    }
                } else if (setting === 'soundEnabled') {
                    settings.soundEnabled = Boolean(value);
                } else if (setting === 'autoStartBreaks') {
                    settings.autoStartBreaks = Boolean(value);
                }

                // Send update to server
                fetch('<%= request.getContextPath() %>/timer/settings/quick', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        setting: setting,
                        value: value
                    })
                }).catch(function(error) { console.error('Settings update error:', error); });
            }

            // ===== INITIALIZATION =====
            
            // Request notification permission
            if ('Notification' in window && Notification.permission === 'default') {
                Notification.requestPermission();
            }

            // Initialize display
            updateTimerDisplay();
            
            // Cập nhật màu nút ban đầu (Pomodoro được chọn mặc định)
            updateTimerButtons();
            
            // Cập nhật thông tin session ban đầu
            updateSessionInfoForSelection();
            
            // Make functions available globally
            window.startTimer = startTimer;
            window.pauseTimer = pauseTimer;
            window.resumeTimer = resumeTimer;
            window.stopTimer = stopTimer;
            window.updateQuickSetting = updateQuickSetting;
            window.selectTimerType = selectTimerType;
            
            console.log('Timer initialization complete');
        </script>
                <%-- 1. THÊM LỚP PHỦ CÀI ĐẶT TẠI ĐÂY --%>
        <%-- Đảm bảo toàn bộ HTML của lớp phủ được tải vào DOM trước khi JS chạy --%>
        <%@ include file="settings-overlay.jsp" %>

        <script src="/resources/js/sidebar.js"></script>
        <script src="/resources/js/setting.js"></script>
    </body>
</html>