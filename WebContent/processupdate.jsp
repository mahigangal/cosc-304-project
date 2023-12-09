<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>

<%
    // Retrieve parameters from the request
    int productId = Integer.parseInt(request.getParameter("productId"));
    String productName = request.getParameter("productName");
    String priceStr = request.getParameter("price");
    String productDesc = request.getParameter("productDesc");
    String categoryIdStr = request.getParameter("categoryId");

    double price = 0.0;
    if (priceStr != null && !priceStr.isEmpty()) {
        try {
            price = Double.parseDouble(priceStr);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

    int categoryId = 0;
    if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
        try {
            categoryId = Integer.parseInt(categoryIdStr);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

    // SQL query to update the product details
    String updateProductSql = "UPDATE product SET productName=?, productPrice=?, productDesc=?, categoryId=? WHERE productId=?";

    try {
        getConnection();

        // Prepare and execute the update statement
        try (PreparedStatement updateProductStmt = con.prepareStatement(updateProductSql)) {
            updateProductStmt.setString(1, productName);
            updateProductStmt.setDouble(2, price);
            updateProductStmt.setString(3, productDesc);
            updateProductStmt.setInt(4, categoryId);
            updateProductStmt.setInt(5, productId);

            int rowsAffected = updateProductStmt.executeUpdate();

            if (rowsAffected > 0) {
%>
                <p>Product details successfully updated.</p>
<%
            } else {
%>
                <p>Error updating product details.</p>
<%
            }
        }
        closeConnection();
    } catch (SQLException ex) {
        out.println(ex);
}
%>
