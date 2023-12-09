<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>

<%
    // Retrieve the product ID from the request
    int productId = Integer.parseInt(request.getParameter("productId"));

    // SQL query to delete the product
    String deleteProductSql = "DELETE FROM product WHERE productId=?";

    try {
        getConnection();

        // Prepare and execute the delete statement
        try (PreparedStatement deleteProductStmt = con.prepareStatement(deleteProductSql)) {
            deleteProductStmt.setInt(1, productId);

            int rowsAffected = deleteProductStmt.executeUpdate();

            if (rowsAffected > 0) {
%>
                <p>Product successfully deleted from the database.</p>
<%
            } else {
%>
                <p>Error deleting product from the database.</p>
<%
            }
        }
        closeConnection();
    } catch (SQLException ex) {
        out.println(ex);
}
%>
