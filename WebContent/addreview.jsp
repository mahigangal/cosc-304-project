<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="jdbc.jsp" %>

<%
    String productId = request.getParameter("productId");
    int rating = request.getParameter("rating");
    String comment = request.getParameter("comment");

    if (productId != null && rating != null && comment != null) {
        try {
            getConnection();

            String insertReviewSql = "INSERT INTO review (reviewRating, reviewComment, productId) VALUES (?, ?, ?)";
            try (PreparedStatement insertReviewStmt = con.prepareStatement(insertReviewSql)) {
                insertReviewStmt.setInt(1, rating);
                insertReviewStmt.setString(2, comment);
                insertReviewStmt.setString(3, productId);

                int rowsAffected = insertReviewStmt.executeUpdate();

                if (rowsAffected > 0) {
                    // Review added successfully
                    out.println("<p>Review added successfully</p>");
                    // You may redirect the user to the Product.jsp or display a message.
                    response.sendRedirect("Product.jsp?id=" + productId);
                } else {
                    out.println("<p>Error adding the review</p>");
                }
            }
        } catch (SQLException e) {
            out.println("SQL Exception: " + e);
        } finally {
            closeConnection();
        }
    } else {
        out.println("<p>Invalid parameters</p>");
    }
%>
