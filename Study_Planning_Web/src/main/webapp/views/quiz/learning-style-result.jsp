<%-- 
    Document   : learning-style-result
    Created on : 21 thg 12, 2025, 22:09:29
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
    <title>Kết quả Phong cách Học tập - ${learningStyleResult.primaryStyle}</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300..700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;700&amp;display=swap" rel="stylesheet" />
    
    <style>
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes slideIn {
            from { opacity: 0; transform: translateX(-20px); }
            to { opacity: 1; transform: translateX(0); }
        }
        
        @keyframes growBar {
            from { height: 0; opacity: 0; }
            to { height: var(--target-height); opacity: 1; }
        }
        
        .animate-fade-in {
            animation: fadeIn 0.6s ease-out;
        }
        
        .animate-slide-in {
            animation: slideIn 0.4s ease-out;
        }
        
        .bar-animation {
            animation: growBar 1.5s cubic-bezier(0.4, 0, 0.2, 1) forwards;
        }
        
        .visual-gradient {
            background: linear-gradient(135deg, #2575fc 0%, #6a11cb 100%);
        }
        
        .auditory-gradient {
            background: linear-gradient(135deg, #00b09b 0%, #96c93d 100%);
        }
        
        .kinesthetic-gradient {
            background: linear-gradient(135deg, #ff5e62 0%, #ff9966 100%);
        }
        
        .balanced-gradient {
            background: linear-gradient(135deg, #8e44ad 0%, #9b59b6 100%);
        }
        
        .visual-text { color: #2575fc; }
        .auditory-text { color: #00b09b; }
        .kinesthetic-text { color: #ff5e62; }
        .balanced-text { color: #8e44ad; }
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
                        "surface-light": "#FFFFFF",
                        "surface-dark": "#293548",
                        "text-light": "#1E293B",
                        "text-dark": "#E2E8F0",
                        "border-light": "#E5E7EB",
                        "border-dark": "#475569",
                        "visual-light": "#2575fc",
                        "visual-dark": "#6a11cb",
                        "auditory-light": "#00b09b",
                        "auditory-dark": "#96c93d",
                        "kinesthetic-light": "#ff5e62",
                        "kinesthetic-dark": "#ff9966",
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
        <!-- Sidebar (copy from MBTI result) -->
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
            </nav>
        </aside>

        <main id="mainContent" class="flex-1 flex flex-col p-6 lg:p-8 ml-20 overflow-y-auto">
            <!-- Header -->
            <header class="flex justify-between items-center mb-8">
                <div>
                    <h1 class="text-3xl font-bold text-slate-900 dark:text-white flex items-center">
                        <span class="material-symbols-outlined mr-3 text-blue-500 dark:text-blue-400">school</span>
                        Kết quả Phong cách Học tập
                    </h1>
                    <p class="text-slate-500 dark:text-slate-400 mt-2">Khám phá cách học hiệu quả nhất dành cho bạn</p>
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

            <!-- Main Result Card -->
            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-xl p-8 mb-8 animate-fade-in">
                <div class="text-center mb-8">
                    <c:choose>
                        <c:when test="${learningStyleResult.primaryStyle == 'VISUAL'}">
                            <div class="text-6xl mb-4">👁️</div>
                            <div class="text-5xl font-black visual-text mb-3">${learningStyleResult.primaryStyle}</div>
                            <h2 class="text-2xl font-bold text-slate-900 dark:text-white mb-4">Người học qua Thị giác</h2>
                            <p class="text-lg text-slate-600 dark:text-slate-300 max-w-3xl mx-auto">
                                Bạn học hiệu quả nhất thông qua hình ảnh, biểu đồ, video và các công cụ trực quan.
                                Bạn thích sử dụng màu sắc, sơ đồ và hình ảnh để ghi nhớ thông tin.
                            </p>
                        </c:when>
                        <c:when test="${learningStyleResult.primaryStyle == 'AUDITORY'}">
                            <div class="text-6xl mb-4">👂</div>
                            <div class="text-5xl font-black auditory-text mb-3">${learningStyleResult.primaryStyle}</div>
                            <h2 class="text-2xl font-bold text-slate-900 dark:text-white mb-4">Người học qua Thính giác</h2>
                            <p class="text-lg text-slate-600 dark:text-slate-300 max-w-3xl mx-auto">
                                Bạn học tốt nhất thông qua âm thanh, thảo luận và lắng nghe.
                                Bạn thích nghe giảng, thảo luận nhóm và sử dụng âm thanh để ghi nhớ.
                            </p>
                        </c:when>
                        <c:when test="${learningStyleResult.primaryStyle == 'KINESTHETIC'}">
                            <div class="text-6xl mb-4">✋</div>
                            <div class="text-5xl font-black kinesthetic-text mb-3">${learningStyleResult.primaryStyle}</div>
                            <h2 class="text-2xl font-bold text-slate-900 dark:text-white mb-4">Người học qua Vận động</h2>
                            <p class="text-lg text-slate-600 dark:text-slate-300 max-w-3xl mx-auto">
                                Bạn học hiệu quả nhất thông qua thực hành, trải nghiệm và vận động.
                                Bạn thích học bằng cách làm, thí nghiệm và tham gia vào các hoạt động thực tế.
                            </p>
                        </c:when>
                        <c:otherwise>
                            <div class="text-6xl mb-4">⚖️</div>
                            <div class="text-5xl font-black balanced-text mb-3">${learningStyleResult.primaryStyle}</div>
                            <h2 class="text-2xl font-bold text-slate-900 dark:text-white mb-4">Người học Đa phương thức</h2>
                            <p class="text-lg text-slate-600 dark:text-slate-300 max-w-3xl mx-auto">
                                Bạn có khả năng học tập cân bằng giữa các phương pháp.
                                Bạn linh hoạt trong việc kết hợp nhiều cách học khác nhau để đạt hiệu quả tốt nhất.
                            </p>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Percentage Display -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4 max-w-2xl mx-auto">
                    <div class="bg-slate-100 dark:bg-slate-700 rounded-xl p-4 text-center">
                        <div class="text-2xl font-bold visual-text">${learningStyleResult.visualPercentage}%</div>
                        <div class="text-sm text-slate-600 dark:text-slate-400 mt-1">Thị giác</div>
                    </div>
                    <div class="bg-slate-100 dark:bg-slate-700 rounded-xl p-4 text-center">
                        <div class="text-2xl font-bold auditory-text">${learningStyleResult.auditoryPercentage}%</div>
                        <div class="text-sm text-slate-600 dark:text-slate-400 mt-1">Thính giác</div>
                    </div>
                    <div class="bg-slate-100 dark:bg-slate-700 rounded-xl p-4 text-center">
                        <div class="text-2xl font-bold kinesthetic-text">${learningStyleResult.kinestheticPercentage}%</div>
                        <div class="text-sm text-slate-600 dark:text-slate-400 mt-1">Vận động</div>
                    </div>
                </div>
            </div>

            <!-- Style Description -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
                <!-- Chart Section -->
                <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 animate-slide-in">
                    <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-6">📊 Phân tích chi tiết</h3>
                    <div class="space-y-6">
                        <!-- Visual Bar -->
                        <div>
                            <div class="flex justify-between mb-2">
                                <span class="font-medium text-slate-700 dark:text-slate-300">👁️ Thị giác</span>
                                <span class="font-bold visual-text" id="visual-value">${learningStyleResult.visualPercentage}%</span>
                            </div>
                            <div class="h-3 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                                <div class="h-full visual-gradient rounded-full" id="visual-bar"></div>
                            </div>
                        </div>
                        
                        <!-- Auditory Bar -->
                        <div>
                            <div class="flex justify-between mb-2">
                                <span class="font-medium text-slate-700 dark:text-slate-300">👂 Thính giác</span>
                                <span class="font-bold auditory-text" id="auditory-value">${learningStyleResult.auditoryPercentage}%</span>
                            </div>
                            <div class="h-3 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                                <div class="h-full auditory-gradient rounded-full" id="auditory-bar"></div>
                            </div>
                        </div>
                        
                        <!-- Kinesthetic Bar -->
                        <div>
                            <div class="flex justify-between mb-2">
                                <span class="font-medium text-slate-700 dark:text-slate-300">✋ Vận động</span>
                                <span class="font-bold kinesthetic-text" id="kinesthetic-value">${learningStyleResult.kinestheticPercentage}%</span>
                            </div>
                            <div class="h-3 bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden">
                                <div class="h-full kinesthetic-gradient rounded-full" id="kinesthetic-bar"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Style Description -->
                <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 animate-slide-in" style="animation-delay: 0.1s">
                    <c:choose>
                        <c:when test="${learningStyleResult.primaryStyle == 'VISUAL'}">
                            <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-4">🎨 Đặc điểm người học Thị giác</h3>
                            <p class="text-slate-600 dark:text-slate-300 mb-4">
                                Bạn có trí nhớ hình ảnh tốt, thường "nhìn thấy" thông tin trong đầu khi cố gắng nhớ lại. 
                                Bạn thích các tài liệu học tập có nhiều hình ảnh, biểu đồ, màu sắc và sắp xếp trực quan.
                            </p>
                            <div class="space-y-3">
                                <div class="flex items-start">
                                    <span class="material-symbols-outlined text-green-500 dark:text-green-400 mr-3 mt-1">check_circle</span>
                                    <span class="text-slate-700 dark:text-slate-300">Ưu điểm: Ghi nhớ lâu dài qua hình ảnh, học nhanh qua video và hình ảnh minh họa</span>
                                </div>
                                <div class="flex items-start">
                                    <span class="material-symbols-outlined text-yellow-500 dark:text-yellow-400 mr-3 mt-1">warning</span>
                                    <span class="text-slate-700 dark:text-slate-300">Thách thức: Có thể gặp khó khăn với bài giảng dài không có hình ảnh hỗ trợ</span>
                                </div>
                            </div>
                        </c:when>
                        <c:when test="${learningStyleResult.primaryStyle == 'AUDITORY'}">
                            <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-4">🎵 Đặc điểm người học Thính giác</h3>
                            <p class="text-slate-600 dark:text-slate-300 mb-4">
                                Bạn học tốt qua việc lắng nghe và thảo luận. Bạn có thể nhớ lại thông tin dễ dàng khi nghe 
                                lại bài giảng hoặc thảo luận về chủ đề đó với người khác.
                            </p>
                            <div class="space-y-3">
                                <div class="flex items-start">
                                    <span class="material-symbols-outlined text-green-500 dark:text-green-400 mr-3 mt-1">check_circle</span>
                                    <span class="text-slate-700 dark:text-slate-300">Ưu điểm: Học hiệu quả qua podcast, thảo luận nhóm, ghi nhớ tốt qua âm thanh</span>
                                </div>
                                <div class="flex items-start">
                                    <span class="material-symbols-outlined text-yellow-500 dark:text-yellow-400 mr-3 mt-1">warning</span>
                                    <span class="text-slate-700 dark:text-slate-300">Thách thức: Có thể gặp khó khăn với tài liệu viết dài không có giải thích bằng lời</span>
                                </div>
                            </div>
                        </c:when>
                        <c:when test="${learningStyleResult.primaryStyle == 'KINESTHETIC'}">
                            <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-4">🔧 Đặc điểm người học Vận động</h3>
                            <p class="text-slate-600 dark:text-slate-300 mb-4">
                                Bạn học tốt nhất khi được thực hành và trải nghiệm thực tế. Bạn cần vận động và tương tác 
                                với môi trường xung quanh để tiếp thu thông tin hiệu quả.
                            </p>
                            <div class="space-y-3">
                                <div class="flex items-start">
                                    <span class="material-symbols-outlined text-green-500 dark:text-green-400 mr-3 mt-1">check_circle</span>
                                    <span class="text-slate-700 dark:text-slate-300">Ưu điểm: Học nhanh qua thực hành, phát triển kỹ năng thực tế tốt, khả năng ứng dụng cao</span>
                                </div>
                                <div class="flex items-start">
                                    <span class="material-symbols-outlined text-yellow-500 dark:text-yellow-400 mr-3 mt-1">warning</span>
                                    <span class="text-slate-700 dark:text-slate-300">Thách thức: Có thể khó tập trung trong môi trường học thụ động, cần không gian để di chuyển</span>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-4">🌈 Đặc điểm người học Đa phương thức</h3>
                            <p class="text-slate-600 dark:text-slate-300 mb-4">
                                Bạn có khả năng thích nghi với nhiều phương pháp học khác nhau. Bạn có thể kết hợp linh hoạt 
                                giữa hình ảnh, âm thanh và vận động để tạo ra trải nghiệm học tập tối ưu cho bản thân.
                            </p>
                            <div class="space-y-3">
                                <div class="flex items-start">
                                    <span class="material-symbols-outlined text-green-500 dark:text-green-400 mr-3 mt-1">check_circle</span>
                                    <span class="text-slate-700 dark:text-slate-300">Ưu điểm: Linh hoạt trong nhiều môi trường học, dễ dàng thích nghi với các phương pháp giảng dạy khác nhau</span>
                                </div>
                                <div class="flex items-start">
                                    <span class="material-symbols-outlined text-blue-500 dark:text-blue-400 mr-3 mt-1">lightbulb</span>
                                    <span class="text-slate-700 dark:text-slate-300">Lời khuyên: Hãy khám phá và kết hợp nhiều phương pháp để tìm ra sự kết hợp hiệu quả nhất cho từng môn học</span>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Learning Tips Grid -->
            <div class="mb-8">
                <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-6">💡 Mẹo học tập hiệu quả</h3>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <!-- Visual Tips -->
                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border-l-4 border-visual-light">
                        <h4 class="font-bold text-lg mb-4 flex items-center">
                            <span class="mr-2">👁️</span> Thị giác
                        </h4>
                        <ul class="space-y-3">
                            <li class="flex items-start">
                                <span class="material-symbols-outlined text-visual-light mr-3 mt-1 text-sm">check</span>
                                <span class="text-slate-600 dark:text-slate-300">Sử dụng mindmap và sơ đồ tư duy</span>
                            </li>
                            <li class="flex items-start">
                                <span class="material-symbols-outlined text-visual-light mr-3 mt-1 text-sm">check</span>
                                <span class="text-slate-600 dark:text-slate-300">Highlight và sử dụng nhiều màu sắc</span>
                            </li>
                            <li class="flex items-start">
                                <span class="material-symbols-outlined text-visual-light mr-3 mt-1 text-sm">check</span>
                                <span class="text-slate-600 dark:text-slate-300">Xem video tutorial và hình ảnh minh họa</span>
                            </li>
                            <li class="flex items-start">
                                <span class="material-symbols-outlined text-visual-light mr-3 mt-1 text-sm">check</span>
                                <span class="text-slate-600 dark:text-slate-300">Sử dụng flashcards với hình ảnh</span>
                            </li>
                        </ul>
                    </div>
                    
                    <!-- Auditory Tips -->
                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border-l-4 border-auditory-light">
                        <h4 class="font-bold text-lg mb-4 flex items-center">
                            <span class="mr-2">👂</span> Thính giác
                        </h4>
                        <ul class="space-y-3">
                            <li class="flex items-start">
                                <span class="material-symbols-outlined text-auditory-light mr-3 mt-1 text-sm">check</span>
                                <span class="text-slate-600 dark:text-slate-300">Ghi âm bài giảng và nghe lại</span>
                            </li>
                            <li class="flex items-start">
                                <span class="material-symbols-outlined text-auditory-light mr-3 mt-1 text-sm">check</span>
                                <span class="text-slate-600 dark:text-slate-300">Đọc to khi học và ôn tập</span>
                            </li>
                            <li class="flex items-start">
                                <span class="material-symbols-outlined text-auditory-light mr-3 mt-1 text-sm">check</span>
                                <span class="text-slate-600 dark:text-slate-300">Tham gia thảo luận nhóm</span>
                            </li>
                            <li class="flex items-start">
                                <span class="material-symbols-outlined text-auditory-light mr-3 mt-1 text-sm">check</span>
                                <span class="text-slate-600 dark:text-slate-300">Sử dụng podcast và audio books</span>
                            </li>
                        </ul>
                    </div>
                    
                    <!-- Kinesthetic Tips -->
                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border-l-4 border-kinesthetic-light">
                        <h4 class="font-bold text-lg mb-4 flex items-center">
                            <span class="mr-2">✋</span> Vận động
                        </h4>
                        <ul class="space-y-3">
                            <li class="flex items-start">
                                <span class="material-symbols-outlined text-kinesthetic-light mr-3 mt-1 text-sm">check</span>
                                <span class="text-slate-600 dark:text-slate-300">Thực hành ngay sau khi học lý thuyết</span>
                            </li>
                            <li class="flex items-start">
                                <span class="material-symbols-outlined text-kinesthetic-light mr-3 mt-1 text-sm">check</span>
                                <span class="text-slate-600 dark:text-slate-300">Sử dụng flashcards và di chuyển khi học</span>
                            </li>
                            <li class="flex items-start">
                                <span class="material-symbols-outlined text-kinesthetic-light mr-3 mt-1 text-sm">check</span>
                                <span class="text-slate-600 dark:text-slate-300">Tham gia các hoạt động thực hành</span>
                            </li>
                            <li class="flex items-start">
                                <span class="material-symbols-outlined text-kinesthetic-light mr-3 mt-1 text-sm">check</span>
                                <span class="text-slate-600 dark:text-slate-300">Học qua trò chơi và hoạt động tương tác</span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Resource Links -->
            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 mb-8">
                <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-6">🔗 Tài nguyên học tập đề xuất</h3>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                    <a href="https://www.khanacademy.org" target="_blank" 
                       class="bg-slate-100 dark:bg-slate-700 hover:bg-slate-200 dark:hover:bg-slate-600 rounded-xl p-4 transition-colors">
                        <div class="text-2xl mb-2">🎬</div>
                        <h4 class="font-semibold text-slate-900 dark:text-white">Khan Academy</h4>
                        <p class="text-sm text-slate-600 dark:text-slate-400 mt-1">Video bài giảng trực quan</p>
                    </a>
                    
                    <a href="https://quizlet.com" target="_blank" 
                       class="bg-slate-100 dark:bg-slate-700 hover:bg-slate-200 dark:hover:bg-slate-600 rounded-xl p-4 transition-colors">
                        <div class="text-2xl mb-2">📝</div>
                        <h4 class="font-semibold text-slate-900 dark:text-white">Quizlet</h4>
                        <p class="text-sm text-slate-600 dark:text-slate-400 mt-1">Flashcards và trò chơi học tập</p>
                    </a>
                    
                    <a href="https://www.coursera.org" target="_blank" 
                       class="bg-slate-100 dark:bg-slate-700 hover:bg-slate-200 dark:hover:bg-slate-600 rounded-xl p-4 transition-colors">
                        <div class="text-2xl mb-2">🎓</div>
                        <h4 class="font-semibold text-slate-900 dark:text-white">Coursera</h4>
                        <p class="text-sm text-slate-600 dark:text-slate-400 mt-1">Khóa học trực tuyến đa dạng</p>
                    </a>
                    
                    <a href="https://www.mindmeister.com" target="_blank" 
                       class="bg-slate-100 dark:bg-slate-700 hover:bg-slate-200 dark:hover:bg-slate-600 rounded-xl p-4 transition-colors">
                        <div class="text-2xl mb-2">🗺️</div>
                        <h4 class="font-semibold text-slate-900 dark:text-white">MindMeister</h4>
                        <p class="text-sm text-slate-600 dark:text-slate-400 mt-1">Công cụ tạo mindmap</p>
                    </a>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="flex flex-col sm:flex-row justify-between items-center gap-4 mt-8">
                <div class="flex flex-wrap gap-3">
                    <a href="#" class="flex items-center px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-lg transition-colors"
                       onclick="shareResults()">
                        <span class="material-symbols-outlined mr-2">share</span>
                        Chia sẻ
                    </a>
                    <a href="#" class="flex items-center px-4 py-2 bg-slate-200 dark:bg-slate-700 hover:bg-slate-300 dark:hover:bg-slate-600 text-slate-800 dark:text-slate-200 font-medium rounded-lg transition-colors"
                       onclick="copyResultToClipboard()">
                        <span class="material-symbols-outlined mr-2">content_copy</span>
                        Sao chép kết quả
                    </a>
                </div>
                
                <div class="flex flex-wrap gap-3">
                    <a href="${pageContext.request.contextPath}/dashboard" 
                       class="flex items-center px-6 py-3 bg-slate-200 dark:bg-slate-700 hover:bg-slate-300 dark:hover:bg-slate-600 text-slate-800 dark:text-slate-200 font-semibold rounded-xl transition-colors">
                        <span class="material-symbols-outlined mr-2">arrow_back</span>
                        Quay lại Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/quiz/learning-style" 
                       class="flex items-center px-6 py-3 bg-red-500 hover:bg-red-600 text-white font-semibold rounded-xl transition-colors">
                        <span class="material-symbols-outlined mr-2">refresh</span>
                        Làm lại quiz
                    </a>
                    <a href="${pageContext.request.contextPath}/quiz/career" 
                       class="flex items-center px-6 py-3 bg-gradient-to-r from-blue-500 to-purple-600 hover:opacity-90 text-white font-semibold rounded-xl transition-opacity">
                        Khám phá nghề nghiệp
                        <span class="material-symbols-outlined ml-2">arrow_forward</span>
                    </a>
                </div>
            </div>
        </main>
    </div>

    <%-- Settings Overlay --%>
    <%@ include file="../settings-overlay.jsp" %>

    <script src="/resources/js/sidebar.js"></script>
    <script src="/resources/js/setting.js"></script>
    
    <script>
        // Animate progress bars on page load
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(() => {
                // Get percentages
                const visualPercent = ${learningStyleResult.visualPercentage};
                const auditoryPercent = ${learningStyleResult.auditoryPercentage};
                const kinestheticPercent = ${learningStyleResult.kinestheticPercentage};
                
                // Animate bars
                animateBar('visual-bar', visualPercent);
                animateBar('auditory-bar', auditoryPercent);
                animateBar('kinesthetic-bar', kinestheticPercent);
                
                // Animate values
                animateValue('visual-value', 0, visualPercent, 1000);
                animateValue('auditory-value', 0, auditoryPercent, 1000);
                animateValue('kinesthetic-value', 0, kinestheticPercent, 1000);
                
                // Create confetti
                createConfetti();
            }, 500);
        });
        
        function animateBar(barId, percentage) {
            const bar = document.getElementById(barId);
            if (bar) {
                bar.style.width = '0%';
                setTimeout(() => {
                    bar.style.transition = 'width 1s ease-out';
                    bar.style.width = percentage + '%';
                }, 100);
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
        
        function createConfetti() {
            const primaryStyle = '${learningStyleResult.primaryStyle}'.toLowerCase();
            const confettiColors = {
                visual: ['#2575fc', '#6a11cb', '#2575fc'],
                auditory: ['#00b09b', '#96c93d', '#00b09b'],
                kinesthetic: ['#ff5e62', '#ff9966', '#ff5e62'],
                balanced: ['#8e44ad', '#9b59b6', '#8e44ad']
            };
            
            const colors = confettiColors[primaryStyle] || confettiColors.visual;
            const confettiCount = 60;
            
            for (let i = 0; i < confettiCount; i++) {
                const confetti = document.createElement('div');
                confetti.className = 'fixed w-2 h-2 rounded-full z-50';
                confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                confetti.style.left = Math.random() * 100 + 'vw';
                confetti.style.top = '-10px';
                confetti.style.opacity = '0.8';
                
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
        
        function copyResultToClipboard() {
            const style = '${learningStyleResult.primaryStyle}';
            const visual = ${learningStyleResult.visualPercentage};
            const auditory = ${learningStyleResult.auditoryPercentage};
            const kinesthetic = ${learningStyleResult.kinestheticPercentage};
            
            const resultText = `🎓 Kết quả Phong cách Học tập của tôi: ${style}\nThị giác: ${visual}% | Thính giác: ${auditory}% | Vận động: ${kinesthetic}%\n\nKhám phá phong cách học tập của bạn tại: ${window.location.origin}`;
            
            navigator.clipboard.writeText(resultText)
                .then(() => alert('Đã sao chép kết quả vào clipboard!'))
                .catch(err => {
                    console.error('Failed to copy: ', err);
                    alert('Không thể sao chép, vui lòng thử lại.');
                });
        }
    </script>
</body>
</html>