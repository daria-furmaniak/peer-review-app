package Repository;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import Models.Document;
import Models.User;

public class DocumentsRepository {
	
	public static ArrayList<Document> getDocuments(int userId) throws SQLException {
		ArrayList<Document> list = new ArrayList<Document>();
		
		User user = UserRepository.getUser(userId);
		if (user == null) {
			return list;
		}
		String sql = "";
		if (user.Role.equals("editor")) {
			sql = "select * from documents where author_id = ?";
		} else if (user.Role.equals("reviewer")) {
			sql = "select d.* from approvals a, documents d " + 
					"where d.id = a.document_id and a.user_id = ?";
		}
		PreparedStatement statement = DbManager.getConnection().prepareStatement(sql);
		statement.setInt(1, userId);
		ResultSet result = statement.executeQuery();
		while (result.next()) {
			list.add(mapResult(result));
		}
		statement.close();
		
		return list;
	}
	
	public static Document getDocument(int id) throws SQLException {
		String sql = "select * from documents where id = ?";
		PreparedStatement statement = DbManager.getConnection().prepareStatement(sql);
		statement.setInt(1, id);
		ResultSet result = statement.executeQuery();
		if (!result.next()) {
			return null;
		}
		return mapResult(result);
	}
	
	public static int saveDocument(Document doc) throws SQLException {
		boolean isNew = doc.Id == null;
		if (isNew) {
			String sql = "insert into documents (author_id, title, content, status) values (?, ?, ?, 'editing')";
			PreparedStatement statement = DbManager.getConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			statement.setInt(1, doc.AuthorId);
			statement.setString(2, doc.Title);
			statement.setString(3, doc.Content);
			
			int affectedRows = statement.executeUpdate();
			if (affectedRows == 0) {
				throw new SQLException("Creating a document failed, no rows affected.");
			}
			
			try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
				if (generatedKeys.next()) {
					return generatedKeys.getInt(1);
				}
				throw new SQLException("Creating a document failed, no Id obtained.");
			}
		} else {
			String sql = "update documents set title = ?, content = ? where id = ?";
			PreparedStatement statement = DbManager.getConnection().prepareStatement(sql);
			statement.setString(1, doc.Title);
			statement.setString(2, doc.Content);
			statement.setInt(3, doc.Id);
			statement.execute();
			return doc.Id;
		}
		
	}
	
	public static void updateDocument(int id, String status) throws SQLException {
		String sql = "update documents set status = ? where id = ?";
		PreparedStatement statement = DbManager.getConnection().prepareStatement(sql);
		statement.setString(1, status);
		statement.setInt(2, id);
		statement.execute();
	}
	
	public static void deleteDocument(int id) throws SQLException {
		String sql = "delete from documents where id = ?";
		PreparedStatement statement = DbManager.getConnection().prepareStatement(sql);
		statement.setInt(1, id);
		statement.execute();
	}
	
	private static Document mapResult(ResultSet result) throws SQLException {
		Document doc = new Document();
		doc.Id = result.getInt("id");
		doc.Title = result.getString("title");
		doc.Content = result.getString("content");
		doc.Status = result.getString("status");
		return doc;
	}
}
