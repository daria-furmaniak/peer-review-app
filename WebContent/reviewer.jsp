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
					<div class="ui secondary segment"><h4>Review article</h4></div>
					<div class="ui segment">
			        	<form class="ui form" id="article-form" action="/documents" method="post">
			        		<input type="hidden" id="article-id">
			        		<div class="field">
			                    <label>Title</label>
			                    <input type="text" name="article-title" id="article-title" placeholder="Article title" disabled></div>
			                <div class="field">
			                    <label>Content</label>
			                    <textarea rows="10" name="article-content" id="article-content" disabled></textarea>
			                </div>
			                <a id="article-reject" class="ui red button disabled">Reject</a>
			                <a id="article-approve" class="ui blue button disabled float-right">Approve</a>
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
    		if (user.Role !== "reviewer") {
    			window.location.href = "user.jsp";
    		}
    		
    		function loadArticles(onSuccess = null) {
	    		$("#article-list").load("/DemoApp/documents?user_id=" + user.Id, onSuccess);
    		}
    		
    		loadArticles();
    		$("#article-reject").click(function() {
    			var docId = $("#article-id").val();
    			$.ajax({
    				type: "POST",
    				url: "/DemoApp/documents/review",
    				data: "doc_id=" + docId + "&user_id=" + user.Id + "&action=reject",
    				success: function() {
    					loadArticles(function() {
    						switchButtons("rejected");
    						$(".item.active").removeClass("active");
    			    		$("#article-" + docId).addClass("active");
    					});
    				}
    			});
    		});
			$("#article-approve").click(function() {
				var docId = $("#article-id").val();
    			$.ajax({
    				type: "POST",
    				url: "/DemoApp/documents/review",
    				data: "doc_id=" + docId + "&user_id=" + user.Id + "&action=approve",
    				success: function() {
    					loadArticles(function() {
    						switchButtons("approved");
    						$(".item.active").removeClass("active");
    			    		$("#article-" + docId).addClass("active");
    					});
    				}
    			});
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
    		if (status === "sent") {
    			$("#article-reject").removeClass("disabled");
				$("#article-approve").removeClass("disabled");
    		} else {
    			$("#article-reject").addClass("disabled");
				$("#article-approve").addClass("disabled");
    		}
    	}
    </script>
</body>
</html>
