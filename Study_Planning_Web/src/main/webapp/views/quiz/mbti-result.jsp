<%-- 
    Document   : mbti-result
    Created on : 21 thg 12, 2025, 18:26:23
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="currentTheme" value="${empty theme ? 'light' : theme}" />
<!DOCTYPE html>
<html lang="vi" class="${currentTheme == 'dark' ? 'dark' : ''}">

<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Kết quả MBTI - ${mbtiResult.mbtiType}</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300..700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;700&amp;display=swap" rel="stylesheet" />
    
    <style>
        .gradient-bg {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .dimension-fill {
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            height: 100%;
            border-radius: 0.5rem;
            transition: width 1s ease;
        }
        
        .mbti-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .animate-fade-in {
            animation: fadeIn 0.6s ease-out;
        }
        
        @keyframes slideIn {
            from { opacity: 0; transform: translateX(-20px); }
            to { opacity: 1; transform: translateX(0); }
        }
        
        .animate-slide-in {
            animation: slideIn 0.4s ease-out;
        }
        
        .type-highlight {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: bold;
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
                        "success": "#10B981",
                        "warning": "#F59E0B",
                        "danger": "#EF4444",
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

                <%-- Timer --%>
                <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300"
                   href="${pageContext.request.contextPath}/timer">
                    <span class="material-icons-outlined text-3xl shrink-0">timer</span>
                    <span class="ml-4 whitespace-nowrap sidebar-text">Bộ hẹn giờ</span>
                </a>
            </nav>
        </aside>

        <main id="mainContent" class="flex-1 flex flex-col p-6 lg:p-8 ml-20 overflow-y-auto">
            <header class="flex justify-between items-center mb-8">
                <div>
                    <h1 class="text-3xl font-bold text-slate-900 dark:text-white flex items-center">
                        <span class="material-symbols-outlined mr-3 text-quiz-purple dark:text-pastel-purple">sentiment_satisfied</span>
                        Kết quả MBTI
                    </h1>
                    <p class="text-slate-500 dark:text-slate-400 mt-2">Khám phá tính cách thật của bạn</p>
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

            <!-- Main Result Card -->
            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-xl p-8 mb-8 animate-fade-in">
                <div class="text-center mb-8">
                    <div class="text-7xl font-black mbti-badge mb-4">
                        ${mbtiResult.mbtiType}
                    </div>
                    <h2 class="text-2xl font-bold text-slate-900 dark:text-white mb-4">
                        <c:choose>
                            <c:when test="${mbtiResult.mbtiType == 'INTJ'}">Kiến trúc sư</c:when>
                            <c:when test="${mbtiResult.mbtiType == 'INTP'}">Nhà tư duy</c:when>
                            <c:when test="${mbtiResult.mbtiType == 'ENTJ'}">Người chỉ huy</c:when>
                            <c:when test="${mbtiResult.mbtiType == 'ENTP'}">Người tranh luận</c:when>
                            <c:when test="${mbtiResult.mbtiType == 'INFJ'}">Người che chở</c:when>
                            <c:when test="${mbtiResult.mbtiType == 'INFP'}">Người hòa giải</c:when>
                            <c:when test="${mbtiResult.mbtiType == 'ENFJ'}">Người cho đi</c:when>
                            <c:when test="${mbtiResult.mbtiType == 'ENFP'}">Người truyền cảm hứng</c:when>
                            <c:when test="${mbtiResult.mbtiType == 'ISTJ'}">Người có trách nhiệm</c:when>
                            <c:when test="${mbtiResult.mbtiType == 'ISFJ'}">Người bảo vệ</c:when>
                            <c:when test="${mbtiResult.mbtiType == 'ESTJ'}">Người quản lý</c:when>
                            <c:when test="${mbtiResult.mbtiType == 'ESFJ'}">Người chăm sóc</c:when>
                            <c:when test="${mbtiResult.mbtiType == 'ISTP'}">Thợ thủ công</c:when>
                            <c:when test="${mbtiResult.mbtiType == 'ISFP'}">Người nghệ sĩ</c:when>
                            <c:when test="${mbtiResult.mbtiType == 'ESTP'}">Doanh nhân</c:when>
                            <c:when test="${mbtiResult.mbtiType == 'ESFP'}">Người trình diễn</c:when>
                            <c:otherwise>Nhà phân tích</c:otherwise>
                        </c:choose>
                    </h2>
                    <p class="text-lg text-slate-600 dark:text-slate-300 max-w-3xl mx-auto">
                        ${mbtiResult.description}
                    </p>
                </div>
            </div>

            <!-- Dimensions Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                <!-- E/I Dimension -->
                <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 animate-slide-in">
                    <div class="flex justify-between items-center mb-4">
                        <h3 class="text-lg font-semibold text-slate-900 dark:text-white">Hướng ngoại (E) ↔ Hướng nội (I)</h3>
                        <span class="font-bold text-quiz-purple dark:text-pastel-purple">
                            ${mbtiResult.dimensionEI}
                        </span>
                    </div>
                    <div class="flex items-center justify-between mb-2">
                        <span class="text-sm text-slate-500 dark:text-slate-400">Hướng ngoại</span>
                        <span class="text-sm text-slate-500 dark:text-slate-400">Hướng nội</span>
                    </div>
                    <div class="h-3 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden mb-4">
                        <div class="dimension-fill" id="ei-progress"></div>
                    </div>
                </div>

                <!-- S/N Dimension -->
                <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 animate-slide-in" style="animation-delay: 0.1s">
                    <div class="flex justify-between items-center mb-4">
                        <h3 class="text-lg font-semibold text-slate-900 dark:text-white">Giác quan (S) ↔ Trực giác (N)</h3>
                        <span class="font-bold text-quiz-purple dark:text-pastel-purple">
                            ${mbtiResult.dimensionSN}
                        </span>
                    </div>
                    <div class="flex items-center justify-between mb-2">
                        <span class="text-sm text-slate-500 dark:text-slate-400">Giác quan</span>
                        <span class="text-sm text-slate-500 dark:text-slate-400">Trực giác</span>
                    </div>
                    <div class="h-3 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden mb-4">
                        <div class="dimension-fill" id="sn-progress"></div>
                    </div>
                </div>

                <!-- T/F Dimension -->
                <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 animate-slide-in" style="animation-delay: 0.2s">
                    <div class="flex justify-between items-center mb-4">
                        <h3 class="text-lg font-semibold text-slate-900 dark:text-white">Lý trí (T) ↔ Cảm xúc (F)</h3>
                        <span class="font-bold text-quiz-purple dark:text-pastel-purple">
                            ${mbtiResult.dimensionTF}
                        </span>
                    </div>
                    <div class="flex items-center justify-between mb-2">
                        <span class="text-sm text-slate-500 dark:text-slate-400">Lý trí</span>
                        <span class="text-sm text-slate-500 dark:text-slate-400">Cảm xúc</span>
                    </div>
                    <div class="h-3 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden mb-4">
                        <div class="dimension-fill" id="tf-progress"></div>
                    </div>
                </div>

                <!-- J/P Dimension -->
                <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 animate-slide-in" style="animation-delay: 0.3s">
                    <div class="flex justify-between items-center mb-4">
                        <h3 class="text-lg font-semibold text-slate-900 dark:text-white">Nguyên tắc (J) ↔ Linh hoạt (P)</h3>
                        <span class="font-bold text-quiz-purple dark:text-pastel-purple">
                            ${mbtiResult.dimensionJP}
                        </span>
                    </div>
                    <div class="flex items-center justify-between mb-2">
                        <span class="text-sm text-slate-500 dark:text-slate-400">Nguyên tắc</span>
                        <span class="text-sm text-slate-500 dark:text-slate-400">Linh hoạt</span>
                    </div>
                    <div class="h-3 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden mb-4">
                        <div class="dimension-fill" id="jp-progress"></div>
                    </div>
                </div>
            </div>

            <!-- Strengths & Weaknesses -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                <!-- Strengths -->
                <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6">
                    <div class="flex items-center mb-6">
                        <div class="w-12 h-12 rounded-xl bg-gradient-to-br from-green-400 to-green-600 flex items-center justify-center mr-4">
                            <span class="material-symbols-outlined text-white text-2xl">military_tech</span>
                        </div>
                        <h3 class="text-xl font-bold text-slate-900 dark:text-white">Điểm mạnh</h3>
                    </div>
                    <div class="space-y-4">
                        <c:forEach var="strength" items="${mbtiResult.strengths}" varStatus="status">
                            <div class="flex items-start">
                                <span class="material-symbols-outlined text-green-500 dark:text-green-400 mr-3 mt-1">check_circle</span>
                                <span class="text-slate-700 dark:text-slate-300">${strength}</span>
                            </div>
                        </c:forEach>
                        <c:if test="${empty mbtiResult.strengths}">
                            <div class="flex items-start">
                                <span class="material-symbols-outlined text-green-500 dark:text-green-400 mr-3 mt-1">check_circle</span>
                                <span class="text-slate-700 dark:text-slate-300">Tư duy logic và phân tích</span>
                            </div>
                            <div class="flex items-start">
                                <span class="material-symbols-outlined text-green-500 dark:text-green-400 mr-3 mt-1">check_circle</span>
                                <span class="text-slate-700 dark:text-slate-300">Khả năng lập kế hoạch chiến lược</span>
                            </div>
                            <div class="flex items-start">
                                <span class="material-symbols-outlined text-green-500 dark:text-green-400 mr-3 mt-1">check_circle</span>
                                <span class="text-slate-700 dark:text-slate-300">Độc lập và tự chủ cao</span>
                            </div>
                            <div class="flex items-start">
                                <span class="material-symbols-outlined text-green-500 dark:text-green-400 mr-3 mt-1">check_circle</span>
                                <span class="text-slate-700 dark:text-slate-300">Quyết tâm và kiên trì</span>
                            </div>
                            <div class="flex items-start">
                                <span class="material-symbols-outlined text-green-500 dark:text-green-400 mr-3 mt-1">check_circle</span>
                                <span class="text-slate-700 dark:text-slate-300">Khả năng học hỏi nhanh</span>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Weaknesses -->
                <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6">
                    <div class="flex items-center mb-6">
                        <div class="w-12 h-12 rounded-xl bg-gradient-to-br from-yellow-400 to-yellow-600 flex items-center justify-center mr-4">
                            <span class="material-symbols-outlined text-white text-2xl">warning</span>
                        </div>
                        <h3 class="text-xl font-bold text-slate-900 dark:text-white">Điểm cần cải thiện</h3>
                    </div>
                    <div class="space-y-4">
                        <c:forEach var="weakness" items="${mbtiResult.weaknesses}" varStatus="status">
                            <div class="flex items-start">
                                <span class="material-symbols-outlined text-yellow-500 dark:text-yellow-400 mr-3 mt-1">warning</span>
                                <span class="text-slate-700 dark:text-slate-300">${weakness}</span>
                            </div>
                        </c:forEach>
                        <c:if test="${empty mbtiResult.weaknesses}">
                            <div class="flex items-start">
                                <span class="material-symbols-outlined text-yellow-500 dark:text-yellow-400 mr-3 mt-1">warning</span>
                                <span class="text-slate-700 dark:text-slate-300">Đôi khi quá cầu toàn</span>
                            </div>
                            <div class="flex items-start">
                                <span class="material-symbols-outlined text-yellow-500 dark:text-yellow-400 mr-3 mt-1">warning</span>
                                <span class="text-slate-700 dark:text-slate-300">Khó thể hiện cảm xúc</span>
                            </div>
                            <div class="flex items-start">
                                <span class="material-symbols-outlined text-yellow-500 dark:text-yellow-400 mr-3 mt-1">warning</span>
                                <span class="text-slate-700 dark:text-slate-300">Có thể thiếu kiên nhẫn</span>
                            </div>
                            <div class="flex items-start">
                                <span class="material-symbols-outlined text-yellow-500 dark:text-yellow-400 mr-3 mt-1">warning</span>
                                <span class="text-slate-700 dark:text-slate-300">Khó chấp nhận ý kiến trái chiều</span>
                            </div>
                            <div class="flex items-start">
                                <span class="material-symbols-outlined text-yellow-500 dark:text-yellow-400 mr-3 mt-1">warning</span>
                                <span class="text-slate-700 dark:text-slate-300">Dễ bị căng thẳng khi mất kiểm soát</span>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Career Suggestions -->
            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 mb-8">
                <div class="flex items-center mb-6">
                    <div class="w-12 h-12 rounded-xl bg-gradient-to-br from-blue-400 to-blue-600 flex items-center justify-center mr-4">
                        <span class="material-symbols-outlined text-white text-2xl">work</span>
                    </div>
                    <h3 class="text-xl font-bold text-slate-900 dark:text-white">Nghề nghiệp phù hợp</h3>
                </div>
                <div class="flex flex-wrap gap-3">
                    <c:forEach var="career" items="${mbtiResult.recommendedCareers}">
                        <span class="px-4 py-2 gradient-bg text-white font-medium rounded-full text-sm">
                            ${career}
                        </span>
                    </c:forEach>
                    <c:if test="${empty mbtiResult.recommendedCareers}">
                        <span class="px-4 py-2 gradient-bg text-white font-medium rounded-full text-sm">
                            Kỹ sư phần mềm
                        </span>
                        <span class="px-4 py-2 gradient-bg text-white font-medium rounded-full text-sm">
                            Data Scientist
                        </span>
                        <span class="px-4 py-2 gradient-bg text-white font-medium rounded-full text-sm">
                            Quản lý dự án
                        </span>
                        <span class="px-4 py-2 gradient-bg text-white font-medium rounded-full text-sm">
                            Kiến trúc sư
                        </span>
                        <span class="px-4 py-2 gradient-bg text-white font-medium rounded-full text-sm">
                            Nhà nghiên cứu
                        </span>
                        <span class="px-4 py-2 gradient-bg text-white font-medium rounded-full text-sm">
                            Tư vấn chiến lược
                        </span>
                        <span class="px-4 py-2 gradient-bg text-white font-medium rounded-full text-sm">
                            Giảng viên đại học
                        </span>
                        <span class="px-4 py-2 gradient-bg text-white font-medium rounded-full text-sm">
                            Chuyên gia phân tích
                        </span>
                    </c:if>
                </div>
            </div>

            <!-- Compatible Types -->
            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 mb-8">
                <div class="flex items-center mb-6">
                    <div class="w-12 h-12 rounded-xl bg-gradient-to-br from-pink-400 to-pink-600 flex items-center justify-center mr-4">
                        <span class="material-symbols-outlined text-white text-2xl">favorite</span>
                    </div>
                    <h3 class="text-xl font-bold text-slate-900 dark:text-white">Tính cách phù hợp</h3>
                </div>
                <p class="text-slate-600 dark:text-slate-300 mb-4">
                    Những tính cách này thường hòa hợp tốt với <span class="font-bold text-quiz-purple">${mbtiResult.mbtiType}</span>
                </p>
                <div class="flex flex-wrap gap-3">
                    <c:forEach var="type" items="${mbtiResult.compatibleTypes}">
                        <span class="px-4 py-2 bg-slate-100 dark:bg-slate-700 text-slate-800 dark:text-slate-200 font-medium rounded-full text-sm">
                            ${type}
                        </span>
                    </c:forEach>
                    <c:if test="${empty mbtiResult.compatibleTypes}">
                        <span class="px-4 py-2 bg-slate-100 dark:bg-slate-700 text-slate-800 dark:text-slate-200 font-medium rounded-full text-sm">
                            ENFP
                        </span>
                        <span class="px-4 py-2 bg-slate-100 dark:bg-slate-700 text-slate-800 dark:text-slate-200 font-medium rounded-full text-sm">
                            ENTP
                        </span>
                        <span class="px-4 py-2 gradient-bg text-white font-bold rounded-full text-sm type-highlight">
                            ${mbtiResult.mbtiType}
                        </span>
                        <span class="px-4 py-2 bg-slate-100 dark:bg-slate-700 text-slate-800 dark:text-slate-200 font-medium rounded-full text-sm">
                            INFJ
                        </span>
                        <span class="px-4 py-2 bg-slate-100 dark:bg-slate-700 text-slate-800 dark:text-slate-200 font-medium rounded-full text-sm">
                            INTP
                        </span>
                    </c:if>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="flex flex-col sm:flex-row justify-between items-center gap-4 mt-8">
                <div class="flex flex-wrap gap-3">
                    <a href="#" class="flex items-center px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-lg transition-colors"
                       onclick="shareOnFacebook()">
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
                    <a href="${pageContext.request.contextPath}/quiz/mbti" 
                       class="flex items-center px-6 py-3 bg-red-500 hover:bg-red-600 text-white font-semibold rounded-xl transition-colors">
                        <span class="material-symbols-outlined mr-2">refresh</span>
                        Làm lại quiz
                    </a>
                    <a href="${pageContext.request.contextPath}/quiz/work-style" 
                       class="flex items-center px-6 py-3 gradient-bg hover:opacity-90 text-white font-semibold rounded-xl transition-opacity">
                        Tiếp tục khám phá
                        <span class="material-symbols-outlined ml-2">arrow_forward</span>
                    </a>
                </div>
            </div>

            <!-- Share Section -->
            <div class="mt-8 p-6 bg-gradient-to-r from-quiz-purple to-quiz-dark-purple rounded-2xl text-white">
                <div class="flex flex-col md:flex-row items-center justify-between">
                    <div class="mb-4 md:mb-0">
                        <h4 class="text-lg font-semibold mb-2">🎉 Chúc mừng bạn đã hoàn thành!</h4>
                        <p class="text-blue-100">Khám phá thêm về bản thân với các bài quiz khác</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/QuizResultController"
                       class="flex items-center px-6 py-3 bg-white text-quiz-purple font-semibold rounded-xl hover:bg-blue-50 transition-colors">
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
        // Animate progress bars
        document.addEventListener('DOMContentLoaded', function() {
            // Get MBTI type
            const mbtiType = '${mbtiResult.mbtiType}';
            
            // Calculate progress based on MBTI type
            setTimeout(() => {
                // E/I dimension
                const eiProgress = document.getElementById('ei-progress');
                if (eiProgress) {
                    eiProgress.style.width = mbtiType.charAt(0) === 'E' ? '70%' : '30%';
                }
                
                // S/N dimension  
                const snProgress = document.getElementById('sn-progress');
                if (snProgress) {
                    snProgress.style.width = mbtiType.charAt(1) === 'S' ? '70%' : '30%';
                }
                
                // T/F dimension
                const tfProgress = document.getElementById('tf-progress');
                if (tfProgress) {
                    tfProgress.style.width = mbtiType.charAt(2) === 'T' ? '70%' : '30%';
                }
                
                // J/P dimension
                const jpProgress = document.getElementById('jp-progress');
                if (jpProgress) {
                    jpProgress.style.width = mbtiType.charAt(3) === 'J' ? '70%' : '30%';
                }
            }, 500);
        });
        
        // Share functions
        function shareOnFacebook() {
            const url = encodeURIComponent(window.location.href);
            const text = encodeURIComponent(`Tôi vừa khám phá tính cách MBTI của mình là ${'${mbtiResult.mbtiType}'}! Khám phá ngay bạn nhé!`);
            window.open(`https://www.facebook.com/sharer/sharer.php?u=${url}&quote=${text}`, '_blank');
        }
        
        function copyResultToClipboard() {
            const mbtiType = '${mbtiResult.mbtiType}';
            const description = '${mbtiResult.description}';
            const resultText = `🎭 Kết quả MBTI của tôi: ${mbtiType}\n${description}\n\nKhám phá tính cách của bạn tại: ${window.location.origin}`;
            
            navigator.clipboard.writeText(resultText)
                .then(() => {
                    alert('Đã sao chép kết quả vào clipboard!');
                })
                .catch(err => {
                    console.error('Failed to copy: ', err);
                    alert('Không thể sao chép, vui lòng thử lại.');
                });
        }
        
        // Confetti effect
        function createConfetti() {
            const colors = ['#667eea', '#764ba2', '#4F46E5', '#A5B4FC'];
            const confettiCount = 50;
            
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
        
        // Trigger confetti on page load
        setTimeout(createConfetti, 1000);
    </script>
</body>
</html>