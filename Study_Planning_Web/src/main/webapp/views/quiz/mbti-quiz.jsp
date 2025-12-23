<%-- 
    Document   : mbti-quiz
    Created on : 21 thg 12, 2025, 18:25:11
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="currentTheme" value="${empty theme ? 'light' : theme}" />
<!DOCTYPE html>
<html lang="vi" class="${currentTheme == 'dark' ? 'dark' : ''}">

<head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>Quiz MBTI - Khám phá tính cách</title>
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
        
        .option-label {
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        
        .option-label:hover {
            border-color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 10px 25px -5px rgba(102, 126, 234, 0.2);
        }
        
        .option-label.selected {
            border-color: #667eea;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
            box-shadow: 0 10px 25px -5px rgba(102, 126, 234, 0.2);
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .question-transition {
            animation: fadeIn 0.3s ease-out;
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
                        Trắc nghiệm MBTI
                    </h1>
                    <p class="text-slate-500 dark:text-slate-400 mt-2">Khám phá tính cách thật của bạn qua ${fn:length(questions)} câu hỏi</p>
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

            <!-- Progress Bar -->
            <div class="mb-8">
                <div class="flex justify-between items-center mb-3">
                    <div class="flex items-center">
                        <span class="text-lg font-semibold text-slate-900 dark:text-white">Tiến độ bài quiz</span>
                        <span class="ml-3 text-sm text-slate-500 dark:text-slate-400" id="progressText">Câu 1/${fn:length(questions)}</span>
                    </div>
                    <span class="text-xl font-bold text-quiz-purple dark:text-pastel-purple" id="percentageText">0%</span>
                </div>
                <div class="w-full h-3 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                    <div class="progress-fill" id="progressFill"></div>
                </div>
            </div>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="mb-6 p-4 bg-red-50 dark:bg-red-900/20 text-red-800 dark:text-red-300 rounded-xl border-l-4 border-red-500">
                    <div class="flex items-center">
                        <span class="material-symbols-outlined mr-3">error</span>
                        <span>${error}</span>
                    </div>
                </div>
            </c:if>

            <!-- Quiz Form -->
            <form id="quizForm" action="${pageContext.request.contextPath}/quiz/mbti/submit" method="post" class="flex-1">
                <c:forEach var="question" items="${questions}" varStatus="status">
                    <div class="question-container bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-8 mb-6 question-transition" 
                         id="question-${status.index}" 
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
                            <!-- Đã xóa phần hiển thị category -->
                        </div>
                        
                        <!-- Question Text -->
                        <h2 class="text-2xl font-bold text-slate-900 dark:text-white mb-8 leading-relaxed">
                            ${question.questionText}
                        </h2>
                        
                        <!-- Options -->
                        <div class="space-y-4 mb-10">
                            <label class="option-label block bg-slate-50 dark:bg-slate-700/50 rounded-xl p-6 cursor-pointer" 
                                   onclick="selectOption(this, ${question.id}, 'A')">
                                <div class="flex items-center">
                                    <div class="w-8 h-8 rounded-full border-2 border-slate-300 dark:border-slate-600 flex items-center justify-center mr-4 option-radio">
                                        <div class="w-4 h-4 rounded-full bg-quiz-purple hidden"></div>
                                    </div>
                                    <input type="radio" 
                                           class="hidden" 
                                           name="question_${question.id}" 
                                           value="A">
                                    <div class="flex-1">
                                        <span class="text-lg font-medium text-slate-900 dark:text-white">${question.optionAText}</span>
                                    </div>
                                </div>
                            </label>
                            
                            <label class="option-label block bg-slate-50 dark:bg-slate-700/50 rounded-xl p-6 cursor-pointer" 
                                   onclick="selectOption(this, ${question.id}, 'B')">
                                <div class="flex items-center">
                                    <div class="w-8 h-8 rounded-full border-2 border-slate-300 dark:border-slate-600 flex items-center justify-center mr-4 option-radio">
                                        <div class="w-4 h-4 rounded-full bg-quiz-purple hidden"></div>
                                    </div>
                                    <input type="radio" 
                                           class="hidden" 
                                           name="question_${question.id}" 
                                           value="B">
                                    <div class="flex-1">
                                        <span class="text-lg font-medium text-slate-900 dark:text-white">${question.optionBText}</span>
                                    </div>
                                </div>
                            </label>
                        </div>
                        
                        <!-- Navigation Buttons -->
                        <div class="flex justify-between items-center pt-6 border-t border-slate-200 dark:border-slate-700">
                            <c:if test="${status.index > 0}">
                                <button type="button" 
                                        class="flex items-center px-6 py-3 text-slate-700 dark:text-slate-300 font-semibold rounded-xl hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors"
                                        onclick="showQuestion(${status.index - 1})">
                                    <span class="material-symbols-outlined mr-2">arrow_back</span>
                                    Câu trước
                                </button>
                            </c:if>
                            
                            <div class="ml-auto">
                                <c:choose>
                                    <c:when test="${status.index < fn:length(questions) - 1}">
                                        <button type="button" 
                                                class="flex items-center px-8 py-3 gradient-bg text-white font-semibold rounded-xl hover:opacity-90 transition-opacity shadow-lg shadow-quiz-purple/30"
                                                onclick="showQuestion(${status.index + 1})">
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
                </c:forEach>
            </form>
            
            <!-- Quiz Tips -->
            <div class="mt-8 p-6 bg-blue-50 dark:bg-blue-900/20 rounded-2xl border border-blue-200 dark:border-blue-800">
                <div class="flex items-start">
                    <span class="material-symbols-outlined text-blue-500 dark:text-blue-400 mr-3 mt-1">tips_and_updates</span>
                    <div>
                        <h3 class="text-lg font-semibold text-blue-900 dark:text-blue-300 mb-2">Mẹo làm bài quiz</h3>
                        <p class="text-blue-800 dark:text-blue-400">
                            • Hãy trả lời theo bản năng đầu tiên, đừng suy nghĩ quá lâu<br>
                            • Không có câu trả lời đúng hay sai, hãy chọn phù hợp nhất với bạn<br>
                            • Bạn có thể quay lại câu trước bất cứ lúc nào<br>
                            • Sử dụng phím 1, 2 để chọn nhanh đáp án, mũi tên trái/phải để điều hướng
                        </p>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <%-- Settings Overlay --%>
    <%@ include file="/views/settings-overlay.jsp" %>

    <script src="${pageContext.request.contextPath}/resources/js/sidebar.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/setting.js"></script>
    
    <script>
        // Định nghĩa các biến và hàm JavaScript
        let currentQuestion = 0;
        const totalQuestions = ${fn:length(questions)};
        const answers = {};
        
        function updateProgress() {
            const progress = ((currentQuestion + 1) / totalQuestions) * 100;
            document.getElementById('progressFill').style.width = progress + '%';
            document.getElementById('percentageText').textContent = Math.round(progress) + '%';
            document.getElementById('progressText').textContent = 'Câu ' + (currentQuestion + 1) + '/' + totalQuestions;
        }
        
        function showQuestion(index) {
            if (index >= 0 && index < totalQuestions) {
                const currentElement = document.getElementById('question-' + currentQuestion);
                const nextElement = document.getElementById('question-' + index);
                
                if (currentElement) {
                    currentElement.style.display = 'none';
                }
                if (nextElement) {
                    nextElement.style.display = 'block';
                    nextElement.classList.add('question-transition');
                    setTimeout(() => {
                        nextElement.classList.remove('question-transition');
                    }, 300);
                }
                currentQuestion = index;
                updateProgress();
                
                // Scroll to top of question
                window.scrollTo({
                    top: nextElement.offsetTop - 100,
                    behavior: 'smooth'
                });
                
                // Check if current question has been answered
                checkCurrentQuestionAnswer();
            }
        }
        
        function selectOption(label, questionId, optionValue) {
            // Remove selected class from all options in this question
            const container = label.parentElement.parentElement;
            const labels = container.querySelectorAll('.option-label');
            labels.forEach(l => {
                l.classList.remove('selected');
                const radioCircle = l.querySelector('.option-radio > div');
                if (radioCircle) radioCircle.classList.add('hidden');
            });
            
            // Add selected class to clicked option
            label.classList.add('selected');
            const radioCircle = label.querySelector('.option-radio > div');
            if (radioCircle) radioCircle.classList.remove('hidden');
            
            // Update the radio button
            const radio = label.querySelector('input[type="radio"]');
            if (radio) radio.checked = true;
            
            // Store answer
            answers[questionId] = optionValue;
        }
        
        function checkCurrentQuestionAnswer() {
            const questionContainer = document.getElementById('question-' + currentQuestion);
            if (questionContainer) {
                // Get question ID from the first question
                const questionIdInput = questionContainer.querySelector('input[type="radio"]');
                if (questionIdInput) {
                    const name = questionIdInput.name;
                    const questionId = name.replace('question_', '');
                    
                    if (answers[questionId]) {
                        const optionValue = answers[questionId];
                        const labels = questionContainer.querySelectorAll('.option-label');
                        labels.forEach(label => {
                            const radio = label.querySelector('input[type="radio"]');
                            if (radio && radio.value === optionValue) {
                                label.classList.add('selected');
                                const radioCircle = label.querySelector('.option-radio > div');
                                if (radioCircle) radioCircle.classList.remove('hidden');
                            }
                        });
                    }
                }
            }
        }
        
        // Form validation before submit
        document.getElementById('quizForm').addEventListener('submit', function(e) {
            if (Object.keys(answers).length < totalQuestions) {
                e.preventDefault();
                alert('Vui lòng trả lời tất cả các câu hỏi trước khi xem kết quả!');
                
                // Find first unanswered question
                for (let i = 0; i < totalQuestions; i++) {
                    const questionContainer = document.getElementById('question-' + i);
                    if (questionContainer) {
                        const questionIdInput = questionContainer.querySelector('input[type="radio"]');
                        if (questionIdInput) {
                            const name = questionIdInput.name;
                            const questionId = name.replace('question_', '');
                            
                            if (!answers[questionId]) {
                                showQuestion(i);
                                break;
                            }
                        }
                    }
                }
            }
        });
        
        // Keyboard navigation
        document.addEventListener('keydown', function(event) {
            if (event.key === 'ArrowRight' || event.key === 'd') {
                showQuestion(Math.min(currentQuestion + 1, totalQuestions - 1));
            } else if (event.key === 'ArrowLeft' || event.key === 'a') {
                showQuestion(Math.max(currentQuestion - 1, 0));
            } else if (event.key === '1') {
                const container = document.getElementById('question-' + currentQuestion);
                const labels = container.querySelectorAll('.option-label');
                if (labels[0]) {
                    const questionIdInput = labels[0].querySelector('input[type="radio"]');
                    if (questionIdInput) {
                        const name = questionIdInput.name;
                        const questionId = name.replace('question_', '');
                        selectOption(labels[0], questionId, 'A');
                    }
                }
            } else if (event.key === '2') {
                const container = document.getElementById('question-' + currentQuestion);
                const labels = container.querySelectorAll('.option-label');
                if (labels[1]) {
                    const questionIdInput = labels[1].querySelector('input[type="radio"]');
                    if (questionIdInput) {
                        const name = questionIdInput.name;
                        const questionId = name.replace('question_', '');
                        selectOption(labels[1], questionId, 'B');
                    }
                }
            }
        });
        
        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            updateProgress();
            
            // Pre-select answers from URL parameters
            const urlParams = new URLSearchParams(window.location.search);
            urlParams.forEach((value, key) => {
                if (key.startsWith('question_')) {
                    const questionId = key.replace('question_', '');
                    answers[questionId] = value;
                }
            });
            
            checkCurrentQuestionAnswer();
        });
    </script>
</body>
</html>