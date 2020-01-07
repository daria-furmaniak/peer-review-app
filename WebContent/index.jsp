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
			</div>
		</div>
		<div class="eight wide column">
			<div class="ui segment">
	        	<form class="ui form" id="article-form" action="/documents" method="post">
	        		<div class="field">
	                    <label>Title</label>
	                    <input type="text" name="article-title" id="article-title" placeholder="Article title"></div>
	                <div class="field">
	                    <label>Content</label>
	                    <textarea rows="10" name="article-content" id="article-content"></textarea>
	                </div>
	                <button class="ui button" type="submit">Send</button>
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
    			e.preventDefault();
    			var title = $("#article-title").val();
    			var content = $("#article-content").val();
    			var dataString = 'title=' + title + '&content=' + content;
    			$.ajax({
    				type: "POST",
    				url: "/DemoApp/documents",
    				data: dataString,
    				success: function() {
    					$("#article-list").load("/DemoApp/documents");
    				}
    			});
    		});
    	});
    	
    	function loadArticle(id) {
    		$.ajax({
    			type: "GET",
    			url: "/DemoApp/documents?docId=" + id,
    			success: function(data) {
    				var article = JSON.parse(data);
    				$("#article-title").val(article.Title);
    				$("#article-content").val(article.Content);
    			}
    		})
    	}
    </script>
</body>
</html>