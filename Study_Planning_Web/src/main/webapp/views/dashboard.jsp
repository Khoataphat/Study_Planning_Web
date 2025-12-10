<%-- 
    Document   : dashboard
    Created on : 28 thg 11, 2025, 22:43:37
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
                </nav>
            </aside>

            <main id="mainContent" class="flex-1 flex flex-col p-6 lg:p-8 overflow-y-auto">
                <header class="flex justify-between items-center mb-6">
                    <div>
                        <h1 class="text-2xl font-bold text-text-color dark:text-white">Chào buổi sáng, ${user.username}!</h1>
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

                        <%-- [THÊM NỘI DUNG TỔNG QUÁT] Các thẻ chỉ số chính --%>
                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-6">
                            <div class="bg-white dark:bg-slate-800 p-5 rounded-lg shadow-md border-t-4 border-pastel-purple">
                                <p class="text-sm font-medium text-slate-500 dark:text-slate-400">Tổng giờ học</p>
                                <p class="text-3xl font-bold text-text-color dark:text-white mt-1">45.5 giờ</p>
                                <p class="text-xs text-green-500 mt-1 flex items-center">
                                    <span class="material-icons-outlined text-lg">arrow_upward</span> 8% so với tuần trước
                                </p>
                            </div>
                            <div class="bg-white dark:bg-slate-800 p-5 rounded-lg shadow-md border-t-4 border-pastel-pink">
                                <p class="text-sm font-medium text-slate-500 dark:text-slate-400">Nhiệm vụ xong</p>
                                <p class="text-3xl font-bold text-text-color dark:text-white mt-1">18/20</p>
                                <p class="text-xs text-slate-500 dark:text-slate-400 mt-1">Tỷ lệ hoàn thành 90%</p>
                            </div>
                            <div class="bg-white dark:bg-slate-800 p-5 rounded-lg shadow-md border-t-4 border-pastel-yellow">
                                <p class="text-sm font-medium text-slate-500 dark:text-slate-400">Sự kiện sắp tới</p>
                                <p class="text-3xl font-bold text-text-color dark:text-white mt-1">3</p>
                                <p class="text-xs text-slate-500 dark:text-slate-400 mt-1">Trong tuần này</p>
                            </div>
                        </div>


                        <div class="bg-white dark:bg-slate-900 p-6 rounded-lg shadow-sm flex-grow">
                            <h3 class="font-bold text-lg mb-4 text-text-color dark:text-white">📅 Thời khóa biểu Tuần</h3>

                            <div class="border border-slate-200 dark:border-slate-700 rounded-lg overflow-hidden">

                                <div class="grid timetable-grid bg-white dark:bg-slate-800/50">

                                    <div class="p-3 text-center font-semibold text-sm text-text-color dark:text-white border-b border-r border-slate-200 dark:border-slate-700">Thứ 2</div>
                                    <div class="p-3 text-center font-semibold text-sm text-text-color dark:text-white border-b border-r border-slate-200 dark:border-slate-700">Thứ 3</div>
                                    <div class="p-3 text-center font-semibold text-sm text-text-color dark:text-white border-b border-r border-slate-200 dark:border-slate-700">Thứ 4</div>
                                    <div class="p-3 text-center font-semibold text-sm text-text-color dark:text-white border-b border-r border-slate-200 dark:border-slate-700">Thứ 5</div>
                                    <div class="p-3 text-center font-semibold text-sm text-text-color dark:text-white border-b border-slate-200 dark:border-slate-700">Thứ 6</div>

                                    <c:set var="lastDayIndex" value="-1" />
                                    <%-- Sử dụng Monday (0) - Friday (4) --%>
                                    <c:forEach var="slot" items="${dash.timetableList}" varStatus="slotStatus">

                                        <%-- [QUAN TRỌNG] Logic điền các ô trống --%>
                                        <c:set var="currentDayIndex" value="${slot.dayOfWeek.ordinal()}" /> 
                                        <c:set var="emptyCells" value="${currentDayIndex - lastDayIndex - 1}" />

                                        <c:if test="${emptyCells > 0}">
                                            <c:forEach begin="1" end="${emptyCells}" varStatus="emptyCellStatus">
                                                <div class="bg-white dark:bg-slate-900 p-2 min-h-[80px] border-b border-slate-200 dark:border-slate-700 
                                                     ${(lastDayIndex + emptyCellStatus.index + 1) % 5 ne 0 ? 'border-r' : ''}">
                                                </div>
                                            </c:forEach>
                                        </c:if>

                                        <c:set var="bgColor" value="${slot.type eq 'HỌC_TẬP' ? '#A5B4FC' : (slot.type eq 'GIẢI_TRÍ' ? '#F9A8D4' : '#FDE68A')}" />
                                        <c:set var="isEndOfRow" value="${currentDayIndex % 5 eq 4}" />

                                        <div class="p-3 m-1 rounded-md text-white shadow-md cursor-pointer transition-transform hover:scale-[1.02] relative border-b border-slate-200 dark:border-slate-700 ${!isEndOfRow ? 'border-r' : ''}" style="background-color: ${bgColor}; min-height: 80px;">
                                            <p class="font-bold text-sm">${slot.subject}</p>
                                            <p class="text-xs opacity-90">${slot.startTime} - ${slot.endTime}</p>
                                        </div>

                                        <c:set var="lastDayIndex" value="${currentDayIndex}" />

                                    </c:forEach>

                                    <%-- Điền các ô trống còn lại cuối hàng --%>
                                    <c:if test="${lastDayIndex < 4}">
                                        <c:set var="emptyCellsEnd" value="${4 - lastDayIndex}" />
                                        <c:forEach begin="1" end="${emptyCellsEnd}" varStatus="emptyCellStatus">
                                            <div class="bg-white dark:bg-slate-900 p-2 min-h-[80px] border-b border-slate-200 dark:border-slate-700
                                                 ${(lastDayIndex + emptyCellStatus.index + 1) % 5 ne 0 ? 'border-r' : ''}">
                                            </div>
                                        </c:forEach>
                                    </c:if>

                                    <c:if test="${empty dash.timetableList}">
                                        <div class="col-span-5 text-center p-8 text-slate-500 dark:text-slate-400 border-b border-slate-200 dark:border-slate-700">
                                            Chưa có thời khóa biểu nào. Hãy tạo slot đầu tiên của bạn!
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div class="lg:col-span-1 flex flex-col gap-6">
                        <%-- [THÊM] Thẻ Phân bổ thời gian (Dashboard) --%>
                        <div class="bg-white dark:bg-slate-900 p-6 rounded-lg shadow-sm">
                            <h3 class="font-bold text-lg mb-4 text-text-color dark:text-white">📊 Phân bổ thời gian</h3>
                            <div class="flex flex-col sm:flex-row gap-6 sm:items-center">
                                <div class="relative w-36 h-36 flex-shrink-0 mx-auto sm:mx-0">

                                    <div class="absolute inset-0 flex items-center justify-center">
                                        <div
                                            class="w-20 h-20 bg-white dark:bg-slate-900 rounded-full flex flex-col items-center justify-center border-2 border-slate-200 dark:border-slate-700">
                                            <span class="text-2xl font-bold text-text-color dark:text-white">45%</span>
                                            <span class="text-xs text-slate-500 dark:text-slate-400">Học tập</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="space-y-3">
                                    <div class="flex items-center">
                                        <div class="w-3 h-3 rounded-full bg-pastel-purple mr-3"></div>
                                        <span class="text-sm font-medium text-text-color dark:text-slate-300">Học tập (45%)</span>
                                    </div>
                                    <div class="flex items-center">
                                        <div class="w-3 h-3 rounded-full bg-pastel-pink mr-3"></div>
                                        <span class="text-sm font-medium text-text-color dark:text-slate-300">Giải trí (30%)</span>
                                    </div>
                                    <div class="flex items-center">
                                        <div class="w-3 h-3 rounded-full bg-pastel-yellow mr-3"></div>
                                        <span class="text-sm font-medium text-text-color dark:text-slate-300">Công việc (20%)</span>
                                    </div>
                                    <div class="flex items-center">
                                        <div class="w-3 h-3 rounded-full bg-pastel-light-purple mr-3"></div>
                                        <span class="text-sm font-medium text-text-color dark:text-slate-300">Khác (5%)</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- [THÊM] Biểu đồ hoạt động (Dashboard) --%>
                        <div class="bg-white dark:bg-slate-900 p-6 rounded-lg shadow-sm">
                            <h3 class="font-bold text-lg mb-4 text-text-color dark:text-white">📈 Thống kê hoạt động</h3>

                            <div class="flex flex-wrap gap-4 mt-4">
                                <div class="flex items-center space-x-2">
                                    <div class="w-3 h-3 rounded-full bg-pastel-purple"></div>
                                    <span class="text-xs font-medium text-text-color dark:text-slate-300">Học tập</span>
                                </div>
                                <div class="flex items-center space-x-2">
                                    <div class="w-3 h-3 rounded-full bg-pastel-pink"></div>
                                    <span class="text-xs font-medium text-text-color dark:text-slate-300">Giải trí</span>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </main>
        </div>

        <%-- 1. THÊM LỚP PHỦ CÀI ĐẶT TẠI ĐÂY --%>
        <%-- Đảm bảo toàn bộ HTML của lớp phủ được tải vào DOM trước khi JS chạy --%>
        <%@ include file="settings-overlay.jsp" %>

        <script src="/resources/js/sidebar.js"></script>
        <script src="/resources/js/setting.js"></script>

    </body>

</html>
