<%-- 
    Document   : mbti-result
    Created on : 21 thg 12, 2025, 18:26:23
    Author     : Admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả MBTI - ${mbtiResult.mbtiType}</title>
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
            max-width: 1000px;
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
        
        .mbti-badge {
            font-size: 48px;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 20px;
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
            margin: 0 auto;
        }
        
        .dimensions-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 25px;
            margin-bottom: 30px;
        }
        
        @media (max-width: 768px) {
            .dimensions-grid {
                grid-template-columns: 1fr;
            }
        }
        
        .dimension-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .dimension-title {
            font-size: 18px;
            color: #333;
            margin-bottom: 20px;
            text-align: center;
            font-weight: 600;
        }
        
        .dimension-bar {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 10px;
        }
        
        .dimension-label {
            width: 120px;
            font-size: 14px;
            color: #666;
        }
        
        .dimension-progress {
            flex: 1;
            height: 30px;
            background: #e9ecef;
            border-radius: 15px;
            overflow: hidden;
            position: relative;
        }
        
        .dimension-fill {
            height: 100%;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            transition: width 1s ease;
        }
        
        .dimension-value {
            width: 60px;
            text-align: center;
            font-weight: 600;
            font-size: 14px;
            color: #333;
        }
        
        .traits-section {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .traits-section h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 24px;
            text-align: center;
        }
        
        .traits-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }
        
        @media (max-width: 768px) {
            .traits-grid {
                grid-template-columns: 1fr;
            }
        }
        
        .trait-card {
            background: #f8f9ff;
            padding: 20px;
            border-radius: 15px;
            border-left: 4px solid #667eea;
        }
        
        .trait-card.positive {
            border-left-color: #28a745;
        }
        
        .trait-card.negative {
            border-left-color: #dc3545;
        }
        
        .trait-card h3 {
            color: #333;
            font-size: 16px;
            margin-bottom: 10px;
        }
        
        .trait-card p {
            color: #666;
            font-size: 14px;
            line-height: 1.5;
        }
        
        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 40px;
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
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
        }
        
        .btn-secondary:hover {
            background: #f8f9ff;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.1);
        }
        
        .strengths-weaknesses {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 25px;
            margin-bottom: 30px;
        }
        
        @media (max-width: 768px) {
            .strengths-weaknesses {
                grid-template-columns: 1fr;
            }
        }
        
        .sw-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .sw-card h3 {
            color: #333;
            margin-bottom: 20px;
            font-size: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .strengths-list, .weaknesses-list {
            list-style: none;
        }
        
        .strengths-list li, .weaknesses-list li {
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .strengths-list li:last-child, .weaknesses-list li:last-child {
            border-bottom: none;
        }
        
        .strength-icon {
            color: #28a745;
            font-size: 18px;
        }
        
        .weakness-icon {
            color: #dc3545;
            font-size: 18px;
        }
        
        .career-suggestions {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .career-suggestions h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 24px;
            text-align: center;
        }
        
        .career-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: center;
        }
        
        .career-tag {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
        }
        
        .compatible-types {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .compatible-types h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 24px;
        }
        
        .type-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            justify-content: center;
        }
        
        .type-badge {
            background: #f8f9ff;
            color: #667eea;
            padding: 10px 20px;
            border-radius: 20px;
            font-size: 16px;
            font-weight: 600;
            border: 2px solid #667eea;
        }
        
        .type-badge.highlight {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .retake-btn {
            background: #ff6b6b;
            color: white;
        }
        
        .retake-btn:hover {
            background: #ff5252;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(255, 107, 107, 0.3);
        }
        
        .share-section {
            text-align: center;
            margin-top: 30px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            backdrop-filter: blur(10px);
        }
        
        .share-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: white;
            color: #333;
            padding: 12px 24px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            margin: 5px;
        }
        
        .share-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        
        .share-btn.facebook {
            background: #1877f2;
            color: white;
        }
        
        .share-btn.twitter {
            background: #1da1f2;
            color: white;
        }
        
        .share-btn.copy {
            background: #6c757d;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Result Header -->
        <div class="result-header">
            <div class="mbti-badge">${mbtiResult.mbtiType}</div>
            <h1>Kết quả trắc nghiệm MBTI</h1>
            <p class="result-description">${mbtiResult.description}</p>
        </div>
        
        <!-- Dimensions Grid -->
        <div class="dimensions-grid">
            <div class="dimension-card">
                <div class="dimension-title">Hướng ngoại (E) ↔ Hướng nội (I)</div>
                <div class="dimension-bar">
                    <span class="dimension-label">Hướng ngoại</span>
                    <div class="dimension-progress">
                        <div class="dimension-fill" id="ei-progress"></div>
                    </div>
                    <span class="dimension-label">Hướng nội</span>
                </div>
                <div class="dimension-value">${mbtiResult.dimensionEI}</div>
            </div>
            
            <div class="dimension-card">
                <div class="dimension-title">Giác quan (S) ↔ Trực giác (N)</div>
                <div class="dimension-bar">
                    <span class="dimension-label">Giác quan</span>
                    <div class="dimension-progress">
                        <div class="dimension-fill" id="sn-progress"></div>
                    </div>
                    <span class="dimension-label">Trực giác</span>
                </div>
                <div class="dimension-value">${mbtiResult.dimensionSN}</div>
            </div>
            
            <div class="dimension-card">
                <div class="dimension-title">Lý trí (T) ↔ Cảm xúc (F)</div>
                <div class="dimension-bar">
                    <span class="dimension-label">Lý trí</span>
                    <div class="dimension-progress">
                        <div class="dimension-fill" id="tf-progress"></div>
                    </div>
                    <span class="dimension-label">Cảm xúc</span>
                </div>
                <div class="dimension-value">${mbtiResult.dimensionTF}</div>
            </div>
            
            <div class="dimension-card">
                <div class="dimension-title">Nguyên tắc (J) ↔ Linh hoạt (P)</div>
                <div class="dimension-bar">
                    <span class="dimension-label">Nguyên tắc</span>
                    <div class="dimension-progress">
                        <div class="dimension-fill" id="jp-progress"></div>
                    </div>
                    <span class="dimension-label">Linh hoạt</span>
                </div>
                <div class="dimension-value">${mbtiResult.dimensionJP}</div>
            </div>
        </div>
        
        <!-- Strengths & Weaknesses -->
        <div class="strengths-weaknesses">
            <div class="sw-card">
                <h3>💪 Điểm mạnh</h3>
                <ul class="strengths-list">
                    <c:forEach var="strength" items="${mbtiResult.strengths}">
                        <li><span class="strength-icon">✓</span> ${strength}</li>
                    </c:forEach>
                    <c:if test="${empty mbtiResult.strengths}">
                        <li><span class="strength-icon">✓</span> Tư duy logic và phân tích</li>
                        <li><span class="strength-icon">✓</span> Khả năng lập kế hoạch chiến lược</li>
                        <li><span class="strength-icon">✓</span> Độc lập và tự chủ cao</li>
                        <li><span class="strength-icon">✓</span> Quyết tâm và kiên trì</li>
                        <li><span class="strength-icon">✓</span> Khả năng học hỏi nhanh</li>
                    </c:if>
                </ul>
            </div>
            
            <div class="sw-card">
                <h3>⚠️ Điểm cần cải thiện</h3>
                <ul class="weaknesses-list">
                    <c:forEach var="weakness" items="${mbtiResult.weaknesses}">
                        <li><span class="weakness-icon">⚠️</span> ${weakness}</li>
                    </c:forEach>
                    <c:if test="${empty mbtiResult.weaknesses}">
                        <li><span class="weakness-icon">⚠️</span> Đôi khi quá cầu toàn</li>
                        <li><span class="weakness-icon">⚠️</span> Khó thể hiện cảm xúc</li>
                        <li><span class="weakness-icon">⚠️</span> Có thể thiếu kiên nhẫn</li>
                        <li><span class="weakness-icon">⚠️</span> Khó chấp nhận ý kiến trái chiều</li>
                        <li><span class="weakness-icon">⚠️</span> Dễ bị căng thẳng khi mất kiểm soát</li>
                    </c:if>
                </ul>
            </div>
        </div>
        
        <!-- Career Suggestions -->
        <div class="career-suggestions">
            <h2>🎯 Nghề nghiệp phù hợp</h2>
            <div class="career-tags">
                <c:forEach var="career" items="${mbtiResult.recommendedCareers}">
                    <span class="career-tag">${career}</span>
                </c:forEach>
                <c:if test="${empty mbtiResult.recommendedCareers}">
                    <span class="career-tag">Kỹ sư phần mềm</span>
                    <span class="career-tag">Data Scientist</span>
                    <span class="career-tag">Quản lý dự án</span>
                    <span class="career-tag">Kiến trúc sư</span>
                    <span class="career-tag">Nhà nghiên cứu</span>
                    <span class="career-tag">Tư vấn chiến lược</span>
                    <span class="career-tag">Giảng viên đại học</span>
                    <span class="career-tag">Chuyên gia phân tích</span>
                </c:if>
            </div>
        </div>
        
        <!-- Compatible Types -->
        <div class="compatible-types">
            <h2>❤️ Tính cách phù hợp</h2>
            <div class="type-badges">
                <c:forEach var="type" items="${mbtiResult.compatibleTypes}">
                    <span class="type-badge">${type}</span>
                </c:forEach>
                <c:if test="${empty mbtiResult.compatibleTypes}">
                    <span class="type-badge">ENFP</span>
                    <span class="type-badge">ENTP</span>
                    <span class="type-badge highlight">${mbtiResult.mbtiType}</span>
                    <span class="type-badge">INFJ</span>
                    <span class="type-badge">INTP</span>
                </c:if>
            </div>
            <p style="color: #666; margin-top: 15px; font-size: 14px;">
                Những tính cách này thường hòa hợp tốt với ${mbtiResult.mbtiType}
            </p>
        </div>
        
        <!-- Share Section -->
        <div class="share-section">
            <p style="color: white; margin-bottom: 15px; font-size: 16px;">
                Chia sẻ kết quả của bạn với bạn bè!
            </p>
            <div>
                <a href="#" class="share-btn facebook" onclick="shareOnFacebook()">
                    📘 Facebook
                </a>
                <a href="#" class="share-btn twitter" onclick="shareOnTwitter()">
                    🐦 Twitter
                </a>
                <a href="#" class="share-btn copy" onclick="copyResultToClipboard()">
                    📋 Copy kết quả
                </a>
            </div>
        </div>
        
        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                ← Quay lại Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/quiz/mbti" class="btn retake-btn">
                🔄 Làm lại quiz
            </a>
            <a href="${pageContext.request.contextPath}/quiz/work-style" class="btn btn-primary">
                Tiếp tục khám phá →
            </a>
        </div>
    </div>
    
    <script>
        // Animate progress bars
        document.addEventListener('DOMContentLoaded', function() {
            // Get MBTI type
            const mbtiType = '${mbtiResult.mbtiType}';
            
            // Calculate progress based on MBTI type
            setTimeout(() => {
                // E/I dimension
                const eiProgress = document.getElementById('ei-progress');
                eiProgress.style.width = mbtiType.charAt(0) === 'E' ? '70%' : '30%';
                
                // S/N dimension  
                const snProgress = document.getElementById('sn-progress');
                snProgress.style.width = mbtiType.charAt(1) === 'S' ? '70%' : '30%';
                
                // T/F dimension
                const tfProgress = document.getElementById('tf-progress');
                tfProgress.style.width = mbtiType.charAt(2) === 'T' ? '70%' : '30%';
                
                // J/P dimension
                const jpProgress = document.getElementById('jp-progress');
                jpProgress.style.width = mbtiType.charAt(3) === 'J' ? '70%' : '30%';
            }, 300);
        });
        
        // Share functions
        function shareOnFacebook() {
            const url = encodeURIComponent(window.location.href);
            const text = encodeURIComponent(`Tôi vừa khám phá tính cách MBTI của mình là ${mbtiType}! Khám phá ngay bạn nhé!`);
            window.open(`https://www.facebook.com/sharer/sharer.php?u=${url}&quote=${text}`, '_blank');
        }
        
        function shareOnTwitter() {
            const url = encodeURIComponent(window.location.href);
            const text = encodeURIComponent(`Tôi là ${mbtiType}! Khám phá tính cách MBTI của bạn tại:`);
            window.open(`https://twitter.com/intent/tweet?url=${url}&text=${text}`, '_blank');
        }
        
        function copyResultToClipboard() {
            const resultText = `🎭 Kết quả MBTI của tôi: ${mbtiType}\n${'${mbtiResult.description}'}\n\nKhám phá tính cách của bạn tại: ${window.location.origin}`;
            
            navigator.clipboard.writeText(resultText)
                .then(() => {
                    alert('Đã sao chép kết quả vào clipboard!');
                })
                .catch(err => {
                    console.error('Failed to copy: ', err);
                    alert('Không thể sao chép, vui lòng thử lại.');
                });
        }
        
        // Add confetti effect
        function celebrate() {
            const confettiCount = 100;
            const confettiColors = ['#667eea', '#764ba2', '#6b46c1', '#553c9a'];
            
            for (let i = 0; i < confettiCount; i++) {
                const confetti = document.createElement('div');
                confetti.style.position = 'fixed';
                confetti.style.width = '10px';
                confetti.style.height = '10px';
                confetti.style.backgroundColor = confettiColors[Math.floor(Math.random() * confettiColors.length)];
                confetti.style.borderRadius = '50%';
                confetti.style.left = Math.random() * 100 + 'vw';
                confetti.style.top = '-10px';
                confetti.style.opacity = '0.8';
                confetti.style.zIndex = '9999';
                
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
        
        // Trigger celebration on page load
        setTimeout(celebrate, 1000);
    </script>
</body>
</html>