package Servlets;

import java.sql.SQLException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Repository.DocumentsRepository;

@WebServlet("/documents/send")
public class DocumentApprovalServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		String idParam = request.getParameter("id");
		if (idParam == null) {
			response.setStatus(400);
			return;
		}
		
		int id = Integer.parseInt(idParam);
		try {
			DocumentsRepository.updateDocument(id, "sent");
		} catch (SQLException e) {
			e.printStackTrace();
			response.setStatus(500);
		}
	}
}
