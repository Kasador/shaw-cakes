<?php

include 'model/dbconnect.php';

$successMessage;

if (isset($_POST['insertSubmit'])) {
  insertProduct();
  $successMessage = "<span class='message success'>Success! Inserted into products. View <a href='index.php' class='checkHere'>Home Page</a> to see all records.</span>";
} else {
  $successMessage = "<span class='message failed'>Failed! Not inserted into products. Try Again...</span>";
}

  function insertProduct() {
    global $conn;

    $insertDescription = mysqli_real_escape_string($conn, $_POST['productDescription']);
    $insertPrice = mysqli_real_escape_string($conn, $_POST['productPrice']);
    $insertType = mysqli_real_escape_string($conn, $_POST['productType']);

      $sql = "CALL InsertProduct(?,?,?);";

      $stmt = mysqli_stmt_init($conn);
      if (!mysqli_stmt_prepare($stmt, $sql)) {
          echo "SQL Error";
      } else {
        mysqli_stmt_bind_param($stmt, "sss", $insertDescription, $insertPrice, $insertType);
        mysqli_stmt_execute($stmt);
      }
    }
?>
