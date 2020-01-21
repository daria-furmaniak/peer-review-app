package Servlets;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Models.Approval;
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
			if (!approve) {
				DocumentsRepository.updateDocument(documentId, "rejected");
			} else {
				ArrayList<Approval> approvals = ApprovalsRepository.getApprovals(documentId);
				if (approvals.size() == 3 && everyApprovalPositive(approvals)) {
					DocumentsRepository.updateDocument(documentId, "approved");
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			response.setStatus(500);
		}
	}
	
	private boolean everyApprovalPositive(ArrayList<Approval> list) {
		for (Approval a : list) {
			if (!a.Approved) {
				return false;
			}
		}
		return true;
	}
}
