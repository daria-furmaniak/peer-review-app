package Repository;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import Models.Document;

public class DocumentsRepository {
	
	public static ArrayList<Document> getDocuments() throws SQLException {
		ArrayList<Document> list = new ArrayList<Document>();
		
		String sql = "select * from documents";
		Statement statement = DbManager.getConnection().createStatement();
		ResultSet result = statement.executeQuery(sql);
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
	
	public static void saveDocument(Document doc) throws SQLException {
		boolean isNew = doc.Id == null;
		if (isNew) {
			String sql = "insert into documents (author_id, title, content) values (1, ?, ?)";
			PreparedStatement statement = DbManager.getConnection().prepareStatement(sql);
			statement.setString(1, doc.Title);
			statement.setString(2, doc.Content);
			statement.execute();
		} else {
			String sql = "update documents set title = ?, content = ? where id = ?";
			PreparedStatement statement = DbManager.getConnection().prepareStatement(sql);
			statement.setString(1, doc.Title);
			statement.setString(2, doc.Content);
			statement.setInt(3, doc.Id);
			statement.execute();
		}
		
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
		return doc;
	}
}
