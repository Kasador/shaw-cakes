<?php
  include 'model/dbconnect.php';

  function getProductInfo() {
     global $conn;

     $sql = "CALL GetProductInfo();";
     $result = $conn->query($sql);

     echo "<table class='tableHome'>
           <tr>
             <th>Product Id</th>
             <th>Description</th>
             <th>Price</th>
             <th>Type</th>
           <tr>";

     if ($result->num_rows > 0) {
       // output data of each row
       while($row = $result->fetch_assoc()) {
        echo "<tr>
                <td>" . $row['Product_Id']. "</td>
                <td>" . $row['ProdDesc']. "</td>
                <td>" . "$" . $row['Price']. "</td>
                <td>" . $row['ProdDescType']. "</td>
              </tr>";
      }
    } else {
    echo "0 results";
    }
      echo "</table>";

      $conn->close();
    }
 ?>
