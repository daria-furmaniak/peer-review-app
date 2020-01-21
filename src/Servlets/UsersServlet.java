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

import Models.User;
import Repository.UserRepository;

@WebServlet("/users")
public class UsersServlet extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) {
		String roleName = request.getParameter("role");
		try {
			ArrayList<User> users = UserRepository.getUsers(roleName);
			PrintWriter out = response.getWriter();
			response.setContentType("application/json");
			Gson gson = new Gson();
			String json = gson.toJson(users);
			out.println(json);
		} catch (SQLException | IOException e) {
			response.setStatus(500);
		}
	}
}
