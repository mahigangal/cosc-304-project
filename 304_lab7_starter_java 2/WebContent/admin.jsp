<!DOCTYPE html>
<html>
<head>
    <title>Administrator Page</title>
</head>
<body>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>
<%
    String userName = (String) session.getAttribute("authenticatedUser");
    
    if (userName == null || userName.isEmpty()) {
%>
    <p>Error: You are not logged in. Please <a href="login.jsp">login</a> to access this page.</p>
<%
    } else {
        
        String salesSql = "SELECT convert(DATE,orderDate) as dates, SUM(totalAmount) as sales "
                + "FROM ordersummary "
                + "GROUP BY convert(DATE,orderDate)";
        try {
            getConnection();
            Statement salesStmt = con.createStatement();
            ResultSet salesRs = salesStmt.executeQuery(salesSql);%>

            <h2>List of Customers</h2>
            <%
                String customerSql = "SELECT * FROM customer";
                Statement customerStmt = con.createStatement();
                ResultSet customerRs = customerStmt.executeQuery(customerSql);
            %>

            <table border="1">
                <tr>
                    <th>Customer ID</th>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>Email</th>
                    <th>Phone Number</th>
                   
                </tr>
                <% while (customerRs.next()) { %>
                    <tr>
                        <td><%= customerRs.getInt("customerId") %></td>
                        <td><%= customerRs.getString("firstName") %></td>
                        <td><%= customerRs.getString("lastName") %></td>
                        <td><%= customerRs.getString("email") %></td>
                        <td><%= customerRs.getString("phonenum") %></td>
                       
                    </tr>
                <% } %>
            </table>


            <h2>Sales Summary</h2>
            <table border="1">
                <tr>
                    <th>Order Day</th>
                    <th>Total Sales</th>
                </tr>
                <% while (salesRs.next()) { %>
                    <tr>
                        <td><%= salesRs.getDate(1).toString() %></td>
                        <td><%= salesRs.getDouble(2) %></td>
                    </tr>
                <% } %>
            </table>

            
            <h2>Add New Product</h2>
<form action="addproduct.jsp" method="post">


    <label for="productName">Product Name:</label>
    <input type="text" id="productName" name="productName" required><br>

    <label for="price">Product Price:</label>
    <input id="price" name="price" required><br>

    <label for="productDesc">Description:</label>
    <textarea id="productDesc" name="productDesc" rows="1" cols="50" required></textarea><br>

    <label for="categoryId">Category Id:</label>
    <input id="categoryId" name="categoryId" required><br>
    



<input type="submit" value="Add Product">
</form>

<%
            closeConnection();
        } catch (SQLException ex) {
            out.println(ex);
        }
    }
%>

</body>
</html>
