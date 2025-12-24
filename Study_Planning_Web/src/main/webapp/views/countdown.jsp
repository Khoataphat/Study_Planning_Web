<%@ page contentType="text/html;charset=UTF-8" %>
<%
    int mins = Integer.parseInt(request.getParameter("mins"));
    int totalSeconds = mins * 60;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Study Timer</title>

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
        "primary-light": "#C7D2FE",
        "primary-dark": "#5C6BC0",
      },
      fontFamily: {
        display: ["Be Vietnam Pro", "sans-serif"],
      }
    }
  }
}
</script>

<style>
body { font-family: 'Be Vietnam Pro', sans-serif; }
</style>
</head>

<body class="bg-background-light text-text-light">

<div class="flex h-screen w-full max-w-[1280px] max-h-[800px] mx-auto">

    <!-- SIDEBAR -->
    <aside class="flex w-20 flex-col items-center space-y-6 bg-surface-light p-4 border-r">
        <div class="flex h-12 w-12 items-center justify-center rounded-full bg-primary text-white">
            <span class="material-symbols-outlined text-3xl">hourglass_top</span>
        </div>
        <nav class="flex flex-col items-center space-y-4">
            <span class="p-3 rounded-xl bg-primary-light text-primary">
                <span class="material-symbols-outlined">timer</span>
            </span>
        </nav>
    </aside>

    <!-- MAIN -->
    <div class="flex flex-1 flex-col">

        <!-- HEADER -->
        <header class="flex h-16 items-center justify-between border-b bg-surface-light px-8">
            <h1 class="text-xl font-bold">Study Timer</h1>
        </header>

        <!-- CONTENT -->
        <main class="flex flex-1 flex-col items-center justify-center p-8 space-y-10">

            <!-- TIMER CIRCLE -->
            <div class="relative flex h-64 w-64 items-center justify-center rounded-full bg-surface-light shadow-lg border-8 border-primary-light">
                <span id="timer" class="font-display text-6xl font-bold tracking-tighter">
                    00:00
                </span>
            </div>

            <!-- BUTTONS -->
            <div class="flex space-x-4">
                <button onclick="pauseTimer()"
                        class="rounded-full bg-yellow-400 px-6 py-3 font-semibold text-white shadow hover:scale-105">
                    ⏸ Tạm dừng
                </button>

                <button onclick="resumeTimer()"
                        class="rounded-full bg-green-500 px-6 py-3 font-semibold text-white shadow hover:scale-105">
                    ▶ Tiếp tục
                </button>

                <button onclick="resetTimer()"
                        class="rounded-full bg-blue-500 px-6 py-3 font-semibold text-white shadow hover:scale-105">
                    🔄 Reset
                </button>
            </div>

            <!-- INFO -->
            <div class="text-subtle-light text-sm">
                Thời gian học: <b><%= mins %> phút</b>
            </div>

        </main>
    </div>
</div>

<audio id="alarm">
    <source src="assets/timesup.mp3" type="audio/mpeg"/>
</audio>

<script>
let total = <%= totalSeconds %>;
let timeLeft = total;
let running = true;
let interval;

function render() {
    let m = Math.floor(timeLeft / 60);
    let s = timeLeft % 60;
    if (s < 10) s = "0" + s;
    if (m < 10) m = "0" + m;
    document.getElementById("timer").textContent = m + ":" + s;
}

function tick() {
    if (!running) return;

    render();

    if (timeLeft <= 0) {
        clearInterval(interval);
        document.getElementById("alarm").play();
        alert("🎉 Hoàn thành phiên học!");
        return;
    }
    timeLeft--;
}

function start() {
    interval = setInterval(tick, 1000);
}

function pauseTimer() {
    running = false;
}

function resumeTimer() {
    running = true;
}

function resetTimer() {
    timeLeft = total;
    running = true;
    render();
}

render();
start();
</script>

</body>
</html>

