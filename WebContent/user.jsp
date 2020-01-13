<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>Article Peer Review</title>
    <link rel="stylesheet" type="text/css" href="https://unpkg.com/fomantic-ui@2.8.2/dist/semantic.min.css">
    <style>
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
    </style>
</head>

<body>
	<div class="ui grid"> 
		<div class="three wide column"></div>
		<div class="five wide column">
			<div class="ui segment">
				<div id="article-list" class="ui divided selection list">
					
				</div>
				<button id="article-add" class="ui primary button">Add article</button>
			</div>
		</div>
		<div class="eight wide column">
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
	                <button id="article-submit" class="ui button" type="submit">Save</button>
	                <button id="article-delete" class="ui red button disabled">Delete</button>
	        	</form>
        	</div>
        </div>
	</div>

	<script src="https://unpkg.com/jquery@3.3.1/dist/jquery.js"></script>
    <script src="https://unpkg.com/fomantic-ui@2.8.2/dist/semantic.min.js"></script>
    <script>
    	$(document).ready(function() {
    		$("#article-list").load("/DemoApp/documents");
    		$("#article-form").submit(function(e) {
    			var submitButton = $("#article-submit");
    			submitButton.addClass("loading")
    			e.preventDefault();
    			var id = $("#article-id").val();
    			var title = $("#article-title").val();
    			var content = $("#article-content").val();
    			var dataString = 'title=' + title + '&content=' + content;
    			if (id) {
    				dataString += '&id=' + id;
    			}
    			$.ajax({
    				type: "POST",
    				url: "/DemoApp/documents",
    				data: dataString,
    				success: function() {
    					$("#article-list").load("/DemoApp/documents");
    					submitButton.removeClass("loading");
    				}
    			});
    		});
    		$("#article-add").click(function() {
    			$("#article-id").val(null);
				$("#article-title").val(null);
				$("#article-content").val(null);
				$("#article-delete").addClass("disabled");
    		});
    		$("#article-delete").click(function(e) {
    			e.preventDefault();
    			$.ajax({
    				type: "DELETE",
    				url: "/DemoApp/documents?id=" + $("#article-id").val(),
    				success: function() {
    					$("#article-list").load("/DemoApp/documents");
    					$("#article-id").val(null);
    					$("#article-title").val(null);
    					$("#article-content").val(null);
    				}
    			})
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
    				$("#article-delete").removeClass("disabled");
    			}
    		})
    	}
    </script>
</body>
</html>