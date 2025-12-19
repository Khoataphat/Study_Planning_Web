<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chọn thời gian học</title>
    <style>
        body {
            font-family: Arial;
            background: #e8f5e9;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-top: 50px;
        }
        .btn {
            background: #4CAF50;
            border: none;
            padding: 15px 25px;
            margin: 10px;
            font-size: 20px;
            color: white;
            border-radius: 10px;
            cursor: pointer;
        }
        .btn:hover {
            background: #43a047;
        }
    </style>
</head>

<body>
<h2>🌳 Hãy chọn thời gian học</h2>

<form action="countdown.jsp">
    <button class="btn" name="mins" value="30">30 phút</button>
    <button class="btn" name="mins" value="60">1 giờ</button>
    <button class="btn" name="mins" value="90">1 giờ 30 phút</button>
    <button class="btn" name="mins" value="120">2 giờ</button>
    <button class="btn" name="mins" value="150">2 giờ 30 phút</button>
</form>

</body>
</html>
