package Servlets;

import java.sql.SQLException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Repository.ApprovalsRepository;
import Repository.DocumentsRepository;

@WebServlet("/documents/review")
public class ReviewServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		String documentIdParam = request.getParameter("doc_id");
		String userIdParam = request.getParameter("user_id");
		String action = request.getParameter("action");
		
		if (documentIdParam == null || userIdParam == null || action == null) {
			response.setStatus(400);
			return;
		}
		
		int documentId = Integer.parseInt(documentIdParam);
		int userId = Integer.parseInt(userIdParam);
		boolean approve = action.equals("approve");
		try {
			ApprovalsRepository.saveApproval(documentId, userId, approve);
			DocumentsRepository.updateDocument(documentId, approve ? "approved" : "rejected");
		} catch (SQLException e) {
			e.printStackTrace();
			response.setStatus(500);
		}
	}
}
