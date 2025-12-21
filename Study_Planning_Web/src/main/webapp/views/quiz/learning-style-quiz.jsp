<%-- 
    Document   : learning-style-quiz
    Created on : 21 thg 12, 2025, 22:08:38
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
    <title>Phong cách Học tập (VAK)</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
            min-height: 100vh;
            padding: 20px;
            margin: 0;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
        }
        
        .quiz-header {
            background: linear-gradient(135deg, #2575fc 0%, #6a11cb 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .quiz-header h1 {
            margin: 0 0 10px 0;
            font-size: 32px;
        }
        
        .quiz-header p {
            margin: 0;
            opacity: 0.9;
        }
        
        .question-container {
            padding: 30px;
        }
        
        .question-card {
            background: #f8f9ff;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            border: 2px solid #e6e9ff;
        }
        
        .question-number {
            color: #2575fc;
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 10px;
        }
        
        .question-text {
            font-size: 18px;
            color: #333;
            margin-bottom: 20px;
            line-height: 1.5;
        }
        
        .options-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
        }
        
        .option-card {
            background: white;
            border: 2px solid #e6e9ff;
            border-radius: 12px;
            padding: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .option-card:hover {
            border-color: #2575fc;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(37, 117, 252, 0.2);
        }
        
        .option-card.selected {
            border-color: #2575fc;
            background: #f0f4ff;
        }
        
        .option-type {
            font-size: 12px;
            font-weight: 600;
            color: #2575fc;
            margin-bottom: 5px;
            text-transform: uppercase;
        }
        
        .option-text {
            font-size: 16px;
            color: #333;
            line-height: 1.4;
        }
        
        .option-radio {
            position: absolute;
            opacity: 0;
        }
        
        .submit-btn {
            display: block;
            width: 100%;
            padding: 18px;
            background: linear-gradient(135deg, #2575fc 0%, #6a11cb 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 20px;
        }
        
        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(37, 117, 252, 0.3);
        }
        
        .submit-btn:active {
            transform: translateY(0);
        }
        
        .error-message {
            background: #ffe6e6;
            color: #d32f2f;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            border-left: 4px solid #d32f2f;
        }
        
        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 15px;
            }
            
            .quiz-header, .question-container {
                padding: 20px;
            }
            
            .options-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="quiz-header">
            <h1>📚 Phong cách Học tập</h1>
            <p>Khám phá phương pháp học tập phù hợp nhất với bạn (VAK Model)</p>
        </div>
        
        <div class="question-container">
            <c:if test="${not empty error}">
                <div class="error-message">
                    ${error}
                </div>
            </c:if>
            
            <form id="learningStyleForm" method="post" 
                  action="${pageContext.request.contextPath}/quiz/learning-style/submit">
                
                <c:forEach var="question" items="${questions}" varStatus="status">
                    <div class="question-card">
                        <div class="question-number">
                            Câu ${status.index + 1} / ${fn:length(questions)}
                        </div>
                        
                        <div class="question-text">
                            ${question.questionText}
                        </div>
                        
                        <div class="options-grid">
                            <label class="option-card" onclick="selectOption(this, ${question.id}, 'VISUAL')">
                                <input type="radio" class="option-radio" 
                                       name="question_${question.id}" value="VISUAL">
                                <div class="option-type">👁️ Hình ảnh</div>
                                <div class="option-text">${question.visualOption}</div>
                            </label>
                            
                            <label class="option-card" onclick="selectOption(this, ${question.id}, 'AUDITORY')">
                                <input type="radio" class="option-radio" 
                                       name="question_${question.id}" value="AUDITORY">
                                <div class="option-type">👂 Âm thanh</div>
                                <div class="option-text">${question.auditoryOption}</div>
                            </label>
                            
                            <label class="option-card" onclick="selectOption(this, ${question.id}, 'KINESTHETIC')">
                                <input type="radio" class="option-radio" 
                                       name="question_${question.id}" value="KINESTHETIC">
                                <div class="option-type">✋ Vận động</div>
                                <div class="option-text">${question.kinestheticOption}</div>
                            </label>
                        </div>
                    </div>
                </c:forEach>
                
                <button type="submit" class="submit-btn">
                    Xem kết quả phân tích của bạn →
                </button>
            </form>
        </div>
    </div>
    
    <script>
        function selectOption(label, questionId, optionValue) {
            // Remove selected class from all options in this question
            const questionCard = label.closest('.question-card');
            const allLabels = questionCard.querySelectorAll('.option-card');
            allLabels.forEach(l => l.classList.remove('selected'));
            
            // Add selected class to clicked option
            label.classList.add('selected');
            
            // Update the radio button
            const radio = label.querySelector('input[type="radio"]');
            radio.checked = true;
        }
        
        // Form validation
        document.getElementById('learningStyleForm').addEventListener('submit', function(event) {
            const questions = ${fn:length(questions)};
            let allAnswered = true;
            
            for (let i = 1; i <= questions; i++) {
                const radios = document.querySelectorAll('input[name="question_' + i + '"]');
                let answered = false;
                
                radios.forEach(radio => {
                    if (radio.checked) answered = true;
                });
                
                if (!answered) {
                    allAnswered = false;
                    // Highlight unanswered question
                    const questionCard = document.querySelector(`input[name="question_${i}"]`)
                        .closest('.question-card');
                    questionCard.style.borderColor = '#d32f2f';
                    questionCard.style.animation = 'shake 0.5s';
                }
            }
            
            if (!allAnswered) {
                event.preventDefault();
                alert('Vui lòng trả lời tất cả các câu hỏi trước khi nộp bài!');
            }
        });
        
        // Add shake animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes shake {
                0%, 100% { transform: translateX(0); }
                25% { transform: translateX(-5px); }
                75% { transform: translateX(5px); }
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>