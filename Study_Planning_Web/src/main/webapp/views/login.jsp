<%-- 
    Document   : login
    Created on : 21 thg 11, 2025, 14:16:35
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Glass Layout Login</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <link rel="stylesheet" href="/resources/css/style.css"> 

</head>
<body class="page-login">

    <div class="background-anim">
        <div class="shape"></div>
        <div class="shape"></div>
        <div class="shape"></div>
    </div>

    <header class="glass-style">
        <div class="logo">MY BRAND</div>
        <nav>
            <ul>
                <li><a href="#">Home</a></li>
                <li><a href="#">About</a></li>
                <li><a href="#">Contact</a></li>
            </ul>
        </nav>
    </header>

    <main>
        <div class="left-section glass-style">
            <div class="image-placeholder">
                <i class="fa-solid fa-rocket"></i> 
                <h2>Welcome to Future</h2>
                <p>Experience the next generation platform with unique design.</p>
            </div>
        </div>

        <div class="right-section">
            <div class="login-card glass-style" id="loginCard">
                
                <div class="form-content form-login">
                    <h2 class="form-title">Login</h2>
                    <div class="social-login">
                        <a href="#"><i class="fa-brands fa-google"></i></a>
                        <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                    </div>
                    <p class="sub-title">or use your username account</p>
                    <form id="signinForm" action="/login" method="post">
                        <div class="input-box">
                            <label>Username</label>
                            <input name="username" type="text" placeholder="Enter your username" required>
                        </div>
                        <div class="input-box">
                            <label>Password</label>
                            <input name="password" type="password" placeholder="Enter your password" required>
                        </div>
                        <button type="submit" class="btn-submit">SIGN IN</button>
                        <p class="toggle-text">
                            Don't have an account? <span id="goto-register">Sign Up</span>
                        </p>
                    </form>
                    <div style="margin-top: 20px; font-size: 12px; opacity: 0.7;">
                        <a href="#" style="color: white; text-decoration: none;">Forgot Password?</a>
                    </div>
                </div>
                <!-- comment 
                <div class="form-content form-register">
                    <h2 class="form-title">Register</h2>
                    <div class="social-login">
                        <a href="#"><i class="fa-brands fa-google"></i></a>
                        <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                    </div>
                    <p class="sub-title">Create a new account</p>
                    <form id="signupForm">
                        <div class="input-box">
                            <label>Username</label>
                            <input type="text" placeholder="Choose a username" required>
                        </div>
                        <div class="input-box">
                            <label>Email</label>
                            <input type="email" placeholder="Enter your email" required>
                        </div>
                        <div class="input-box">
                            <label>Password</label>
                            <input type="password" placeholder="Create a password" required>
                        </div>
                        <button class="btn-submit">SIGN UP</button>
                        <p class="toggle-text">
                            Already have an account? <span id="goto-login">Sign In</span>
                        </p>
                    </form>
                </div>
                 -->
            </div>
        </div>
    </main>

    <footer class="glass-style">
        <p>&copy; 2024 Website Name. All rights reserved.</p>
    </footer>
<!-- comment 
    <script>
        const loginCard = document.getElementById('loginCard');
        const gotoRegister = document.getElementById('goto-register');
        const gotoLogin = document.getElementById('goto-login');
        const signinForm = document.getElementById('signinForm');
        const signupForm = document.getElementById('signupForm');

        // Chuyển qua form đăng ký
        gotoRegister.addEventListener('click', () => {
            loginCard.classList.add('active');
        });

        // Chuyển về form đăng nhập
        gotoLogin.addEventListener('click', () => {
            loginCard.classList.remove('active');
        });

        // Redirect -> ĐÂY LÀ PHẦN QUAN TRỌNG
        // Nó sẽ chuyển hướng đến home.html sau khi submit
        signinForm.addEventListener('submit', (e) => {
            e.preventDefault();
            window.location.href = "";
        });

        signupForm.addEventListener('submit', (e) => {
            e.preventDefault();
            alert("Registration successful!");
            window.location.href = "";
        });
    </script>
-->
</body>
</html>


<!--<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <form action="login" method="post">
            <input type="text" name="username" placeholder="Username" required /><br>
            <input type="password" name="password" placeholder="Password" required /><br>
            <button type="submit">Login</button>
        </form>

        <p style="color:red;">${error}</p>
    </body>
</html>
-->