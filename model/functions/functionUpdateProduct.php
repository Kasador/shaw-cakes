<?php

include 'model/dbconnect.php';

$successMessage;

if (isset($_POST['updateSubmit'])) {
  updateProduct();
  $successMessage = "<span class='message success'>Success! Updated selected product. View <a href='index.php' class='checkHere'>Home Page</a> to see all records.</span>";
} else {
  $successMessage = "<span class='message failed'>Failed! Product not updated. Try Again...</span>";
}

  function updateProduct() {
    global $conn;

    $updateDescription = mysqli_real_escape_string($conn, $_POST['productDescription']);
    $updatePrice = mysqli_real_escape_string($conn, $_POST['productPrice']);
    $updateType = mysqli_real_escape_string($conn, $_POST['productType']);
    $updateId = mysqli_real_escape_string($conn, $_POST['productId']);

      $sql = "CALL UpdateProduct(?,?,?,?);";

      $stmt = mysqli_stmt_init($conn);
      if (!mysqli_stmt_prepare($stmt, $sql)) {
          echo "SQL Error";
      } else {
        mysqli_stmt_bind_param($stmt, "ssss", $updateId, $updateDescription, $updatePrice, $updateType);
        mysqli_stmt_execute($stmt);
      }
    }
?>
