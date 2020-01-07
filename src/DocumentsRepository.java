import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class DocumentsRepository {
	
	public static ArrayList<Document> GetDocuments() {
		ArrayList<Document> list = new ArrayList<Document>();
		
		String sql = "select * from documents";
		Statement statement;
		try {
			statement = DbManager.getConnection().createStatement();
			ResultSet result = statement.executeQuery(sql);
			while (result.next()) {
				Document doc = new Document();
				doc.Id = (int) result.getObject("id");
				doc.Title = (String) result.getObject("title");
				doc.Content = (String) result.getObject("content");
				list.add(doc);
			}
			statement.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
	public static Document GetDocument(int id) throws ClassNotFoundException, SQLException {
		String sql = "select * from documents where id = ?";
		PreparedStatement statement = DbManager.getConnection().prepareStatement(sql);
		statement.setInt(1, id);
		ResultSet result = statement.executeQuery();
		result.next();
		Document doc = new Document();
		doc.Id = (int) result.getObject("id");
		doc.Title = (String) result.getObject("title");
		doc.Content = (String) result.getObject("content");
		return doc;
	}
	
	public static void SaveDocument(Document doc) throws ClassNotFoundException, SQLException {
		String sql = "insert into documents (author_id, title, content) values (1, ?, ?)";
		PreparedStatement statement = DbManager.getConnection().prepareStatement(sql);
		statement.setString(1, doc.Title);
		statement.setString(2, doc.Content);
		statement.execute();
	}
}
