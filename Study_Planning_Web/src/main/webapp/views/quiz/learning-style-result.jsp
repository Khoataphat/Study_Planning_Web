<%-- 
    Document   : learning-style-result
    Created on : 21 thg 12, 2025, 22:09:29
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
    <title>Kết quả Phong cách Học tập - ${learningStyleResult.primaryStyle}</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #00b09b 0%, #96c93d 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
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
        
        .style-badge {
            font-size: 48px;
            font-weight: bold;
            margin-bottom: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 15px;
        }
        
        .visual-badge { color: #2575fc; }
        .auditory-badge { color: #00b09b; }
        .kinesthetic-badge { color: #ff5e62; }
        .balanced-badge { color: #8e44ad; }
        
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
        
        .percentage-display {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            background: #f8f9ff;
            padding: 15px 30px;
            border-radius: 50px;
            display: inline-block;
            margin-top: 10px;
        }
        
        .visual-percent { color: #2575fc; }
        .auditory-percent { color: #00b09b; }
        .kinesthetic-percent { color: #ff5e62; }
        
        /* Chart Section */
        .chart-section {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .chart-section h2 {
            color: #333;
            margin-bottom: 25px;
            font-size: 24px;
            text-align: center;
        }
        
        .chart-container {
            display: flex;
            justify-content: center;
            align-items: flex-end;
            height: 300px;
            gap: 60px;
            margin: 40px 0;
            padding: 0 20px;
        }
        
        @media (max-width: 768px) {
            .chart-container {
                flex-direction: column;
                height: auto;
                align-items: center;
                gap: 30px;
            }
        }
        
        .chart-bar {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 100px;
        }
        
        .bar-value {
            font-size: 20px;
            font-weight: bold;
            color: #333;
            margin-bottom: 15px;
        }
        
        .bar {
            width: 60px;
            border-radius: 10px 10px 0 0;
            transition: height 1.5s ease;
            position: relative;
            overflow: hidden;
        }
        
        .bar-visual {
            background: linear-gradient(to top, #2575fc, #6a11cb);
        }
        
        .bar-auditory {
            background: linear-gradient(to top, #00b09b, #96c93d);
        }
        
        .bar-kinesthetic {
            background: linear-gradient(to top, #ff5e62, #ff9966);
        }
        
        .bar-label {
            margin-top: 15px;
            font-weight: 600;
            color: #333;
            font-size: 16px;
            text-align: center;
        }
        
        .bar-icon {
            font-size: 24px;
            margin-bottom: 5px;
        }
        
        /* Learning Tips */
        .learning-tips {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .learning-tips h2 {
            color: #333;
            margin-bottom: 25px;
            font-size: 24px;
            text-align: center;
        }
        
        .tips-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
        }
        
        .tip-card {
            background: #f8f9ff;
            border-radius: 15px;
            padding: 25px;
            border-left: 4px solid;
            transition: transform 0.3s ease;
        }
        
        .tip-card:hover {
            transform: translateY(-5px);
        }
        
        .tip-card.visual { border-left-color: #2575fc; }
        .tip-card.auditory { border-left-color: #00b09b; }
        .tip-card.kinesthetic { border-left-color: #ff5e62; }
        
        .tip-card h3 {
            color: #333;
            font-size: 18px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .tip-card ul {
            list-style: none;
            padding-left: 0;
        }
        
        .tip-card li {
            padding: 8px 0;
            color: #666;
            line-height: 1.5;
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }
        
        .tip-card li:before {
            content: "✓";
            color: #00b09b;
            font-weight: bold;
        }
        
        /* Comparison Section */
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
        
        .comparison-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .comparison-table th {
            background: #f8f9ff;
            padding: 15px;
            text-align: center;
            font-weight: 600;
            color: #333;
            border-bottom: 2px solid #e6e9ff;
        }
        
        .comparison-table td {
            padding: 15px;
            text-align: center;
            border-bottom: 1px solid #f0f0f0;
            color: #666;
        }
        
        .comparison-table tr:hover {
            background: #f8f9ff;
        }
        
        .style-indicator {
            display: inline-block;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin-right: 8px;
        }
        
        .style-indicator.visual { background: #2575fc; }
        .style-indicator.auditory { background: #00b09b; }
        .style-indicator.kinesthetic { background: #ff5e62; }
        
        /* Action Buttons */
        .action-buttons {
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
            background: linear-gradient(135deg, #00b09b 0%, #96c93d 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0, 176, 155, 0.3);
        }
        
        .btn-secondary {
            background: white;
            color: #00b09b;
            border: 2px solid #00b09b;
        }
        
        .btn-secondary:hover {
            background: #f8f9ff;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0, 176, 155, 0.1);
        }
        
        .btn-retake {
            background: linear-gradient(135deg, #ff5e62 0%, #ff9966 100%);
            color: white;
        }
        
        .btn-retake:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(255, 94, 98, 0.3);
        }
        
        /* Resource Links */
        .resource-links {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-top: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .resource-links h2 {
            color: #333;
            margin-bottom: 25px;
            font-size: 24px;
        }
        
        .resource-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .resource-card {
            background: #f8f9ff;
            border-radius: 15px;
            padding: 20px;
            text-decoration: none;
            color: #333;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        
        .resource-card:hover {
            transform: translateY(-5px);
            border-color: #00b09b;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        
        .resource-icon {
            font-size: 32px;
            margin-bottom: 15px;
        }
        
        .resource-card h3 {
            font-size: 18px;
            margin-bottom: 10px;
            color: #333;
        }
        
        .resource-card p {
            color: #666;
            font-size: 14px;
            line-height: 1.5;
        }
        
        /* Download Section */
        .download-section {
            text-align: center;
            margin-top: 30px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            backdrop-filter: blur(10px);
        }
        
        .download-btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: white;
            color: #333;
            padding: 12px 24px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            margin: 5px;
        }
        
        .download-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        
        /* Style Description */
        .style-description {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 25px;
            margin: 20px 0;
            border-left: 4px solid;
        }
        
        .style-description.visual { border-left-color: #2575fc; }
        .style-description.auditory { border-left-color: #00b09b; }
        .style-description.kinesthetic { border-left-color: #ff5e62; }
        .style-description.balanced { border-left-color: #8e44ad; }
        
        .style-description h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 20px;
        }
        
        .style-description p {
            color: #666;
            line-height: 1.6;
            margin-bottom: 15px;
        }
        
        /* Progress Animation */
        @keyframes growBar {
            from { height: 0; }
            to { height: var(--target-height); }
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .result-header, .chart-section, .learning-tips, 
            .comparison-section, .resource-links {
                padding: 20px;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn {
                width: 100%;
                max-width: 300px;
            }
            
            .comparison-table {
                display: block;
                overflow-x: auto;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Result Header -->
        <div class="result-header">
            <c:choose>
                <c:when test="${learningStyleResult.primaryStyle == 'VISUAL'}">
                    <div class="style-badge visual-badge">
                        👁️ ${learningStyleResult.primaryStyle}
                    </div>
                    <h1>Người học qua Thị giác</h1>
                    <p class="result-description">
                        Bạn học hiệu quả nhất thông qua hình ảnh, biểu đồ, video và các công cụ trực quan.
                        Bạn thích sử dụng màu sắc, sơ đồ và hình ảnh để ghi nhớ thông tin.
                    </p>
                </c:when>
                <c:when test="${learningStyleResult.primaryStyle == 'AUDITORY'}">
                    <div class="style-badge auditory-badge">
                        👂 ${learningStyleResult.primaryStyle}
                    </div>
                    <h1>Người học qua Thính giác</h1>
                    <p class="result-description">
                        Bạn học tốt nhất thông qua âm thanh, thảo luận và lắng nghe.
                        Bạn thích nghe giảng, thảo luận nhóm và sử dụng âm thanh để ghi nhớ.
                    </p>
                </c:when>
                <c:when test="${learningStyleResult.primaryStyle == 'KINESTHETIC'}">
                    <div class="style-badge kinesthetic-badge">
                        ✋ ${learningStyleResult.primaryStyle}
                    </div>
                    <h1>Người học qua Vận động</h1>
                    <p class="result-description">
                        Bạn học hiệu quả nhất thông qua thực hành, trải nghiệm và vận động.
                        Bạn thích học bằng cách làm, thí nghiệm và tham gia vào các hoạt động thực tế.
                    </p>
                </c:when>
                <c:otherwise>
                    <div class="style-badge balanced-badge">
                        ⚖️ ${learningStyleResult.primaryStyle}
                    </div>
                    <h1>Người học Đa phương thức</h1>
                    <p class="result-description">
                        Bạn có khả năng học tập cân bằng giữa các phương pháp.
                        Bạn linh hoạt trong việc kết hợp nhiều cách học khác nhau để đạt hiệu quả tốt nhất.
                    </p>
                </c:otherwise>
            </c:choose>
            
            <div class="percentage-display">
                <span class="visual-percent">Thị giác: ${learningStyleResult.visualPercentage}%</span> • 
                <span class="auditory-percent">Thính giác: ${learningStyleResult.auditoryPercentage}%</span> • 
                <span class="kinesthetic-percent">Vận động: ${learningStyleResult.kinestheticPercentage}%</span>
            </div>
        </div>
        
        <!-- Style Description -->
        <div class="style-description ${fn:toLowerCase(learningStyleResult.primaryStyle)}">
            <c:choose>
                <c:when test="${learningStyleResult.primaryStyle == 'VISUAL'}">
                    <h3>🎨 Đặc điểm người học Thị giác</h3>
                    <p>Bạn có trí nhớ hình ảnh tốt, thường "nhìn thấy" thông tin trong đầu khi cố gắng nhớ lại. 
                    Bạn thích các tài liệu học tập có nhiều hình ảnh, biểu đồ, màu sắc và sắp xếp trực quan.</p>
                    <p><strong>Ưu điểm:</strong> Ghi nhớ lâu dài qua hình ảnh, học nhanh qua video và hình ảnh minh họa.</p>
                    <p><strong>Thách thức:</strong> Có thể gặp khó khăn với bài giảng dài không có hình ảnh hỗ trợ.</p>
                </c:when>
                <c:when test="${learningStyleResult.primaryStyle == 'AUDITORY'}">
                    <h3>🎵 Đặc điểm người học Thính giác</h3>
                    <p>Bạn học tốt qua việc lắng nghe và thảo luận. Bạn có thể nhớ lại thông tin dễ dàng khi nghe 
                    lại bài giảng hoặc thảo luận về chủ đề đó với người khác.</p>
                    <p><strong>Ưu điểm:</strong> Học hiệu quả qua podcast, thảo luận nhóm, ghi nhớ tốt qua âm thanh.</p>
                    <p><strong>Thách thức:</strong> Có thể gặp khó khăn với tài liệu viết dài không có giải thích bằng lời.</p>
                </c:when>
                <c:when test="${learningStyleResult.primaryStyle == 'KINESTHETIC'}">
                    <h3>🔧 Đặc điểm người học Vận động</h3>
                    <p>Bạn học tốt nhất khi được thực hành và trải nghiệm thực tế. Bạn cần vận động và tương tác 
                    với môi trường xung quanh để tiếp thu thông tin hiệu quả.</p>
                    <p><strong>Ưu điểm:</strong> Học nhanh qua thực hành, phát triển kỹ năng thực tế tốt, khả năng ứng dụng cao.</p>
                    <p><strong>Thách thức:</strong> Có thể khó tập trung trong môi trường học thụ động, cần không gian để di chuyển.</p>
                </c:when>
                <c:otherwise>
                    <h3>🌈 Đặc điểm người học Đa phương thức</h3>
                    <p>Bạn có khả năng thích nghi với nhiều phương pháp học khác nhau. Bạn có thể kết hợp linh hoạt 
                    giữa hình ảnh, âm thanh và vận động để tạo ra trải nghiệm học tập tối ưu cho bản thân.</p>
                    <p><strong>Ưu điểm:</strong> Linh hoạt trong nhiều môi trường học, dễ dàng thích nghi với các phương pháp giảng dạy khác nhau.</p>
                    <p><strong>Lời khuyên:</strong> Hãy khám phá và kết hợp nhiều phương pháp để tìm ra sự kết hợp hiệu quả nhất cho từng môn học.</p>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Chart Section -->
        <div class="chart-section">
            <h2>📊 Phân tích chi tiết phong cách học tập</h2>
            <div class="chart-container">
                <!-- Visual Bar -->
                <div class="chart-bar">
                    <div class="bar-value visual-percent" id="visual-value">
                        ${learningStyleResult.visualPercentage}%
                    </div>
                    <div class="bar bar-visual" id="visual-bar" style="height: 0px;"></div>
                    <div class="bar-label">
                        <div class="bar-icon">👁️</div>
                        Thị giác
                    </div>
                </div>
                
                <!-- Auditory Bar -->
                <div class="chart-bar">
                    <div class="bar-value auditory-percent" id="auditory-value">
                        ${learningStyleResult.auditoryPercentage}%
                    </div>
                    <div class="bar bar-auditory" id="auditory-bar" style="height: 0px;"></div>
                    <div class="bar-label">
                        <div class="bar-icon">👂</div>
                        Thính giác
                    </div>
                </div>
                
                <!-- Kinesthetic Bar -->
                <div class="chart-bar">
                    <div class="bar-value kinesthetic-percent" id="kinesthetic-value">
                        ${learningStyleResult.kinestheticPercentage}%
                    </div>
                    <div class="bar bar-kinesthetic" id="kinesthetic-bar" style="height: 0px;"></div>
                    <div class="bar-label">
                        <div class="bar-icon">✋</div>
                        Vận động
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Learning Tips -->
        <div class="learning-tips">
            <h2>💡 Mẹo học tập hiệu quả cho bạn</h2>
            <div class="tips-grid">
                <!-- Visual Tips -->
                <div class="tip-card visual">
                    <h3>👁️ Dành cho người học Thị giác</h3>
                    <ul>
                        <li>Sử dụng mindmap và sơ đồ tư duy</li>
                        <li>Highlight và sử dụng nhiều màu sắc khi ghi chú</li>
                        <li>Xem video tutorial và hình ảnh minh họa</li>
                        <li>Sử dụng flashcards với hình ảnh</li>
                        <li>Vẽ biểu đồ và sơ đồ để hiểu concepts</li>
                        <li>Sắp xếp thông tin thành bảng biểu trực quan</li>
                    </ul>
                </div>
                
                <!-- Auditory Tips -->
                <div class="tip-card auditory">
                    <h3>👂 Dành cho người học Thính giác</h3>
                    <ul>
                        <li>Ghi âm bài giảng và nghe lại</li>
                        <li>Đọc to khi học và ôn tập</li>
                        <li>Tham gia thảo luận nhóm</li>
                        <li>Sử dụng podcast và audio books</li>
                        <li>Giải thích kiến thức cho người khác</li>
                        <li>Tạo các bài hát hoặc vần điệu để ghi nhớ</li>
                    </ul>
                </div>
                
                <!-- Kinesthetic Tips -->
                <div class="tip-card kinesthetic">
                    <h3>✋ Dành cho người học Vận động</h3>
                    <ul>
                        <li>Thực hành ngay sau khi học lý thuyết</li>
                        <li>Sử dụng flashcards và di chuyển khi học</li>
                        <li>Tham gia các hoạt động thực hành và thí nghiệm</li>
                        <li>Học qua trò chơi và hoạt động tương tác</li>
                        <li>Đi bộ hoặc vận động nhẹ khi ôn bài</li>
                        <li>Sử dụng các mô hình và vật thể thực tế</li>
                    </ul>
                </div>
            </div>
        </div>
        
        <!-- Comparison Table -->
        <div class="comparison-section">
            <h2>📋 So sánh các phong cách học tập</h2>
            <table class="comparison-table">
                <thead>
                    <tr>
                        <th>Đặc điểm</th>
                        <th><span class="style-indicator visual"></span> Thị giác</th>
                        <th><span class="style-indicator auditory"></span> Thính giác</th>
                        <th><span class="style-indicator kinesthetic"></span> Vận động</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><strong>Học tốt nhất qua</strong></td>
                        <td>Hình ảnh, biểu đồ, video</td>
                        <td>Âm thanh, thảo luận, giảng bài</td>
                        <td>Thực hành, trải nghiệm, vận động</td>
                    </tr>
                    <tr>
                        <td><strong>Ghi chú hiệu quả</strong></td>
                        <td>Mindmap, sơ đồ, highlight</td>
                        <td>Ghi âm, tóm tắt bằng lời</td>
                        <td>Ghi chú ngắn + thực hành</td>
                    </tr>
                    <tr>
                        <td><strong>Công cụ hỗ trợ</strong></td>
                        <td>Video, infographic, color coding</td>
                        <td>Podcast, audio book, thảo luận</td>
                        <td>Mô hình, thí nghiệm, trò chơi</td>
                    </tr>
                    <tr>
                        <td><strong>Môi trường lý tưởng</strong></td>
                        <td>Yên tĩnh, nhiều tài liệu trực quan</td>
                        <td>Có thể nghe rõ, có không gian thảo luận</td>
                        <td>Có không gian di chuyển, dụng cụ thực hành</td>
                    </tr>
                    <tr>
                        <td><strong>Nghề nghiệp phù hợp</strong></td>
                        <td>Thiết kế, kiến trúc, nhiếp ảnh</td>
                        <td>Âm nhạc, giảng dạy, tư vấn</td>
                        <td>Thể thao, y tế, kỹ thuật</td>
                    </tr>
                </tbody>
            </table>
        </div>
        
        <!-- Resource Links -->
        <div class="resource-links">
            <h2>🔗 Tài nguyên học tập đề xuất</h2>
            <div class="resource-grid">
                <a href="https://www.khanacademy.org" target="_blank" class="resource-card">
                    <div class="resource-icon">🎬</div>
                    <h3>Khan Academy</h3>
                    <p>Video bài giảng trực quan cho mọi môn học</p>
                </a>
                
                <a href="https://quizlet.com" target="_blank" class="resource-card">
                    <div class="resource-icon">📝</div>
                    <h3>Quizlet</h3>
                    <p>Flashcards và trò chơi học tập tương tác</p>
                </a>
                
                <a href="https://www.coursera.org" target="_blank" class="resource-card">
                    <div class="resource-icon">🎓</div>
                    <h3>Coursera</h3>
                    <p>Khóa học trực tuyến với đa dạng phương pháp</p>
                </a>
                
                <a href="https://www.mindmeister.com" target="_blank" class="resource-card">
                    <div class="resource-icon">🗺️</div>
                    <h3>MindMeister</h3>
                    <p>Công cụ tạo mindmap và sơ đồ tư duy</p>
                </a>
            </div>
        </div>
        
        <!-- Download Section -->
        <div class="download-section">
            <p style="color: white; margin-bottom: 15px; font-size: 16px;">
                Tải về kết quả phân tích của bạn!
            </p>
            <div>
                <a href="#" class="download-btn" onclick="downloadAsPDF()">
                    📄 Tải PDF báo cáo
                </a>
                <a href="#" class="download-btn" onclick="downloadAsImage()">
                    🖼️ Tải hình ảnh
                </a>
                <a href="#" class="download-btn" onclick="shareResults()">
                    📤 Chia sẻ kết quả
                </a>
            </div>
        </div>
        
        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                ← Quay lại Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/quiz/learning-style" class="btn btn-retake">
                🔄 Làm lại quiz
            </a>
            <a href="${pageContext.request.contextPath}/quiz/career" class="btn btn-primary">
                Khám phá nghề nghiệp →
            </a>
        </div>
    </div>
    
    <script>
        // Animate bars on page load
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(() => {
                // Get percentages
                const visualPercent = ${learningStyleResult.visualPercentage};
                const auditoryPercent = ${learningStyleResult.auditoryPercentage};
                const kinestheticPercent = ${learningStyleResult.kinestheticPercentage};
                
                // Calculate bar heights (max 250px)
                const maxHeight = 250;
                const visualHeight = (visualPercent / 100) * maxHeight;
                const auditoryHeight = (auditoryPercent / 100) * maxHeight;
                const kinestheticHeight = (kinestheticPercent / 100) * maxHeight;
                
                // Animate bars
                animateBar('visual-bar', visualHeight);
                animateBar('auditory-bar', auditoryHeight);
                animateBar('kinesthetic-bar', kinestheticHeight);
                
                // Update values with animation
                animateValue('visual-value', 0, visualPercent, 1500);
                animateValue('auditory-value', 0, auditoryPercent, 1500);
                animateValue('kinesthetic-value', 0, kinestheticPercent, 1500);
                
            }, 500);
        });
        
        function animateBar(barId, targetHeight) {
            const bar = document.getElementById(barId);
            if (bar) {
                bar.style.transition = 'height 1.5s cubic-bezier(0.4, 0, 0.2, 1)';
                bar.style.height = targetHeight + 'px';
            }
        }
        
        function animateValue(elementId, start, end, duration) {
            const element = document.getElementById(elementId);
            if (!element) return;
            
            let startTimestamp = null;
            const step = (timestamp) => {
                if (!startTimestamp) startTimestamp = timestamp;
                const progress = Math.min((timestamp - startTimestamp) / duration, 1);
                const value = Math.floor(progress * (end - start) + start);
                element.textContent = value + '%';
                
                if (progress < 1) {
                    window.requestAnimationFrame(step);
                }
            };
            window.requestAnimationFrame(step);
        }
        
        // Download and Share Functions
        function downloadAsPDF() {
            alert('Tính năng tải PDF đang được phát triển!');
            // Implement PDF generation here
        }
        
        function downloadAsImage() {
            alert('Tính năng tải hình ảnh đang được phát triển!');
            // Implement screenshot capture here
        }
        
        function shareResults() {
            const style = '${learningStyleResult.primaryStyle}';
            const visual = ${learningStyleResult.visualPercentage};
            const auditory = ${learningStyleResult.auditoryPercentage};
            const kinesthetic = ${learningStyleResult.kinestheticPercentage};
            
            const shareText = `Tôi vừa khám phá phong cách học tập của mình: ${style} (Thị giác: ${visual}%, Thính giác: ${auditory}%, Vận động: ${kinesthetic}%). Khám phá ngay bạn nhé!`;
            
            if (navigator.share) {
                navigator.share({
                    title: 'Kết quả Phong cách Học tập',
                    text: shareText,
                    url: window.location.href
                });
            } else {
                navigator.clipboard.writeText(shareText + '\n' + window.location.href)
                    .then(() => alert('Đã sao chép kết quả vào clipboard!'))
                    .catch(err => alert('Không thể chia sẻ: ' + err));
            }
        }
        
        // Add celebration effect for primary style
        function celebratePrimaryStyle() {
            const primaryStyle = '${learningStyleResult.primaryStyle}'.toLowerCase();
            const confettiColors = {
                visual: ['#2575fc', '#6a11cb', '#2575fc'],
                auditory: ['#00b09b', '#96c93d', '#00b09b'],
                kinesthetic: ['#ff5e62', '#ff9966', '#ff5e62'],
                balanced: ['#8e44ad', '#9b59b6', '#8e44ad']
            };
            
            const colors = confettiColors[primaryStyle] || confettiColors.balanced;
            createConfetti(colors);
        }
        
        function createConfetti(colors) {
            const confettiCount = 80;
            
            for (let i = 0; i < confettiCount; i++) {
                const confetti = document.createElement('div');
                confetti.style.position = 'fixed';
                confetti.style.width = '10px';
                confetti.style.height = '10px';
                confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                confetti.style.borderRadius = '50%';
                confetti.style.left = Math.random() * 100 + 'vw';
                confetti.style.top = '-10px';
                confetti.style.opacity = '0.8';
                confetti.style.zIndex = '9999';
                
                document.body.appendChild(confetti);
                
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
        
        // Trigger celebration after bars animation
        setTimeout(celebratePrimaryStyle, 2000);
    </script>
</body>
</html>