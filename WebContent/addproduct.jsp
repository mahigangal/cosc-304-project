<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>

<%
    String productName = request.getParameter("productName");
    String priceStr = request.getParameter("price");
    String productDesc = request.getParameter("productDesc");
    
    String idcategory= request.getParameter("categoryId");

    double price = 0.0;
    if (priceStr != null && !priceStr.isEmpty()) {
        try {
            price = Double.parseDouble(priceStr);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }


    String addProductSql = "INSERT INTO product (productName, productPrice, productDesc, categoryId) VALUES (?, ?, ?,?)";

    try {
        getConnection();  

        PreparedStatement addProductStmt = con.prepareStatement(addProductSql);
        
        addProductStmt.setString(1, productName);
        addProductStmt.setDouble(2, price);
        addProductStmt.setString(3, productDesc);
        int categoryId = Integer.parseInt(idcategory);
        addProductStmt.setInt(4, categoryId);
        

        int rowsAffected = addProductStmt.executeUpdate();

        if (rowsAffected > 0) {
%>
            <p>Product successfully added to the database.</p>
<%
        } else {
%>
            <p>Error adding the product to the database.</p>
<%
        }
        closeConnection();  
    } catch (SQLException ex) {
        out.println(ex);
    }


%>
