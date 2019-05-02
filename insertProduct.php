<h1 class="headerText">Insert Product Page</h1>
<?php
  include 'includes/header.php';
  include 'includes/navs/navigation-insert.php';
  include 'model/functions/functionInsertProduct.php';
  include 'model/functions/functionProductInfoById.php';
 ?>
 <main>
   <p class="paraText">
    Insert page of product controller. Please pick another to view controller.
   </p>
   <?php
   if (isset($_POST['insertSubmit'])) {
     echo $successMessage;
   }
   ?>
   <form action="" method="GET" class="checkForm">
     <div id="insertWrapper">
       <?php
        if (isset($_GET['checkSubmit'])) {
          echo "<label>Product Id #: " . $_GET['productIdCheck']. "</label>";
          echo "<br /><br />";
        }
       ?>
       <input type="submit" name="checkSubmit" value="Check Record By ID" class="buttons check"/>
       <?php
          include 'model/dropDownGetIdCheck.php';

          if (isset($_GET['checkSubmit'])) {
            echo "<br /><br /><br />";
            getProductInfoById();
          }
        ?>
      </div>
   </form>
   <br />
   <form action="" method="POST" id="insertForm">
     <div id="insertWrapper">
       <!-- Product Description -->
       <label> Product Description: </label>
       <br />
       <input type="text" name="productDescription" />
       <br /><br />
       <!-- Product Price -->
       <label> Product Price: </label>
       <br />
       <input type="text" name="productPrice" />
       <br /><br />
       <!-- Product Type -->
       <label> Product Type: </label>
       <br />
       <?php
        include 'model/dropDown.php';
        ?>
       <br /><br />
       <input type="submit" name="insertSubmit" value="Enter" class="buttons"/>
     </div>
   </form>
 </main>
<?php
  include 'includes/footer.php';
 ?>
