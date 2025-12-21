<%-- 
    Document   : mbti-quiz
    Created on : 21 thg 12, 2025, 18:25:11
    Author     : Admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz MBTI - Khám phá tính cách</title>
    <style>
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
        
        .progress-bar {
            height: 8px;
            background: #e9ecef;
            border-radius: 4px;
            overflow: hidden;
            margin-top: 20px;
        }
        
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            border-radius: 4px;
            transition: width 0.3s ease;
        }
        
        .question-container {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
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
        
        .options-container {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .option-label {
            display: flex;
            align-items: center;
            padding: 20px;
            border: 2px solid #e9ecef;
            border-radius: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .option-label:hover {
            border-color: #667eea;
            background: #f8f9ff;
        }
        
        .option-label.selected {
            border-color: #667eea;
            background: #f8f9ff;
        }
        
        .option-radio {
            margin-right: 15px;
            width: 20px;
            height: 20px;
            accent-color: #667eea;
        }
        
        .option-text {
            font-size: 16px;
            color: #333;
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
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: scale(1.05);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            background: #e9ecef;
            color: #333;
        }
        
        .btn-secondary:hover {
            background: #dee2e6;
        }
        
        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            border-left: 4px solid #dc3545;
        }
        
        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }
            
            .quiz-header, .question-container {
                padding: 20px;
            }
            
            .question-text {
                font-size: 18px;
            }
            
            .nav-buttons {
                flex-direction: column;
                gap: 10px;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <form id="quizForm" action="${pageContext.request.contextPath}/quiz/mbti/submit" method="post">
            <!-- Header -->
            <div class="quiz-header">
                <h1>🎭 Trắc nghiệm MBTI</h1>
                <p>Khám phá tính cách thật của bạn qua 20 câu hỏi</p>
                <div class="progress-bar">
                    <div class="progress-fill" id="progressFill"></div>
                </div>
            </div>
            
            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="error-message">
                    ${error}
                </div>
            </c:if>
            
            <!-- Questions -->
            <c:forEach var="question" items="${questions}" varStatus="status">
                <div class="question-container" id="question-${status.index}" 
                     style="${status.index == 0 ? '' : 'display: none;'}">
                    
                    <div class="question-number">
                        Câu ${status.index + 1} / ${fn:length(questions)}
                    </div>
                    
                    <div class="question-text">
                        ${question.questionText}
                    </div>
                    
                    <div class="options-container">
                        <label class="option-label" onclick="selectOption(this, ${question.id}, 'A')">
                            <input type="radio" class="option-radio" 
                                   name="question_${question.id}" 
                                   value="A" 
                                   onclick="selectOption(this.parentNode, ${question.id}, 'A')">
                            <span class="option-text">${question.optionAText}</span>
                        </label>
                        
                        <label class="option-label" onclick="selectOption(this, ${question.id}, 'B')">
                            <input type="radio" class="option-radio" 
                                   name="question_${question.id}" 
                                   value="B"
                                   onclick="selectOption(this.parentNode, ${question.id}, 'B')">
                            <span class="option-text">${question.optionBText}</span>
                        </label>
                    </div>
                    
                    <div class="nav-buttons">
                        <c:if test="${status.index > 0}">
                            <button type="button" class="btn btn-secondary" onclick="showQuestion(${status.index - 1})">
                                ← Câu trước
                            </button>
                        </c:if>
                        
                        <c:choose>
                            <c:when test="${status.index < fn:length(questions) - 1}">
                                <button type="button" class="btn btn-primary" onclick="showQuestion(${status.index + 1})">
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
                </div>
            </c:forEach>
        </form>
    </div>
    
    <script>
        let currentQuestion = 0;
        const totalQuestions = ${fn:length(questions)};
        
        function updateProgress() {
            const progress = ((currentQuestion + 1) / totalQuestions) * 100;
            document.getElementById('progressFill').style.width = progress + '%';
        }
        
        function showQuestion(index) {
            if (index >= 0 && index < totalQuestions) {
                document.getElementById('question-' + currentQuestion).style.display = 'none';
                document.getElementById('question-' + index).style.display = 'block';
                currentQuestion = index;
                updateProgress();
            }
        }
        
        function selectOption(label, questionId, optionValue) {
            // Remove selected class from all options in this question
            const container = label.parentElement;
            const labels = container.querySelectorAll('.option-label');
            labels.forEach(l => l.classList.remove('selected'));
            
            // Add selected class to clicked option
            label.classList.add('selected');
            
            // Update the radio button
            const radio = label.querySelector('input[type="radio"]');
            radio.checked = true;
        }
        
        // Initialize
        updateProgress();
        
        // Keyboard navigation
        document.addEventListener('keydown', function(event) {
            if (event.key === 'ArrowRight') {
                showQuestion(Math.min(currentQuestion + 1, totalQuestions - 1));
            } else if (event.key === 'ArrowLeft') {
                showQuestion(Math.max(currentQuestion - 1, 0));
            } else if (event.key >= '1' && event.key <= '2') {
                const optionIndex = parseInt(event.key) - 1;
                const container = document.getElementById('question-' + currentQuestion);
                const labels = container.querySelectorAll('.option-label');
                if (labels[optionIndex]) {
                    selectOption(labels[optionIndex], 0, optionIndex === 0 ? 'A' : 'B');
                }
            }
        });
    </script>
</body>
</html>
