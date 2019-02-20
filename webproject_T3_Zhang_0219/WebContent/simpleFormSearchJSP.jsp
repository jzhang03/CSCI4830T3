<%@ page language="java" import="java.sql.*"
	contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Simple DB Connection</title>
</head>
<body>
	<h1 align="center"> Database Result (JSP) </h1>
	<%!String keyword;%>
	<%keyword = request.getParameter("keyword");%>
	<%=runMySQL()%>

	<%!String runMySQL() throws SQLException {
		System.out.println("[DBG] User entered keyword: " + keyword);
		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			System.out.println("Where is your MySQL JDBC Driver?");
			e.printStackTrace();
			return null;
		}

		System.out.println("MySQL JDBC Driver Registered!");
		Connection connection = null;

		try {
			connection = DriverManager.getConnection("jdbc:mysql://"
			   		+ "ec2-18-223-0-133.us-east-2.compute.amazonaws.com"
			   		+ ":3306/myDB", "ZhangMySQL", "CSCI4830SE0219");
		} catch (SQLException e) {
			System.out.println("Connection Failed! Check output console");
			e.printStackTrace();
			return null;
		}

		if (connection != null) {
			System.out.println("You made it, take control your database now!");
		} else {
			System.out.println("Failed to make connection!");
		}

		PreparedStatement query = null;
		StringBuilder sb = new StringBuilder();

		try {
			connection.setAutoCommit(false);

			if (keyword.isEmpty()) {
				String selectSQL = "SELECT * FROM MYSQL_DBTABLE_Zhang";
				query = connection.prepareStatement(selectSQL);
			} else {
				String selectSQL = "SELECT * FROM MYSQL_DBTABLE_Zhang WHERE MYUSER LIKE ?";
				String theUserName = keyword + "%";
				query = connection.prepareStatement(selectSQL);
				query.setString(1, theUserName);
			}
			
			//String qSql = "SELECT * FROM myTable";
			//query = connection.prepareStatement(qSql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			ResultSet rs = query.executeQuery();
			while (rs.next()) {
				int id = rs.getInt("id");
				String userName = rs.getString("myuser").trim();
				String email = rs.getString("email").trim();
				String phone = rs.getString("phone").trim();

				// Display values to console.
				System.out.println("ID: " + id + ", ");
				System.out.println("User: " + userName + ", ");
				System.out.println("Email: " + email + ", ");
				System.out.println("Phone: " + phone + "<br>");
				// Display values to webpage.
				sb.append("ID: " + id + ", ");
				sb.append("User: " + userName + ", ");
				sb.append("Email: " + email + ", ");
				sb.append("Phone: " + phone + "<br>");
			}
			connection.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sb.toString();
	}%>

	<a href=/webproject/simpleFormSearchJSP.html>Search Data</a> <br>
</body>
</html>