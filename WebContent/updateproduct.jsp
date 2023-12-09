<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.io.PrintWriter" %>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>

<%
    // Retrieve the product ID from the request parameter
    String productId = request.getParameter("productId");

    // Retrieve the existing product details based on the product ID
    String getProductSql = "SELECT * FROM product WHERE productId = ?";
    try {
        getConnection();
        PreparedStatement getProductStmt = con.prepareStatement(getProductSql);
        getProductStmt.setString(1, productId);
        ResultSet productRs = getProductStmt.executeQuery();

        if (productRs.next()) {
            // Retrieve the existing product details
            String productName = productRs.getString("productName");
            double productPrice = productRs.getDouble("productPrice");
            String productDesc = productRs.getString("productDesc");
            int categoryId = productRs.getInt("categoryId");

%>
           
            <h2>Update Product</h2>
            <form action="processupdate.jsp" method="post">
                <label for="productName">Product Name:</label>
                <input type="text" id="productName" name="productName" value="<%= productName %>" required><br>

                <label for="price">Product Price:</label>
                <input id="price" name="price" value="<%= productPrice %>" required><br>

                <label for="productDesc">Description:</label>
                <textarea id="productDesc" name="productDesc" rows="1" cols="50" required><%= productDesc %></textarea><br>

                <label for="categoryId">Category Id:</label>
                <input id="categoryId" name="categoryId" value="<%= categoryId %>" required><br>

                <input type="hidden" name="productId" value="<%= productId %>">

                <input type="submit" value="Update Product">
            </form>
<%
        } else {
%>
            <p>Error: Product not found for ID <%= productId %></p>
<%
        }
    } catch (SQLException ex) {
        out.println(ex);
    } finally {
        closeConnection();
}
%>
