<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" class="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Schedules - PlanZ</title>
    
    <!-- Tailwind CSS & Plugins -->
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <!-- Custom Config & Styles -->
    <script src="../js/tailwind-config.js"></script>
    <link rel="stylesheet" href="../css/pastel-overrides.css">
    <link rel="stylesheet" href="../css/schedule.css">
</head>
<body class="font-display bg-background-light text-slate-dark antialiased overflow-hidden">

    <div class="flex h-screen w-full">
        
        <!-- Left Sidebar Navigation -->
        <nav class="w-56 flex flex-col py-6 bg-white border-r border-slate-200">
            <div class="px-6 mb-8">
                <h1 class="text-xl font-bold text-primary">Scheduler</h1>
            </div>
            
            <div class="flex flex-col gap-1 px-3">
                <a href="../dashboard.jsp" class="flex items-center gap-3 px-4 py-3 rounded-xl text-slate-600 hover:bg-slate-100 transition-all">
                    <span class="material-symbols-outlined text-lg">dashboard</span>
                    Bảng điều khiển
                </a>
                <a href="schedule.jsp" class="flex items-center gap-3 px-4 py-3 rounded-xl bg-primary text-white font-semibold transition-all">
                    <span class="material-symbols-outlined text-lg">calendar_month</span>
                    Lịch của tôi
                </a>
                <a href="tasks.jsp" class="flex items-center gap-3 px-4 py-3 rounded-xl text-slate-600 hover:bg-slate-100 transition-all">
                    <span class="material-symbols-outlined text-lg">task_alt</span>
                    Nhiệm vụ
                </a>
                <a href="statistics.jsp" class="flex items-center gap-3 px-4 py-3 rounded-xl text-slate-600 hover:bg-slate-100 transition-all">
                    <span class="material-symbols-outlined text-lg">analytics</span>
                    Thống kê
                </a>
            </div>
        </nav>

        <!-- Main Content -->
        <main class="flex-1 flex flex-col min-w-0 bg-slate-50/50 h-full overflow-hidden relative">
            
            <!-- Header -->
            <header class="h-20 px-8 flex items-center justify-between bg-white/40 backdrop-blur-md border-b border-white/40 z-10">
                <h2 class="text-2xl font-bold text-slate-dark">All Schedules</h2>
                <div class="flex items-center gap-4">
                    <button class="w-10 h-10 rounded-full bg-white/50 flex items-center justify-center text-slate-400 hover:text-primary hover:bg-white transition-all shadow-sm">
                        <i class="fa-solid fa-cog"></i>
                    </button>
                    <a href="../login.jsp" class="w-10 h-10 rounded-full bg-white/50 flex items-center justify-center text-slate-400 hover:text-red-400 hover:bg-white transition-all shadow-sm" title="Logout">
                        <i class="fa-solid fa-arrow-right-from-bracket"></i>
                    </a>
                </div>
            </header>

            <!-- Schedule Grid -->
            <div class="flex-1 overflow-y-auto p-8">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 max-w-7xl mx-auto" id="scheduleListContainer">
                    
                    <!-- Create New Schedule Card -->
                    <a href="javascript:createNewSchedule()" class="schedule-card card-add-new bg-white/40 backdrop-blur-xl rounded-3xl p-8 shadow-sm flex flex-col items-center justify-center min-h-[250px] text-center group cursor-pointer">
                        <i class="fa-solid fa-plus-circle text-6xl text-primary/60 group-hover:text-primary transition-colors mb-4"></i>
                        <span class="text-lg font-bold text-slate-600 group-hover:text-primary transition-colors">Create New Schedule</span>
                        <p class="text-sm text-slate-400 mt-2">Start planning your semester</p>
                    </a>

                    <!-- Schedule cards will be dynamically added here -->

                </div>
            </div>
        </main>
    </div>

    <!-- Rename Modal -->
    <div id="renameModal" class="modal-overlay hidden">
        <div class="modal-container">
            <div class="modal-header">
                <h3 class="modal-title">Đổi tên lịch học</h3>
                <button onclick="closeRenameModal()" class="modal-close">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>
            <div class="modal-body">
                <label for="renameInput" class="modal-label">Tên lịch học</label>
                <input type="text" id="renameInput" class="modal-input" placeholder="Nhập tên mới...">
            </div>
            <div class="modal-footer">
                <button onclick="closeRenameModal()" class="modal-btn modal-btn-cancel">Hủy</button>
                <button onclick="confirmRename()" class="modal-btn modal-btn-primary">Lưu</button>
            </div>
        </div>
    </div>

    <script src="../js/schedule.js"></script>

</body>
</html>
