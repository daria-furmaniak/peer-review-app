<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>Article Peer Review</title>
    <link rel="stylesheet" type="text/css" href="https://unpkg.com/fomantic-ui@2.8.2/dist/semantic.min.css">
    <style>
	    .ui.grid {
	    	margin: 0 !important;
	    }
	    .ui.top.menu {
	    	padding-left: 0;
	    }
	    .ui.top.menu i {
	    	font-size: 1.5rem;
	    }
	    .ui.bottom.attached.segment {
	    	height: calc(100vh - 50px);
	    	margin-bottom: 0;
	    }
        .selection.list > .item {
            display: flex;
            align-items: center;
            justify-content: space-around;
        }
        .selection.list > .empty.item {
        	display: block;
        }
        .selection.list > .item i {
            transition: unset !important;
        }
        .selection.list > .item .ui.horizontal.label {
            margin-left: auto;
        }
        .float-right {
        	float: right;
        }
        .p-0 {
        	padding: 0 !important;
        }
    </style>
</head>

<body>
	<div class="ui top attached menu">
		<div class="ui item">
			<i class="file alternate outline icon"></i>
			<span>Document Review System</span>
		</div>
		<div class="ui item">
			<button id="article-add" class="ui primary button">New article</button>
		</div>
		<div class="right menu">
			<a class="ui item" id="logout">Logout</a>
		</div>
	</div>
	<div class="ui bottom attached segment">
		<div class="ui grid">
			<div class="five wide column">
				<div class="ui segments">
					<div class="ui secondary segment"><h4>Articles</h4></div>
					<div class="ui segment p-0">
						<div id="article-list" class="ui divided selection list"></div>
					</div>						
				</div>
			</div>
			<div class="eleven wide column">
				<div class="ui segments">
					<div class="ui secondary segment"><h4>Edit article</h4></div>
					<div class="ui segment">
			        	<form class="ui form" id="article-form" action="/documents" method="post">
			        		<input type="hidden" id="article-id">
			        		<div class="field">
			                    <label>Title</label>
			                    <input type="text" name="article-title" id="article-title" placeholder="Article title"></div>
			                <div class="field">
			                    <label>Content</label>
			                    <textarea rows="10" name="article-content" id="article-content"></textarea>
			                </div>
			                <a id="article-delete" class="ui red button disabled">Delete</a>
			                <button id="article-submit" class="ui blue button float-right" type="submit">Save</button>
			                <a id="article-send" class="ui teal button disabled float-right">Send for approval</a>
			        	</form>
	        		</div>
				</div>
	        </div>
	    </div>
	</div>

	<script src="https://unpkg.com/jquery@3.3.1/dist/jquery.js"></script>
    <script src="https://unpkg.com/fomantic-ui@2.8.2/dist/semantic.min.js"></script>
    <script>
    	$(document).ready(function() {
    		var user = JSON.parse(localStorage.getItem("user"));
    		if (!user) {
    			window.location.href = "index.jsp?error=notLoggedIn";
    		}
    		
    		if (user.Role !== "user") {
    			window.location.href = user.Role + ".jsp";
    		}
    		
    		function loadArticles(onSuccess = null) {
	    		$("#article-list").load("/DemoApp/documents?user_id=" + user.Id, onSuccess);
    		}
    		
    		loadArticles();
    		$("#article-form").submit(function(e) {
    			e.preventDefault();
    			var id = $("#article-id").val();
    			var title = $("#article-title").val();
    			var content = $("#article-content").val();
    			var dataString = 'title=' + title + '&content=' + content + '&author_id=' + user.Id;
    			if (id) {
    				dataString += '&id=' + id;
    			}
    			$.ajax({
    				type: "POST",
    				url: "/DemoApp/documents",
    				data: dataString,
    				success: function(obtainedId) {
    					$("#article-id").val(obtainedId);
    					loadArticles(function() {
	 	   					$(".item.active").removeClass("active");
	    		    		$("#article-" + obtainedId).addClass("active");
	    		    		switchButtons("editing");
    					});
    				}
    			});
    		});
    		$("#article-add").click(function() {
    			$("#article-id").val(null);
				$("#article-title").val(null);
				$("#article-content").val(null);
				switchButtons("new");
				$(".item.active").removeClass("active");
    		});
    		$("#article-delete").click(function() {
    			$.ajax({
    				type: "DELETE",
    				url: "/DemoApp/documents?id=" + $("#article-id").val(),
    				success: function() {
    					loadArticles();
    					$("#article-id").val(null);
    					$("#article-title").val(null);
    					$("#article-content").val(null);
    					switchButtons("new");
    				}
    			})
    		});
    		$("#article-send").click(function(e) {
    			var docId = $("#article-id").val();
    			$.ajax({
    				type: "POST",
    				url: "/DemoApp/documents/send?id=" + docId,
    				success: function() {
    					loadArticles(function() {
    						$(".item.active").removeClass("active");
    			    		$("#article-" + docId).addClass("active");
    					});
    					switchButtons("pending");
    				}
    			})
    		});
    		$("#logout").click(function(e) {
    			localStorage.removeItem("user");
    			window.location.href = "index.jsp?error=loggedOut";
    		});
    	});
    	
    	function loadArticle(id) {
    		$(".item.active").removeClass("active");
    		$("#article-" + id).addClass("active");
    		$.ajax({
    			type: "GET",
    			url: "/DemoApp/documents?docId=" + id,
    			success: function(article) {
    				$("#article-id").val(article.Id);
    				$("#article-title").val(article.Title);
    				$("#article-content").val(article.Content);
    				switchButtons(article.Status);
    			}
    		})
    	}
    	function switchButtons(status) {
    		switch (status) {
    			case "new":
    				$("#article-delete").addClass("disabled");
    				$("#article-send").addClass("disabled");
    				$("#article-submit").removeClass("disabled");
    				break;
    			case "editing":
    				$("#article-delete").removeClass("disabled");
    				$("#article-send").removeClass("disabled");
    				$("#article-submit").removeClass("disabled");
    				break;
    			case "pending":
    				$("#article-delete").addClass("disabled");
    				$("#article-send").addClass("disabled");
    				$("#article-submit").addClass("disabled");
    				break;
    			case "approved":
    				$("#article-delete").addClass("disabled");
    				$("#article-send").addClass("disabled");
    				$("#article-submit").addClass("disabled");
    				break;
    			case "rejected":
    				$("#article-delete").addClass("disabled");
    				$("#article-send").removeClass("disabled");
    				$("#article-submit").removeClass("disabled");
    				break;
    		}
    	}
    </script>
</body>
</html>
