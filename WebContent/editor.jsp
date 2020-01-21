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
	    	height: calc(100vh - 49px);
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
        .ml-1 {
        	margin-left: 1rem !important;
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
			<div class="four wide column">
				<div class="ui segments">
					<div class="ui secondary segment"><h4>Articles</h4></div>
					<div class="ui segment p-0">
						<div id="article-list" class="ui divided selection list"></div>
					</div>						
				</div>
			</div>
			<div class="eight wide column">
				<div class="ui segments">
					<div class="ui secondary segment"><h4>Review article</h4></div>
					<div class="ui segment">
			        	<form class="ui form" id="article-form" action="/documents" method="post">
			        		<input type="hidden" id="article-id">
			        		<div class="field">
			                    <label>Title</label>
			                    <input type="text" name="article-title" id="article-title" placeholder="Article title" disabled>
			                </div>
			                <div class="field">
			                	<label>Author</label>
			                	<input type="text" name="article-author" id="article-author" placeholder="Article author" disabled>
			                </div>
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
	        <div class="four wide column">
	        	<div class="ui segments">
	        		<div class="ui secondary segment"><h4>Approvals</h4></div>
	        		<div class="ui segment p-0">
	        			<div id="approval-list" class="ui divided selection list">
	        				<div class="item">
	        					<div class="ui fluid selection disabled dropdown" id="approval-dropdown">
	        						<div class="text"></div>
	        						<i class="dropdown icon"></i>
						        </div>
						        <a class="ui primary tiny disabled button ml-1" id="approval-dropdown-add" onclick="addReviewer()">Add</a>
	        				</div>
	        			</div>
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
    		if (user.Role !== "editor") {
    			window.location.href = user.Role + ".jsp";
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
    				$("#article-author").val(article.Author.FirstName + " " + article.Author.LastName);
    				$("#article-content").val(article.Content);
    				switchButtons(article.Status);
    				if (!["approved", "rejected"].includes(article.Status)) {
    					loadReviewers();
    				} else {
    					$("#approval-dropdown").addClass("disabled");
        				$("#approval-dropdown-add").addClass("disabled");
    				}
    				loadApprovals(id);
    			}
    		});
    	}
    	function loadApprovals(docId) {
    		$.ajax({
    			type: "GET",
    			url: "/DemoApp/approvals?docId=" + docId,
    			success: function(approvals) {
   					$(".approval.item").remove();
   					if (approvals.length >= 3) {
   						$("#approval-dropdown").addClass("disabled");
   	    				$("#approval-dropdown-add").addClass("disabled");
   					}
  						for (var a of approvals) {
  	    					const status = !a.Timestamp ? "pending" : a.Approved ? "approved" : "rejected";
  	    					const color = status === "approved" ? "green" : status === "rejected" ? "red" : "purple";
  	    					$("#approval-list").append("<div class=\"item approval\"><i class=\"user " + color + " circle outline big icon\"></i>" +
  	    							a.User.FirstName + " " + a.User.LastName +
  	    							"<div class=\"ui horizontal " + color + " label\">" + status + "</div></div>");	
  	    				}
    			}
    		})
    	}
    	function loadReviewers() {
    		$.ajax({
    			type: "GET",
    			url: "/DemoApp/users?role=reviewer",
    			success: function(users) {
    				const u = users.map(x => ({ name: x.FirstName + " " + x.LastName, value: x.Id }));
    				$("#approval-dropdown").dropdown({
    					values: u
    				});
    				$("#approval-dropdown").removeClass("disabled");
    				$("#approval-dropdown-add").removeClass("disabled");
    			}
    		})
    	}
    	function addReviewer() {
    		const docId = $("#article-id").val();
    		const userId = $("#approval-dropdown").dropdown("get value");
    		$.ajax({
    			type: "POST",
    			url: "/DemoApp/approvals?docId=" + docId + "&userId=" + userId,
    			success: function() {
    				loadApprovals(docId);
    			}
    		});
    	}
    	function switchButtons(status) {
    	}
    </script>
</body>
</html>