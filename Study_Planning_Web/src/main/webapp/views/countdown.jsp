<%@ page contentType="text/html;charset=UTF-8" %>
<%
    int mins = Integer.parseInt(request.getParameter("mins"));
    int totalSeconds = mins * 60;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Study Timer</title>

    <style>
        body {
            font-family: Arial;
            background: linear-gradient(#a5d6a7, #66bb6a);
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-top: 40px;
            color: white;
        }

        #timer {
            font-size: 70px;
            font-weight: bold;
            margin: 20px;
        }

        .btn {
            margin: 10px;
            padding: 12px 25px;
            background: #2e7d32;
            border: none;
            color: white;
            font-size: 20px;
            border-radius: 8px;
            cursor: pointer;
        }

        .btn:hover {
            background: #1b5e20;
        }

        #tree {
            width: 200px;
            transition: transform 1s linear;
            margin-top: 30px;
        }
    </style>
</head>
<body>

<h2>🌱 Đang học trong <%= mins %> phút</h2>

<div id="timer"></div>

<button class="btn" onclick="pauseTimer()">⏸ Tạm dừng</button>
<button class="btn" onclick="resumeTimer()">▶ Tiếp tục</button>
<button class="btn" onclick="resetTimer()">🔄 Reset</button>

<!-- Cây forest -->
<img id="tree" src="assets/tree.png">

<!-- Âm thanh báo hết giờ -->
<audio id="alarm">
    <source src="assets/timesup.mp3" type="audio/mpeg">
</audio>

<script>
    let total = <%= totalSeconds %>;
    let timeLeft = total;
    let running = true;
    let timerInterval;

    function updateTimer() {
        let mins = Math.floor(timeLeft / 60);
        let secs = timeLeft % 60;
        if (secs < 10) secs = "0" + secs;
        if (mins < 10) mins = "0" + mins;

        document.getElementById("timer").textContent = mins + ":" + secs;

        // animation cây lớn dần
        let grow = 1 + ((total - timeLeft) / total);
        document.getElementById("tree").style.transform = "scale(" + grow + ")";

        if (timeLeft <= 0) {
            clearInterval(timerInterval);
            document.getElementById("alarm").play();
            alert("🎉 Bạn đã hoàn thành thời gian học!");

            // gửi kết quả lên server để lưu vào DB
            fetch("StudySessionServlet", {
                method: "POST",
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify({
                    minutes: <%= mins %>,
                    finished: true
                })
            });

            return;
        }

        timeLeft--;
    }

    function startTimer() {
        timerInterval = setInterval(updateTimer, 1000);
    }

    function pauseTimer() {
        if (running) {
            clearInterval(timerInterval);
            running = false;
        }
    }

    function resumeTimer() {
        if (!running) {
            startTimer();
            running = true;
        }
    }

    function resetTimer() {
        timeLeft = total;
        document.getElementById("tree").style.transform = "scale(1)";
        pauseTimer();
        updateTimer();
    }

    startTimer();
</script>

</body>
</html>
