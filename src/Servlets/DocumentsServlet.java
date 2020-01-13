package Servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import Models.Document;
import Repository.DocumentsRepository;

@WebServlet("/documents")
public class DocumentsServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String docIdParam = request.getParameter("docId");
		if (docIdParam == null) {
			printAllDocuments(response);
		} else {
			int docId = Integer.parseInt(docIdParam);
			printDocument(docId, response);
		}
	}
	
	private void printAllDocuments(HttpServletResponse response) throws IOException {
		PrintWriter out = response.getWriter();
		try {
			response.setContentType("text/html");
			ArrayList<Document> documents = DocumentsRepository.getDocuments();
			for (Document doc : documents) {
	        	out.println("<div class=\"item\" id=\"article-" + doc.Id + "\" onclick=\"loadArticle(" + doc.Id + ")\">");
	        	out.println("<i class=\"file primary alternate big icon\"></i>");
				out.println(doc.Title);
				out.println("<div class=\"ui primary horizontal label\">editing</div>");
				out.println("</div>");
			}
		} catch (SQLException ex) {
			out.println("Could not connect to the database.");
		}
	}
	
	private void printDocument(int docId, HttpServletResponse response) throws IOException {
		PrintWriter out = response.getWriter();
		try {
			response.setContentType("application/json");
			Document doc = DocumentsRepository.getDocument(docId);
			Gson gson = new Gson();
			String json = gson.toJson(doc);
			out.println(json);
		} catch (SQLException ex) {
			out.println("Could not connect to the database.");
		}
		
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		Document doc = new Document();
		String idParam = request.getParameter("id");
		if (idParam != null) {
			doc.Id = Integer.parseInt(idParam);			
		}
		doc.Title = request.getParameter("title");
		doc.Content = request.getParameter("content");
		
		try {
			DocumentsRepository.saveDocument(doc);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	protected void doDelete(HttpServletRequest request, HttpServletResponse response) {
		String idParam = request.getParameter("id");
		if (idParam == null) {
			return;
		}
		
		try {
			DocumentsRepository.deleteDocument(Integer.parseInt(idParam));
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}
