<!DOCTYPE html>
<html>
<head>
    <title>User Account</title>
</head>
<body>

    <%@ include file="auth.jsp" %>
    <%@ include file="jdbc.jsp" %>

<%
    String userName = (String) session.getAttribute("authenticatedUser");
    
    if (userName == null || userName.isEmpty()) {
%>
    <p>Error: You are not logged in. Please <a href="login.jsp">login</a> to access this page.</p>
<%
    }

%>    
<body>
        <h1>User Account</h1>
<%
try {
    getConnection();
    Statement stmt = con.createStatement(); 

    String sql1 = "SELECT * FROM customer WHERE userId = ?";
    String sql = "select orderId, orderDate, orderSummary.customerId, firstName, lastName, totalAmount from orderSummary join customer on orderSummary.customerId=customer.customerId order by orderId";
    String sql2 = "select productId, quantity, price from orderproduct where orderId= ?";

    PreparedStatement pstmt = con.prepareStatement(sql1);
    pstmt.setString(1, userName);

    ResultSet rs = pstmt.executeQuery();

    if(rs.next()){
        String name = rs.getString(2)+" "+rs.getString(3);
        %>
        <h2><%= name %></h2>
<%
    }
}
finally{
    closeConnection();
}
%>



</body>
</html>