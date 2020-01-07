import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbManager {
	
	private static Connection _connection;
	public static Connection getConnection() throws ClassNotFoundException, SQLException {
		if (_connection == null) {
			Class.forName("com.mysql.jdbc.Driver");
			String url = "jdbc:mysql://localhost:3306/peer_review";
			_connection = DriverManager.getConnection(url, "root", "admin");
		}
		return _connection;
	}
}
