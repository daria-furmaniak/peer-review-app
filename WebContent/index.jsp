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
        .d-none {
        	display: none;
        }
    </style>
</head>

<body>
    <div class="container login-container">
        <div class="ui raised container segment">
            <h2 class="ui header">
                <i class="file alternate outline icon"></i>
				<div class="content">
					<span>Log in</span>
					<div class="sub header">Document Review System</div>
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
            <div class="ui message d-none" id="error-message">Please log in.</div>
        </div>
    </div>
   
    <script src="https://unpkg.com/jquery@3.3.1/dist/jquery.js"></script>
    <script src="https://unpkg.com/fomantic-ui@2.8.2/dist/semantic.min.js"></script>
    <script>
    $(document).ready(function() {
    	var urlParams = new URLSearchParams(window.location.search);
    	if (urlParams.has("error")) {
    		var error = urlParams.get("error");
    		printMessage(error);
    	}
    	$("#login-form").submit(function(e) {
    		e.preventDefault();
    		$.ajax({
    			type: "POST",
    			url: "/DemoApp/login?username=" + $("#username").val() + "&password=" + $("#password").val(),
    			success: function(data) {
    				localStorage.setItem("user", JSON.stringify(data));
    				if (data.Role === "editor") {
	    				window.location.href = "user.jsp";					
    				} else {
    					window.location.href = "reviewer.jsp";
    				}
    			},
    			error: function(xhr) {
    				if ([400, 404].includes(xhr.status)) {
    					printMessage("wrongCredentials");
    				} else {
    					printMessage("unknown");
    				}
    			}
    		});
    	});
    });
    
    function printMessage(message) {
    	var messageText;
    	var messageType = "error";
    	switch (message) {
			case "loggedOut":
				messageType = "success";
				messageText = "You've been logged out successfully.";
				break;
			case "notLoggedIn":
				messageText = "You are not logged in.";
				break;
			case "wrongCredentials":
				messageText = "Your username and/or password are incorrect.";
				break;
			case "unknown":
				messageText = "An unknown error has occured.";
				break;
			}
    	var messageDiv = $("#error-message");
    	messageDiv.removeClass("error success d-none");
    	messageDiv.addClass(messageType);
		messageDiv.html(messageText);
    }
    </script>
</body>

</html>
