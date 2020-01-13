package Repository;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import Models.User;

public class UserRepository {
	
	public static User getUser(String username) throws SQLException {
		String sql = "select * from users where username = ?";
		PreparedStatement statement = DbManager.getConnection().prepareStatement(sql);
		statement.setString(1, username);
		ResultSet result = statement.executeQuery();
		if (!result.next()) {
			return null;
		}
		User user = new User();
		user.Id = result.getInt("id");
		user.Password = result.getString("password");
		user.Username = result.getString("username");
		user.FirstName = result.getString("first_name");
		user.LastName = result.getString("last_name");
		return user;
	}
	

}
