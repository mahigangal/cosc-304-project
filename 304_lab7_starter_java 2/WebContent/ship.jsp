<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Kenzo Coffer's Grocery store</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
// TODO: Get order id
String OID = request.getParameter("orderId"); 
String sql = "select customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password from customer WHERE userid = ?";
 String url = "jdbc:sqlserver://cosc304_sqlserver:1433;database=orders;TrustServerCertificate=True";
 String uid = "sa";
 String pw = "304#sa#pw";
// TODO: Check if valid order id
if(OID == null|| OID.equals(""))
	out.println("<h1>Invalid order id.</h1>");
else{
	String sql3 = "SELECT orderId, productId, quantity, price FROM orderproduct WHERE orderId = ?";
	con = DriverManager.getConnection(url, uid, pw);
	PreparedStatement pstmt = con.prepareStatement(sql3);
	pstmt.setInt(1, Integer.parseInt(OID));
	ResultSet rst = pstmt.executeQuery();
	int orderId = 0; 
	String custName = "";

	if(!rst.next()){
		out.println("<h1>Invalid order id or no items in order</h1>");
	}
	else{
		try(Connection con = DriverManager.getConnection(url, uid, pw);
		Statement stmt = con.createStatement();){
			// TODO: Start a transaction (turn-off auto-commit)
			con.setAutoCommit(false);
			//enter shipment info into database
			sql = "INSERT INTO shipment (shipmentDate, warehouseId) VALUES (?,1);"; 
			pstmt = con.prepareStatement(sql);
			pstmt.setTimestamp(1,new java.sql.Timestamp(new Date().getTime()));
			pstmt.executeUpdate();
		
			// TODO: Retrieve all items in order with given id
			// TODO: Create a new shipment record.
			// TODO: For each item verify sufficient quantity available in warehouse 1.
			// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.


			String sql2 = "SELECT quantity FROM productinventory WHERE warehouseId = 1 and productId = ?";
			PreparedStatement pstmt2 = con.prepareStatement(sql2);
			boolean success = true; 

			sql = "UPDATE productinventory SET quantity = ? WHERE warehouseId = 1 and productId = ?";
			pstmt = con.prepareStatement(sql);

			
			do{
				int prodId = rst.getInt(2);
				int qty = rst.getInt(3);
				pstmt2.setInt(1,prodId);
				ResultSet res2 = pstmt2.executeQuery();
				if(!res2.next() || res2.getInt(1)<qty){
					// insufficient inventory 
					out.println("<h1>Shipment failed, insufficient inventory</h1>");
					success = false; 
					break;
				}
				//update inventory record
				int inventory = res2.getInt(1);
				pstmt.setInt(1,inventory-qty);
				pstmt.setInt(2,prodId);
				pstmt.executeUpdate();

				out.println("<h2>Ordered product: " +prodId+ " Qty: " +qty+ " Previous Inventory: " +inventory+ " New Inventory " +(inventory-qty)+ " </h2>");


			} 
			while(rst.next());

			//commit or rollback 
			if(!success)
				con.rollback();
			else{
				out.println("<h1>Shipment successfully processed.</h1>");
				con.commit();
			}

		}
		
		catch(SQLException e){
			con.rollback();
			out.println(e);
		}
		finally{
			// TODO: Auto-commit should be turned back on
			con.setAutoCommit(true);
		}

	}


}







%>                       
                  				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
