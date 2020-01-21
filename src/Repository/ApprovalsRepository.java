package Repository;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;

import com.sun.corba.se.spi.orbutil.fsm.Guard.Result;

import Models.Approval;

public class ApprovalsRepository {
	
	public static void addApproval(int documentId, int userId) throws SQLException {
		String sql = "insert into approvals (document_id, user_id) values(?, ?)";
		PreparedStatement statement = DbManager.getConnection().prepareStatement(sql);
		statement.setInt(1, documentId);
		statement.setInt(2, userId);
		statement.execute();
	}
	
	public static void saveApproval(int documentId, int userId, boolean approve) throws SQLException {
		String sql = "update approvals set approved = ?, timestamp = now() where document_id = ? and user_id = ?";
		PreparedStatement statement = DbManager.getConnection().prepareStatement(sql);
		statement.setBoolean(1, approve);
		statement.setInt(2, documentId);
		statement.setInt(3, userId);
		statement.execute();
	}
	
	public static ArrayList<Approval> getApprovals(int documentId) throws SQLException {
		String sql = "select * from approvals where document_id = ?";
		PreparedStatement statement = DbManager.getConnection().prepareStatement(sql);
		statement.setInt(1, documentId);
		ResultSet result = statement.executeQuery();
		ArrayList<Approval> list = new ArrayList<Approval>();
		while (result.next()) {
			list.add(mapResult(result));
		}
		return list;
	}

	private static Approval mapResult(ResultSet result) throws SQLException {
		Approval approval = new Approval();
		approval.User = UserRepository.getUser(result.getInt("user_id"));
		approval.Approved = result.getBoolean("approved");
		Timestamp tstmp = result.getTimestamp("timestamp");
		if (tstmp != null) {
			approval.Timestamp = new Date(tstmp.getTime());			
		}
		return approval;
	}
}
