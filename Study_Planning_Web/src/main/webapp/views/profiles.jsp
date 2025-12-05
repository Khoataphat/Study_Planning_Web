<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Khám phá phương pháp học - Study Plan</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&display=swap" rel="stylesheet"/>
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
                        "pastel-1": "#A5B4FC",
                        "pastel-2": "#C7D2FE",
                        "pastel-3": "#F9A8D4",
                        "pastel-4": "#FDE68A",
                        "text-dark": "#1E293B",
                    },
                    fontFamily: {
                        display: ["Be Vietnam Pro", "sans-serif"],
                    },
                    borderRadius: { DEFAULT: "1rem" },
                },
            },
        };
    </script>
    <style>
        body { font-family: 'Be Vietnam Pro', sans-serif; }
        .selected {
            transform: scale(1.05);
            box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04);
        }
        .question-section { display: none; }
        .question-section.active { display: block; }
    </style>
</head>
<body class="bg-background-light dark:bg-background-dark text-slate-800 dark:text-slate-200">
<div class="flex h-screen">
    <!-- Sidebar -->
    <aside class="w-20 flex flex-col items-center space-y-8 py-8 bg-white/50 dark:bg-slate-900/50 border-r border-slate-200 dark:border-slate-800">
        <div class="w-12 h-12 bg-primary rounded-full flex items-center justify-center">
            <span class="text-2xl font-bold text-white">G</span>
        </div>
        <nav class="flex flex-col items-center space-y-6">
            <a class="p-3 text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-lg" href="${pageContext.request.contextPath}/dashboard">
                <span class="material-icons-outlined">dashboard</span>
            </a>
            <a class="p-3 bg-primary/20 text-primary rounded-lg" href="${pageContext.request.contextPath}/profiles">
                <span class="material-icons-outlined">school</span>
            </a>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="flex-1 flex flex-col overflow-hidden">
        <header class="flex items-center justify-between p-6 border-b border-slate-200 dark:border-slate-800 bg-background-light dark:bg-background-dark">
            <div>
                <h1 class="text-2xl font-bold text-slate-900 dark:text-white">Khám phá phương pháp học của bạn</h1>
                <p class="text-slate-500 dark:text-slate-400">Hãy trả lời các câu hỏi để chúng tôi hiểu rõ hơn về bạn!</p>
            </div>
            <div class="flex items-center space-x-4">
                <span class="text-slate-600 dark:text-slate-300">Xin chào, ${user.username}!</span>
                <a href="${pageContext.request.contextPath}/logout" class="p-2 text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-full">
                    <span class="material-icons-outlined">logout</span>
                </a>
            </div>
        </header>

        <div class="flex-1 overflow-y-auto p-8">
            <div class="max-w-4xl mx-auto">

                <!-- Error message -->
                <c:if test="${not empty error}">
                    <div class="mb-6 p-4 bg-red-100 border border-red-400 text-red-700 rounded-lg">
                        ${error}
                    </div>
                </c:if>

                <!-- Progress bar -->
                <div class="mb-8">
                    <div class="flex justify-between mb-1">
                        <span class="text-base font-medium text-primary dark:text-white">Tiến độ</span>
                        <span class="text-sm font-medium text-primary dark:text-white">Bước <span id="current-step">1</span>/3</span>
                    </div>
                    <div class="w-full bg-slate-200 dark:bg-slate-700 rounded-full h-2.5">
                        <div class="bg-primary h-2.5 rounded-full" id="progress-bar" style="width: 33%"></div>
                    </div>
                </div>

                <form id="learningStyleForm" action="${pageContext.request.contextPath}/learning-style-setup" method="post">

                    <!-- Question 1 -->
                    <div class="question-section active" id="question1">
                        <div class="bg-white dark:bg-slate-900 p-8 rounded-lg shadow-sm border border-slate-200 dark:border-slate-800">
                            <div class="text-center mb-8">
                                <p class="text-sm font-semibold text-primary uppercase tracking-wider mb-2">Câu hỏi 1</p>
                                <h2 class="text-2xl font-bold text-slate-900 dark:text-white">Khi học một chủ đề mới, bạn thích...</h2>
                            </div>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <label class="cursor-pointer">
                                    <input type="checkbox" name="study_visual" value="true" class="hidden">
                                    <div class="text-left p-4 rounded-lg bg-pastel-1 text-text-dark font-semibold hover:opacity-90 transition-all duration-200 option-btn">
                                        🎨 Xem hình ảnh, sơ đồ và video.
                                    </div>
                                </label>
                                <label class="cursor-pointer">
                                    <input type="checkbox" name="study_auditory" value="true" class="hidden">
                                    <div class="text-left p-4 rounded-lg bg-pastel-2 text-text-dark font-semibold hover:opacity-90 transition-all duration-200 option-btn">
                                        🎧 Nghe giảng, podcast hoặc thảo luận.
                                    </div>
                                </label>
                                <label class="cursor-pointer">
                                    <input type="checkbox" name="study_reading" value="true" class="hidden">
                                    <div class="text-left p-4 rounded-lg bg-pastel-3 text-text-dark font-semibold hover:opacity-90 transition-all duration-200 option-btn">
                                        📖 Đọc sách, tài liệu và ghi chú.
                                    </div>
                                </label>
                                <label class="cursor-pointer">
                                    <input type="checkbox" name="study_practice" value="true" class="hidden">
                                    <div class="text-left p-4 rounded-lg bg-pastel-4 text-text-dark font-semibold hover:opacity-90 transition-all duration-200 option-btn">
                                        🖐️ Tự mình thực hành, làm thử.
                                    </div>
                                </label>
                            </div>
                        </div>
                        <div class="flex justify-end mt-8">
                            <button type="button" class="px-8 py-3 bg-primary text-white font-bold rounded-lg shadow-sm hover:opacity-90 transition-opacity text-lg next-btn" data-next="2">
                                TIẾP THEO
                            </button>
                        </div>
                    </div>

                    <!-- Question 2 -->
                    <div class="question-section" id="question2">
                        <div class="bg-white dark:bg-slate-900 p-8 rounded-lg shadow-sm border border-slate-200 dark:border-slate-800">
                            <div class="text-center mb-8">
                                <p class="text-sm font-semibold text-primary uppercase tracking-wider mb-2">Câu hỏi 2</p>
                                <h2 class="text-2xl font-bold text-slate-900 dark:text-white">Bạn cảm thấy năng suất nhất khi nào?</h2>
                            </div>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <label class="cursor-pointer">
                                    <input type="radio" name="productive_time" value="morning" class="hidden" required>
                                    <div class="text-left p-4 rounded-lg bg-pastel-4 text-text-dark font-semibold hover:opacity-90 transition-all duration-200 option-btn">
                                        ☀️ Buổi sáng
                                    </div>
                                </label>
                                <label class="cursor-pointer">
                                    <input type="radio" name="productive_time" value="afternoon" class="hidden">
                                    <div class="text-left p-4 rounded-lg bg-pastel-1 text-text-dark font-semibold hover:opacity-90 transition-all duration-200 option-btn">
                                        🏙️ Buổi chiều
                                    </div>
                                </label>
                                <label class="cursor-pointer">
                                    <input type="radio" name="productive_time" value="evening" class="hidden">
                                    <div class="text-left p-4 rounded-lg bg-pastel-2 text-text-dark font-semibold hover:opacity-90 transition-all duration-200 option-btn">
                                        🌙 Buổi tối
                                    </div>
                                </label>
                                <label class="cursor-pointer">
                                    <input type="radio" name="productive_time" value="night" class="hidden">
                                    <div class="text-left p-4 rounded-lg bg-pastel-3 text-text-dark font-semibold hover:opacity-90 transition-all duration-200 option-btn">
                                        🌃 Đêm khuya
                                    </div>
                                </label>
                            </div>
                        </div>
                        <div class="flex justify-between mt-8">
                            <button type="button" class="px-8 py-3 bg-slate-300 text-slate-700 font-bold rounded-lg shadow-sm hover:opacity-90 transition-opacity text-lg prev-btn" data-prev="1">
                                QUAY LẠI
                            </button>
                            <button type="button" class="px-8 py-3 bg-primary text-white font-bold rounded-lg shadow-sm hover:opacity-90 transition-opacity text-lg next-btn" data-next="3">
                                TIẾP THEO
                            </button>
                        </div>
                    </div>

                    <!-- Question 3 -->
                    <div class="question-section" id="question3">
                        <div class="bg-white dark:bg-slate-900 p-8 rounded-lg shadow-sm border border-slate-200 dark:border-slate-800">
                            <div class="text-center mb-8">
                                <p class="text-sm font-semibold text-primary uppercase tracking-wider mb-2">Câu hỏi 3</p>
                                <h2 class="text-2xl font-bold text-slate-900 dark:text-white">Đánh giá mức độ yêu thích học nhóm của bạn?</h2>
                                <p class="text-slate-500 dark:text-slate-400 mt-1">(1 = Rất ghét, 5 = Rất thích)</p>
                            </div>
                            <div class="flex justify-center items-center space-x-2 md:space-x-4">
                                <c:forEach var="i" begin="1" end="5">
                                    <label class="cursor-pointer">
                                        <input type="radio" name="group_study_preference" value="${i}" class="hidden" required>
                                        <div class="w-12 h-12 md:w-16 md:h-16 flex items-center justify-center rounded-full bg-slate-200 text-text-dark text-xl font-bold hover:opacity-90 transition-all duration-200 option-btn">
                                            ${i}
                                        </div>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>
                        <div class="flex justify-between mt-8">
                            <button type="button" class="px-8 py-3 bg-slate-300 text-slate-700 font-bold rounded-lg shadow-sm hover:opacity-90 transition-opacity text-lg prev-btn" data-prev="2">
                                QUAY LẠI
                            </button>
                            <button type="submit" class="px-8 py-3 bg-primary text-white font-bold rounded-lg shadow-sm hover:opacity-90 transition-opacity text-lg">
                                HOÀN THÀNH
                            </button>
                        </div>
                    </div>

                </form>
            </div>
        </div>
    </main>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const nextButtons = document.querySelectorAll('.next-btn');
    const prevButtons = document.querySelectorAll('.prev-btn');
    const questionSections = document.querySelectorAll('.question-section');
    const progressBar = document.getElementById('progress-bar');
    const currentStep = document.getElementById('current-step');
    const optionButtons = document.querySelectorAll('.option-btn');

    // Chọn option
    optionButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            const input = this.previousElementSibling;
            if (input.type === 'checkbox') {
                input.checked = !input.checked;
                this.classList.toggle('selected', input.checked);
            } else if (input.type === 'radio') {
                const groupName = input.name;
                document.querySelectorAll(`input[name="${groupName}"]`).forEach(r => r.nextElementSibling.classList.remove('selected'));
                input.checked = true;
                this.classList.add('selected');
            }
        });
    });

    // Next
    nextButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            const current = this.closest('.question-section');
            const nextId = this.dataset.next;

            if (!validateCurrentQuestion(current)) return;

            current.classList.remove('active');
            document.getElementById('question' + nextId).classList.add('active');
            updateProgressBar(nextId);
        });
    });

    // Previous
    prevButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            const current = this.closest('.question-section');
            const prevId = this.dataset.prev;

            current.classList.remove('active');
            document.getElementById('question' + prevId).classList.add('active');
            updateProgressBar(prevId);
        });
    });

    // Validate question
    function validateCurrentQuestion(section) {
        const inputs = section.querySelectorAll('input');
        let valid = false;
        inputs.forEach(input => {
            if (input.checked) valid = true;
        });
        if (!valid) { alert('Vui lòng chọn một phương án trước khi tiếp tục!'); return false; }
        return true;
    }

    function updateProgressBar(step) {
        const percent = (step / 3) * 100;
        progressBar.style.width = percent + '%';
        currentStep.textContent = step;
    }
});
</script>
</body>
</html>
