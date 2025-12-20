<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Chọn thời gian học</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        primary: "#A5B4FC",
                        "background-light": "#F8FAFC",
                        "background-dark": "#0B1120",
                        "surface-light": "#FFFFFF",
                        "surface-dark": "#1E293B",
                        "text-light": "#1E293B",
                        "text-dark": "#E2E8F0",
                        "subtle-light": "#64748B",
                        "subtle-dark": "#94A3B8",
                        "accent-pink": "#F9A8D4",
                        "accent-yellow": "#FDE68A",
                        "primary-light": "#C7D2FE",
                        "primary-dark": "#5C6BC0",
                    },
                    fontFamily: {
                        display: ["Be Vietnam Pro", "sans-serif"],
                    },
                    borderRadius: {
                        DEFAULT: "0.75rem",
                    },
                },
            },
        };
    </script>
    <style>
        .material-symbols-outlined {
            font-variation-settings:
                'FILL' 0,
                'wght' 400,
                'GRAD' 0,
                'opsz' 24
        }
        body {
            font-family: 'Be Vietnam Pro', sans-serif;
        }
    </style>
</head>
<body class="bg-background-light dark:bg-background-dark min-h-screen">
<div class="flex min-h-screen w-full" style="max-width: 1280px; margin: auto;">
    <aside class="flex w-20 flex-col items-center space-y-6 bg-surface-light dark:bg-surface-dark p-4 border-r border-slate-200 dark:border-slate-700">
        <div class="flex h-12 w-12 items-center justify-center rounded-full bg-primary text-white">
            <span class="material-symbols-outlined text-3xl">hourglass_top</span>
        </div>
        <nav class="flex flex-col items-center space-y-4">
            <a class="p-3 rounded-xl bg-primary-light dark:bg-primary-dark text-primary dark:text-white" href="#">
                <span class="material-symbols-outlined">dashboard</span>
            </a>
            <a class="p-3 rounded-xl text-subtle-light dark:text-subtle-dark hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors" href="#">
                <span class="material-symbols-outlined">calendar_month</span>
            </a>
            <a class="p-3 rounded-xl text-subtle-light dark:text-subtle-dark hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors" href="#">
                <span class="material-symbols-outlined">timer</span>
            </a>
            <a class="p-3 rounded-xl text-subtle-light dark:text-subtle-dark hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors" href="#">
                <span class="material-symbols-outlined">bar_chart</span>
            </a>
        </nav>
        <div class="mt-auto p-3 rounded-xl text-subtle-light dark:text-subtle-dark hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors">
            <a href="#"><span class="material-symbols-outlined">account_circle</span></a>
        </div>
    </aside>
    
    <div class="flex flex-1 flex-col">
        <header class="flex h-16 items-center justify-between border-b border-slate-200 dark:border-slate-700 bg-surface-light dark:bg-surface-dark px-8">
            <h1 class="text-xl font-bold text-text-light dark:text-text-dark">Work Timer</h1>
            <div class="flex items-center space-x-4">
                <button class="p-2 rounded-full hover:bg-slate-100 dark:hover:bg-slate-700 text-subtle-light dark:text-subtle-dark transition-colors">
                    <span class="material-symbols-outlined">settings</span>
                </button>
                <button class="p-2 rounded-full hover:bg-slate-100 dark:hover:bg-slate-700 text-subtle-light dark:text-subtle-dark transition-colors">
                    <span class="material-symbols-outlined">arrow_forward</span>
                </button>
            </div>
        </header>
        
        <main class="flex flex-1 flex-col items-center justify-center p-8 space-y-10">
            <div class="text-center mb-8">
                <h2 class="text-3xl font-bold text-text-light dark:text-text-dark mb-4">🌳 Hãy chọn thời gian học</h2>
                <p class="text-subtle-light dark:text-subtle-dark">Chọn một trong các tùy chọn dưới đây để bắt đầu phiên học tập</p>
            </div>
            
            <form action="countdown.jsp" class="w-full max-w-2xl">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <button name="mins" value="30" 
                        class="flex flex-col items-center justify-center rounded-xl bg-surface-light dark:bg-surface-dark p-6 shadow-lg border border-slate-200 dark:border-slate-700 hover:border-primary transition-all hover:scale-105 hover:shadow-xl">
                        <span class="text-4xl font-bold text-primary mb-2">30</span>
                        <span class="text-lg font-semibold text-text-light dark:text-text-dark">phút</span>
                        <span class="text-sm text-subtle-light dark:text-subtle-dark mt-2">Phiên học ngắn</span>
                    </button>
                    
                    <button name="mins" value="60" 
                        class="flex flex-col items-center justify-center rounded-xl bg-surface-light dark:bg-surface-dark p-6 shadow-lg border border-slate-200 dark:border-slate-700 hover:border-primary transition-all hover:scale-105 hover:shadow-xl">
                        <span class="text-4xl font-bold text-primary mb-2">60</span>
                        <span class="text-lg font-semibold text-text-light dark:text-text-dark">phút</span>
                        <span class="text-sm text-subtle-light dark:text-subtle-dark mt-2">1 giờ</span>
                    </button>
                    
                    <button name="mins" value="90" 
                        class="flex flex-col items-center justify-center rounded-xl bg-surface-light dark:bg-surface-dark p-6 shadow-lg border border-slate-200 dark:border-slate-700 hover:border-primary transition-all hover:scale-105 hover:shadow-xl">
                        <span class="text-4xl font-bold text-primary mb-2">90</span>
                        <span class="text-lg font-semibold text-text-light dark:text-text-dark">phút</span>
                        <span class="text-sm text-subtle-light dark:text-subtle-dark mt-2">1 giờ 30 phút</span>
                    </button>
                    
                    <button name="mins" value="120" 
                        class="flex flex-col items-center justify-center rounded-xl bg-surface-light dark:bg-surface-dark p-6 shadow-lg border border-slate-200 dark:border-slate-700 hover:border-primary transition-all hover:scale-105 hover:shadow-xl">
                        <span class="text-4xl font-bold text-primary mb-2">120</span>
                        <span class="text-lg font-semibold text-text-light dark:text-text-dark">phút</span>
                        <span class="text-sm text-subtle-light dark:text-subtle-dark mt-2">2 giờ</span>
                    </button>
                    
                    <button name="mins" value="150" 
                        class="flex flex-col items-center justify-center rounded-xl bg-surface-light dark:bg-surface-dark p-6 shadow-lg border border-slate-200 dark:border-slate-700 hover:border-primary transition-all hover:scale-105 hover:shadow-xl">
                        <span class="text-4xl font-bold text-primary mb-2">150</span>
                        <span class="text-lg font-semibold text-text-light dark:text-text-dark">phút</span>
                        <span class="text-sm text-subtle-light dark:text-subtle-dark mt-2">2 giờ 30 phút</span>
                    </button>
                    
                    <button name="mins" value="custom" 
                        class="flex flex-col items-center justify-center rounded-xl bg-primary/10 dark:bg-primary/20 p-6 shadow-lg border-2 border-dashed border-primary hover:bg-primary/20 transition-all hover:scale-105 hover:shadow-xl">
                        <span class="material-symbols-outlined text-4xl text-primary mb-2">add</span>
                        <span class="text-lg font-semibold text-text-light dark:text-text-dark">Tùy chỉnh</span>
                        <span class="text-sm text-subtle-light dark:text-subtle-dark mt-2">Thời gian riêng</span>
                    </button>
                </div>
            </form>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 w-full max-w-2xl pt-6">
                <div class="flex items-start space-x-4 rounded-lg bg-accent-yellow/20 dark:bg-accent-yellow/10 p-4 border border-accent-yellow/50 dark:border-accent-yellow/30">
                    <span class="material-symbols-outlined mt-1 text-yellow-600 dark:text-accent-yellow">lightbulb</span>
                    <div>
                        <h3 class="font-semibold text-yellow-800 dark:text-yellow-200">Mẹo học tập</h3>
                        <p class="text-sm text-yellow-700 dark:text-yellow-300">Chọn thời gian phù hợp với khả năng tập trung của bạn!</p>
                    </div>
                </div>
                <div class="flex items-start space-x-4 rounded-lg bg-accent-pink/20 dark:bg-accent-pink/10 p-4 border border-accent-pink/50 dark:border-accent-pink/30">
                    <span class="material-symbols-outlined mt-1 text-pink-600 dark:text-accent-pink">timer</span>
                    <div>
                        <h3 class="font-semibold text-pink-800 dark:text-pink-200">Nhắc nhở</h3>
                        <p class="text-sm text-pink-700 dark:text-pink-300">Đừng quên nghỉ giải lao sau mỗi 25-30 phút học tập.</p>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>