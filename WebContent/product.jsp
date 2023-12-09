<%@ page import="java.sql.*, java.net.URLEncoder, java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>KenzoCoffer's Grocery Store - Product Information</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
        }

        .header-ribbon {
            position: relative;
            background-color: #4CAF50;
            color: white;
            text-align: center;
            padding: 20px;
            font-size: 36px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .header-title {
            font-family: 'Impact', sans-serif;
            margin-bottom: 10px;
        }

        .container {
            margin-top: 50px;
        }

        .product-details {
            max-width: 600px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }

        .product-image {
            max-width: 100%;
            height: 200px; /* Set a fixed height for all images */
            object-fit: cover; /* Maintain aspect ratio and cover the container */
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .add-to-cart-btn,
        .continue-shopping-btn {
            display: inline-block;
            padding: 10px 20px;
            margin-top: 10px;
            text-decoration: none;
            color: #fff;
            background-color: #3E71B7;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .add-to-cart-btn:hover,
        .continue-shopping-btn:hover {
            background-color: #29568F;
        }
    </style>
</head>
<body>

<div class="header-ribbon">
    <div class="header-title">
        <%@ include file="header.jsp" %>
    </div>
</div>

<div class="container">
    <div class="product-details">
        <% 
            // Get product ID to search for
            String productId = request.getParameter("id");

            if (productId != null && !productId.isEmpty()) {
                String sql = "SELECT * FROM Product WHERE productId = ?";

                try {
                    getConnection();  

                    try (PreparedStatement pstmt = con.prepareStatement(sql)) {
                        pstmt.setInt(1, Integer.parseInt(productId));
                        ResultSet rs = pstmt.executeQuery();

                        if (rs.next()) {
                            String productName = rs.getString("productName");
                            Double productPrice = rs.getDouble("productPrice");
                            String productImageURL = rs.getString("productImageURL");
        %>
                            <h2><%= productName %></h2>
                            <table>
                                <tr>
                                    <th>Id</th><td><%= productId %></td>
                                </tr>
                                <tr>
                                    <th>Price</th><td><%= NumberFormat.getCurrencyInstance().format(productPrice) %></td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <% if (productImageURL != null && !productImageURL.isEmpty()) { %>
                                            <img class="product-image" src="<%= productImageURL %>" alt="<%= productName %>">
                                        <% } %>
                                    </td>
                                </tr>
                            </table>
                            <a class="add-to-cart-btn" href="addcart.jsp?id=<%= productId %>&name=<%= URLEncoder.encode(productName, "UTF-8") %>&price=<%= productPrice %>">Add to Cart</a>
                            <a class="continue-shopping-btn" href="listprod.jsp">Continue Shopping</a>
        <%
                        } else {
                            out.println("<p>Product not found</p>");
                        }
                    }
                } catch (SQLException e) {
                    out.println("SQL Exception: " + e);
                } finally {
                    closeConnection();  
                }
            } else {
                out.println("<p>Invalid product ID</p>");
            }
        %>
    </div>
</div>

</body>
</html>
