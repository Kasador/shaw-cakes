<h1 class="headerText">Delete Product Page</h1>
<?php
  include 'includes/header.php';
  include 'includes/navs/navigation-delete.php';
  include 'model/functions/functionDeleteProduct.php';
  include 'model/functions/functionProductInfoById.php';
 ?>
 <main>
   <p class="paraText">
    Delete page of product controller. Please pick another to view controller.
   </p>
   <?php
   if (isset($_GET['deleteSubmit'])) {
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
   <form action="" method="GET" id="insertForm">
     <div id="insertWrapper">
       <!-- Where product ID = x -->
       <label> Delete Product With Id: </label>
       <br />
       <?php
        include 'model/dropDownGetId.php';
        ?>
       <br /><br />

       <input type="submit" name="deleteSubmit" value="Enter" class="buttons"/>
     </div>
   </form>
 </main>
<?php
  include 'includes/footer.php';
 ?>
