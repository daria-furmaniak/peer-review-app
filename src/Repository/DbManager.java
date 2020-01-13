package Repository;

import java.sql.Connection;
import java.sql.DriverManager;

public class DbManager {
	
	private static Connection _connection;
	public static Connection getConnection() {
		try {
			if (_connection == null) {
				Class.forName("com.mysql.jdbc.Driver");
				String url = "jdbc:mysql://localhost:3306/peer_review";
				_connection = DriverManager.getConnection(url, "root", "admin");
			}
			return _connection;
		} catch (Exception ex) {
			return null;
		}
	}
}
