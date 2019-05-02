<?php

include 'model/dbconnect.php';

$successMessage;

if (isset($_GET['deleteSubmit'])) {
  deleteProduct();
  $successMessage = "<span class='message success'>Success! Deleted selected product. View <a href='index.php' class='checkHere'>Home Page</a> to see all records.</span>";
} else {
  $successMessage = "<span class='message failed'>Failed! Product not deleted. Try Again...</span>";
}

  function deleteProduct() {
    global $conn;

    $updateId = mysqli_real_escape_string($conn, $_GET['productId']);

      $sql = "CALL DeleteProduct(?);";

      $stmt = mysqli_stmt_init($conn);
      if (!mysqli_stmt_prepare($stmt, $sql)) {
          echo "SQL Error";
      } else {
        mysqli_stmt_bind_param($stmt, "s", $updateId);
        mysqli_stmt_execute($stmt);
      }
    }
?>
