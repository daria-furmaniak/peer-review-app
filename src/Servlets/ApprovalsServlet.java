package Servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.DateFormat;
import java.util.ArrayList;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import Models.Approval;
import Models.User;
import Repository.ApprovalsRepository;
import Repository.UserRepository;

@WebServlet("/approvals")
public class ApprovalsServlet extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) {
		String docIdParam = request.getParameter("docId");
		if (docIdParam == null) {
			response.setStatus(400);
			return;
		}
		
		try {
			int docId = Integer.parseInt(docIdParam);
			ArrayList<Approval> approvals = ApprovalsRepository.getApprovals(docId);
			PrintWriter out = response.getWriter();
			response.setContentType("application/json");
			Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm").create();
			String json = gson.toJson(approvals);
			out.println(json);
		} catch (SQLException | IOException e) {
			response.setStatus(500);
		}
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		String docIdParam = request.getParameter("docId");
		String userIdParam = request.getParameter("userId");
		if (docIdParam == null || userIdParam == null) {
			response.setStatus(400);
			return;
		}
		
		try {
			int docId = Integer.parseInt(docIdParam);
			int userId = Integer.parseInt(userIdParam);
			
			ApprovalsRepository.addApproval(docId, userId);
		} catch (SQLException e) {
			response.setStatus(500);
		}
	}
}
