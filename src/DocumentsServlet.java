import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

@WebServlet("/documents")
public class DocumentsServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		
		String docIdParam = request.getParameter("docId");
		if (docIdParam == null) {
			response.setContentType("text/html");
			ArrayList<Document> documents = DocumentsRepository.GetDocuments();
			for (Document doc : documents) {
	        	out.println("<div class=\"item\" onclick=\"loadArticle(" + doc.Id + ")\">");
	        	out.println("<i class=\"file primary alternate big icon\"></i>");
				out.println(doc.Title);
				out.println("<div class=\"ui primary horizontal label\">editing</div>");
				out.println("</div>");
			}
		} else {
			int docId = Integer.parseInt(docIdParam);
			try {
				Document doc = DocumentsRepository.GetDocument(docId);
				Gson gson = new Gson();
				String json = gson.toJson(doc);
				out.println(json);
			} catch (ClassNotFoundException | SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		Document doc = new Document();
		doc.Title = request.getParameter("title");
		doc.Content = request.getParameter("content");
		
		try {
			DocumentsRepository.SaveDocument(doc);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
