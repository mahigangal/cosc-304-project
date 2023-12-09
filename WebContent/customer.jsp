<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <title>Customer Page</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
        }

        .ribbon {
            background-color: #28a745;
            padding: 10px 0;
            text-align: center;
            color: white;
            font-size: 16px;
        }

        .ribbon a {
            color: white;
            margin: 0 15px;
            text-decoration: none;
        }

        .navbar {
            background-color: #4CAF50;
            overflow: hidden;
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
            margin-top: 20px;
        }

        .table th,
        .table td {
            text-align: center;
        }

        .alert {
            margin-top: 20px;
        }
    </style>
</head>

<body>

    <div class="ribbon">
        <h2>Welcome to KenzoCoffer's Grocery</h2>
    </div>

    <div class="navbar">
        <a href="listprod.jsp">Begin Shopping</a>
        <a href="index.jsp">Main Page</a>
        <a href="logout.jsp">Logout</a>
    </div>

    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <h2 class="text-center mb-4">Customer Profile</h2>

                <%
                    String userName = (String) session.getAttribute("authenticatedUser");

                    if (userName == null || userName.isEmpty()) {
                %>
                    <div class="alert alert-danger" role="alert">
                        Error: You are not logged in. Please <a href="login.jsp">login</a> to access this page.
                    </div>
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

                                <table class="table table-bordered">
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

                                <h2 class="text-center mb-4">Customer Orders</h2>
                                <table class="table table-bordered">
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
                                <div class="alert alert-warning" role="alert">
                                    No customer information found for <%= userName %>
                                </div>
                <%
                            }
                            closeConnection();
                        } catch (SQLException ex) {
                            out.println(ex);
                        }
                    }
                %>

            </div>
        </div>
    </div>

</body>

</html>
