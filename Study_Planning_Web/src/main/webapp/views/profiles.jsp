<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="currentTheme" value="${empty theme ? 'light' : theme}" />
<!DOCTYPE html>
<html lang="vi" class="${currentTheme == 'dark' ? 'dark' : ''}">

    <head>
        <meta charset="utf-8" />
        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
        <title>Tổng quan (Dashboard)</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
        <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@300..700&display=swap" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet" />
        <!-- new -->
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet"/>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;700&amp;display=swap"
              rel="stylesheet" />
        <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
        <script>
            
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        colors: {
                            // Đã thay đổi primary về một màu nổi hơn cho dễ nhìn
                            primary: "#4F46E5", // Thay #A5B4FC bằng Indigo 600
                            "background-light": "#F8FAFC",
                            "background-dark": "#0F172A",
                            // New pastel colors
                            "pastel-purple": "#A5B4FC",
                            "pastel-light-purple": "#C7D2FE",
                            "pastel-pink": "#F9A8D4",
                            "pastel-yellow": "#FDE68A",
                            "text-color": "#1E293B",

                            //new
                            "surface-light": "#FFFFFF",
                            "surface-dark": "#293548",
                            "text-light": "#1E293B",
                            "text-dark": "#E2E8F0",
                            "border-light": "#E5E7EB",
                            "border-dark": "#475569",
                            "secondary-pink": "#F9A8D4",
                            "secondary-indigo-light": "#C7D2FE",
                            "secondary-yellow": "#FDE68A",
                        },
                        fontFamily: {
                            display: ["Be Vietnam Pro", "Quicksand", "sans-serif"],
                        },
                        borderRadius: {
                            DEFAULT: "0.75rem",
                        },
                    },
                },
            };
        </script>
        <link rel="stylesheet" href="/resources/css/sidebar.css">
        <link rel="stylesheet" href="/resources/css/setting.css">

    </head>

    <body class="font-display bg-background-light dark:bg-background-dark text-text-color dark:text-slate-200">
        <div class="flex h-screen">
            <aside 
                id="sidebar"
                class="bg-white dark:bg-slate-900 flex flex-col py-6 space-y-8 border-r border-slate-200 dark:border-slate-800 
                h-screen fixed top-0 left-0 transition-all duration-500 z-40 cursor-pointer"
                >

                <div class="w-14 h-14 bg-primary rounded-full flex items-center justify-center shrink-0 mx-auto">
                    <span class="material-icons-outlined text-white text-3xl">face</span>
                </div>

                <nav class="flex flex-col space-y-2 flex-grow w-full">

                    <%-- [ĐÃ SỬA ĐỔI] Đặt trạng thái active cho Bảng điều khiển --%>
                    <a class="nav-link w-full rounded-lg transition-colors hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300"
                       href="/dashboard">
                        <span class="material-icons-outlined text-3xl shrink-0">dashboard</span>
                        <span class="ml-4 whitespace-nowrap sidebar-text">Bảng điều khiển</span>
                    </a>

                    <%-- [ĐÃ SỬA ĐỔI] Lịch của tôi không còn active --%>
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

                       <a class="nav-link w-full rounded-lg transition-colors bg-primary shadow-md shadow-primary/30 text-white"
                          href="${pageContext.request.contextPath}/user-profiles">
                           <span class="material-icons-outlined text-3xl shrink-0">manage_accounts</span>
                           <span class="ml-4 whitespace-nowrap sidebar-text">Thiết lập hồ sơ</span>
                       </a>
                </nav>
            </aside>

            <main id="mainContent" class="flex-1 flex flex-col p-6 lg:p-8 overflow-y-auto">
                <header class="flex justify-between items-center mb-6">
                    <div>
                        <h1 class="text-2xl font-bold text-text-color dark:text-white">Chào buổi sáng, ${user.username}!</h1>
                        <p class="text-slate-500 dark:text-slate-400">Đây là tổng quan các hoạt động của bạn.</p>
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

                <!-- Error Message -->
                <c:if test="${not empty error}">
                    <div class="m-4 bg-red-50 dark:bg-red-900/30 border border-red-200 dark:border-red-800 text-red-700 dark:text-red-300 px-4 py-3 rounded-lg">
                        <div class="flex items-center">
                            <span class="material-icons-outlined mr-2">error</span>
                            <span>${error}</span>
                        </div>
                    </div>
                </c:if>

                <!-- Form Container -->
                <div class="flex-1 overflow-y-auto p-8">
                    <div class="max-w-6xl mx-auto">
                        <form method="post" action="${pageContext.request.contextPath}/profiles" id="profileForm">
                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">

                                <!-- Card 1: Năm học & Tính cách -->
                                <div class="bg-white dark:bg-slate-900 p-6 rounded-lg shadow-sm border border-slate-200 dark:border-slate-800">
                                    <div class="flex items-center space-x-3 mb-4">
                                        <div class="w-10 h-10 bg-blue-100 dark:bg-blue-900/50 rounded-lg flex items-center justify-center">
                                            <span class="material-icons-outlined text-blue-500 dark:text-blue-400">school</span>
                                        </div>
                                        <h3 class="font-semibold text-lg text-slate-800 dark:text-slate-200">Thông tin Học tập</h3>
                                    </div>

                                    <div class="space-y-4">
                                        <div>
                                            <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Năm học hiện tại</label>
                                            <select class="w-full form-select bg-slate-50 dark:bg-slate-800 border-slate-200 dark:border-slate-700 rounded-md focus:ring-primary/50 focus:border-primary" 
                                                    name="year_of_study" required>
                                                <option value="">Chọn năm học</option>
                                                <option value="1" ${userProfile.yearOfStudy == 1 ? 'selected' : ''}>Năm 1</option>
                                                <option value="2" ${userProfile.yearOfStudy == 2 ? 'selected' : ''}>Năm 2</option>
                                                <option value="3" ${userProfile.yearOfStudy == 3 ? 'selected' : ''}>Năm 3</option>
                                                <option value="4" ${userProfile.yearOfStudy == 4 ? 'selected' : ''}>Năm 4</option>
                                            </select>
                                        </div>

                                        <div>
                                            <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Loại tính cách (MBTI)</label>
                                            <select class="w-full form-select bg-slate-50 dark:bg-slate-800 border-slate-200 dark:border-slate-700 rounded-md focus:ring-primary/50 focus:border-primary" 
                                                    name="personality_type" required>
                                                <option value="">Chọn loại tính cách</option>
                                                <option value="ISTJ" ${userProfile.personalityType == 'ISTJ' ? 'selected' : ''}>ISTJ - Người trách nhiệm</option>
                                                <option value="ISFJ" ${userProfile.personalityType == 'ISFJ' ? 'selected' : ''}>ISFJ - Người bảo vệ</option>
                                                <option value="INFJ" ${userProfile.personalityType == 'INFJ' ? 'selected' : ''}>INFJ - Người cố vấn</option>
                                                <option value="INTJ" ${userProfile.personalityType == 'INTJ' ? 'selected' : ''}>INTJ - Nhà khoa học</option>
                                                <option value="ISTP" ${userProfile.personalityType == 'ISTP' ? 'selected' : ''}>ISTP - Nhà kỹ thuật</option>
                                                <option value="ISFP" ${userProfile.personalityType == 'ISFP' ? 'selected' : ''}>ISFP - Người nghệ sĩ</option>
                                                <option value="INFP" ${userProfile.personalityType == 'INFP' ? 'selected' : ''}>INFP - Người lý tưởng</option>
                                                <option value="INTP" ${userProfile.personalityType == 'INTP' ? 'selected' : ''}>INTP - Nhà tư duy</option>
                                                <option value="ESTP" ${userProfile.personalityType == 'ESTP' ? 'selected' : ''}>ESTP - Người thực thi</option>
                                                <option value="ESFP" ${userProfile.personalityType == 'ESFP' ? 'selected' : ''}>ESFP - Người trình diễn</option>
                                                <option value="ENFP" ${userProfile.personalityType == 'ENFP' ? 'selected' : ''}>ENFP - Người truyền cảm hứng</option>
                                                <option value="ENTP" ${userProfile.personalityType == 'ENTP' ? 'selected' : ''}>ENTP - Nhà phát minh</option>
                                                <option value="ESTJ" ${userProfile.personalityType == 'ESTJ' ? 'selected' : ''}>ESTJ - Người giám sát</option>
                                                <option value="ESFJ" ${userProfile.personalityType == 'ESFJ' ? 'selected' : ''}>ESFJ - Người chăm sóc</option>
                                                <option value="ENFJ" ${userProfile.personalityType == 'ENFJ' ? 'selected' : ''}>ENFJ - Người cho đi</option>
                                                <option value="ENTJ" ${userProfile.personalityType == 'ENTJ' ? 'selected' : ''}>ENTJ - Nhà điều hành</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <!-- Card 2: Phong cách học -->
                                <div class="bg-white dark:bg-slate-900 p-6 rounded-lg shadow-sm border border-slate-200 dark:border-slate-800">
                                    <div class="flex items-center space-x-3 mb-4">
                                        <div class="w-10 h-10 bg-purple-100 dark:bg-purple-900/50 rounded-lg flex items-center justify-center">
                                            <span class="material-icons-outlined text-purple-500 dark:text-purple-400">psychology</span>
                                        </div>
                                        <h3 class="font-semibold text-lg text-slate-800 dark:text-slate-200">Phong cách Học tập</h3>
                                    </div>
                                    <p class="text-slate-500 dark:text-slate-400 mb-4 text-sm">Bạn tiếp thu kiến thức hiệu quả nhất qua hình thức nào?</p>
                                    <div class="space-y-3">
                                        <label class="option-card flex items-center p-3 rounded-md border border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800/50 cursor-pointer ${userProfile.learningStyle == 'visual' ? 'selected' : ''}">
                                            <input class="form-radio text-primary focus:ring-primary/50" name="learning_style" value="visual" type="radio" ${userProfile.learningStyle == 'visual' ? 'checked' : ''} required/>
                                            <span class="ml-3 text-slate-700 dark:text-slate-300">👁️ Học qua hình ảnh (Visual)</span>
                                        </label>
                                        <label class="option-card flex items-center p-3 rounded-md border border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800/50 cursor-pointer ${userProfile.learningStyle == 'auditory' ? 'selected' : ''}">
                                            <input class="form-radio text-primary focus:ring-primary/50" name="learning_style" value="auditory" type="radio" ${userProfile.learningStyle == 'auditory' ? 'checked' : ''}/>
                                            <span class="ml-3 text-slate-700 dark:text-slate-300">👂 Học qua âm thanh (Auditory)</span>
                                        </label>
                                        <label class="option-card flex items-center p-3 rounded-md border border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800/50 cursor-pointer ${userProfile.learningStyle == 'kinesthetic' ? 'selected' : ''}">
                                            <input class="form-radio text-primary focus:ring-primary/50" name="learning_style" value="kinesthetic" type="radio" ${userProfile.learningStyle == 'kinesthetic' ? 'checked' : ''}/>
                                            <span class="ml-3 text-slate-700 dark:text-slate-300">🖐️ Học qua thực hành (Kinesthetic)</span>
                                        </label>
                                    </div>
                                </div>

                                <!-- Card 3: Thời gian học -->
                                <div class="bg-white dark:bg-slate-900 p-6 rounded-lg shadow-sm border border-slate-200 dark:border-slate-800">
                                    <div class="flex items-center space-x-3 mb-4">
                                        <div class="w-10 h-10 bg-teal-100 dark:bg-teal-900/50 rounded-lg flex items-center justify-center">
                                            <span class="material-icons-outlined text-teal-500 dark:text-teal-400">schedule</span>
                                        </div>
                                        <h3 class="font-semibold text-lg text-slate-800 dark:text-slate-200">Thời gian Học hiệu quả</h3>
                                    </div>
                                    <p class="text-slate-500 dark:text-slate-400 mb-4 text-sm">Bạn cảm thấy tập trung và hiệu quả nhất vào khoảng thời gian nào?</p>
                                    <select class="w-full form-select bg-slate-50 dark:bg-slate-800 border-slate-200 dark:border-slate-700 rounded-md focus:ring-primary/50 focus:border-primary" 
                                            name="preferred_study_time" required>
                                        <option value="">Chọn thời gian</option>
                                        <option value="morning" ${userProfile.preferredStudyTime == 'morning' ? 'selected' : ''}>🌅 Buổi sáng (6h-12h)</option>
                                        <option value="afternoon" ${userProfile.preferredStudyTime == 'afternoon' ? 'selected' : ''}>☀️ Buổi chiều (12h-18h)</option>
                                        <option value="evening" ${userProfile.preferredStudyTime == 'evening' ? 'selected' : ''}>🌙 Buổi tối (18h-24h)</option>
                                        <option value="night" ${userProfile.preferredStudyTime == 'night' ? 'selected' : ''}>🌃 Ban đêm (0h-6h)</option>
                                    </select>
                                </div>

                                <!-- Card 4: Thời gian tập trung -->
                                <div class="bg-white dark:bg-slate-900 p-6 rounded-lg shadow-sm border border-slate-200 dark:border-slate-800">
                                    <div class="flex items-center space-x-3 mb-4">
                                        <div class="w-10 h-10 bg-amber-100 dark:bg-amber-900/50 rounded-lg flex items-center justify-center">
                                            <span class="material-icons-outlined text-amber-500 dark:text-amber-400">timer</span>
                                        </div>
                                        <h3 class="font-semibold text-lg text-slate-800 dark:text-slate-200">Thời gian Tập trung</h3>
                                    </div>
                                    <p class="text-slate-500 dark:text-slate-400 mb-4 text-sm">Thời gian bạn có thể tập trung học liên tục tối đa (phút)</p>
                                    <select class="w-full form-select bg-slate-50 dark:bg-slate-800 border-slate-200 dark:border-slate-700 rounded-md focus:ring-primary/50 focus:border-primary" 
                                            name="focus_duration">
                                        <option value="">Chọn thời gian</option>
                                        <option value="25" ${userProfile.focusDuration == 25 ? 'selected' : ''}>25 phút (Pomodoro)</option>
                                        <option value="45" ${userProfile.focusDuration == 45 ? 'selected' : ''}>45 phút (Tiết học)</option>
                                        <option value="60" ${userProfile.focusDuration == 60 ? 'selected' : ''}>60 phút (1 giờ)</option>
                                        <option value="90" ${userProfile.focusDuration == 90 ? 'selected' : ''}>90 phút (1.5 giờ)</option>
                                        <option value="120" ${userProfile.focusDuration == 120 ? 'selected' : ''}>120 phút (2 giờ)</option>
                                    </select>
                                </div>

                                <!-- Card 5: Mục tiêu học tập -->
                                <div class="bg-white dark:bg-slate-900 p-6 rounded-lg shadow-sm border border-slate-200 dark:border-slate-800 lg:col-span-2">
                                    <div class="flex items-center space-x-3 mb-4">
                                        <div class="w-10 h-10 bg-green-100 dark:bg-green-900/50 rounded-lg flex items-center justify-center">
                                            <span class="material-icons-outlined text-green-500 dark:text-green-400">flag</span>
                                        </div>
                                        <h3 class="font-semibold text-lg text-slate-800 dark:text-slate-200">Mục tiêu Học tập</h3>
                                    </div>
                                    <p class="text-slate-500 dark:text-slate-400 mb-4 text-sm">Mục tiêu học tập của bạn là gì? Hãy chia sẻ để chúng tôi hỗ trợ tốt hơn</p>
                                    <textarea class="w-full form-textarea bg-slate-50 dark:bg-slate-800 border-slate-200 dark:border-slate-700 rounded-md focus:ring-primary/50 focus:border-primary" 
                                              name="goal" rows="4" placeholder="Ví dụ: Đạt GPA 3.5, hoàn thành khóa học lập trình Java, thi đỗ chứng chỉ IELTS 7.0...">${userProfile.goal}</textarea>
                                    <div class="mt-2 text-sm text-slate-500 dark:text-slate-400">
                                        <span id="goalCounter">${userProfile.goal != null ? userProfile.goal.length() : 0}</span>/500 ký tự
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="mt-8 flex justify-end space-x-4">
                                <a href="${pageContext.request.contextPath}/dashboard" class="px-6 py-3 bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 font-semibold rounded-lg hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors">
                                    Bỏ qua
                                </a>
                                <button type="submit" class="px-6 py-3 bg-primary text-white font-semibold rounded-lg shadow-sm hover:opacity-90 transition-opacity flex items-center">
                                    <span>Lưu và tiếp tục</span>
                                    <span class="material-icons-outlined ml-2">arrow_forward</span>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
        
        <%-- 1. THÊM LỚP PHỦ CÀI ĐẶT TẠI ĐÂY --%>
        <%-- Đảm bảo toàn bộ HTML của lớp phủ được tải vào DOM trước khi JS chạy --%>
        <%@ include file="settings-overlay.jsp" %>

        <script src="/resources/js/sidebar.js"></script>
        <script src="/resources/js/setting.js"></script>
        <script>
            // Auto-select option cards when radio is checked
            document.querySelectorAll('input[type="radio"]').forEach(radio => {
                radio.addEventListener('change', function () {
                    // Remove selected class from all cards in the same group
                    const groupName = this.getAttribute('name');
                    document.querySelectorAll(`input[name="${groupName}"]`).forEach(r => {
                        r.closest('label').classList.remove('selected');
                    });

                    // Add selected class to current card
                    if (this.checked) {
                        this.closest('label').classList.add('selected');
                    }
                });

                // Initialize selected state on page load
                if (radio.checked) {
                    radio.closest('label').classList.add('selected');
                }
            });

            // Goal character counter
            const goalTextarea = document.querySelector('textarea[name="goal"]');
            const goalCounter = document.getElementById('goalCounter');

            if (goalTextarea && goalCounter) {
                goalTextarea.addEventListener('input', function () {
                    goalCounter.textContent = this.value.length;
                });
            }

            // Form validation
            document.getElementById('profileForm').addEventListener('submit', function (e) {
                const requiredFields = this.querySelectorAll('[required]');
                let isValid = true;
                let firstInvalidField = null;

                requiredFields.forEach(field => {
                    if (!field.value.trim()) {
                        isValid = false;
                        field.style.borderColor = '#ef4444';

                        if (!firstInvalidField) {
                            firstInvalidField = field;
                        }
                    } else {
                        field.style.borderColor = '';
                    }
                });

                if (!isValid) {
                    e.preventDefault();
                    alert('Vui lòng điền đầy đủ thông tin bắt buộc (Năm học, Loại tính cách, Phong cách học, Thời gian học)');

                    if (firstInvalidField) {
                        firstInvalidField.focus();
                    }
                }
            });

            // Clear error styling on input
            document.querySelectorAll('input, select, textarea').forEach(field => {
                field.addEventListener('input', function () {
                    this.style.borderColor = '';
                });

                field.addEventListener('change', function () {
                    this.style.borderColor = '';
                });
            });
        </script>

    </body>
</html>