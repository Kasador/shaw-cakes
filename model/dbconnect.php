<?php
  // $db_host = 'localhost';
  // $db_user = 'root';
  // $db_pass = '';
  // $db_name = 'shawcakes';
  //
  // $conn = new mysqli($db_host, $db_user, $db_pass, $db_name);

    define("DB_HOST", "localhost");
    define("DB_USER", "root");
    define("DB_PASSWORD", "");
    define("DB_DATABASE", "shawcakes");

    $conn = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_DATABASE);


  if (!$conn) {
    die("Connection error: " . mysqli_connect_error());
  }
 ?>
