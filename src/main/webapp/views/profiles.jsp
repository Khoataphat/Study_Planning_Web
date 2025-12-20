<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Thiết lập Hồ sơ Học tập</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
    <script>
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            colors: {
              primary: "#A5B4FC",
              "background-light": "#F8FAFC",
              "background-dark": "#1E293B",
            },
            fontFamily: {
              display: ["Be Vietnam Pro", "sans-serif"],
            },
            borderRadius: {
              DEFAULT: "1rem",
            },
          },
        },
      };
    </script>
    <style>
        body {
            font-family: 'Be Vietnam Pro', sans-serif;
        }
        .option-card {
            transition: all 0.2s ease;
        }
        .option-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .option-card.selected {
            border-color: #A5B4FC;
            background-color: rgba(165, 180, 252, 0.1);
        }
    </style>
</head>
<body class="bg-background-light dark:bg-background-dark text-slate-800 dark:text-slate-200">
<div class="flex h-screen">
    <!-- Sidebar -->
    <aside class="w-20 flex flex-col items-center space-y-8 py-8 bg-white/50 dark:bg-slate-900/50 border-r border-slate-200 dark:border-slate-800">
        <div class="w-12 h-12 bg-primary rounded-full flex items-center justify-center">
            <span class="text-2xl font-bold text-white">S</span>
        </div>
        <nav class="flex flex-col items-center space-y-6">
            <a class="p-3 text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg" href="${pageContext.request.contextPath}/dashboard">
                <span class="material-icons-outlined">dashboard</span>
            </a>
            <a class="p-3 bg-primary/20 text-primary rounded-lg" href="${pageContext.request.contextPath}/profiles">
                <span class="material-icons-outlined">person</span>
            </a>
            <a class="p-3 text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg" href="${pageContext.request.contextPath}/user/learning-style-setup">
                <span class="material-icons-outlined">psychology</span>
            </a>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="flex-1 flex flex-col overflow-hidden">
        <!-- Header -->
        <header class="flex items-center justify-between p-6 border-b border-slate-200 dark:border-slate-800 bg-background-light dark:bg-background-dark">
            <div>
                <h1 class="text-2xl font-bold text-slate-900 dark:text-white">Thiết lập Hồ sơ Học tập</h1>
                <p class="text-slate-500 dark:text-slate-400">Điền thông tin cơ bản để bắt đầu</p>
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

<script>
    // Auto-select option cards when radio is checked
    document.querySelectorAll('input[type="radio"]').forEach(radio => {
        radio.addEventListener('change', function() {
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
        goalTextarea.addEventListener('input', function() {
            goalCounter.textContent = this.value.length;
        });
    }

    // Form validation
    document.getElementById('profileForm').addEventListener('submit', function(e) {
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
        field.addEventListener('input', function() {
            this.style.borderColor = '';
        });
        
        field.addEventListener('change', function() {
            this.style.borderColor = '';
        });
    });
</script>
</body>
</html>