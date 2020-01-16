package Repository;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import com.sun.corba.se.spi.orbutil.fsm.Guard.Result;

import Models.Approval;

public class ApprovalsRepository {
	
	public static void saveApproval(int documentId, int userId, boolean approve) throws SQLException {
		String sql = "update approvals set approved = ?, timestamp = now() where document_id = ? and user_id = ?";
		PreparedStatement statement = DbManager.getConnection().prepareStatement(sql);
		statement.setBoolean(1, approve);
		statement.setInt(2, documentId);
		statement.setInt(3, userId);
		statement.execute();
	}

}
