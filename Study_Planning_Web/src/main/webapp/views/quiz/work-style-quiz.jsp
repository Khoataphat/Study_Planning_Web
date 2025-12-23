<%-- 
    Document   : work-style-quiz
    Created on : 22 thg 12, 2025, 12:08:10
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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz Phong cách Làm việc</title>
    
    <!-- Tailwind CSS & Google Fonts -->
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
        
        .option-card {
            transition: all 0.3s ease;
            border: 2px solid transparent;
            position: relative;
            cursor: pointer;
        }
        
        .option-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 15px 30px -10px rgba(102, 126, 234, 0.2);
        }
        
        .option-card.selected {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px -5px rgba(102, 126, 234, 0.2);
        }
        
        .option-card.option-a { 
            border-color: rgba(102, 126, 234, 0.3); 
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.03) 0%, rgba(102, 126, 234, 0.01) 100%);
        }
        .option-card.option-b { 
            border-color: rgba(118, 75, 162, 0.3);
            background: linear-gradient(135deg, rgba(118, 75, 162, 0.03) 0%, rgba(118, 75, 162, 0.01) 100%);
        }
        .option-card.option-c { 
            border-color: rgba(72, 187, 120, 0.3);
            background: linear-gradient(135deg, rgba(72, 187, 120, 0.03) 0%, rgba(72, 187, 120, 0.01) 100%);
        }
        
        .option-card.option-a.selected { 
            border-color: #667eea; 
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(102, 126, 234, 0.05) 100%);
        }
        .option-card.option-b.selected { 
            border-color: #764ba2;
            background: linear-gradient(135deg, rgba(118, 75, 162, 0.1) 0%, rgba(118, 75, 162, 0.05) 100%);
        }
        .option-card.option-c.selected { 
            border-color: #48bb78;
            background: linear-gradient(135deg, rgba(72, 187, 120, 0.1) 0%, rgba(72, 187, 120, 0.05) 100%);
        }
        
        .dark .option-card.option-a.selected { background: rgba(102, 126, 234, 0.15); }
        .dark .option-card.option-b.selected { background: rgba(118, 75, 162, 0.15); }
        .dark .option-card.option-c.selected { background: rgba(72, 187, 120, 0.15); }
        
        .option-label {
            display: flex;
            align-items: center;
            font-weight: 600;
            font-size: 1.125rem;
            margin-bottom: 8px;
        }
        
        .option-label-a { color: #667eea; }
        .option-label-b { color: #764ba2; }
        .option-label-c { color: #48bb78; }
        
        .dark .option-label-a { color: #818cf8; }
        .dark .option-label-b { color: #a78bfa; }
        .dark .option-label-c { color: #34d399; }
        
        .option-icon {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
            font-weight: bold;
            color: white;
        }
        
        .option-icon-a { background: linear-gradient(135deg, #667eea 0%, #4f46e5 100%); }
        .option-icon-b { background: linear-gradient(135deg, #764ba2 0%, #7c3aed 100%); }
        .option-icon-c { background: linear-gradient(135deg, #48bb78 0%, #10b981 100%); }
        
        /* Quick Navigation */
        .quick-nav-container {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            justify-content: center;
            margin-top: 20px;
            padding: 16px;
            background: rgba(241, 245, 249, 0.5);
            border-radius: 16px;
            border: 1px solid #e2e8f0;
        }
        
        .dark .quick-nav-container {
            background: rgba(30, 41, 59, 0.5);
            border-color: #475569;
        }
        
        .quick-nav-btn {
            transition: all 0.3s ease;
            width: 40px;
            height: 40px;
            border-radius: 10px;
            border: 2px solid #cbd5e1;
            background: white;
            color: #64748b;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            position: relative;
        }
        
        .dark .quick-nav-btn {
            border-color: #475569;
            background: #1e293b;
            color: #cbd5e1;
        }
        
        .quick-nav-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border-color: #94a3b8;
        }
        
        .dark .quick-nav-btn:hover {
            border-color: #64748b;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        }
        
        .quick-nav-btn.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-color: transparent;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }
        
        .quick-nav-btn.answered {
            border-width: 3px;
        }
        
        /* Màu border cho các câu đã trả lời */
        .quick-nav-btn.answered[data-answer="A"] { border-color: #667eea; }
        .quick-nav-btn.answered[data-answer="B"] { border-color: #764ba2; }
        .quick-nav-btn.answered[data-answer="C"] { border-color: #48bb78; }
        
        /* Hiển thị đáp án đã chọn trên quick nav */
        .answer-indicator {
            position: absolute;
            bottom: -6px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 10px;
            font-weight: bold;
            width: 18px;
            height: 18px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }
        
        .answer-indicator[data-answer="A"] { background-color: #667eea; }
        .answer-indicator[data-answer="B"] { background-color: #764ba2; }
        .answer-indicator[data-answer="C"] { background-color: #48bb78; }
        
        /* Current Answer Display */
        .current-answer-display {
            margin-top: 16px;
            padding: 12px 20px;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
            border-radius: 12px;
            border-left: 4px solid #667eea;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .dark .current-answer-display {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.15) 0%, rgba(118, 75, 162, 0.15) 100%);
            border-left-color: #a5b4fc;
        }
        
        .current-answer-icon {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }
        
        .current-answer-icon[data-answer="A"] { background: #667eea; }
        .current-answer-icon[data-answer="B"] { background: #764ba2; }
        .current-answer-icon[data-answer="C"] { background: #48bb78; }
        
        /* Checkmark cho option đã chọn */
        .option-card.selected::after {
            content: '✓';
            position: absolute;
            top: 12px;
            right: 12px;
            width: 24px;
            height: 24px;
            background-color: currentColor;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            font-weight: bold;
            color: white;
        }
        
        .option-card.option-a.selected::after { background-color: #667eea; }
        .option-card.option-b.selected::after { background-color: #764ba2; }
        .option-card.option-c.selected::after { background-color: #48bb78; }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .question-transition {
            animation: fadeIn 0.3s ease-out;
        }
        
        .time-badge {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
            border: 1px solid rgba(102, 126, 234, 0.3);
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }
        
        .shake {
            animation: shake 0.5s;
        }
        
        /* Work Style Colors */
        .work-style-info {
            border-left-width: 4px;
            border-left-style: solid;
        }
        
        .work-style-info.analytical { 
            border-left-color: #667eea;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.05) 0%, rgba(102, 126, 234, 0.02) 100%);
        }
        
        .work-style-info.collaborative { 
            border-left-color: #764ba2;
            background: linear-gradient(135deg, rgba(118, 75, 162, 0.05) 0%, rgba(118, 75, 162, 0.02) 100%);
        }
        
        .work-style-info.practical { 
            border-left-color: #48bb78;
            background: linear-gradient(135deg, rgba(72, 187, 120, 0.05) 0%, rgba(72, 187, 120, 0.02) 100%);
        }
        
        .dark .work-style-info.analytical { background: rgba(102, 126, 234, 0.1); }
        .dark .work-style-info.collaborative { background: rgba(118, 75, 162, 0.1); }
        .dark .work-style-info.practical { background: rgba(72, 187, 120, 0.1); }
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
                        "quiz-purple": "#667eea",
                        "quiz-dark-purple": "#764ba2",
                        "option-a-color": "#667eea",
                        "option-b-color": "#764ba2",
                        "option-c-color": "#48bb78",
                        "border-light": "#E5E7EB",
                        "border-dark": "#475569",
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/setting.css">
</head>
<body class="font-display bg-background-light dark:bg-background-dark text-slate-900 dark:text-slate-200">
    <div class="flex min-h-screen">
        <!-- Sidebar -->
        <aside 
            id="sidebar"
            class="bg-white dark:bg-slate-900 flex flex-col py-6 space-y-8 border-r border-slate-200 dark:border-slate-800 
            h-screen fixed top-0 left-0 transition-all duration-500 z-40 cursor-pointer"
            >
            <div class="w-14 h-14 bg-primary rounded-full flex items-center justify-center shrink-0 mx-auto">
                <span class="material-icons-outlined text-white text-3xl">work</span>
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

                <!-- Active state for Quiz -->
                <a class="nav-link w-full rounded-lg transition-colors bg-primary shadow-md shadow-primary/30 text-white"
                   href="${pageContext.request.contextPath}/QuizResultController">
                    <span class="material-icons-outlined text-3xl shrink-0">psychology</span>
                    <span class="ml-4 whitespace-nowrap sidebar-text">Khám phá bản thân</span>
                </a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main id="mainContent" class="flex-1 flex flex-col p-6 lg:p-8 ml-20 overflow-y-auto">
            <!-- Header -->
            <header class="flex justify-between items-center mb-8">
                <div>
                    <h1 class="text-3xl font-bold text-slate-900 dark:text-white flex items-center">
                        <span class="material-symbols-outlined mr-3 text-quiz-purple dark:text-pastel-purple">work</span>
                        Phong cách Làm việc
                    </h1>
                    <p class="text-slate-500 dark:text-slate-400 mt-2">Khám phá phong cách làm việc phù hợp nhất với bạn qua ${fn:length(questions)} câu hỏi</p>
                </div>
                <div class="flex items-center space-x-4">
                    <!-- Time Estimate Badge -->
                    <div class="time-badge px-4 py-2 rounded-full text-sm font-medium text-quiz-purple dark:text-pastel-purple">
                        ⏱️ 
                        <c:choose>
                            <c:when test="${not empty questions and fn:length(questions) > 0}">
                                <fmt:formatNumber value="${fn:length(questions) * 0.5}" 
                                                maxFractionDigits="1" /> phút
                            </c:when>
                            <c:otherwise>
                                0 phút
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <button class="p-2 rounded-full hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors" aria-label="Settings" onclick="loadSettingsAndOpen()">
                        <span class="material-icons-outlined text-slate-600 dark:text-slate-300">settings</span>
                    </button>
                    <a href="/logout" class="p-2 rounded-full hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors" aria-label="Logout">
                        <span class="material-icons-outlined text-slate-600 dark:text-slate-300">logout</span>
                    </a>
                </div>
            </header>

            <!-- Progress Bar -->
            <div class="mb-8">
                <div class="flex justify-between items-center mb-3">
                    <div class="flex items-center">
                        <span class="text-lg font-semibold text-slate-900 dark:text-white">Tiến độ bài quiz</span>
                        <span class="ml-3 text-sm text-slate-500 dark:text-slate-400" id="progressText">
                            Câu <span id="currentQuestionNum">1</span>/<span id="totalQuestions">${fn:length(questions)}</span>
                        </span>
                    </div>
                    <div class="flex items-center space-x-2">
                        <span class="text-sm text-slate-500 dark:text-slate-400" id="answeredCount">Đã trả lời: 0/${fn:length(questions)}</span>
                        <span class="text-xl font-bold text-quiz-purple dark:text-pastel-purple" id="percentageText">0%</span>
                    </div>
                </div>
                <div class="w-full h-3 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                    <div class="progress-fill" id="progressFill"></div>
                </div>
            </div>

            <!-- Error Message -->
            <div id="errorMessage" class="mb-6 p-4 bg-red-50 dark:bg-red-900/20 text-red-800 dark:text-red-300 rounded-xl border-l-4 border-red-500 hidden">
                <div class="flex items-center">
                    <span class="material-symbols-outlined mr-3">error</span>
                    <span id="errorText"></span>
                </div>
            </div>

            <!-- Current Answer Display -->
            <div id="currentAnswerDisplay" class="mb-6 hidden">
                <div class="current-answer-display">
                    <div class="current-answer-icon" id="currentAnswerIcon"></div>
                    <div>
                        <div class="text-sm font-medium text-slate-600 dark:text-slate-300">Đáp án hiện tại:</div>
                        <div class="text-lg font-semibold text-slate-900 dark:text-white" id="currentAnswerText"></div>
                    </div>
                </div>
            </div>

            <!-- Quiz Form -->
            <form id="workStyleForm" method="post" action="${pageContext.request.contextPath}/quiz/work-style/submit" class="flex-1">
                <c:forEach var="question" items="${questions}" varStatus="status">
                    <div class="question-container bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-8 mb-6 question-transition" 
                         id="question-${status.index}" 
                         data-question-id="${question.id}"
                         style="${status.index == 0 ? '' : 'display: none;'}">
                        
                        <!-- Question Header -->
                        <div class="flex items-center justify-between mb-6">
                            <div class="flex items-center">
                                <div class="w-10 h-10 rounded-lg gradient-bg flex items-center justify-center text-white font-bold text-lg">
                                    ${status.index + 1}
                                </div>
                                <span class="ml-4 text-lg font-semibold text-quiz-purple dark:text-pastel-purple">
                                    Câu ${status.index + 1} / ${fn:length(questions)}
                                </span>
                            </div>
                        </div>
                        
                        <!-- Question Text -->
                        <h2 class="text-2xl font-bold text-slate-900 dark:text-white mb-8 leading-relaxed">
                            ${question.questionText}
                        </h2>
                        
                        <!-- Options -->
                        <div class="space-y-4 mb-10">
                            <!-- Option A -->
                            <div class="option-card option-a rounded-xl p-6"
                                 onclick="selectOption(${status.index}, 'A')">
                                <input type="radio" 
                                       class="hidden" 
                                       name="question_${question.id}" 
                                       value="A"
                                       id="q${question.id}_a">
                                <div class="flex items-start">
                                    <div class="option-icon option-icon-a">A</div>
                                    <div class="flex-1">
                                        <p class="text-slate-600 dark:text-slate-400 leading-relaxed">
                                            ${question.optionAText}
                                        </p>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Option B -->
                            <div class="option-card option-b rounded-xl p-6"
                                 onclick="selectOption(${status.index}, 'B')">
                                <input type="radio" 
                                       class="hidden" 
                                       name="question_${question.id}" 
                                       value="B"
                                       id="q${question.id}_b">
                                <div class="flex items-start">
                                    <div class="option-icon option-icon-b">B</div>
                                    <div class="flex-1">
                                        <p class="text-slate-600 dark:text-slate-400 leading-relaxed">
                                            ${question.optionBText}
                                        </p>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Option C (if exists) -->
                            <c:if test="${not empty question.optionCText}">
                            <div class="option-card option-c rounded-xl p-6"
                                 onclick="selectOption(${status.index}, 'C')">
                                <input type="radio" 
                                       class="hidden" 
                                       name="question_${question.id}" 
                                       value="C"
                                       id="q${question.id}_c">
                                <div class="flex items-start">
                                    <div class="option-icon option-icon-c">C</div>
                                    <div class="flex-1">
                                        <p class="text-slate-600 dark:text-slate-400 leading-relaxed">
                                            ${question.optionCText}
                                        </p>
                                    </div>
                                </div>
                            </div>
                            </c:if>
                        </div>
                        
                        <!-- Navigation Buttons -->
                        <div class="flex justify-between items-center pt-6 border-t border-slate-200 dark:border-slate-700">
                            <div>
                                <c:if test="${status.index > 0}">
                                    <button type="button" 
                                            class="flex items-center px-6 py-3 text-slate-700 dark:text-slate-300 font-semibold rounded-xl hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors"
                                            onclick="prevQuestion()">
                                        <span class="material-symbols-outlined mr-2">arrow_back</span>
                                        Câu trước
                                    </button>
                                </c:if>
                            </div>
                            
                            <div class="ml-auto">
                                <c:choose>
                                    <c:when test="${status.index < fn:length(questions) - 1}">
                                        <button type="button" 
                                                class="flex items-center px-8 py-3 gradient-bg text-white font-semibold rounded-xl hover:opacity-90 transition-opacity shadow-lg shadow-quiz-purple/30"
                                                onclick="nextQuestion()"
                                                id="nextBtn-${status.index}">
                                            Câu tiếp theo
                                            <span class="material-symbols-outlined ml-2">arrow_forward</span>
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="submit" 
                                                class="flex items-center px-8 py-3 gradient-bg text-white font-semibold rounded-xl hover:opacity-90 transition-opacity shadow-lg shadow-quiz-purple/30">
                                            <span class="material-symbols-outlined mr-2">rocket_launch</span>
                                            Xem kết quả phân tích
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </form>
            
            <!-- Quick Navigation Container -->
            <div class="mt-6">
                <div class="quick-nav-container">
                    <c:forEach var="i" begin="1" end="${fn:length(questions)}">
                        <button type="button" 
                                class="quick-nav-btn"
                                onclick="showQuestion(${i - 1})"
                                id="quick-nav-${i - 1}"
                                data-answer="">
                            ${i}
                            <div class="answer-indicator hidden" id="answer-indicator-${i - 1}" data-answer=""></div>
                        </button>
                    </c:forEach>
                </div>
            </div>
            
            <!-- Quiz Tips -->
            <div class="mt-8 p-6 bg-indigo-50 dark:bg-indigo-900/20 rounded-2xl border border-indigo-200 dark:border-indigo-800">
                <div class="flex items-start">
                    <span class="material-symbols-outlined text-indigo-500 dark:text-indigo-400 mr-3 mt-1">tips_and_updates</span>
                    <div class="flex-1">
                        <h3 class="text-lg font-semibold text-indigo-900 dark:text-indigo-300 mb-2">Phong cách làm việc phổ biến</h3>
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mt-3">
                            <div class="work-style-info analytical p-4 rounded-lg">
                                <div class="flex items-center mb-2">
                                    <span class="material-symbols-outlined text-option-a-color mr-2">analytics</span>
                                    <span class="font-semibold text-slate-900 dark:text-white">Phân tích (Analytical)</span>
                                </div>
                                <p class="text-sm text-slate-600 dark:text-slate-400">
                                    Ưu tiên logic, dữ liệu, phân tích chi tiết và ra quyết định dựa trên bằng chứng
                                </p>
                            </div>
                            <div class="work-style-info collaborative p-4 rounded-lg">
                                <div class="flex items-center mb-2">
                                    <span class="material-symbols-outlined text-option-b-color mr-2">group</span>
                                    <span class="font-semibold text-slate-900 dark:text-white">Hợp tác (Collaborative)</span>
                                </div>
                                <p class="text-sm text-slate-600 dark:text-slate-400">
                                    Làm việc nhóm hiệu quả, giao tiếp tốt, xây dựng mối quan hệ và hợp tác
                                </p>
                            </div>
                            <div class="work-style-info practical p-4 rounded-lg">
                                <div class="flex items-center mb-2">
                                    <span class="material-symbols-outlined text-option-c-color mr-2">build</span>
                                    <span class="font-semibold text-slate-900 dark:text-white">Thực tiễn (Practical)</span>
                                </div>
                                <p class="text-sm text-slate-600 dark:text-slate-400">
                                    Tập trung vào kết quả, giải quyết vấn đề thực tế, hành động và hiệu quả
                                </p>
                            </div>
                        </div>
                        <p class="text-sm text-slate-600 dark:text-slate-400 mt-4">
                            <span class="font-semibold">Mẹo:</span> Sử dụng phím số 1, 2, 3 để chọn nhanh đáp án. 
                            Phím mũi tên trái/phải để điều hướng giữa các câu hỏi.
                        </p>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Settings Overlay -->
    <%@ include file="/views/settings-overlay.jsp" %>

    <script src="${pageContext.request.contextPath}/resources/js/sidebar.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/setting.js"></script>
    
    <script>
        // Quiz state
        let currentQuestionIndex = 0;
        const totalQuestions = document.querySelectorAll('.question-container').length;
        let answers = new Array(totalQuestions).fill(null);
        let startTime = new Date();

        // Initialize
        if (totalQuestions > 0) {
            showQuestion(0);
            updateProgress();
            updateAnsweredCount();
            loadSavedAnswers();
        }

        function showQuestion(index) {
            if (index < 0 || index >= totalQuestions) return;

            // Hide all questions
            document.querySelectorAll('.question-container').forEach(q => {
                q.style.display = 'none';
            });

            // Show selected question
            const question = document.getElementById('question-' + index);
            if (question) {
                question.style.display = 'block';
                question.classList.add('question-transition');
                setTimeout(() => {
                    question.classList.remove('question-transition');
                }, 300);
                
                currentQuestionIndex = index;
                updateProgress();
                updateQuickNav();
                updateCurrentAnswerDisplay();

                // Scroll to top of question
                window.scrollTo({
                    top: question.offsetTop - 100,
                    behavior: 'smooth'
                });
            }
        }

        function selectOption(questionIndex, value) {
            if (questionIndex < 0 || questionIndex >= totalQuestions) return;

            // Remove selected class from all options in this question
            const questionEl = document.getElementById('question-' + questionIndex);
            if (questionEl) {
                const options = questionEl.querySelectorAll('.option-card');
                options.forEach(option => {
                    option.classList.remove('selected');
                });
            }

            // Add selected class to chosen option
            let selectedOption;
            if (value === 'A') {
                selectedOption = document.querySelector(`#question-${questionIndex} .option-card.option-a`);
            } else if (value === 'B') {
                selectedOption = document.querySelector(`#question-${questionIndex} .option-card.option-b`);
            } else if (value === 'C') {
                selectedOption = document.querySelector(`#question-${questionIndex} .option-card.option-c`);
            }

            if (selectedOption) {
                selectedOption.classList.add('selected');
            }

            // Update radio button
            const questionId = questionEl.dataset.questionId;
            const radio = document.querySelector(`input[name="question_${questionId}"][value="${value}"]`);
            if (radio) {
                radio.checked = true;
            }

            // Save answer
            answers[questionIndex] = value;
            hideError();
            updateQuickNav();
            updateAnsweredCount();
            updateCurrentAnswerDisplay();
        }

        function nextQuestion() {
            if (answers[currentQuestionIndex] === null) {
                showError('Vui lòng chọn một đáp án trước khi tiếp tục!');
                return;
            }
            hideError();
            
            if (currentQuestionIndex < totalQuestions - 1) {
                showQuestion(currentQuestionIndex + 1);
            }
        }

        function prevQuestion() {
            if (currentQuestionIndex > 0) {
                showQuestion(currentQuestionIndex - 1);
            }
        }

        function updateProgress() {
            const progress = ((currentQuestionIndex + 1) / totalQuestions) * 100;
            
            // Update progress bar
            const progressFill = document.getElementById('progressFill');
            if (progressFill) {
                progressFill.style.width = progress + '%';
            }
            
            // Update percentage
            const percentageText = document.getElementById('percentageText');
            if (percentageText) {
                percentageText.textContent = Math.round(progress) + '%';
            }
            
            // Update question number
            const currentQuestionNum = document.getElementById('currentQuestionNum');
            if (currentQuestionNum) {
                currentQuestionNum.textContent = currentQuestionIndex + 1;
            }
        }

        function updateAnsweredCount() {
            const answered = answers.filter(answer => answer !== null).length;
            const answeredCount = document.getElementById('answeredCount');
            if (answeredCount) {
                answeredCount.textContent = `Đã trả lời: ${answered}/${totalQuestions}`;
            }
        }

        function updateQuickNav() {
            // Update quick navigation buttons
            document.querySelectorAll('.quick-nav-btn').forEach((btn, index) => {
                const answer = answers[index];
                
                // Update active state
                btn.classList.toggle('active', index === currentQuestionIndex);
                
                // Update answered state
                if (answer !== null) {
                    btn.classList.add('answered');
                    btn.setAttribute('data-answer', answer);
                    
                    // Show answer indicator
                    const indicator = document.getElementById(`answer-indicator-${index}`);
                    if (indicator) {
                        indicator.classList.remove('hidden');
                        indicator.setAttribute('data-answer', answer);
                        indicator.textContent = answer;
                    }
                } else {
                    btn.classList.remove('answered');
                    btn.removeAttribute('data-answer');
                    
                    // Hide answer indicator
                    const indicator = document.getElementById(`answer-indicator-${index}`);
                    if (indicator) {
                        indicator.classList.add('hidden');
                        indicator.removeAttribute('data-answer');
                    }
                }
            });
        }

        function updateCurrentAnswerDisplay() {
            const currentAnswer = answers[currentQuestionIndex];
            const display = document.getElementById('currentAnswerDisplay');
            const iconEl = document.getElementById('currentAnswerIcon');
            const textEl = document.getElementById('currentAnswerText');
            
            if (currentAnswer !== null) {
                // Show display
                display.classList.remove('hidden');
                
                // Update icon
                iconEl.className = 'current-answer-icon';
                iconEl.setAttribute('data-answer', currentAnswer);
                iconEl.textContent = currentAnswer;
                
                // Update text
                const answerTexts = {
                    'A': 'Lựa chọn A',
                    'B': 'Lựa chọn B',
                    'C': 'Lựa chọn C'
                };
                textEl.textContent = answerTexts[currentAnswer] || currentAnswer;
            } else {
                // Hide display
                display.classList.add('hidden');
            }
        }

        function showError(message) {
            const errorEl = document.getElementById('errorMessage');
            const errorText = document.getElementById('errorText');
            if (errorEl && errorText) {
                errorText.textContent = message;
                errorEl.classList.remove('hidden');
                
                // Auto-hide after 3 seconds
                setTimeout(() => {
                    errorEl.classList.add('hidden');
                }, 3000);
            }
        }

        function hideError() {
            const errorEl = document.getElementById('errorMessage');
            if (errorEl) {
                errorEl.classList.add('hidden');
            }
        }

        // Keyboard navigation
        document.addEventListener('keydown', function (event) {
            if (event.key === 'ArrowRight' || event.key === 'd' || event.key === 'Enter') {
                event.preventDefault();
                nextQuestion();
            } else if (event.key === 'ArrowLeft' || event.key === 'a') {
                event.preventDefault();
                prevQuestion();
            } else if (event.key === '1') {
                event.preventDefault();
                selectOption(currentQuestionIndex, 'A');
            } else if (event.key === '2') {
                event.preventDefault();
                selectOption(currentQuestionIndex, 'B');
            } else if (event.key === '3') {
                event.preventDefault();
                // Only select C if it exists for this question
                const questionEl = document.getElementById('question-' + currentQuestionIndex);
                if (questionEl && questionEl.querySelector('.option-card.option-c')) {
                    selectOption(currentQuestionIndex, 'C');
                }
            }
        });

        // Load saved answers from localStorage
        function loadSavedAnswers() {
            try {
                const saved = localStorage.getItem('work_style_quiz_answers');
                if (saved) {
                    const data = JSON.parse(saved);
                    const now = new Date().getTime();
                    const oneHour = 60 * 60 * 1000;

                    if (now - data.timestamp < oneHour) {
                        answers = data.answers || new Array(totalQuestions).fill(null);

                        // Restore selections and UI
                        answers.forEach((answer, index) => {
                            if (answer !== null) {
                                // Update visual selection
                                selectOption(index, answer);
                            }
                        });

                        updateQuickNav();
                        updateAnsweredCount();
                        updateCurrentAnswerDisplay();
                    }
                }
            } catch (e) {
                console.error('Error loading saved answers:', e);
                localStorage.removeItem('work_style_quiz_answers');
            }
        }

        // Save answers before unload
        window.addEventListener('beforeunload', function () {
            if (answers.some(answer => answer !== null)) {
                const saveData = {
                    answers: answers,
                    timestamp: new Date().getTime(),
                    currentQuestion: currentQuestionIndex
                };
                localStorage.setItem('work_style_quiz_answers', JSON.stringify(saveData));
            }
        });

        // Form submission validation
        document.getElementById('workStyleForm').addEventListener('submit', function (event) {
            const unanswered = [];
            answers.forEach((answer, index) => {
                if (answer === null) {
                    unanswered.push(index + 1);
                }
            });

            if (unanswered.length > 0) {
                event.preventDefault();
                const questionText = unanswered.length === 1 ? 'câu hỏi' : 'các câu hỏi';
                showError(`Vui lòng trả lời ${questionText} ${unanswered.join(', ')} trước khi nộp bài!`);

                // Show first unanswered question
                if (unanswered[0]) {
                    showQuestion(unanswered[0] - 1);
                    
                    // Highlight the question
                    const questionEl = document.getElementById('question-' + (unanswered[0] - 1));
                    if (questionEl) {
                        questionEl.classList.add('shake');
                        setTimeout(() => {
                            questionEl.classList.remove('shake');
                        }, 500);
                    }
                }
            } else {
                // Calculate time spent
                const endTime = new Date();
                const timeSpent = Math.round((endTime - startTime) / 1000);
                
                // Add time spent as hidden input
                const timeInput = document.createElement('input');
                timeInput.type = 'hidden';
                timeInput.name = 'time_spent';
                timeInput.value = timeSpent;
                this.appendChild(timeInput);

                // Clear saved answers
                localStorage.removeItem('work_style_quiz_answers');

                // Show confirmation
                if (!confirm('Bạn đã hoàn thành tất cả câu hỏi! Bấm OK để xem kết quả phân tích.')) {
                    event.preventDefault();
                }
            }
        });

        // Initialize progress
        document.addEventListener('DOMContentLoaded', function() {
            if (totalQuestions > 0) {
                updateProgress();
                updateAnsweredCount();
                updateCurrentAnswerDisplay();
            }
        });
    </script>
</body>
</html>