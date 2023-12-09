<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%

// Get the product ID to remove from the request
String productId = request.getParameter("productId");

// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList != null && productList.containsKey(productId)) {
    // Remove the selected product from the cart
    productList.remove(productId);

    // Update the session attribute
    session.setAttribute("productList", productList);
}

// Redirect back to the shopping cart page
response.sendRedirect("showcart.jsp");

%>