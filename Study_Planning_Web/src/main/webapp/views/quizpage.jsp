<%-- 
    Document   : quizpage
    Created on : 21 thg 12, 2025, 18:23:14
    Author     : Admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz Home - Dashboard</title>
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
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.1);
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 32px;
            font-weight: bold;
        }
        
        .user-details h1 {
            font-size: 28px;
            color: #333;
            margin-bottom: 5px;
        }
        
        .user-details p {
            color: #666;
            font-size: 16px;
        }
        
        .progress-section {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 20px;
            margin-top: 20px;
        }
        
        .progress-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .progress-title h3 {
            color: #333;
            font-size: 18px;
        }
        
        .progress-percentage {
            font-size: 24px;
            font-weight: bold;
            color: #667eea;
        }
        
        .progress-bar {
            height: 10px;
            background: #e9ecef;
            border-radius: 5px;
            overflow: hidden;
            margin-bottom: 15px;
        }
        
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            border-radius: 5px;
            transition: width 0.5s ease;
        }
        
        .quiz-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-top: 30px;
        }
        
        .quiz-card {
            background: white;
            border-radius: 20px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
            border: 2px solid transparent;
        }
        
        .quiz-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
            border-color: #667eea;
        }
        
        .quiz-card.completed {
            border-color: #28a745;
        }
        
        .quiz-card h3 {
            color: #333;
            font-size: 20px;
            margin-bottom: 10px;
        }
        
        .quiz-card p {
            color: #666;
            font-size: 14px;
            line-height: 1.5;
            margin-bottom: 20px;
        }
        
        .quiz-status {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }
        
        .badge.completed {
            background: #d4edda;
            color: #155724;
        }
        
        .badge.not-started {
            background: #f8d7da;
            color: #721c24;
        }
        
        .btn {
            padding: 12px 24px;
            border-radius: 25px;
            border: none;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: scale(1.05);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .insights-section {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-top: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .insights-section h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 24px;
        }
        
        .insight-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 10px;
            border-left: 4px solid #667eea;
        }
        
        @media (max-width: 768px) {
            .quiz-grid {
                grid-template-columns: 1fr;
            }
            
            .user-info {
                flex-direction: column;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <div class="user-info">
                <div class="avatar">
                    ${userName.charAt(0)}
                </div>
                <div class="user-details">
                    <h1>${userName}</h1>
                    <p>Sinh viên năm 2 – Thích khám phá và học hỏi những điều mới mẻ.</p>
                </div>
            </div>
            
            <!-- Progress Section -->
            <div class="progress-section">
                <div class="progress-title">
                    <h3>Tiến độ hoàn thành quiz</h3>
                    <div class="progress-percentage">
                        ${dashboardData.completionPercentage}%
                    </div>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: ${dashboardData.completionPercentage}%"></div>
                </div>
                <p>${dashboardData.completedQuizzes} / ${dashboardData.totalQuizzes} quiz đã hoàn thành</p>
            </div>
        </div>
        
        <!-- Quiz Grid -->
        <h2 style="color: white; margin: 30px 0 20px; font-size: 28px;">Khám phá bản thân</h2>
        
        <div class="quiz-grid">
            <!-- MBTI Quiz Card -->
            <div class="quiz-card ${dashboardData.mbtiResult != null ? 'completed' : ''}">
                <h3>🎭 Trắc nghiệm Tính cách</h3>
                <p>Khám phá MBTI của bạn để hiểu rõ điểm mạnh và điểm yếu.</p>
                <div class="quiz-status">
                    <c:choose>
                        <c:when test="${dashboardData.mbtiResult != null}">
                            <span class="badge completed">${dashboardData.mbtiResult.mbtiType}</span>
                            <a href="${pageContext.request.contextPath}/quiz/mbti" class="btn btn-primary">Xem kết quả</a>
                        </c:when>
                        <c:otherwise>
                            <span class="badge not-started">Chưa làm</span>
                            <a href="${pageContext.request.contextPath}/quiz/mbti" class="btn btn-primary">Bắt đầu ngay →</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- Work Style Quiz Card -->
            <div class="quiz-card ${dashboardData.workStyleResult != null ? 'completed' : ''}">
                <h3>💼 Phong cách Làm việc</h3>
                <p>Bạn là người dẫn đầu hay người hỗ trợ tuyệt vời trong team?</p>
                <div class="quiz-status">
                    <c:choose>
                        <c:when test="${dashboardData.workStyleResult != null}">
                            <span class="badge completed">${dashboardData.workStyleResult.primaryStyle}</span>
                            <a href="${pageContext.request.contextPath}/quiz/work-style" class="btn btn-primary">Xem kết quả</a>
                        </c:when>
                        <c:otherwise>
                            <span class="badge not-started">Chưa làm</span>
                            <a href="${pageContext.request.contextPath}/quiz/work-style" class="btn btn-primary">Bắt đầu ngay →</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- Learning Style Quiz Card -->
            <div class="quiz-card ${dashboardData.learningStyleResult != null ? 'completed' : ''}">
                <h3>📚 Phong cách Học tập</h3>
                <p>Tìm ra phương pháp học tập tối ưu: VAK (Visual, Auditory, Kinesthetic).</p>
                <div class="quiz-status">
                    <c:choose>
                        <c:when test="${dashboardData.learningStyleResult != null}">
                            <span class="badge completed">${dashboardData.learningStyleResult.primaryStyle}</span>
                            <a href="${pageContext.request.contextPath}/quiz/learning-style" class="btn btn-primary">Xem kết quả</a>
                        </c:when>
                        <c:otherwise>
                            <span class="badge not-started">Chưa làm</span>
                            <a href="${pageContext.request.contextPath}/quiz/learning-style" class="btn btn-primary">Bắt đầu ngay →</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- Career Quiz Card -->
            <div class="quiz-card ${dashboardData.careerResult != null ? 'completed' : ''}">
                <h3>🎯 Định hướng Nghề nghiệp</h3>
                <p>Xác định nghề nghiệp phù hợp dựa trên sở thích và năng lực.</p>
                <div class="quiz-status">
                    <c:choose>
                        <c:when test="${dashboardData.careerResult != null}">
                            <span class="badge completed">Hoàn thành</span>
                            <a href="${pageContext.request.contextPath}/quiz/career" class="btn btn-primary">Xem kết quả</a>
                        </c:when>
                        <c:otherwise>
                            <span class="badge not-started">Chưa làm</span>
                            <a href="${pageContext.request.contextPath}/quiz/career" class="btn btn-primary">Bắt đầu ngay →</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        
        <!-- Insights Section -->
        <div class="insights-section">
            <h2>📊 Insights cá nhân hóa</h2>
            <c:choose>
                <c:when test="${not empty dashboardData.insights}">
                    <c:forEach var="insight" items="${dashboardData.insights}">
                        <div class="insight-item">
                            ${insight}
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p style="color: #666; text-align: center; padding: 20px;">
                        Hoàn thành các bài quiz để nhận insights cá nhân hóa!
                    </p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
