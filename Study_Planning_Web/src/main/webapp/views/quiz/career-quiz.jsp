<%-- 
    Document   : career-quiz.jsp
    Created on : 21 thg 12, 2025, 23:26:05
    Author     : Admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Định hướng Nghề nghiệp</title>
        <style>
            .quick-nav-btn.answered {
                background: #d1fae5;
                border-color: #10b981;
                color: #065f46;
            }
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                padding: 20px;
            }

            .container {
                max-width: 800px;
                margin: 0 auto;
                padding: 20px;
            }

            .quiz-header {
                background: white;
                border-radius: 20px;
                padding: 30px;
                margin-bottom: 30px;
                box-shadow: 0 20px 60px rgba(0,0,0,0.1);
                text-align: center;
            }

            .quiz-header h1 {
                color: #333;
                font-size: 32px;
                margin-bottom: 10px;
            }

            .quiz-header p {
                color: #666;
                font-size: 16px;
                margin-bottom: 20px;
            }

            .progress-container {
                margin-top: 20px;
            }

            .progress-info {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 10px;
                font-size: 14px;
                color: #666;
            }

            .progress-bar {
                height: 8px;
                background: #e9ecef;
                border-radius: 4px;
                overflow: hidden;
            }

            .progress-fill {
                height: 100%;
                background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
                border-radius: 4px;
                transition: width 0.3s ease;
                width: 0%;
            }

            .question-container {
                background: white;
                border-radius: 20px;
                padding: 30px;
                margin-bottom: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                display: none;
            }

            .question-container.active {
                display: block;
                animation: fadeIn 0.5s ease;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .question-number {
                font-size: 14px;
                color: #667eea;
                font-weight: 600;
                margin-bottom: 10px;
            }

            .question-text {
                font-size: 20px;
                color: #333;
                margin-bottom: 25px;
                line-height: 1.5;
            }

            .likert-scale {
                display: flex;
                justify-content: space-between;
                gap: 10px;
                margin-bottom: 30px;
            }

            @media (max-width: 768px) {
                .likert-scale {
                    flex-direction: column;
                    gap: 15px;
                }
            }

            .likert-option {
                flex: 1;
                text-align: center;
            }

            .likert-input {
                display: none;
            }

            .likert-label {
                display: block;
                padding: 20px 15px;
                border: 2px solid #e9ecef;
                border-radius: 15px;
                cursor: pointer;
                transition: all 0.3s ease;
                background: white;
            }

            .likert-label:hover {
                border-color: #667eea;
                background: #f8f9ff;
                transform: translateY(-2px);
            }

            .likert-input:checked + .likert-label {
                border-color: #667eea;
                background: #f8f9ff;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(102, 126, 234, 0.2);
            }

            .likert-value {
                font-size: 20px;
                font-weight: bold;
                color: #333;
                margin-bottom: 5px;
            }

            .likert-text {
                font-size: 14px;
                color: #666;
            }

            .nav-buttons {
                display: flex;
                justify-content: space-between;
                margin-top: 30px;
            }

            .btn {
                padding: 15px 30px;
                border-radius: 25px;
                border: none;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
            }

            .btn-primary {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }

            .btn-primary:hover:not(:disabled) {
                transform: translateY(-2px);
                box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
            }

            .btn-primary:disabled {
                opacity: 0.5;
                cursor: not-allowed;
            }

            .btn-secondary {
                background: #e9ecef;
                color: #333;
            }

            .btn-secondary:hover {
                background: #dee2e6;
            }

            .btn-secondary.hidden {
                visibility: hidden;
            }

            .error-message {
                background: #f8d7da;
                color: #721c24;
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 20px;
                border-left: 4px solid #dc3545;
                display: none;
            }

            .error-message.show {
                display: block;
                animation: shake 0.5s;
            }

            @keyframes shake {
                0%, 100% {
                    transform: translateX(0);
                }
                25% {
                    transform: translateX(-5px);
                }
                75% {
                    transform: translateX(5px);
                }
            }

            .quick-nav {
                display: flex;
                flex-wrap: wrap;
                gap: 8px;
                margin-top: 20px;
                justify-content: center;
            }

            .quick-nav-btn {
                width: 35px;
                height: 35px;
                border-radius: 50%;
                border: 2px solid #e9ecef;
                background: white;
                color: #666;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .quick-nav-btn:hover {
                border-color: #667eea;
                color: #667eea;
            }

            .quick-nav-btn.active {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border-color: transparent;
            }

            .time-indicator {
                display: inline-block;
                padding: 8px 16px;
                background: rgba(255, 255, 255, 0.9);
                border-radius: 20px;
                font-size: 14px;
                color: #666;
                margin-top: 10px;
            }

            .no-questions {
                text-align: center;
                padding: 40px;
                background: white;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            }

            .no-questions h3 {
                color: #667eea;
                margin-bottom: 15px;
                font-size: 24px;
            }

            .no-questions p {
                color: #666;
                margin-bottom: 25px;
                font-size: 16px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <!-- Error Message -->
            <div id="error-message" class="error-message">
                <span id="error-text"></span>
            </div>

            <!-- Quiz Header -->
            <div class="quiz-header">
                <h1>🎯 Định hướng Nghề nghiệp</h1>
                <p>Tìm hiểu nghề nghiệp phù hợp với sở thích và năng lực của bạn</p>

                <div class="progress-container">
                    <div class="progress-info">
                        <span>Tiến độ: <span id="current-question">1</span>/<span id="total-questions">
                                <c:choose>
                                    <c:when test="${not empty questions}">${fn:length(questions)}</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </span></span>
                        <span id="completion-percent">0%</span>
                    </div>
                    <div class="progress-bar">
                        <div class="progress-fill" id="progress-fill"></div>
                    </div>
                </div>

                <!-- Time Estimate -->
                <div class="time-indicator">
                    ⏱️ Thời gian ước tính: 
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
            </div>

            <!-- Questions -->
            <c:choose>
                <c:when test="${not empty questions}">
                    <form id="careerQuizForm" method="post" action="${pageContext.request.contextPath}/quiz/career/submit">
                        <c:forEach var="question" items="${questions}" varStatus="status">
                            <div class="question-container" id="question-${status.index}" data-question-id="${question.id}">
                                <div class="question-number">
                                    Câu ${status.index + 1} / ${fn:length(questions)} - Đánh giá mức độ phù hợp
                                </div>

                                <div class="question-text">
                                    ${question.questionText}
                                </div>

                                <!-- Likert Scale -->
                                <div class="likert-scale">
                                    <div class="likert-option">
                                        <input type="radio" class="likert-input" 
                                               id="q${question.id}_1" 
                                               name="question_${question.id}" 
                                               value="1"
                                               onchange="selectOption(${status.index}, 1)">
                                        <label class="likert-label" for="q${question.id}_1">
                                            <div class="likert-value">1</div>
                                            <div class="likert-text">Hoàn toàn<br>không phù hợp</div>
                                        </label>
                                    </div>

                                    <div class="likert-option">
                                        <input type="radio" class="likert-input" 
                                               id="q${question.id}_2" 
                                               name="question_${question.id}" 
                                               value="2"
                                               onchange="selectOption(${status.index}, 2)">
                                        <label class="likert-label" for="q${question.id}_2">
                                            <div class="likert-value">2</div>
                                            <div class="likert-text">Không<br>phù hợp</div>
                                        </label>
                                    </div>

                                    <div class="likert-option">
                                        <input type="radio" class="likert-input" 
                                               id="q${question.id}_3" 
                                               name="question_${question.id}" 
                                               value="3"
                                               onchange="selectOption(${status.index}, 3)">
                                        <label class="likert-label" for="q${question.id}_3">
                                            <div class="likert-value">3</div>
                                            <div class="likert-text">Bình thường</div>
                                        </label>
                                    </div>

                                    <div class="likert-option">
                                        <input type="radio" class="likert-input" 
                                               id="q${question.id}_4" 
                                               name="question_${question.id}" 
                                               value="4"
                                               onchange="selectOption(${status.index}, 4)">
                                        <label class="likert-label" for="q${question.id}_4">
                                            <div class="likert-value">4</div>
                                            <div class="likert-text">Phù hợp</div>
                                        </label>
                                    </div>

                                    <div class="likert-option">
                                        <input type="radio" class="likert-input" 
                                               id="q${question.id}_5" 
                                               name="question_${question.id}" 
                                               value="5"
                                               onchange="selectOption(${status.index}, 5)">
                                        <label class="likert-label" for="q${question.id}_5">
                                            <div class="likert-value">5</div>
                                            <div class="likert-text">Rất phù hợp</div>
                                        </label>
                                    </div>
                                </div>

                                <!-- Navigation Buttons -->
                                <div class="nav-buttons">
                                    <c:if test="${status.index > 0}">
                                        <button type="button" class="btn btn-secondary" onclick="prevQuestion()">
                                            ← Câu trước
                                        </button>
                                    </c:if>

                                    <c:choose>
                                        <c:when test="${status.index < fn:length(questions) - 1}">
                                            <button type="button" class="btn btn-primary" onclick="nextQuestion()">
                                                Câu tiếp theo →
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="submit" class="btn btn-primary">
                                                Xem kết quả 🎯
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Quick Navigation -->
                                <div class="quick-nav">
                                    <c:forEach var="i" begin="1" end="${fn:length(questions)}">
                                        <button type="button" 
                                                class="quick-nav-btn ${i == status.index + 1 ? 'active' : ''}"
                                                onclick="showQuestion(${i - 1})">
                                            ${i}
                                        </button>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:forEach>
                    </form>
                </c:when>
                <c:otherwise>
                    <!-- No Questions State -->
                    <div class="no-questions">
                        <h3>⚠️ Không có câu hỏi nào</h3>
                        <p>Hiện tại chưa có câu hỏi định hướng nghề nghiệp nào được thiết lập.</p>
                        <p>Vui lòng quay lại sau hoặc liên hệ với quản trị viên.</p>
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary" style="margin-top: 20px;">
                            ← Quay lại Dashboard
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <script>
            // Quiz state
            let currentQuestion = 0;
            const totalQuestions = document.querySelectorAll('.question-container').length;
            let answers = new Array(totalQuestions).fill(null);
            let startTime = new Date();

            // Initialize
            if (totalQuestions > 0) {
                showQuestion(0);
                updateProgress();
                loadSavedAnswers();
            }

            function showQuestion(index) {
                if (index < 0 || index >= totalQuestions)
                    return;

                // Hide all questions
                document.querySelectorAll('.question-container').forEach(q => {
                    q.classList.remove('active');
                });

                // Show selected question
                const question = document.getElementById('question-' + index);
                if (question) {
                    question.classList.add('active');
                    currentQuestion = index;
                    updateProgress();
                    updateQuickNav();

                    // Scroll to top
                    window.scrollTo({top: 0, behavior: 'smooth'});
                }
            }

            function selectOption(questionIndex, value) {
                if (questionIndex < 0 || questionIndex >= totalQuestions)
                    return;

                // Save answer
                answers[questionIndex] = value;
                hideError();
                updateQuickNav();

                // Auto-advance on option 5 - chỉ khi đang ở câu đó
                if (value === 5 && questionIndex === currentQuestion && currentQuestion < totalQuestions - 1) {
                    setTimeout(() => {
                        nextQuestion();
                    }, 500);
                }
            }

            function nextQuestion() {
                // Kiểm tra câu trả lời hiện tại
                if (answers[currentQuestion] === null) {
                    showError('Vui lòng chọn mức độ phù hợp trước khi tiếp tục!');
                    return;
                }

                hideError();

                // Chuyển đến câu tiếp theo
                if (currentQuestion < totalQuestions - 1) {
                    showQuestion(currentQuestion + 1);
                }
            }

            function prevQuestion() {
                if (currentQuestion > 0) {
                    showQuestion(currentQuestion - 1);
                }
            }

            function updateProgress() {
                const progress = ((currentQuestion + 1) / totalQuestions) * 100;

                // Update progress bar
                const progressFill = document.getElementById('progress-fill');
                if (progressFill) {
                    progressFill.style.width = progress + '%';
                }

                // Update percentage
                const completionPercent = document.getElementById('completion-percent');
                if (completionPercent) {
                    completionPercent.textContent = Math.round(progress) + '%';
                }

                // Update question number
                const currentQuestionEl = document.getElementById('current-question');
                if (currentQuestionEl) {
                    currentQuestionEl.textContent = currentQuestion + 1;
                }
            }

            function updateQuickNav() {
                document.querySelectorAll('.quick-nav-btn').forEach((btn, index) => {
                    btn.classList.toggle('active', index === currentQuestion);
                    btn.classList.toggle('answered', answers[index] !== null && index !== currentQuestion);
                });
            }

            function showError(message) {
                const errorEl = document.getElementById('error-message');
                const errorText = document.getElementById('error-text');
                if (errorEl && errorText) {
                    errorText.textContent = message;
                    errorEl.classList.add('show');

                    // Auto-hide after 3 seconds
                    setTimeout(hideError, 3000);

                    // Shake animation
                    errorEl.style.animation = 'none';
                    setTimeout(() => {
                        errorEl.style.animation = 'shake 0.5s';
                    }, 10);
                }
            }

            function hideError() {
                const errorEl = document.getElementById('error-message');
                if (errorEl) {
                    errorEl.classList.remove('show');
                }
            }

            // Keyboard navigation
            document.addEventListener('keydown', function (event) {
                if (event.key === 'ArrowRight' || event.key === 'Enter') {
                    event.preventDefault();
                    nextQuestion();
                } else if (event.key === 'ArrowLeft') {
                    event.preventDefault();
                    prevQuestion();
                } else if (event.key >= '1' && event.key <= '5') {
                    event.preventDefault();
                    const value = parseInt(event.key);
                    
                    // Gọi hàm selectOption cho câu hỏi hiện tại
                    selectOption(currentQuestion, value);
                    
                    // Cập nhật radio button UI
                    const questionEl = document.getElementById('question-' + currentQuestion);
                    if (questionEl) {
                        const questionId = questionEl.dataset.questionId;
                        const radio = document.querySelector(`input[name="question_${questionId}"][value="${value}"]`);
                        if (radio) {
                            radio.checked = true;
                        }
                    }
                }
            });

            // Load saved answers
            function loadSavedAnswers() {
                try {
                    const saved = localStorage.getItem('career_quiz_answers');
                    if (saved) {
                        const data = JSON.parse(saved);
                        const now = new Date().getTime();
                        const oneHour = 60 * 60 * 1000;

                        // Chỉ load nếu dữ liệu chưa quá 1 giờ
                        if (now - data.timestamp < oneHour) {
                            answers = data.answers || new Array(totalQuestions).fill(null);

                            // Restore radio selections
                            answers.forEach((answer, index) => {
                                if (answer !== null) {
                                    const questionEl = document.getElementById('question-' + index);
                                    if (questionEl) {
                                        const questionId = questionEl.dataset.questionId;
                                        const radio = document.querySelector(`input[name="question_${questionId}"][value="${answer}"]`);
                                        if (radio) {
                                            radio.checked = true;
                                        }
                                    }
                                }
                            });

                            updateQuickNav();
                        }
                    }
                } catch (e) {
                    console.error('Error loading saved answers:', e);
                    localStorage.removeItem('career_quiz_answers');
                }
            }

            // Save answers on unload
            window.addEventListener('beforeunload', function () {
                if (answers.some(answer => answer !== null)) {
                    const saveData = {
                        answers: answers,
                        timestamp: new Date().getTime(),
                        currentQuestion: currentQuestion
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

            // Cập nhật trạng thái answered cho quick nav khi chọn đáp án
            document.querySelectorAll('.likert-input').forEach(radio => {
                radio.addEventListener('change', function () {
                    updateQuickNav();
                });
            });
            
            // Debug function để kiểm tra
            window.debugAnswers = function() {
                console.log('Current answers:', answers);
                console.log('Current question:', currentQuestion);
                console.log('Is current answered?', answers[currentQuestion] !== null);
            };
        </script>
    </body>
</html>