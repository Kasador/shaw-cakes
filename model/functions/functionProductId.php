<?php

include 'model/dbconnect.php';

function getProductId() {
  global $conn;

  $stmt = mysqli_stmt_init($conn);
  $query = 'CALL GetProductId();';

  if (!mysqli_stmt_prepare($stmt, $query)) {
    echo "SQL statement failed...";
  } else {
      mysqli_stmt_execute($stmt);
      $result = mysqli_stmt_get_result($stmt);
    }

    return $result;
  }
?>
