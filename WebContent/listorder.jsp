<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>KenzoCoffer's Grocery Store Order</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .ribbon {
            background-color: #28a745;
            padding: 10px 0;
            text-align: center;
            color: white;
            font-size: 30px;
            width: 100%;
        }

        .navbar {
            background-color: #4CAF50;
            overflow: hidden;
            width: 100%;
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

        table {
            border-collapse: collapse;
            width: 80%;
            margin: 20px 0;
            background-color: #ffffff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
        }

        th, td {
            border: 1px solid #dddddd;
            padding: 15px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
            font-weight: bold;
            font-size: 16px;
        }

        td {
            background-color: #ffffff;
        }

        td, th {
            white-space: nowrap;
        }

        tbody tr:hover {
            background-color: #f5f5f5;
        }

        td[colspan="5"] {
            padding: 0;
        }

        td > table {
            width: 100%;
            border-collapse: collapse;
        }

        td > table th, td > table td {
            border: 1px solid #dddddd;
            padding: 12px;
            text-align: left;
        }

        td > table th {
            background-color: #f2f2f2;
            font-weight: bold;
            font-size: 16px;
        }

        td > table td {
            background-color: #ffffff;
        }
    </style>
</head>
<body>

    <div class="ribbon">
        Welcome to KenzoCoffer Grocery
    </div>

    <div class="navbar">
        <a href="listprod.jsp">Begin Shopping</a>
        <a href="index.jsp">Main Page</a>
        <a href="login.jsp">Login</a>
    </div>

    <table>
        <thead>
            <tr>
                <th>Order ID</th>
                <th>Order Date</th>
                <th>Customer ID</th>
                <th>Customer Name</th>
                <th>Total Amount</th>
            </tr>
        </thead>
        <tbody>
            <%
            try {
                getConnection();
                Statement stmt = con.createStatement(); 
                {            
                    String sql = "select orderId, orderDate, orderSummary.customerId, firstName, lastName, totalAmount from orderSummary join customer on orderSummary.customerId=customer.customerId order by orderId";
                    String sql2 = "select productId, quantity, price from orderproduct where orderId= ?";
                    PreparedStatement ps = con.prepareStatement(sql2);
                    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

                    ResultSet rst = stmt.executeQuery(sql);

                    while (rst.next()) {
            %>
                        <tr>
                            <td><%= rst.getInt(1) %></td>
                            <td><%= rst.getDate(2) %></td>
                            <td><%= rst.getInt(3) %></td>
                            <td><%= rst.getString(4) + " " + rst.getString(5) %></td>
                            <td><%= currFormat.format(rst.getDouble(6)) %></td>
                        </tr>
            <%
                        ps.setInt(1, rst.getInt("orderId"));
                        ResultSet rst2 = ps.executeQuery();
            %>
                        <tr>
                            <td colspan='5'>
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Product ID</th>
                                            <th>Quantity</th>
                                            <th>Price</th>
                                        </tr>
                                    </thead>
                                    <tbody>
            <%
                        while (rst2.next()) {
            %>
                            <tr>
                                <td><%= rst2.getInt(1) %></td>
                                <td><%= rst2.getInt(2) %></td>
                                <td><%= currFormat.format(rst2.getInt(3)) %></td>
                            </tr>
            <%
                        }
                        rst2.close();
            %>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
            <%
                    }
                    stmt.close();
                    ps.close();
                    closeConnection();
                }
            } catch (SQLException e) {
                out.println("SQLException: " + e.getMessage());
            }
            %>
        </tbody>
    </table>
</body>
</html>
