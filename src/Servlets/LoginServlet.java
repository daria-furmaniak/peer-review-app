package Servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import Models.User;
import Repository.UserRepository;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		if (username == null || password == null) {
			response.setStatus(400);
			return;
		}
		
		try {
			User user = UserRepository.getUser(username);
			if (user == null) {
				response.setStatus(404);
				return;
			}
			if (user.Password.equals(password)) {
				PrintWriter out = response.getWriter();
				response.setContentType("application/json");
				Gson gson = new Gson();
				user.Password = null;
				String json = gson.toJson(user);
				out.println(json);
			} else {
				response.setStatus(400);
			}
		} catch (SQLException | IOException e) {
			
		}
	}
}
