<h1 class="headerText">Update Product Page</h1>
<?php
  include 'includes/header.php';
  include 'includes/navs/navigation-update.php';
  include 'model/functions/functionUpdateProduct.php';
  include 'model/functions/functionProductInfoById.php';
 ?>
 <main>
   <p class="paraText">
    Update page of product controller. Please pick another to view controller.
   </p>
   <?php
   if (isset($_POST['updateSubmit'])) {
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
       <!-- Where product ID = x -->
       <label> Update Product With Id: </label>
       <br />
       <?php
        include 'model/dropDownGetId.php';
        ?>
       <br /><br />
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
       <input type="submit" name="updateSubmit" value="Enter" class="buttons"/>
     </div>
   </form>
 </main>
<?php
  include 'includes/footer.php';
 ?>
