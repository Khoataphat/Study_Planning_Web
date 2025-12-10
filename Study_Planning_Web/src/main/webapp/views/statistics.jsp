<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="currentTheme" value="${empty theme ? 'light' : theme}" />
<!DOCTYPE html>
<html lang="en" class="${currentTheme == 'dark' ? 'dark' : ''}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistics - PlanZ</title>
    
    <!-- Tailwind CSS & Plugins -->
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <!-- Custom Config & Styles -->
    <script src="../resources/js/tailwind-config.js"></script>
    <link rel="stylesheet" href="../resources/css/pastel-overrides.css">
    
    <!-- khoa -->
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300..700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet" />
    <script>
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        colors: {
                            primary: "#4F46E5",
                            "background-light": "#F8FAFC",
                            "background-dark": "#0F172A",
                            "text-color": "#1E293B",
                        },
                        fontFamily: {
                            display: ["Quicksand", "sans-serif"],
                        },
                        borderRadius: {
                            DEFAULT: "0.75rem",
                        },
                    },
                },
            };
        </script>
        <link rel="stylesheet" href="/resources/css/sidebar.css">
        <!-- khoa -->
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

                    <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300"
                       href="${pageContext.request.contextPath}/dashboard">
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

                    <a class="nav-link w-full rounded-lg transition-colors bg-primary shadow-md shadow-primary/30 text-white"
                       href="${pageContext.request.contextPath}/statistics">
                        <span class="material-icons-outlined text-3xl shrink-0">interests</span>
                        <span class="ml-4 whitespace-nowrap sidebar-text">Thống kê</span>
                    </a>
                </nav>
            </aside>

            <main id="mainContent" class="flex-1 flex flex-col p-6 lg:p-8 overflow-y-auto">
                <header class="flex justify-between items-center mb-6">
                    <div>
                        <h1 class="text-2xl font-bold text-text-color dark:text-white">Thống Kê</h1>
                        <p class="text-slate-500 dark:text-slate-400">Xem thống kê học tập của bạn</p>
                    </div>
                    <div class="flex items-center space-x-4">
                        <button class="p-2 rounded-full hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors" aria-label="Settings">
                            <span class="material-icons-outlined text-slate-600 dark:text-slate-300">settings</span>
                        </button>
                        <a href="/logout" class="p-2 rounded-full hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors" aria-label="Logout">
                            <span class="material-icons-outlined text-slate-600 dark:text-slate-300">logout</span>
                        </a>
                    </div>
                </header>

                <div class="flex-1 flex items-center justify-center">
                    <div class="text-center">
                        <span class="material-icons-outlined text-6xl text-slate-300 mb-4">analytics</span>
                        <h2 class="text-xl font-semibold text-slate-600">Tính năng đang phát triển</h2>
                        <p class="text-slate-400">Vui lòng quay lại sau!</p>
                    </div>
                </div>
            </main>
        </div>

    <script src="/resources/js/sidebar.js"></script>
</body>
</html>
