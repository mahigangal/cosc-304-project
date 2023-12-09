<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
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
            ResultSet salesRs = salesStmt.executeQuery(salesSql);
        %>

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

        <!-- Add New Product Form -->
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

        <!-- List of Products -->
        <h2>List of Products</h2>
        <table border="1">
            <tr>
                <th>Product ID</th>
                <th>Product Name</th>
                <th>Product Price</th>
                <th>Product Description</th>
                <th>Category ID</th>
                <th>Actions</th>
            </tr>
            <% 
                String productSql = "SELECT * FROM product";
                Statement productStmt = con.createStatement();
                ResultSet productRs = productStmt.executeQuery(productSql);
                while (productRs.next()) { 
            %>
                <tr>
                    <td><%= productRs.getInt("productId") %></td>
                    <td><%= productRs.getString("productName") %></td>
                    <td><%= productRs.getDouble("productPrice") %></td>
                    <td><%= productRs.getString("productDesc") %></td>
                    <td><%= productRs.getInt("categoryId") %></td>
                    <td>
                       <!-- Button to updateproduct.jsp with the product ID -->
<form action="updateproduct.jsp" method="get">
    <input type="hidden" name="productId" value="<%= productRs.getInt("productId") %>">
    <input type="submit" value="Update">
</form>

<!-- Button to deleteproduct.jsp with the product ID -->
<form action="deleteproduct.jsp" method="post">
    <input type="hidden" name="productId" value="<%= productRs.getInt("productId") %>">
    <input type="submit" value="Delete">
</form>

                    </td>
                </tr>
            <% } %>
        </table>

<%
        closeConnection();
    } catch (SQLException ex) {
        out.println(ex);
    }
}
%>

<!-- Add JavaScript functions for update and delete actions -->
<script>
    function updateProduct(productId) {
        // Implement update logic using AJAX or redirect to update page
        alert("Update product with ID: " + productId);
    }

    function deleteProduct(productId) {
        // Implement delete logic using AJAX or redirect to delete page
        alert("Delete product with ID: " + productId);
    }
</script>
</body>
</html>
