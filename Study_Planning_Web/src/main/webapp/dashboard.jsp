<!DOCTYPE html>
<html lang="en" class="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - PlanZ</title>
    
    <!-- Tailwind CSS & Plugins -->
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <!-- Custom Config & Styles -->
    <script src="js/tailwind-config.js"></script>
    <link rel="stylesheet" href="css/pastel-overrides.css">
</head>
<body class="font-display bg-background-light text-slate-dark antialiased overflow-hidden">

    <div class="flex h-screen w-full bg-pattern">
        
        <!-- Sidebar -->
        <nav class="w-64 flex flex-col py-6 bg-white/60 backdrop-blur-xl border-r border-white/40 shadow-sm z-20">
            <div class="px-8 mb-8 flex items-center gap-3">
                <span class="material-symbols-outlined text-primary text-3xl">stacks</span>
                <span class="text-xl font-bold text-slate-dark">PlanZ</span>
            </div>

            <div class="flex flex-col items-center mb-8">
                <div class="w-20 h-20 rounded-full bg-gradient-to-tr from-pinky to-primary p-1 shadow-lg">
                    <div class="w-full h-full rounded-full bg-white flex items-center justify-center text-3xl text-slate-400">
                        <i class="fa-solid fa-user"></i>
                    </div>
                </div>
                <h3 class="mt-3 font-bold text-slate-dark">Student Name</h3>
                <p class="text-xs text-slate-400">Premium Member</p>
            </div>
            
            <div class="flex flex-col gap-2 w-full px-4">
                <a href="dashboard.jsp" class="flex items-center gap-4 px-6 py-3 rounded-2xl bg-primary/10 text-primary font-bold transition-all">
                    <span class="material-symbols-outlined">dashboard</span>
                    Dashboard
                </a>
                <a href="user/schedule.jsp" class="flex items-center gap-4 px-6 py-3 rounded-2xl text-slate-500 hover:text-primary hover:bg-white/50 transition-all font-medium">
                    <span class="material-symbols-outlined">calendar_month</span>
                    My Schedule
                </a>
                <a href="user/tasks.jsp" class="flex items-center gap-4 px-6 py-3 rounded-2xl text-slate-500 hover:text-primary hover:bg-white/50 transition-all font-medium">
                    <span class="material-symbols-outlined">check_circle</span>
                    Tasks
                </a>
                <a href="#" class="flex items-center gap-4 px-6 py-3 rounded-2xl text-slate-500 hover:text-primary hover:bg-white/50 transition-all font-medium">
                    <span class="material-symbols-outlined">pie_chart</span>
                    Analytics
                </a>
                <a href="#" class="flex items-center gap-4 px-6 py-3 rounded-2xl text-slate-500 hover:text-primary hover:bg-white/50 transition-all font-medium">
                    <span class="material-symbols-outlined">smart_toy</span>
                    AI Suggest
                </a>
            </div>
        </nav>

        <!-- Main Content -->
        <main class="flex-1 flex flex-col h-full overflow-hidden relative">
            
            <!-- Header -->
            <header class="h-20 px-8 flex items-center justify-end bg-white/40 backdrop-blur-md border-b border-white/40 z-10 gap-4">
                <button class="w-10 h-10 rounded-full bg-white/50 flex items-center justify-center text-slate-400 hover:text-primary hover:bg-white transition-all shadow-sm">
                    <i class="fa-solid fa-cog"></i>
                </button>
                <a href="login.jsp" class="w-10 h-10 rounded-full bg-white/50 flex items-center justify-center text-slate-400 hover:text-red-400 hover:bg-white transition-all shadow-sm" title="Logout">
                    <i class="fa-solid fa-arrow-right-from-bracket"></i>
                </a>
            </header>

            <!-- Dashboard Grid -->
            <div class="flex-1 overflow-y-auto p-8">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 max-w-6xl mx-auto">
                    
                    <!-- Widget 1: Line Chart -->
                    <div class="bg-white/60 backdrop-blur-xl rounded-3xl p-6 shadow-sm border border-white/50 min-h-[300px] flex flex-col">
                        <h3 class="text-lg font-bold text-slate-dark mb-4 border-b border-slate-100 pb-2">Progress Analytics</h3>
                        <div class="flex-1 flex items-center justify-center text-slate-300 bg-slate-50/50 rounded-2xl">
                            <!-- Placeholder for Chart -->
                            <span class="material-symbols-outlined text-6xl opacity-20">show_chart</span>
                        </div>
                    </div>

                    <!-- Widget 2: Bar Chart -->
                    <div class="bg-white/60 backdrop-blur-xl rounded-3xl p-6 shadow-sm border border-white/50 min-h-[300px] flex flex-col">
                        <h3 class="text-lg font-bold text-slate-dark mb-4 border-b border-slate-100 pb-2">Task Summary</h3>
                        <div class="flex-1 flex items-center justify-center text-slate-300 bg-slate-50/50 rounded-2xl">
                            <!-- Placeholder for Chart -->
                            <span class="material-symbols-outlined text-6xl opacity-20">bar_chart</span>
                        </div>
                    </div>

                    <!-- Widget 3: Calendar Grid -->
                    <div class="bg-white/60 backdrop-blur-xl rounded-3xl p-6 shadow-sm border border-white/50 min-h-[300px] flex flex-col">
                        <h3 class="text-lg font-bold text-slate-dark mb-4 border-b border-slate-100 pb-2">My Schedule</h3>
                        <div class="flex-1 overflow-hidden rounded-2xl border border-slate-100">
                            <table class="w-full h-full border-collapse">
                                <thead class="bg-slate-50">
                                    <tr>
                                        <th class="p-2 text-xs font-bold text-slate-400 border-b border-r border-slate-100">Mon</th>
                                        <th class="p-2 text-xs font-bold text-slate-400 border-b border-r border-slate-100">Tue</th>
                                        <th class="p-2 text-xs font-bold text-slate-400 border-b border-r border-slate-100">Wed</th>
                                        <th class="p-2 text-xs font-bold text-slate-400 border-b border-r border-slate-100">Thu</th>
                                        <th class="p-2 text-xs font-bold text-slate-400 border-b border-slate-100">Fri</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="border-r border-b border-slate-100 h-12"></td>
                                        <td class="border-r border-b border-slate-100 h-12"></td>
                                        <td class="border-r border-b border-slate-100 h-12"></td>
                                        <td class="border-r border-b border-slate-100 h-12"></td>
                                        <td class="border-b border-slate-100 h-12"></td>
                                    </tr>
                                    <tr>
                                        <td class="border-r border-b border-slate-100 h-12"></td>
                                        <td class="border-r border-b border-slate-100 h-12"></td>
                                        <td class="border-r border-b border-slate-100 h-12"></td>
                                        <td class="border-r border-b border-slate-100 h-12"></td>
                                        <td class="border-b border-slate-100 h-12"></td>
                                    </tr>
                                    <tr>
                                        <td class="border-r border-slate-100 h-12"></td>
                                        <td class="border-r border-slate-100 h-12"></td>
                                        <td class="border-r border-slate-100 h-12"></td>
                                        <td class="border-r border-slate-100 h-12"></td>
                                        <td class="h-12"></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Widget 4: Pie Chart -->
                    <div class="bg-white/60 backdrop-blur-xl rounded-3xl p-6 shadow-sm border border-white/50 min-h-[300px] flex flex-col">
                        <h3 class="text-lg font-bold text-slate-dark mb-4 border-b border-slate-100 pb-2">Categories</h3>
                        <div class="flex-1 flex items-center justify-center text-slate-300 bg-slate-50/50 rounded-2xl">
                            <!-- Placeholder for Chart -->
                            <span class="material-symbols-outlined text-6xl opacity-20">pie_chart</span>
                        </div>
                    </div>

                </div>
            </div>
        </main>
    </div>

</body>
</html>