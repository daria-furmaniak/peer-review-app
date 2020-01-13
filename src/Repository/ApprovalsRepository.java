package Repository;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import Models.Approval;

public class ApprovalsRepository {
	
	public static ArrayList<Approval> GetApprovals(int documentId) throws SQLException {
		ArrayList<Approval> list = new ArrayList<Approval>();
		
		String sql = "select * from approvals where document_id = ?";
		PreparedStatement statement = DbManager.getConnection().prepareStatement(sql);
		ResultSet result;
		try {
			result = statement.executeQuery();
			while (result.next()) {
				Approval approval = new Approval();
				approval.Approved = result.getBoolean("approved");
				approval.Timestamp = result.getDate("timestamp");
				list.add(approval);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

}
