package Repository;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import Models.User;

public class UserRepository {
	
	public static ArrayList<User> getUsers(String roleName) throws SQLException {
		String sql = "select users.id, username, password, first_name, last_name, roles.name role_name " + 
				"from users, roles " + 
				"where users.role_id = roles.id ";
		if (roleName != null) {
			sql += "and roles.name = ?";
		}
		
		PreparedStatement statement = DbManager.getConnection().prepareStatement(sql);
		if (roleName != null) {
			statement.setString(1, roleName);
		}
		
		ArrayList<User> list = new ArrayList<User>();
		ResultSet result = statement.executeQuery();
		while (result.next()) {
			list.add(mapResult(result));
		}
		statement.close();
		
		return list;
	}
	
	public static User getUser(int id) throws SQLException {
		String sql = "select users.id, username, password, first_name, last_name, roles.name role_name " + 
				"from users, roles " + 
				"where users.role_id = roles.id " + 
				"and users.id = ?";
		PreparedStatement statement = DbManager.getConnection().prepareStatement(sql);
		statement.setInt(1, id);
		return getUser(statement);
	}
	
	public static User getUser(String username) throws SQLException {
		String sql = "select users.id, username, password, first_name, last_name, roles.name role_name " + 
				"from users, roles " + 
				"where users.role_id = roles.id " + 
				"and users.username = ?";
		PreparedStatement statement = DbManager.getConnection().prepareStatement(sql);
		statement.setString(1, username);
		return getUser(statement);
	}
	
	private static User getUser(PreparedStatement statement) throws SQLException {
		ResultSet result = statement.executeQuery();
		if (!result.next()) {
			return null;
		}
		return mapResult(result);
	}
	
	private static User mapResult(ResultSet result) throws SQLException {
		User user = new User();
		user.Id = result.getInt("id");
		user.Password = result.getString("password");
		user.Username = result.getString("username");
		user.FirstName = result.getString("first_name");
		user.LastName = result.getString("last_name");
		user.Role = result.getString("role_name");
		return user;
	}
}
