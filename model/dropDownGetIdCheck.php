<?php

include 'functions/functionProductIdCheck.php';

$ProductIds = getProductIdCheck();

  echo '<select name="productIdCheck" id="select">';
  echo '<option disabled selected value> -- select an option -- </option>';
  foreach ($ProductIds as $ProductId) {
    echo '<option value=' . $ProductId["Product_Id"] . '>' .
    $ProductId["Product_Id"] . '</option>';
  }
  echo '</select>';

?>
