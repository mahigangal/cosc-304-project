<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.sql.*, java.io.PrintWriter, java.net.URLEncoder, java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%!  // Use <%! to declare methods in JSP

    // Function to check if the requested quantity is available in the inventory
    boolean isQuantityAvailable(String prodId, int requestedQuantity) {
        boolean available = false;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Check if the requested quantity is available
            String sql = "SELECT quantity FROM productinventory WHERE productId = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, prodId);
            rs = ps.executeQuery();

            if (rs.next()) {
                int availableQuantity = rs.getInt("quantity");
                available = (requestedQuantity <= availableQuantity);
            }
        } catch (SQLException e) {
            // Handle SQLException
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return available;
    }

%>

<%
    // Initialize the PrintWriter for writing the response
    PrintWriter responseWriter = response.getWriter();

    try {
        // Establish the database connection
        getConnection();

        // Get the product ID and updated quantity from the request
        String productId = request.getParameter("productId");
        int newQuantity = Integer.parseInt(request.getParameter("quantity"));

        // Get the current list of products from the session
        @SuppressWarnings({"unchecked"})
        HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

        // Check if the product list is not null and contains the specified product
        if (productList != null && productList.containsKey(productId)) {
            ArrayList<Object> product = productList.get(productId);

            // Check if the new quantity is valid (greater than or equal to 1)
            if (newQuantity >= 1) {
                // Check if the requested quantity is available in the inventory
                if (isQuantityAvailable(productId, newQuantity)) {
                    // Update the quantity in the product list
                    product.set(3, newQuantity);
                } else {
                    // If the requested quantity is not available, you can handle it accordingly.
                    // For now, let's remove the item from the cart. You may want to display a message to the user.
                    
                    responseWriter.println("<p>Sorry, the requested quantity is not available in the inventory.</p>");
                }
            } else {
                // If the new quantity is 0 or less, remove the item from the cart
                productList.remove(productId);
                responseWriter.println("<p>Invalid quantity. The item has been removed from the cart.</p>");
            }

            // Update the session attribute with the modified product list
            session.setAttribute("productList", productList);
        }
    } finally {
        // Close the database connection
        closeConnection();
    }

    // Redirect back to the shopping cart page
    response.sendRedirect("showcart.jsp");
%>