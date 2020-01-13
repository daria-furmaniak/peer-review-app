<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>Article peer review - login</title>
    <link rel="stylesheet" type="text/css" href="https://unpkg.com/fomantic-ui@2.8.2/dist/semantic.min.css">
    <style>
        .login-container {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 60%;
        }
        .login-container > .ui.segment {
            width: 500px !important;
        }
    </style>
</head>

<body>
    <div class="container login-container">
        <div class="ui raised container segment">
            <h2 class="ui header">
                <i class="file alternate outline icon"></i>
						<div class="content">Log in
						<div class="sub header">Documents Review System</div>
						</div>
               </h2>
            <form class="ui form" id="login-form">
                <div class="field">
                    <label>Username</label>
                    <input type="text" name="username" id="username" placeholder="Username" required>
                </div>
                <div class="field">
                    <label>Password</label>
                    <input type="password" name="password" id="password" placeholder="Password" required>
                </div>
                <button class="ui button" type="submit">Log in</button>
            </form>
            <div class="ui message">New to us? <a href="#">Register</a></div>
        </div>
    </div>
   
    <script src="https://unpkg.com/jquery@3.3.1/dist/jquery.js"></script>
    <script src="https://unpkg.com/fomantic-ui@2.8.2/dist/semantic.min.js"></script>
    <script>
    $(document).ready(function() {
    	$("#login-form").submit(function(e) {
    		e.preventDefault();
    		$.ajax({
    			type: "POST",
    			url: "/DemoApp/login?username=" + $("#username").val() + "&password=" + $("#password").val(),
    			success: function(data) {
    				console.log(data);
    			}
    		});
    	});
    });
    </script>
</body>

</html>
