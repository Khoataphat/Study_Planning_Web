<%-- 
    Document   : career-result.jsp
    Created on : 21 thg 12, 2025, 23:28:30
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
    <title>Kết quả Định hướng Nghề nghiệp</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .result-header {
            background: white;
            border-radius: 20px;
            padding: 40px;
            margin-bottom: 30px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .congratulations {
            font-size: 24px;
            color: #f5576c;
            margin-bottom: 15px;
            font-weight: bold;
        }
        
        .result-header h1 {
            color: #333;
            font-size: 32px;
            margin-bottom: 15px;
        }
        
        .result-description {
            color: #666;
            font-size: 18px;
            line-height: 1.6;
            max-width: 800px;
            margin: 0 auto 20px;
        }
        
        .completion-badge {
            display: inline-block;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 10px 25px;
            border-radius: 50px;
            font-weight: bold;
            font-size: 18px;
            margin-top: 15px;
        }
        
        /* Score Radar Chart */
        .score-section {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .score-section h2 {
            color: #333;
            margin-bottom: 25px;
            font-size: 24px;
            text-align: center;
        }
        
        .score-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            align-items: center;
        }
        
        @media (max-width: 1024px) {
            .score-grid {
                grid-template-columns: 1fr;
            }
        }
        
        .radar-container {
            position: relative;
            height: 400px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .radar-canvas {
            max-width: 100%;
            height: auto;
        }
        
        .score-breakdown {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .score-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px;
            background: #f8f9ff;
            border-radius: 10px;
            transition: transform 0.3s ease;
        }
        
        .score-item:hover {
            transform: translateX(5px);
            background: #f0f2ff;
        }
        
        .score-category {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
            color: #333;
        }
        
        .score-category-icon {
            font-size: 20px;
        }
        
        .score-bar-container {
            flex: 1;
            margin: 0 20px;
            height: 8px;
            background: #e9ecef;
            border-radius: 4px;
            overflow: hidden;
        }
        
        .score-bar {
            height: 100%;
            border-radius: 4px;
            transition: width 1.5s ease;
        }
        
        .score-value {
            font-weight: bold;
            font-size: 18px;
            color: #333;
            min-width: 50px;
            text-align: right;
        }
        
        /* Top Careers */
        .careers-section {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .careers-section h2 {
            color: #333;
            margin-bottom: 25px;
            font-size: 24px;
            text-align: center;
        }
        
        .careers-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
        }
        
        .career-card {
            background: #f8f9ff;
            border-radius: 15px;
            padding: 25px;
            border-left: 4px solid;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .career-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(240, 147, 251, 0.2);
        }
        
        .career-card.tech { border-left-color: #2575fc; }
        .career-card.business { border-left-color: #00b09b; }
        .career-card.creative { border-left-color: #ff5e62; }
        .career-card.science { border-left-color: #8e44ad; }
        .career-card.education { border-left-color: #f39c12; }
        .career-card.social { border-left-color: #27ae60; }
        
        .career-rank {
            position: absolute;
            top: 15px;
            right: 15px;
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 18px;
        }
        
        .career-icon {
            font-size: 32px;
            margin-bottom: 15px;
        }
        
        .career-title {
            font-size: 20px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }
        
        .career-category {
            display: inline-block;
            padding: 5px 12px;
            background: rgba(0,0,0,0.05);
            border-radius: 20px;
            font-size: 12px;
            color: #666;
            margin-bottom: 15px;
        }
        
        .career-description {
            color: #666;
            line-height: 1.5;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .career-details {
            display: flex;
            justify-content: space-between;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #e6e9ff;
        }
        
        .career-detail-item {
            text-align: center;
        }
        
        .detail-label {
            font-size: 12px;
            color: #999;
            margin-bottom: 5px;
        }
        
        .detail-value {
            font-weight: 600;
            color: #333;
        }
        
        /* Next Steps */
        .next-steps {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .next-steps h2 {
            color: #333;
            margin-bottom: 25px;
            font-size: 24px;
            text-align: center;
        }
        
        .steps-timeline {
            position: relative;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .steps-timeline:before {
            content: '';
            position: absolute;
            left: 50%;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #e6e9ff;
            transform: translateX(-50%);
        }
        
        @media (max-width: 768px) {
            .steps-timeline:before {
                left: 30px;
            }
        }
        
        .timeline-step {
            display: flex;
            margin-bottom: 40px;
            position: relative;
        }
        
        .timeline-step:nth-child(odd) {
            flex-direction: row;
        }
        
        .timeline-step:nth-child(even) {
            flex-direction: row-reverse;
        }
        
        @media (max-width: 768px) {
            .timeline-step {
                flex-direction: row !important;
            }
        }
        
        .step-marker {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 20px;
            position: relative;
            z-index: 1;
            flex-shrink: 0;
        }
        
        .step-content {
            flex: 1;
            padding: 20px;
            background: #f8f9ff;
            border-radius: 15px;
            margin: 0 30px;
        }
        
        @media (max-width: 768px) {
            .step-content {
                margin: 0 0 0 30px;
            }
        }
        
        .step-content h3 {
            color: #333;
            margin-bottom: 10px;
            font-size: 18px;
        }
        
        .step-content p {
            color: #666;
            line-height: 1.5;
            font-size: 14px;
        }
        
        /* Comparison */
        .comparison-section {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .comparison-section h2 {
            color: #333;
            margin-bottom: 25px;
            font-size: 24px;
            text-align: center;
        }
        
        .comparison-chart {
            height: 300px;
            position: relative;
            margin: 40px 0;
        }
        
        /* Download & Share */
        .share-download {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .share-download h2 {
            color: #333;
            margin-bottom: 25px;
            font-size: 24px;
        }
        
        .action-buttons-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .action-btn {
            padding: 20px;
            border-radius: 15px;
            text-decoration: none;
            color: white;
            font-weight: 600;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: all 0.3s ease;
        }
        
        .action-btn:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }
        
        .action-btn.pdf { background: linear-gradient(135deg, #ff5e62 0%, #ff9966 100%); }
        .action-btn.image { background: linear-gradient(135deg, #2575fc 0%, #6a11cb 100%); }
        .action-btn.share { background: linear-gradient(135deg, #00b09b 0%, #96c93d 100%); }
        .action-btn.print { background: linear-gradient(135deg, #8e44ad 0%, #9b59b6 100%); }
        
        .action-icon {
            font-size: 32px;
        }
        
        /* Navigation Buttons */
        .nav-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 40px;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 15px 30px;
            border-radius: 25px;
            border: none;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 180px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(240, 147, 251, 0.3);
        }
        
        .btn-secondary {
            background: white;
            color: #f5576c;
            border: 2px solid #f5576c;
        }
        
        .btn-secondary:hover {
            background: #f8f9ff;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(245, 87, 108, 0.1);
        }
        
        .btn-retake {
            background: linear-gradient(135deg, #2575fc 0%, #6a11cb 100%);
            color: white;
        }
        
        .btn-retake:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(37, 117, 252, 0.3);
        }
        
        /* Insights */
        .insights-section {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .insights-section h2 {
            color: #333;
            margin-bottom: 25px;
            font-size: 24px;
            text-align: center;
        }
        
        .insights-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
        }
        
        .insight-card {
            background: #f8f9ff;
            border-radius: 15px;
            padding: 25px;
            text-align: center;
        }
        
        .insight-icon {
            font-size: 40px;
            margin-bottom: 15px;
        }
        
        .insight-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }
        
        .insight-text {
            color: #666;
            line-height: 1.5;
            font-size: 14px;
        }
        
        /* Animation */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .animate-on-scroll {
            animation: fadeInUp 0.6s ease forwards;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .result-header, .score-section, .careers-section,
            .next-steps, .comparison-section, .share-download,
            .insights-section {
                padding: 20px;
            }
            
            .nav-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn {
                width: 100%;
                max-width: 300px;
            }
            
            .careers-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Result Header -->
        <div class="result-header">
            <div class="congratulations">🎉 Chúc mừng bạn đã hoàn thành!</div>
            <h1>Kết quả Định hướng Nghề nghiệp</h1>
            <p class="result-description">
                Dựa trên phân tích sở thích và năng lực của bạn, đây là những lĩnh vực nghề nghiệp phù hợp nhất.
                Kết quả này sẽ giúp bạn có cái nhìn rõ ràng hơn về con đường sự nghiệp tương lai.
            </p>
            <div class="completion-badge">
                🎯 Hoàn thành: ${fn:length(questions)} câu hỏi
            </div>
        </div>
        
        <!-- Top Category -->
        <c:if test="${not empty scoreBreakdown}">
            <c:set var="topCategory" value="" />
            <c:set var="topScore" value="0" />
            <c:forEach var="entry" items="${scoreBreakdown}">
                <c:if test="${entry.value > topScore}">
                    <c:set var="topCategory" value="${entry.key}" />
                    <c:set var="topScore" value="${entry.value}" />
                </c:if>
            </c:forEach>
            
            <div class="result-header" style="margin-top: -20px;">
                <h2 style="color: #f5576c; margin-bottom: 10px;">⭐ Lĩnh vực nổi bật nhất</h2>
                <div style="font-size: 28px; font-weight: bold; color: #333; margin-bottom: 10px;">
                    <c:choose>
                        <c:when test="${topCategory == 'Công nghệ'}">💻 ${topCategory}</c:when>
                        <c:when test="${topCategory == 'Kinh doanh'}">📊 ${topCategory}</c:when>
                        <c:when test="${topCategory == 'Sáng tạo'}">🎨 ${topCategory}</c:when>
                        <c:when test="${topCategory == 'Khoa học'}">🔬 ${topCategory}</c:when>
                        <c:when test="${topCategory == 'Giáo dục'}">📚 ${topCategory}</c:when>
                        <c:when test="${topCategory == 'Xã hội'}">🤝 ${topCategory}</c:when>
                        <c:otherwise>${topCategory}</c:otherwise>
                    </c:choose>
                </div>
                <p style="color: #666; max-width: 600px; margin: 0 auto;">
                    <c:choose>
                        <c:when test="${topCategory == 'Công nghệ'}">
                            Bạn có xu hướng phù hợp với các công việc liên quan đến công nghệ, 
                            phân tích và giải quyết vấn đề. Đây là lĩnh vực đang phát triển mạnh với nhiều cơ hội nghề nghiệp.
                        </c:when>
                        <c:when test="${topCategory == 'Kinh doanh'}">
                            Bạn có tố chất trong lĩnh vực kinh doanh, quản lý và chiến lược. 
                            Khả năng lãnh đạo và tư duy kinh doanh sẽ giúp bạn thành công trong môi trường doanh nghiệp.
                        </c:when>
                        <c:when test="${topCategory == 'Sáng tạo'}">
                            Sự sáng tạo và khả năng nghệ thuật là điểm mạnh của bạn. 
                            Các ngành nghề liên quan đến thiết kế, nghệ thuật và sáng tạo nội dung sẽ phát huy tối đa tiềm năng của bạn.
                        </c:when>
                        <c:when test="${topCategory == 'Khoa học'}">
                            Bạn có tư duy phân tích và đam mê khám phá. 
                            Các lĩnh vực nghiên cứu khoa học, y tế và kỹ thuật sẽ là môi trường lý tưởng để bạn phát triển.
                        </c:when>
                        <c:when test="${topCategory == 'Giáo dục'}">
                            Bạn có khả năng truyền đạt và đam mê chia sẻ kiến thức. 
                            Các ngành nghề trong lĩnh vực giáo dục và đào tạo sẽ mang lại cho bạn nhiều ý nghĩa và sự thỏa mãn.
                        </c:when>
                        <c:when test="${topCategory == 'Xã hội'}">
                            Bạn có khả năng thấu hiểu và giúp đỡ người khác. 
                            Các công việc trong lĩnh vực xã hội, tâm lý và nhân sự sẽ phù hợp với giá trị cốt lõi của bạn.
                        </c:when>
                    </c:choose>
                </p>
            </div>
        </c:if>
        
        <!-- Score Breakdown -->
        <div class="score-section animate-on-scroll">
            <h2>📊 Phân tích điểm số các lĩnh vực</h2>
            <div class="score-grid">
                <div class="radar-container">
                    <canvas id="radarChart" class="radar-canvas"></canvas>
                </div>
                <div class="score-breakdown">
                    <c:forEach var="entry" items="${scoreBreakdown}" varStatus="status">
                        <div class="score-item" data-score="${entry.value}">
                            <div class="score-category">
                                <span class="score-category-icon">
                                    <c:choose>
                                        <c:when test="${entry.key == 'Công nghệ'}">💻</c:when>
                                        <c:when test="${entry.key == 'Kinh doanh'}">📊</c:when>
                                        <c:when test="${entry.key == 'Sáng tạo'}">🎨</c:when>
                                        <c:when test="${entry.key == 'Khoa học'}">🔬</c:when>
                                        <c:when test="${entry.key == 'Giáo dục'}">📚</c:when>
                                        <c:when test="${entry.key == 'Xã hội'}">🤝</c:when>
                                        <c:otherwise>📈</c:otherwise>
                                    </c:choose>
                                </span>
                                <span>${entry.key}</span>
                            </div>
                            <div class="score-bar-container">
                                <div class="score-bar" 
                                     style="background: 
                                        <c:choose>
                                            <c:when test="${entry.key == 'Công nghệ'}">linear-gradient(90deg, #2575fc 0%, #6a11cb 100%)</c:when>
                                            <c:when test="${entry.key == 'Kinh doanh'}">linear-gradient(90deg, #00b09b 0%, #96c93d 100%)</c:when>
                                            <c:when test="${entry.key == 'Sáng tạo'}">linear-gradient(90deg, #ff5e62 0%, #ff9966 100%)</c:when>
                                            <c:when test="${entry.key == 'Khoa học'}">linear-gradient(90deg, #8e44ad 0%, #9b59b6 100%)</c:when>
                                            <c:when test="${entry.key == 'Giáo dục'}">linear-gradient(90deg, #f39c12 0%, #f1c40f 100%)</c:when>
                                            <c:when test="${entry.key == 'Xã hội'}">linear-gradient(90deg, #27ae60 0%, #2ecc71 100%)</c:when>
                                            <c:otherwise>linear-gradient(90deg, #f093fb 0%, #f5576c 100%)</c:otherwise>
                                        </c:choose>; width: 0%">
                                </div>
                            </div>
                            <div class="score-value">0</div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
        
        <!-- Top Career Recommendations -->
        <div class="careers-section animate-on-scroll">
            <h2>💼 Top nghề nghiệp đề xuất cho bạn</h2>
            <div class="careers-grid">
                <c:choose>
                    <c:when test="${not empty careerRecommendations}">
                        <c:forEach var="category" items="${careerRecommendations}" varStatus="catStatus">
                            <c:forEach var="career" items="${category.careers}" varStatus="careerStatus">
                                <c:if test="${careerStatus.index < 2}">
                                    <div class="career-card ${fn:toLowerCase(category.category)}">
                                        <div class="career-rank">#${(catStatus.index * 2) + careerStatus.index + 1}</div>
                                        <div class="career-icon">
                                            <c:choose>
                                                <c:when test="${category.category == 'TECHNOLOGY'}">💻</c:when>
                                                <c:when test="${category.category == 'BUSINESS'}">📊</c:when>
                                                <c:when test="${category.category == 'CREATIVE'}">🎨</c:when>
                                                <c:when test="${category.category == 'SCIENCE'}">🔬</c:when>
                                                <c:when test="${category.category == 'EDUCATION'}">📚</c:when>
                                                <c:when test="${category.category == 'SOCIAL'}">🤝</c:when>
                                            </c:choose>
                                        </div>
                                        <div class="career-title">${career}</div>
                                        <div class="career-category">
                                            <c:choose>
                                                <c:when test="${category.category == 'TECHNOLOGY'}">Công nghệ</c:when>
                                                <c:when test="${category.category == 'BUSINESS'}">Kinh doanh</c:when>
                                                <c:when test="${category.category == 'CREATIVE'}">Sáng tạo</c:when>
                                                <c:when test="${category.category == 'SCIENCE'}">Khoa học</c:when>
                                                <c:when test="${category.category == 'EDUCATION'}">Giáo dục</c:when>
                                                <c:when test="${category.category == 'SOCIAL'}">Xã hội</c:when>
                                            </c:choose>
                                        </div>
                                        <div class="career-description">
                                            <c:choose>
                                                <c:when test="${career.contains('Lập trình')}">
                                                    Phát triển phần mềm, ứng dụng và hệ thống công nghệ. Mức lương khởi điểm: 15-25 triệu VND.
                                                </c:when>
                                                <c:when test="${career.contains('Data')}">
                                                    Phân tích dữ liệu để đưa ra quyết định kinh doanh. Mức lương khởi điểm: 18-30 triệu VND.
                                                </c:when>
                                                <c:when test="${career.contains('Business')}">
                                                    Phân tích và tối ưu hóa hoạt động doanh nghiệp. Mức lương khởi điểm: 12-20 triệu VND.
                                                </c:when>
                                                <c:when test="${career.contains('Marketing')}">
                                                    Phát triển chiến lược tiếp thị và quảng cáo. Mức lương khởi điểm: 10-18 triệu VND.
                                                </c:when>
                                                <c:when test="${career.contains('Design')}">
                                                    Thiết kế giao diện và trải nghiệm người dùng. Mức lương khởi điểm: 12-22 triệu VND.
                                                </c:when>
                                                <c:when test="${career.contains('Research')}">
                                                    Nghiên cứu và phát triển sản phẩm mới. Mức lương khởi điểm: 14-25 triệu VND.
                                                </c:when>
                                                <c:otherwise>
                                                    Nghề nghiệp có triển vọng phát triển tốt trong tương lai. Phù hợp với năng lực và sở thích của bạn.
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="career-details">
                                            <div class="career-detail-item">
                                                <div class="detail-label">Nhu cầu</div>
                                                <div class="detail-value">
                                                    <c:choose>
                                                        <c:when test="${category.category == 'TECHNOLOGY'}">Rất cao</c:when>
                                                        <c:when test="${category.category == 'BUSINESS'}">Cao</c:when>
                                                        <c:otherwise>Trung bình</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            <div class="career-detail-item">
                                                <div class="detail-label">Độ khó</div>
                                                <div class="detail-value">
                                                    <c:choose>
                                                        <c:when test="${category.category == 'TECHNOLOGY'}">Cao</c:when>
                                                        <c:otherwise>Trung bình</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            <div class="career-detail-item">
                                                <div class="detail-label">Triển vọng</div>
                                                <div class="detail-value">Tốt</div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <!-- Default career suggestions -->
                        <div class="career-card tech">
                            <div class="career-rank">#1</div>
                            <div class="career-icon">💻</div>
                            <div class="career-title">Lập trình viên Full-stack</div>
                            <div class="career-category">Công nghệ</div>
                            <div class="career-description">
                                Phát triển cả front-end và back-end của ứng dụng web. Kỹ năng cần có: HTML/CSS, JavaScript, React, Node.js, Database.
                            </div>
                            <div class="career-details">
                                <div class="career-detail-item">
                                    <div class="detail-label">Nhu cầu</div>
                                    <div class="detail-value">Rất cao</div>
                                </div>
                                <div class="career-detail-item">
                                    <div class="detail-label">Mức lương</div>
                                    <div class="detail-value">15-40tr</div>
                                </div>
                                <div class="career-detail-item">
                                    <div class="detail-label">Triển vọng</div>
                                    <div class="detail-value">Tốt</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="career-card business">
                            <div class="career-rank">#2</div>
                            <div class="career-icon">📊</div>
                            <div class="career-title">Business Analyst</div>
                            <div class="career-category">Kinh doanh</div>
                            <div class="career-description">
                                Phân tích nhu cầu doanh nghiệp và đề xuất giải pháp công nghệ. Cầu nối giữa IT và Business.
                            </div>
                            <div class="career-details">
                                <div class="career-detail-item">
                                    <div class="detail-label">Nhu cầu</div>
                                    <div class="detail-value">Cao</div>
                                </div>
                                <div class="career-detail-item">
                                    <div class="detail-label">Mức lương</div>
                                    <div class="detail-value">12-25tr</div>
                                </div>
                                <div class="career-detail-item">
                                    <div class="detail-label">Triển vọng</div>
                                    <div class="detail-value">Tốt</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="career-card creative">
                            <div class="career-rank">#3</div>
                            <div class="career-icon">🎨</div>
                            <div class="career-title">UI/UX Designer</div>
                            <div class="career-category">Sáng tạo</div>
                            <div class="career-description">
                                Thiết kế giao diện và trải nghiệm người dùng cho ứng dụng và website. Kết hợp giữa nghệ thuật và công nghệ.
                            </div>
                            <div class="career-details">
                                <div class="career-detail-item">
                                    <div class="detail-label">Nhu cầu</div>
                                    <div class="detail-value">Cao</div>
                                </div>
                                <div class="career-detail-item">
                                    <div class="detail-label">Mức lương</div>
                                    <div class="detail-value">10-25tr</div>
                                </div>
                                <div class="career-detail-item">
                                    <div class="detail-label">Triển vọng</div>
                                    <div class="detail-value">Tốt</div>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- Next Steps Timeline -->
        <div class="next-steps animate-on-scroll">
            <h2>🚀 Lộ trình phát triển sự nghiệp</h2>
            <div class="steps-timeline">
                <div class="timeline-step">
                    <div class="step-marker">1</div>
                    <div class="step-content">
                        <h3>Khám phá sâu hơn</h3>
                        <p>Tìm hiểu chi tiết về các ngành nghề được đề xuất. Tham gia các buổi workshop, webinar về ngành nghề bạn quan tâm.</p>
                    </div>
                </div>
                
                <div class="timeline-step">
                    <div class="step-marker">2</div>
                    <div class="step-content">
                        <h3>Phát triển kỹ năng</h3>
                        <p>Xác định kỹ năng cần thiết cho ngành nghề mục tiêu. Tham gia các khóa học online hoặc offline để phát triển kỹ năng.</p>
                    </div>
                </div>
                
                <div class="timeline-step">
                    <div class="step-marker">3</div>
                    <div class="step-content">
                        <h3>Thực tập & Trải nghiệm</h3>
                        <p>Tìm kiếm cơ hội thực tập trong lĩnh vực quan tâm. Tham gia các dự án thực tế để tích lũy kinh nghiệm.</p>
                    </div>
                </div>
                
                <div class="timeline-step">
                    <div class="step-marker">4</div>
                    <div class="step-content">
                        <h3>Xây dựng portfolio</h3>
                        <p>Tạo portfolio thể hiện kỹ năng và thành tích của bạn. Chuẩn bị CV và kỹ năng phỏng vấn chuyên nghiệp.</p>
                    </div>
                </div>
                
                <div class="timeline-step">
                    <div class="step-marker">5</div>
                    <div class="step-content">
                        <h3>Ứng tuyển & Phát triển</h3>
                        <p>Bắt đầu ứng tuyển vào các vị trí phù hợp. Không ngừng học hỏi và phát triển trong sự nghiệp.</p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Insights -->
        <div class="insights-section animate-on-scroll">
            <h2>💡 Insights từ kết quả của bạn</h2>
            <div class="insights-grid">
                <div class="insight-card">
                    <div class="insight-icon">🎯</div>
                    <div class="insight-title">Điểm mạnh nổi bật</div>
                    <div class="insight-text">
                        <c:choose>
                            <c:when test="${topCategory == 'Công nghệ'}">
                                Tư duy logic, khả năng giải quyết vấn đề, và sự thích nghi với công nghệ mới.
                            </c:when>
                            <c:when test="${topCategory == 'Kinh doanh'}">
                                Khả năng lãnh đạo, tư duy chiến lược, và kỹ năng giao tiếp hiệu quả.
                            </c:when>
                            <c:when test="${topCategory == 'Sáng tạo'}">
                                Sự sáng tạo, khả năng tư duy hình ảnh, và cảm thụ nghệ thuật tốt.
                            </c:when>
                            <c:otherwise>
                                Khả năng phân tích, tư duy hệ thống, và sự kiên trì trong công việc.
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <div class="insight-card">
                    <div class="insight-icon">📈</div>
                    <div class="insight-title">Xu hướng thị trường</div>
                    <div class="insight-text">
                        Các ngành nghề trong lĩnh vực ${topCategory} đang có nhu cầu nhân lực cao tại Việt Nam với mức tăng trưởng 15-20%/năm.
                    </div>
                </div>
                
                <div class="insight-card">
                    <div class="insight-icon">🎓</div>
                    <div class="insight-title">Đề xuất học tập</div>
                    <div class="insight-text">
                        Nên tập trung vào các chương trình đào tạo liên quan đến ${topCategory} tại các trường đại học hàng đầu hoặc khóa học trực tuyến.
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Download & Share -->
        <div class="share-download animate-on-scroll">
            <h2>📤 Lưu trữ & Chia sẻ kết quả</h2>
            <div class="action-buttons-grid">
                <a href="#" class="action-btn pdf" onclick="downloadPDF()">
                    <div class="action-icon">📄</div>
                    <div>Tải PDF báo cáo</div>
                </a>
                
                <a href="#" class="action-btn image" onclick="downloadImage()">
                    <div class="action-icon">🖼️</div>
                    <div>Tải hình ảnh</div>
                </a>
                
                <a href="#" class="action-btn share" onclick="shareResults()">
                    <div class="action-icon">📤</div>
                    <div>Chia sẻ kết quả</div>
                </a>
                
                <a href="#" class="action-btn print" onclick="window.print()">
                    <div class="action-icon">🖨️</div>
                    <div>In báo cáo</div>
                </a>
            </div>
        </div>
        
        <!-- Navigation Buttons -->
        <div class="nav-buttons">
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                ← Quay lại Dashboard
            </a>
            
            <a href="${pageContext.request.contextPath}/quiz/career" class="btn btn-retake">
                🔄 Làm lại quiz
            </a>
            
            <a href="${pageContext.request.contextPath}/resources" class="btn btn-primary">
                Xem tài nguyên học tập →
            </a>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // Animate score bars
        document.addEventListener('DOMContentLoaded', function() {
            // Animate score bars
            setTimeout(() => {
                document.querySelectorAll('.score-item').forEach(item => {
                    const score = parseInt(item.dataset.score);
                    const maxScore = 100; // Assuming max score is 100
                    const percentage = (score / maxScore) * 100;
                    
                    const bar = item.querySelector('.score-bar');
                    const value = item.querySelector('.score-value');
                    
                    // Animate bar width
                    setTimeout(() => {
                        bar.style.width = percentage + '%';
                    }, 100);
                    
                    // Animate value counter
                    animateCounter(value, 0, score, 1500);
                });
            }, 500);
            
            // Initialize radar chart
            initializeRadarChart();
            
            // Add scroll animations
            initScrollAnimations();
            
            // Add celebration effect
            setTimeout(celebrateResults, 1000);
        });
        
        function animateCounter(element, start, end, duration) {
            let startTimestamp = null;
            const step = (timestamp) => {
                if (!startTimestamp) startTimestamp = timestamp;
                const progress = Math.min((timestamp - startTimestamp) / duration, 1);
                const value = Math.floor(progress * (end - start) + start);
                element.textContent = value;
                
                if (progress < 1) {
                    window.requestAnimationFrame(step);
                }
            };
            window.requestAnimationFrame(step);
        }
        
        function initializeRadarChart() {
            const ctx = document.getElementById('radarChart').getContext('2d');
            
            // Get scores from score breakdown
            const scores = [];
            const labels = [];
            const colors = [];
            
            document.querySelectorAll('.score-item').forEach(item => {
                const category = item.querySelector('.score-category span:nth-child(2)').textContent;
                const score = parseInt(item.dataset.score);
                const barColor = item.querySelector('.score-bar').style.background;
                
                // Extract color from gradient
                let color = '#f093fb'; // default
                if (barColor.includes('#2575fc')) color = '#2575fc';
                else if (barColor.includes('#00b09b')) color = '#00b09b';
                else if (barColor.includes('#ff5e62')) color = '#ff5e62';
                else if (barColor.includes('#8e44ad')) color = '#8e44ad';
                else if (barColor.includes('#f39c12')) color = '#f39c12';
                else if (barColor.includes('#27ae60')) color = '#27ae60';
                
                labels.push(category);
                scores.push(score);
                colors.push(color);
            });
            
            // Create radar chart
            new Chart(ctx, {
                type: 'radar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Điểm số lĩnh vực',
                        data: scores,
                        backgroundColor: 'rgba(240, 147, 251, 0.2)',
                        borderColor: '#f5576c',
                        pointBackgroundColor: colors,
                        pointBorderColor: '#fff',
                        pointHoverBackgroundColor: '#fff',
                        pointHoverBorderColor: colors,
                        pointRadius: 6,
                        pointHoverRadius: 8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        r: {
                            angleLines: {
                                display: true,
                                color: 'rgba(0,0,0,0.1)'
                            },
                            suggestedMin: 0,
                            suggestedMax: 100,
                            ticks: {
                                stepSize: 20,
                                backdropColor: 'transparent'
                            },
                            grid: {
                                color: 'rgba(0,0,0,0.1)'
                            },
                            pointLabels: {
                                font: {
                                    size: 14,
                                    family: "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif"
                                },
                                color: '#333'
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            backgroundColor: 'rgba(0,0,0,0.7)',
                            titleFont: {
                                size: 14
                            },
                            bodyFont: {
                                size: 14
                            },
                            padding: 12,
                            cornerRadius: 8
                        }
                    },
                    animation: {
                        duration: 2000,
                        easing: 'easeOutQuart'
                    }
                }
            });
        }
        
        function initScrollAnimations() {
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('animate-on-scroll');
                    }
                });
            }, {
                threshold: 0.1
            });
            
            document.querySelectorAll('.score-section, .careers-section, .next-steps, .insights-section, .share-download')
                .forEach(section => observer.observe(section));
        }
        
        function celebrateResults() {
            const confettiCount = 150;
            const colors = ['#f093fb', '#f5576c', '#2575fc', '#00b09b', '#ff5e62', '#8e44ad'];
            
            for (let i = 0; i < confettiCount; i++) {
                const confetti = document.createElement('div');
                confetti.style.position = 'fixed';
                confetti.style.width = '12px';
                confetti.style.height = '12px';
                confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                confetti.style.borderRadius = '50%';
                confetti.style.left = Math.random() * 100 + 'vw';
                confetti.style.top = '-20px';
                confetti.style.opacity = '0.8';
                confetti.style.zIndex = '9999';
                
                document.body.appendChild(confetti);
                
                const animation = confetti.animate([
                    { transform: 'translateY(0) rotate(0deg)', opacity: 0.8 },
                    { transform: `translateY(${window.innerHeight + 20}px) rotate(${360 + Math.random() * 360}deg)`, opacity: 0 }
                ], {
                    duration: 2000 + Math.random() * 3000,
                    easing: 'cubic-bezier(0.215, 0.61, 0.355, 1)'
                });
                
                animation.onfinish = () => confetti.remove();
            }
        }
        
        // Download and Share Functions
        function downloadPDF() {
            alert('Tính năng tải PDF đang được phát triển! Báo cáo PDF sẽ được gửi đến email của bạn.');
            // Implement PDF generation here
        }
        
        function downloadImage() {
            alert('Tính năng tải hình ảnh đang được phát triển!');
            // Implement screenshot capture here
        }
        
        function shareResults() {
            const topCategory = '${topCategory}';
            const topScore = '${topScore}';
            
            const shareText = `Tôi vừa khám phá định hướng nghề nghiệp của mình! Lĩnh vực nổi bật nhất: ${topCategory} (${topScore} điểm). Khám phá ngay bạn nhé!`;
            
            if (navigator.share) {
                navigator.share({
                    title: 'Kết quả Định hướng Nghề nghiệp',
                    text: shareText,
                    url: window.location.href
                }).catch(err => {
                    console.log('Error sharing:', err);
                    copyToClipboard(shareText);
                });
            } else {
                copyToClipboard(shareText);
            }
        }
        
        function copyToClipboard(text) {
            navigator.clipboard.writeText(text + '\n' + window.location.href)
                .then(() => alert('Đã sao chép kết quả vào clipboard!'))
                .catch(err => alert('Không thể sao chép: ' + err));
        }
        
        // Print styling
        window.addEventListener('beforeprint', () => {
            document.body.style.background = 'white';
            document.querySelectorAll('.btn, .action-btn').forEach(btn => {
                btn.style.display = 'none';
            });
        });
        
        window.addEventListener('afterprint', () => {
            document.body.style.background = '';
            document.querySelectorAll('.btn, .action-btn').forEach(btn => {
                btn.style.display = '';
            });
        });
    </script>
</body>
</html>