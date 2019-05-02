<h1 class="headerText">Home Page</h1>
<?php
  include 'includes/header.php';
  include 'includes/navs/navigation-home.php';
  include 'model/functions/functionProductInfoById.php';
 ?>
 <main>
   <p class="paraText">
     Home page of product controller. Please pick another to view controller.
   </p>
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
   <?php
      include 'model/functions/functionProductInfo.php';
      getProductInfo();
    ?>
 </main>
<?php
  include 'includes/footer.php';
 ?>
