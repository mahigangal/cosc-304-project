<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>KenzoCoffer's Grocery Store Order</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }

        table {
            border-collapse: collapse;
            width: 60%;
            margin: 20px 0;
        }

        th, td {
            border: 1px solid #dddddd;
            padding: 12px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        td {
            background-color: #ffffff;
        }

        h1 {
            color: #333333;
        }
    </style>
</head>
<body>
    <h1>Order List</h1>

    <table>
        <thead>
            <tr>
                <th>OrderId</th>
                <th>Order Date</th>
                <th>Customer Id</th>
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
                        out.println("<tr>");
                        out.println("<td>" + rst.getInt(1) + "</td>");
                        out.println("<td>" + rst.getDate(2) + "</td>");
                        out.println("<td>" + rst.getInt(3) + "</td>");
                        out.println("<td>" + rst.getString(4) + " " + rst.getString(5) + "</td>");
                        out.println("<td>" + currFormat.format(rst.getDouble(6)) + "</td>");
                        out.println("</tr>");

                        ps.setInt(1, rst.getInt("orderId"));
                        ResultSet rst2 = ps.executeQuery();
                        out.println("<tr><td colspan='5'><table><thead><tr><th>ProductId</th><th>Quantity</th><th>Price</th></tr></thead><tbody>");

                        while (rst2.next()) {
                            out.println("<tr>");
                            out.println("<td>" + rst2.getInt(1) + "</td>");
                            out.println("<td>" + rst2.getInt(2) + "</td>");
                            out.println("<td>" + currFormat.format(rst2.getInt(3)) + "</td>");
                            out.println("</tr>");
                        }

                        out.println("</tbody></table></td></tr>");
                        rst2.close();
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
