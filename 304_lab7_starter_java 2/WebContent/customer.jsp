<!DOCTYPE html>
<html>
<head>
    <title>Customer Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
    String userName = (String) session.getAttribute("authenticatedUser");
    
    if (userName == null || userName.isEmpty()) {
%>
    <p>Error: You are not logged in. Please <a href="login.jsp">login</a> to access this page.</p>
<%
    } else {
        
        try {
            getConnection();

            String customerSql = "SELECT * FROM customer WHERE userId = ?";
            PreparedStatement customerPstmt = con.prepareStatement(customerSql);
            customerPstmt.setString(1, userName);
            ResultSet rs = customerPstmt.executeQuery();

            if (rs.next()) {
%>

                <h2>Customer Profile</h2>
                <table border="1">
                    <tr>
                        <th>Id</th>
                        <td><%= rs.getInt(1) %></td>
                    </tr>
                    <tr>
                        <th>First Name</th>
                        <td><%= rs.getString(2) %></td>
                    </tr>
                    <tr>
                        <th>Last Name</th>
                        <td><%= rs.getString(3) %></td>
                    </tr>
                    <tr>
                        <th>Email</th>
                        <td><%= rs.getString(4) %></td>
                    </tr>
                    <tr>
                        <th>Phone</th>
                        <td><%= rs.getString(5) %></td>
                    </tr>
                    <tr>
                        <th>Address</th>
                        <td><%= rs.getString(6) %></td>
                    </tr>
                    <tr>
                        <th>City</th>
                        <td><%= rs.getString(7)%></td>
                    </tr>
                    <tr>
                        <th>State</th>
                        <td><%= rs.getString(8) %></td>
                    </tr>
                    <tr>
                        <th>Postal Code</th>
                        <td><%= rs.getString(9) %></td>
                    </tr>
                    <tr>
                        <th>Country</th>
                        <td><%= rs.getString(10)%></td>
                    </tr>
                    <tr>
                        <th>User Id</th>
                        <td><%= rs.getString(11) %></td>
                    </tr>
                </table>

                <h2>Customer Orders</h2>
                <table border="1">
                    <tr>
                        <th>Order Id</th>
                        <th>Order Date</th>
                        <th>Total Amount</th>
                        
                    </tr>
                    <%
                        // Retrieve customer orders
                        String orderSql = "SELECT * FROM orderSummary WHERE customerId = ?";
                        PreparedStatement orderPstmt = con.prepareStatement(orderSql);
                        orderPstmt.setInt(1, rs.getInt(1));
                        ResultSet orderRs = orderPstmt.executeQuery();

                        while (orderRs.next()) {
                    %>
                            <tr>
                                <td><%= orderRs.getInt("orderId") %></td>
                                <td><%= orderRs.getDate("orderDate") %></td>
                                <td><%= orderRs.getDouble("totalAmount") %></td>
                              
                            </tr>
                    <%
                        }
                    %>
                </table>

<%
            } else {
%>
                <p>No customer information found for <%= userName %></p>
<%
            }
            
            closeConnection();
        } catch (SQLException ex) {
            out.println(ex);
        }
    }
%>

</body>
</html>