<%@ page trimDirectiveWhitespaces="true" import="java.sql.*,java.io.*" %>
<%@ include file="jdbc.jsp" %>

<%
// Get the image id
String id = request.getParameter("id");

if (id == null)
    return;

int idVal = -1;
try {
    idVal = Integer.parseInt(id);
} catch (Exception e) {
    out.println("Invalid image id: " + id + " Error: " + e);
    return;
}

// Check if the image is from the img folder or the database
if (idVal == 0) {
    // For images from the img folder
    String imgFileName = "1_a.jpg"; // Change this to the desired image file name
    String imgPath = getServletContext().getRealPath("/img/" + imgFileName);

    try (InputStream inputStream = new FileInputStream(imgPath);
         OutputStream outputStream = response.getOutputStream()) {

        int bytesRead;
        byte[] buffer = new byte[8192];

        while ((bytesRead = inputStream.read(buffer, 0, 8192)) != -1) {
            outputStream.write(buffer, 0, bytesRead);
        }
    } catch (IOException e) {
        out.println("Error reading image from file: " + e.getMessage());
    }
} else {
    // For images from the database
    String sql = "SELECT productImage FROM Product WHERE productId = ?";

    try {
        getConnection();

        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setInt(1, idVal);
            ResultSet rst = stmt.executeQuery();

            int BUFFER_SIZE = 10000;
            byte[] data = new byte[BUFFER_SIZE];

            if (rst.next()) {
                // Copy stream of bytes from database to output stream for JSP/Servlet
                InputStream istream = rst.getBinaryStream(1);
                OutputStream ostream = response.getOutputStream();

                int count;
                while ((count = istream.read(data, 0, BUFFER_SIZE)) != -1)
                    ostream.write(data, 0, count);

                ostream.close();
                istream.close();
            }
        }
    } catch (SQLException ex) {
        out.println(ex);
    } finally {
        closeConnection();
    }
}
%>
