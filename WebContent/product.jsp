<%@ page import="java.sql.*, java.net.URLEncoder, java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>KenzoCoffer's Grocery Store - Product Information</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
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

        .navbar {
            background-color: #4CAF50;
            overflow: hidden;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .navbar a {
            float: left;
            display: block;
            color: #ffffff;
            text-align: center;
            padding: 14px 16px;
            text-decoration: none;
            font-size: 18px;
        }

        .navbar a:hover {
            background-color: #ddd;
            color: black;
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
            height: 200px;
            object-fit: cover;
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

        .reviews-container {
            margin-top: 20px;
        }

        .review-form {
            margin-top: 20px;
            border-top: 1px solid #ddd;
            padding-top: 20px;
        }

        .review-form textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
        }

        .submit-review-btn {
            display: inline-block;
            padding: 10px 20px;
            text-decoration: none;
            color: #fff;
            background-color: #3E71B7;
            border-radius: 5px;
            transition: background-color 0.3s ease;
            cursor: pointer;
        }

        .submit-review-btn:hover {
            background-color: #29568F;
        }

        .review-item {
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

<div class="header-ribbon">
    <div class="header-title">Welcome to KenzoCoffer's Grocery Store</div>
</div>

<div class="navbar">
    <a href="login.jsp">Login</a>
    <a href="listprod.jsp">Product List</a>
    <a href="customer.jsp">Customer Info</a>
    <a href="index.jsp">Main Page</a>
    <a href="logout.jsp">Log out</a>
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
                            
                           
                            <div class="reviews-container">
                                <h3>Product Reviews</h3>
                                <% 
                                    // Retrieve and display product reviews
                                    String reviewSql = "SELECT * FROM review WHERE productId = ?";
                                    try (PreparedStatement reviewStmt = con.prepareStatement(reviewSql)) {
                                        reviewStmt.setString(1, productId);
                                        ResultSet reviewRs = reviewStmt.executeQuery();

                                        while (reviewRs.next()) {
                                            int reviewRating = reviewRs.getInt("reviewRating");
                                            String reviewComment = reviewRs.getString("reviewComment");
                                %>
                                            <div class="review-item">
                                                <p><strong>Rating:</strong> <%= reviewRating %> stars</p>
                                                <p><strong>Comment:</strong> <%= reviewComment %></p>
                                            </div>
                                <%
                                        }
                                    }
                                %>
                            </div>

                            
                            <div class="review-form">
                                <h3>Add Your Review</h3>
                                <form method="post" action="addreview.jsp">
                                    <input type="hidden" name="productId" value="<%= productId %>">
                                    <label for="rating">Rating:</label>
                                    <select name="rating" id="rating">
                                        <option value="1">1 star</option>
                                        <option value="2">2 stars</option>
                                        <option value="3">3 stars</option>
                                        <option value="4">4 stars</option>
                                        <option value="5">5 stars</option>
                                    </select>
                                    <br>
                                    <label for="comment">Comment:</label>
                                    <textarea name="comment" id="comment" rows="4" cols="50"></textarea>
                                    <br>
                                    <input type="submit" value="Submit Review" class="submit-review-btn">
                                </form>
                            </div>
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