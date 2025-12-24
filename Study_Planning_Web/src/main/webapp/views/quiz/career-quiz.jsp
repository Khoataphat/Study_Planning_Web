<%-- 
    Document   : career-quiz.jsp
    Created on : 21 thg 12, 2025, 23:26:05
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
        <title>Định hướng Nghề nghiệp</title>
        
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
            
            .likert-option {
                transition: all 0.3s ease;
                border: 2px solid #e5e7eb;
                cursor: pointer;
                position: relative;
            }
            
            .dark .likert-option {
                border-color: #475569;
            }
            
            .likert-option:hover {
                border-color: #667eea;
                transform: translateY(-2px);
                box-shadow: 0 10px 25px -5px rgba(102, 126, 234, 0.2);
            }
            
            .dark .likert-option:hover {
                border-color: #a5b4fc;
            }
            
            .likert-option.selected {
                border-color: #667eea;
                background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
                box-shadow: 0 10px 25px -5px rgba(102, 126, 234, 0.2);
            }
            
            .dark .likert-option.selected {
                border-color: #a5b4fc;
                background: linear-gradient(135deg, rgba(165, 180, 252, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
            }
            
            /* Màu sắc cho từng mức độ đã chọn */
            .likert-option.selected[data-value="1"] { 
                border-color: #ef4444; 
                background: rgba(239, 68, 68, 0.1); 
            }
            .likert-option.selected[data-value="2"] { 
                border-color: #f59e0b; 
                background: rgba(245, 158, 11, 0.1); 
            }
            .likert-option.selected[data-value="3"] { 
                border-color: #10b981; 
                background: rgba(16, 185, 129, 0.1); 
            }
            .likert-option.selected[data-value="4"] { 
                border-color: #3b82f6; 
                background: rgba(59, 130, 246, 0.1); 
            }
            .likert-option.selected[data-value="5"] { 
                border-color: #8b5cf6; 
                background: rgba(139, 92, 246, 0.1); 
            }
            
            .likert-value {
                transition: all 0.3s ease;
            }
            
            .likert-option.selected .likert-value {
                transform: scale(1.2);
            }
            
            /* Biểu tượng check cho đáp án đã chọn */
            .likert-option.selected::after {
                content: '✓';
                position: absolute;
                top: 8px;
                right: 8px;
                width: 24px;
                height: 24px;
                background-color: currentColor;
                color: white;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 14px;
                font-weight: bold;
            }
            
            .likert-option.selected[data-value="1"]::after { background-color: #ef4444; }
            .likert-option.selected[data-value="2"]::after { background-color: #f59e0b; }
            .likert-option.selected[data-value="3"]::after { background-color: #10b981; }
            .likert-option.selected[data-value="4"]::after { background-color: #3b82f6; }
            .likert-option.selected[data-value="5"]::after { background-color: #8b5cf6; }
            
            /* Quick Navigation Styling */
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
            .quick-nav-btn.answered[data-answer="1"] { border-color: #ef4444; }
            .quick-nav-btn.answered[data-answer="2"] { border-color: #f59e0b; }
            .quick-nav-btn.answered[data-answer="3"] { border-color: #10b981; }
            .quick-nav-btn.answered[data-answer="4"] { border-color: #3b82f6; }
            .quick-nav-btn.answered[data-answer="5"] { border-color: #8b5cf6; }
            
            /* Hiển thị đáp án đã chọn trên quick nav */
            .answer-indicator {
                position: absolute;
                bottom: -4px;
                left: 50%;
                transform: translateX(-50%);
                font-size: 10px;
                font-weight: bold;
                width: 16px;
                height: 16px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
            }
            
            .answer-indicator[data-answer="1"] { background-color: #ef4444; }
            .answer-indicator[data-answer="2"] { background-color: #f59e0b; }
            .answer-indicator[data-answer="3"] { background-color: #10b981; }
            .answer-indicator[data-answer="4"] { background-color: #3b82f6; }
            .answer-indicator[data-answer="5"] { background-color: #8b5cf6; }
            
            .time-badge {
                background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
                border: 1px solid rgba(102, 126, 234, 0.3);
            }
            
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(10px); }
                to { opacity: 1; transform: translateY(0); }
            }
            
            .question-transition {
                animation: fadeIn 0.3s ease-out;
            }
            
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
            
            .current-answer-value {
                width: 36px;
                height: 36px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                font-size: 16px;
                color: white;
            }
            
            .current-answer-value[data-value="1"] { background-color: #ef4444; }
            .current-answer-value[data-value="2"] { background-color: #f59e0b; }
            .current-answer-value[data-value="3"] { background-color: #10b981; }
            .current-answer-value[data-value="4"] { background-color: #3b82f6; }
            .current-answer-value[data-value="5"] { background-color: #8b5cf6; }
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
                            "success-light": "#d1fae5",
                            "success-dark": "#065f46",
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
                <!-- Sidebar content same as before -->
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
                        
                                        <%-- Timer --%>
                    <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300"
                       href="${pageContext.request.contextPath}/timer">
                        <span class="material-icons-outlined text-3xl shrink-0">timer</span>
                        <span class="ml-4 whitespace-nowrap sidebar-text">Bộ hẹn giờ</span>
                    </a>
                </nav>
            </aside>

            <!-- Main Content -->
            <main id="mainContent" class="flex-1 flex flex-col p-6 lg:p-8 ml-20 overflow-y-auto">
                <!-- Header -->
                <header class="flex justify-between items-center mb-8">
                    <div>
                        <h1 class="text-3xl font-bold text-slate-900 dark:text-white flex items-center">
                            <span class="material-symbols-outlined mr-3 text-quiz-purple dark:text-pastel-purple">target</span>
                            Định hướng Nghề nghiệp
                        </h1>
                        <p class="text-slate-500 dark:text-slate-400 mt-2">
                            Tìm hiểu nghề nghiệp phù hợp với sở thích và năng lực của bạn
                        </p>
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
                                Câu <span id="currentQuestionNum">1</span>/
                                <c:choose>
                                    <c:when test="${not empty questions}">${fn:length(questions)}</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
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
                        <div class="current-answer-value" id="currentAnswerValue"></div>
                        <div>
                            <div class="text-sm font-medium text-slate-600 dark:text-slate-300">Đáp án hiện tại:</div>
                            <div class="text-lg font-semibold text-slate-900 dark:text-white" id="currentAnswerText"></div>
                        </div>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty questions}">
                        <!-- Quiz Content -->
                        <div class="flex-1">
                            <form id="careerQuizForm" method="post" action="${pageContext.request.contextPath}/quiz/career/submit">
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
                                            <span class="text-sm text-slate-500 dark:text-slate-400">
                                                Đánh giá mức độ phù hợp
                                            </span>
                                        </div>
                                        
                                        <!-- Question Text -->
                                        <h2 class="text-2xl font-bold text-slate-900 dark:text-white mb-8 leading-relaxed">
                                            ${question.questionText}
                                        </h2>
                                        
                                        <!-- Likert Scale Options -->
                                        <div class="grid grid-cols-1 md:grid-cols-5 gap-4 mb-6">
                                            <c:forEach var="value" begin="1" end="5">
                                                <div class="likert-option flex flex-col items-center bg-slate-50 dark:bg-slate-700/50 rounded-xl p-6"
                                                     onclick="selectOption(${status.index}, ${value})"
                                                     id="option-${status.index}-${value}"
                                                     data-value="${value}">
                                                    <input type="radio" 
                                                           class="hidden" 
                                                           name="question_${question.id}" 
                                                           value="${value}"
                                                           id="q${question.id}_${value}">
                                                    <div class="text-3xl font-bold text-slate-900 dark:text-white mb-2 likert-value">
                                                        ${value}
                                                    </div>
                                                    <div class="text-center text-sm text-slate-600 dark:text-slate-400">
                                                        <c:choose>
                                                            <c:when test="${value == 1}">Hoàn toàn<br>không phù hợp</c:when>
                                                            <c:when test="${value == 2}">Không<br>phù hợp</c:when>
                                                            <c:when test="${value == 3}">Bình thường</c:when>
                                                            <c:when test="${value == 4}">Phù hợp</c:when>
                                                            <c:when test="${value == 5}">Rất phù hợp</c:when>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </c:forEach>
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
                                            
                                            <div class="flex items-center space-x-4">
                                                <!-- Next/Submit Button -->
                                                <div>
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
                                                                Xem kết quả ngay
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </form>
                        </div>
                        
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
                        <div class="mt-8 p-6 bg-blue-50 dark:bg-blue-900/20 rounded-2xl border border-blue-200 dark:border-blue-800">
                            <div class="flex items-start">
                                <span class="material-symbols-outlined text-blue-500 dark:text-blue-400 mr-3 mt-1">tips_and_updates</span>
                                <div>
                                    <h3 class="text-lg font-semibold text-blue-900 dark:text-blue-300 mb-2">Mẹo làm bài đánh giá nghề nghiệp</h3>
                                    <p class="text-blue-800 dark:text-blue-400">
                                        • Hãy trả lời theo cảm nhận thật của bạn, không suy nghĩ quá lâu<br>
                                        • Chọn mức độ phù hợp dựa trên sở thích và khả năng thực tế<br>
                                        • Sử dụng phím số 1-5 để chọn nhanh, mũi tên trái/phải để điều hướng<br>
                                        • Câu trả lời sẽ được tự động lưu tạm thời<br>
                                        • Nhìn vào thanh điều hướng bên dưới để biết câu nào đã trả lời và đáp án là gì
                                    </p>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- No Questions State (giữ nguyên) -->
                        <div class="flex-1 flex items-center justify-center">
                            <div class="text-center max-w-md p-8 bg-white dark:bg-slate-800 rounded-2xl shadow-lg">
                                <div class="w-20 h-20 gradient-bg rounded-full flex items-center justify-center mx-auto mb-6">
                                    <span class="material-symbols-outlined text-white text-4xl">warning</span>
                                </div>
                                <h3 class="text-2xl font-bold text-slate-900 dark:text-white mb-3">⚠️ Không có câu hỏi nào</h3>
                                <p class="text-slate-600 dark:text-slate-400 mb-6">
                                    Hiện tại chưa có câu hỏi định hướng nghề nghiệp nào được thiết lập.
                                    Vui lòng quay lại sau hoặc liên hệ với quản trị viên.
                                </p>
                                <a href="${pageContext.request.contextPath}/dashboard" 
                                   class="inline-flex items-center px-6 py-3 gradient-bg text-white font-semibold rounded-xl hover:opacity-90 transition-opacity shadow-lg shadow-quiz-purple/30">
                                    <span class="material-symbols-outlined mr-2">arrow_back</span>
                                    Quay lại Dashboard
                                </a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
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
                for (let i = 1; i <= 5; i++) {
                    const option = document.getElementById(`option-${questionIndex}-${i}`);
                    if (option) {
                        option.classList.remove('selected');
                    }
                }

                // Add selected class to chosen option
                const selectedOption = document.getElementById(`option-${questionIndex}-${value}`);
                if (selectedOption) {
                    selectedOption.classList.add('selected');
                }

                // Update radio button
                const questionEl = document.getElementById('question-' + questionIndex);
                if (questionEl) {
                    const questionId = questionEl.dataset.questionId;
                    const radio = document.querySelector(`input[name="question_${questionId}"][value="${value}"]`);
                    if (radio) {
                        radio.checked = true;
                    }
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
                    showError('Vui lòng chọn mức độ phù hợp trước khi tiếp tục!');
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
                const valueEl = document.getElementById('currentAnswerValue');
                const textEl = document.getElementById('currentAnswerText');
                
                if (currentAnswer !== null) {
                    // Show display
                    display.classList.remove('hidden');
                    
                    // Update value
                    valueEl.setAttribute('data-value', currentAnswer);
                    valueEl.textContent = currentAnswer;
                    
                    // Update text
                    const answerTexts = {
                        1: 'Hoàn toàn không phù hợp',
                        2: 'Không phù hợp',
                        3: 'Bình thường',
                        4: 'Phù hợp',
                        5: 'Rất phù hợp'
                    };
                    textEl.textContent = answerTexts[currentAnswer];
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
                } else if (event.key >= '1' && event.key <= '5') {
                    event.preventDefault();
                    const value = parseInt(event.key);
                    selectOption(currentQuestionIndex, value);
                }
            });

            // Load saved answers from localStorage
            function loadSavedAnswers() {
                try {
                    const saved = localStorage.getItem('career_quiz_answers');
                    if (saved) {
                        const data = JSON.parse(saved);
                        const now = new Date().getTime();
                        const oneHour = 60 * 60 * 1000;

                        if (now - data.timestamp < oneHour) {
                            answers = data.answers || new Array(totalQuestions).fill(null);

                            // Restore selections and UI
                            answers.forEach((answer, index) => {
                                if (answer !== null) {
                                    // Update radio button
                                    const questionEl = document.getElementById('question-' + index);
                                    if (questionEl) {
                                        const questionId = questionEl.dataset.questionId;
                                        const radio = document.querySelector(`input[name="question_${questionId}"][value="${answer}"]`);
                                        if (radio) {
                                            radio.checked = true;
                                        }
                                    }
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
                    localStorage.removeItem('career_quiz_answers');
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
                    localStorage.setItem('career_quiz_answers', JSON.stringify(saveData));
                }
            });

            // Form submission validation
            document.getElementById('careerQuizForm')?.addEventListener('submit', function (event) {
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
                    localStorage.removeItem('career_quiz_answers');

                    // Show confirmation
                    if (!confirm('Bạn đã hoàn thành tất cả câu hỏi! Bấm OK để xem kết quả.')) {
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