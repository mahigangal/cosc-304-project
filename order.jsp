<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>KenzoCoffer's Grocery Store Order Processing</title>
</head>
<body>

<% 
// Get customer id
String custId = request.getParameter("customerId");
String pass = request.getParameter("password");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Determine if valid customer id was entered
// Determine if there are products in the shopping cart
// If either are not true, display an error message

if (custId == null || !custId.matches("\\d+")) {
    out.println("<p><strong><b>Invalid customer id. Go back to the previous page and try again</b></strong></p>");
} 
else {
    // Make connection
    getConnection();
}

String sql = "SELECT * FROM customer WHERE customerId = ?";
try (PreparedStatement ps = con.prepareStatement(sql)) {
    ps.setInt(1, Integer.parseInt(custId));
    ResultSet rst = ps.executeQuery();

    if (!rst.next()) {
        out.println("<p><strong><b>Invalid customer id. Go back to the previous page and try again</b></strong></p>");
    }
    else {

		String p = rst.getString("password");

		if(pass == null || pass.isEmpty()){
			out.println("<p><strong><b>Enter password!</b></strong></p>");
		}
		else if(!pass.equals(p)){
			out.println("<p><strong><b>Incorrect password!</b></strong></p>");
		}

		else{
        // Check if the shopping cart is empty
        if (productList == null || productList.isEmpty()) {
            out.println("<p><strong><b>Shopping cart is empty!</b></strong></p>");
        } 
        else {
            // Save order information to the database
            String sql2 = "INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (?, GETDATE(), ?)";

            try (PreparedStatement ps2 = con.prepareStatement(sql2, Statement.RETURN_GENERATED_KEYS)) {
                ps2.setInt(1, Integer.parseInt(custId));
                ps2.setDouble(2, 0.0); // Placeholder for totalAmount, will be updated later

                int rows = ps2.executeUpdate();

                if (rows == 0) {
                    out.println("<p>Error: Order creation failed.</p>");
                }
                else {
                    // Retrieve the auto-generated orderId
                    ResultSet rst2 = ps2.getGeneratedKeys();
                    if (rst2.next()) {
                        int orderId = rst2.getInt(1);

                        String sql3 = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";

                        try (PreparedStatement ps3 = con.prepareStatement(sql3)) {
                            Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
                            double totalAmount = 0.0;

                            out.println("<h2>Your Order Summary</h2>");
                            out.println("<table border=\"1\">");
                            out.println("<tr><th>Product ID</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");

                            while (iterator.hasNext()) {
                                Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                                ArrayList<Object> product = entry.getValue();
                                String productId = (String) product.get(0);
                                String productName = (String) product.get(1);
                                String price = (String) product.get(2);
                                double pr = Double.parseDouble(price);
                                int qty = ((Integer) product.get(3)).intValue();

                                totalAmount += qty * pr;

                                ps3.setInt(1, orderId);
                                ps3.setString(2, productId);
                                ps3.setInt(3, qty);
                                ps3.setDouble(4, pr);

                                ps3.executeUpdate();

                                // Display each ordered item in the table
                                double subtotal = qty * pr;
                                out.println("<tr><td>" + productId + "</td><td>" + productName + "</td><td>" + qty + "</td><td>$" + pr + "</td><td>$" + subtotal + "</td></tr>");
                            }

                            out.println("</table>");

                            // Update total amount for the order record
                            String sql4 = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";

                            try (PreparedStatement ps4 = con.prepareStatement(sql4)) {
                                ps4.setDouble(1, totalAmount);
                                ps4.setInt(2, orderId);

                                ps4.executeUpdate();
                            }

                            // Print out order summary details
                            
                            out.println("<p>Total Amount: $" + totalAmount + "</p>");
                            out.println("<strong><b>Order Completed will be shipped soon...</b></strong>");
                            // Display the order reference number
                            out.println("<p><strong><b>Your order reference number is: " + orderId + "</b></strong></p>");

                            // Display customer name
                            String customerName = rst.getString("firstName") + " " + rst.getString("lastName");
                            out.println("<p><strong><b>Shipping to customer: " + custId + " Name: " + customerName + "</b></strong></p>");

                            // Clear cart if the order is placed successfully
                            session.setAttribute("productList", null);
                        }
                    }
                }
            }
        }}
    }
}

// Close connection
closeConnection();
%>
</body>
</html>
