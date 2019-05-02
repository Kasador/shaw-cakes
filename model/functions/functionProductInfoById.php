<?php

include 'model/dbconnect.php';

function getProductInfoById() {
  global $conn;

  $productId = $_GET['productIdCheck'];

  $sql = 'CALL GetProductInfoById(' . $productId . ');';
  // connect -> use query function with mysql code variable inside prameters and store into result variable
  $result = $conn->query($sql);
  // if result is greater than 0 (if any data comes back) display the data in a table maded with PHP
  if ($result->num_rows > 0) {
    echo '<table class="tableHome">';
    echo '<tr>';
    echo '<th>Description</th>';
    echo '<th>Price</th>';
    echo '<th>Type</th>';
    echo '</tr>';
      // output data of each row
      while($row = $result->fetch_assoc()) {
          echo
          '<tr><td>' . $row["ProdDesc"].
          '</td><td>' . '$' . $row["Price"].
          '</td><td>' . $row["ProdDescType"].
          '</td></tr>';
      }
      echo '</table>';
    } else {
        echo '<span style="color:red;">' . '0 results for Product Id #: ' . $productId. '</span>';
    }
    $conn->close();
  }
?>
