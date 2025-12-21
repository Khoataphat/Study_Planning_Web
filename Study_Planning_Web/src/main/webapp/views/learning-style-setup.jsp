<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Khám Phá Phong Cách Học Tập</title>
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
        .quiz-card {
            transition: all 0.2s ease;
            cursor: pointer;
        }
        .quiz-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        .quiz-card.selected {
            border-color: #A5B4FC;
            border-width: 2px;
            background-color: rgba(165, 180, 252, 0.05);
        }
        .number-circle {
            width: 32px;
            height: 32px;
            background: #A5B4FC;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
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
            <a class="p-3 text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg" href="${pageContext.request.contextPath}/profiles">
                <span class="material-icons-outlined">person</span>
            </a>
            <a class="p-3 bg-primary/20 text-primary rounded-lg" href="${pageContext.request.contextPath}/user/learning-style-setup">
                <span class="material-icons-outlined">psychology</span>
            </a>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="flex-1 flex flex-col overflow-hidden">
        <!-- Header -->
        <header class="flex items-center justify-between p-6 border-b border-slate-200 dark:border-slate-800 bg-background-light dark:bg-background-dark">
            <div>
                <h1 class="text-2xl font-bold text-slate-900 dark:text-white">Khám Phá Phong Cách Học Tập</h1>
                <p class="text-slate-500 dark:text-slate-400">Trả lời câu hỏi để tối ưu hóa phương pháp học của bạn</p>
            </div>
        </header>

        <!-- Error Messages -->
        <c:if test="${not empty error}">
            <div class="m-4 bg-red-50 dark:bg-red-900/30 border border-red-200 dark:border-red-800 text-red-700 dark:text-red-300 px-4 py-3 rounded-lg">
                <div class="flex items-center">
                    <span class="material-icons-outlined mr-2">error</span>
                    <span>${error}</span>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="m-4 bg-red-50 dark:bg-red-900/30 border border-red-200 dark:border-red-800 text-red-700 dark:text-red-300 px-4 py-3 rounded-lg">
                <div class="flex items-center">
                    <span class="material-icons-outlined mr-2">error</span>
                    <span>${errorMessage}</span>
                </div>
            </div>
        </c:if>

        <!-- Progress Bar -->
        <div class="px-8 pt-8">
            <div class="max-w-4xl mx-auto">
                <div class="mb-6">
                    <div class="flex justify-between mb-2">
                        <span class="text-sm font-medium text-slate-600 dark:text-slate-400">Tiến độ hoàn thành</span>
                        <span class="text-sm font-medium text-primary dark:text-primary">Bước 2/2</span>
                    </div>
                    <div class="w-full bg-slate-200 dark:bg-slate-700 rounded-full h-2.5">
                        <div class="bg-primary h-2.5 rounded-full" style="width: 100%"></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Form Container -->
        <div class="flex-1 overflow-y-auto p-8">
            <div class="max-w-4xl mx-auto">
                <form method="post" action="${pageContext.request.contextPath}/user/learning-style-setup" id="learningStyleForm">
                    
                    <!-- Question 1: Phong cách học -->
                    <div class="bg-white dark:bg-slate-900 p-8 rounded-lg shadow-sm border border-slate-200 dark:border-slate-800 mb-8">
                        <div class="flex items-center mb-6">
                            <div class="number-circle mr-4">1</div>
                            <div>
                                <h2 class="text-xl font-bold text-slate-900 dark:text-white">Phong cách Học tập của bạn là gì?</h2>
                                <p class="text-slate-500 dark:text-slate-400 mt-1">Chọn phương pháp học phù hợp nhất với bạn</p>
                            </div>
                        </div>
                        
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                            <label class="quiz-card p-6 rounded-lg border border-slate-200 dark:border-slate-700 hover:border-primary dark:hover:border-primary cursor-pointer ${userProfile.learningStyle == 'visual' ? 'selected' : ''}">
                                <input class="hidden" type="radio" name="learning_style" value="visual" required ${userProfile.learningStyle == 'visual' ? 'checked' : ''}>
                                <div class="text-center">
                                    <div class="text-4xl mb-3">👁️</div>
                                    <h3 class="font-semibold text-slate-800 dark:text-slate-200 mb-2">Học qua Hình ảnh</h3>
                                    <p class="text-sm text-slate-600 dark:text-slate-400">Sơ đồ, video, infographic, mindmap</p>
                                </div>
                            </label>
                            
                            <label class="quiz-card p-6 rounded-lg border border-slate-200 dark:border-slate-700 hover:border-primary dark:hover:border-primary cursor-pointer ${userProfile.learningStyle == 'auditory' ? 'selected' : ''}">
                                <input class="hidden" type="radio" name="learning_style" value="auditory" ${userProfile.learningStyle == 'auditory' ? 'checked' : ''}>
                                <div class="text-center">
                                    <div class="text-4xl mb-3">👂</div>
                                    <h3 class="font-semibold text-slate-800 dark:text-slate-200 mb-2">Học qua Âm thanh</h3>
                                    <p class="text-sm text-slate-600 dark:text-slate-400">Thảo luận, podcast, ghi âm, đọc to</p>
                                </div>
                            </label>
                            
                            <label class="quiz-card p-6 rounded-lg border border-slate-200 dark:border-slate-700 hover:border-primary dark:hover:border-primary cursor-pointer ${userProfile.learningStyle == 'kinesthetic' ? 'selected' : ''}">
                                <input class="hidden" type="radio" name="learning_style" value="kinesthetic" ${userProfile.learningStyle == 'kinesthetic' ? 'checked' : ''}>
                                <div class="text-center">
                                    <div class="text-4xl mb-3">🖐️</div>
                                    <h3 class="font-semibold text-slate-800 dark:text-slate-200 mb-2">Học qua Thực hành</h3>
                                    <p class="text-sm text-slate-600 dark:text-slate-400">Làm bài tập, thí nghiệm, project thực tế</p>
                                </div>
                            </label>
                        </div>
                    </div>

                    <!-- Question 2: Thời gian học hiệu quả -->
                    <div class="bg-white dark:bg-slate-900 p-8 rounded-lg shadow-sm border border-slate-200 dark:border-slate-800 mb-8">
                        <div class="flex items-center mb-6">
                            <div class="number-circle mr-4">2</div>
                            <div>
                                <h2 class="text-xl font-bold text-slate-900 dark:text-white">Bạn học hiệu quả nhất vào thời gian nào?</h2>
                                <p class="text-slate-500 dark:text-slate-400 mt-1">Chọn khoảng thời gian bạn tập trung nhất</p>
                            </div>
                        </div>
                        
                        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                            <label class="quiz-card p-6 rounded-lg border border-slate-200 dark:border-slate-700 hover:border-primary dark:hover:border-primary cursor-pointer ${userProfile.preferredStudyTime == 'morning' ? 'selected' : ''}">
                                <input class="hidden" type="radio" name="preferred_study_time" value="morning" required ${userProfile.preferredStudyTime == 'morning' ? 'checked' : ''}>
                                <div class="text-center">
                                    <div class="text-4xl mb-3">🌅</div>
                                    <h3 class="font-semibold text-slate-800 dark:text-slate-200 mb-2">Buổi sáng</h3>
                                    <p class="text-sm text-slate-600 dark:text-slate-400">6h - 12h</p>
                                </div>
                            </label>
                            
                            <label class="quiz-card p-6 rounded-lg border border-slate-200 dark:border-slate-700 hover:border-primary dark:hover:border-primary cursor-pointer ${userProfile.preferredStudyTime == 'afternoon' ? 'selected' : ''}">
                                <input class="hidden" type="radio" name="preferred_study_time" value="afternoon" ${userProfile.preferredStudyTime == 'afternoon' ? 'checked' : ''}>
                                <div class="text-center">
                                    <div class="text-4xl mb-3">☀️</div>
                                    <h3 class="font-semibold text-slate-800 dark:text-slate-200 mb-2">Buổi chiều</h3>
                                    <p class="text-sm text-slate-600 dark:text-slate-400">12h - 18h</p>
                                </div>
                            </label>
                            
                            <label class="quiz-card p-6 rounded-lg border border-slate-200 dark:border-slate-700 hover:border-primary dark:hover:border-primary cursor-pointer ${userProfile.preferredStudyTime == 'evening' ? 'selected' : ''}">
                                <input class="hidden" type="radio" name="preferred_study_time" value="evening" ${userProfile.preferredStudyTime == 'evening' ? 'checked' : ''}>
                                <div class="text-center">
                                    <div class="text-4xl mb-3">🌙</div>
                                    <h3 class="font-semibold text-slate-800 dark:text-slate-200 mb-2">Buổi tối</h3>
                                    <p class="text-sm text-slate-600 dark:text-slate-400">18h - 24h</p>
                                </div>
                            </label>
                            
                            <label class="quiz-card p-6 rounded-lg border border-slate-200 dark:border-slate-700 hover:border-primary dark:hover:border-primary cursor-pointer ${userProfile.preferredStudyTime == 'night' ? 'selected' : ''}">
                                <input class="hidden" type="radio" name="preferred_study_time" value="night" ${userProfile.preferredStudyTime == 'night' ? 'checked' : ''}>
                                <div class="text-center">
                                    <div class="text-4xl mb-3">🌃</div>
                                    <h3 class="font-semibold text-slate-800 dark:text-slate-200 mb-2">Đêm khuya</h3>
                                    <p class="text-sm text-slate-600 dark:text-slate-400">0h - 6h</p>
                                </div>
                            </label>
                        </div>
                    </div>

                    <!-- Additional Information Section -->
                    <div class="bg-white dark:bg-slate-900 p-8 rounded-lg shadow-sm border border-slate-200 dark:border-slate-800 mb-8">
                        <h2 class="text-xl font-bold text-slate-900 dark:text-white mb-6">Thông tin Bổ sung</h2>
                        
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                            <!-- Năm học -->
                            <div>
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Năm học</label>
                                <select class="w-full form-select bg-slate-50 dark:bg-slate-800 border-slate-200 dark:border-slate-700 rounded-md focus:ring-primary/50 focus:border-primary" 
                                        name="year_of_study">
                                    <option value="">Chọn năm học</option>
                                    <option value="1" ${userProfile.yearOfStudy == 1 ? 'selected' : ''}>Năm 1</option>
                                    <option value="2" ${userProfile.yearOfStudy == 2 ? 'selected' : ''}>Năm 2</option>
                                    <option value="3" ${userProfile.yearOfStudy == 3 ? 'selected' : ''}>Năm 3</option>
                                    <option value="4" ${userProfile.yearOfStudy == 4 ? 'selected' : ''}>Năm 4</option>
                                </select>
                            </div>

                            <!-- Thời gian tập trung -->
                            <div>
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Thời gian tập trung (phút)</label>
                                <select class="w-full form-select bg-slate-50 dark:bg-slate-800 border-slate-200 dark:border-slate-700 rounded-md focus:ring-primary/50 focus:border-primary" 
                                        name="focus_duration">
                                    <option value="">Chọn thời gian</option>
                                    <option value="25" ${userProfile.focusDuration == 25 ? 'selected' : ''}>25 phút</option>
                                    <option value="45" ${userProfile.focusDuration == 45 ? 'selected' : ''}>45 phút</option>
                                    <option value="60" ${userProfile.focusDuration == 60 ? 'selected' : ''}>60 phút</option>
                                    <option value="90" ${userProfile.focusDuration == 90 ? 'selected' : ''}>90 phút</option>
                                    <option value="120" ${userProfile.focusDuration == 120 ? 'selected' : ''}>120 phút</option>
                                </select>
                            </div>

                            <!-- Loại tính cách -->
                            <div>
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Loại tính cách (MBTI)</label>
                                <select class="w-full form-select bg-slate-50 dark:bg-slate-800 border-slate-200 dark:border-slate-700 rounded-md focus:ring-primary/50 focus:border-primary" 
                                        name="personality_type">
                                    <option value="">Chọn tính cách</option>
                                    <option value="ISTJ" ${userProfile.personalityType == 'ISTJ' ? 'selected' : ''}>ISTJ</option>
                                    <option value="ISFJ" ${userProfile.personalityType == 'ISFJ' ? 'selected' : ''}>ISFJ</option>
                                    <option value="INFJ" ${userProfile.personalityType == 'INFJ' ? 'selected' : ''}>INFJ</option>
                                    <option value="INTJ" ${userProfile.personalityType == 'INTJ' ? 'selected' : ''}>INTJ</option>
                                    <option value="ISTP" ${userProfile.personalityType == 'ISTP' ? 'selected' : ''}>ISTP</option>
                                    <option value="ISFP" ${userProfile.personalityType == 'ISFP' ? 'selected' : ''}>ISFP</option>
                                    <option value="INFP" ${userProfile.personalityType == 'INFP' ? 'selected' : ''}>INFP</option>
                                    <option value="INTP" ${userProfile.personalityType == 'INTP' ? 'selected' : ''}>INTP</option>
                                    <option value="ESTP" ${userProfile.personalityType == 'ESTP' ? 'selected' : ''}>ESTP</option>
                                    <option value="ESFP" ${userProfile.personalityType == 'ESFP' ? 'selected' : ''}>ESFP</option>
                                    <option value="ENFP" ${userProfile.personalityType == 'ENFP' ? 'selected' : ''}>ENFP</option>
                                    <option value="ENTP" ${userProfile.personalityType == 'ENTP' ? 'selected' : ''}>ENTP</option>
                                </select>
                            </div>

                            <!-- Mục tiêu -->
                            <div class="lg:col-span-2">
                                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Mục tiêu học tập</label>
                                <textarea class="w-full form-textarea bg-slate-50 dark:bg-slate-800 border-slate-200 dark:border-slate-700 rounded-md focus:ring-primary/50 focus:border-primary" 
                                          name="goal" rows="3" placeholder="Đạt GPA 3.5, thi đỗ chứng chỉ...">${userProfile.goal}</textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="flex justify-between mt-8">
                        <a href="${pageContext.request.contextPath}/profiles" class="px-8 py-3 bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 font-semibold rounded-lg hover:bg-slate-200 dark:hover:bg-slate-700 transition-colors">
                            ← Quay lại
                        </a>
                        <button type="submit" class="px-8 py-3 bg-primary text-white font-semibold rounded-lg shadow-sm hover:opacity-90 transition-opacity">
                            HOÀN THÀNH & VÀO DASHBOARD
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script>
    // Auto-select quiz cards
    document.querySelectorAll('.quiz-card').forEach(card => {
        card.addEventListener('click', function() {
            const input = this.querySelector('input[type="radio"]');
            if (input) {
                input.checked = true;
                
                // Remove selected class from all cards in the same question
                const name = input.getAttribute('name');
                document.querySelectorAll(`input[name="${name}"]`).forEach(radio => {
                    radio.closest('.quiz-card').classList.remove('selected');
                });
                
                // Add selected class to clicked card
                this.classList.add('selected');
            }
        });
    });

    // Initialize selected state
    document.querySelectorAll('input[type="radio"]:checked').forEach(radio => {
        radio.closest('.quiz-card')?.classList.add('selected');
    });

    // Form validation
    document.getElementById('learningStyleForm').addEventListener('submit', function(e) {
        const requiredFields = [
            'learning_style',
            'preferred_study_time'
        ];
        
        let isValid = true;
        let missingFields = [];
        
        requiredFields.forEach(fieldName => {
            const field = document.querySelector(`[name="${fieldName}"]:checked`);
            if (!field) {
                isValid = false;
                missingFields.push(fieldName);
            }
        });
        
        if (!isValid) {
            e.preventDefault();
            
            let errorMessage = 'Vui lòng hoàn thành các câu hỏi bắt buộc:\n';
            if (missingFields.includes('learning_style')) {
                errorMessage += '- Chọn phong cách học tập\n';
            }
            if (missingFields.includes('preferred_study_time')) {
                errorMessage += '- Chọn thời gian học hiệu quả\n';
            }
            
            alert(errorMessage);
            
            // Scroll to first missing field
            if (missingFields.length > 0) {
                const firstField = document.querySelector(`[name="${missingFields[0]}"]`);
                if (firstField) {
                    firstField.closest('.bg-white')?.scrollIntoView({ behavior: 'smooth' });
                }
            }
        }
    });
</script>
</body>
</html>