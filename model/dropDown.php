<?php

include 'functions/functionProductTypeInfo.php';

$ProductTypes = getProductTypeInfo();

  echo '<select name="productType" id="select">';
  echo '<option disabled selected value> -- select an option -- </option>';
  foreach ($ProductTypes as $ProductType) {
    echo '<option value=' . $ProductType["Prod_Type_Id"] . '>' .
    $ProductType["ProdTypeDesc"] . '</option>';

  }
  echo '</select>';

?>
