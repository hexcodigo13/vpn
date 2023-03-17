<?php
// Start the session
session_start();

// Check if the user is not logged in
if (!isset($_SESSION['username'])) {
  // Redirect the user to the login page
  header('Location: login.php');
  exit;
}
?> 
<html>
  <head>
    <title>Internet Plans</title>
    <link rel="stylesheet" type="text/css" href="style.css">
    <!-- <link rel="stylesheet" type="text/css" href="expenses-style.css"> -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="script.js"></script>
  </head>
  <body>
    <div class="plans-container">
      <div class="client-header ">
        <h1 class="sticky-top">Client Information</h1>
      </div>

      <h2 class="welcomeh2">Login as: <strong> <?php echo $_SESSION['username']; ?> </strong></h2>
  
      <a href="logout.php">Logout</a>
      <div class="text-center sticky-top" style="margin-bottom: 15px">
      <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#exampleModal">
        CLIENT Form
      </button>
      <a href="#" id="expenses-link" class="btn btn-info" onclick="loadexpensesData()">Expenses</a>
      <a href="#" id="vendo-link" class="btn btn-success" onclick="loadVendoData()">VENDO</a>
    </div>
    

<!-- Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" data-bs-backdrop="static" data-bs-keyboard="false" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <!-- <h5 class="modal-title" id="exampleModalLabel">Form</h5> -->
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div class="shadow p-1 mb-5 bg-white rounded">
        <form id="index-form" method="post" action="submit.php">
          <div class="form-container shadow">
            <div class="form-row">
              <div class="form-group col-md-6">
                <label for="name">Name</label>
                <input type="text" class="form-control shadow-sm" id="name" name="name" required>
              </div>
              <div class="form-group col-md-6">
                <label for="address">Address</label>
                <input type="text" class="form-control shadow-sm" id="address" name="address" required>
              </div>
            </div>
            <div class="form-row">
              <div class="form-group col-md-6">
                <label for="installation">Installation</label>
                <div class="input-group">
                  <div class="input-group-prepend">
                    <span class="input-group-text">₱</span>
                  </div>
                  <input type="number" class="form-control shadow-sm" id="installation" name="installation" oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                </div>
              </div>
              <div class="form-group col-md-6">
                <label for="due-date">Due Date</label>
                <input type="date" class="form-control shadow-sm" id="due-date" name="due-date" required>
              </div>
            </div>
            <div class="form-row">
              <div class="form-group col-md-6">
  <label for="internet-plan">Internet Plan</label>
  <div class="input-group">
    <input type="text" class="form-control shadow-sm" id="internet-plan" name="internet-plan" required>
    <div class="input-group-append">
      <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Select</button>
      <div class="dropdown-menu">
        <a class="dropdown-item" href="#">3MBPS</a>
        <a class="dropdown-item" href="#">5MBPS</a>
        <a class="dropdown-item" href="#">10MBPS</a>
        <a class="dropdown-item" href="#">20MBPS</a>
        <a class="dropdown-item" href="#">25MBPS</a>
      </div>
    </div>
  </div>
</div>
              <div class="form-group col-md-6">
                <label for="monthly-bill">Monthly Bill</label>
                <div class="input-group">
                  <div class="input-group-prepend">
                    <span class="input-group-text">₱</span>
                  </div>
                  <input type="number" class="form-control shadow-sm" id="monthly-bill" name="monthly-bill" oninput="this.value = this.value.replace(/[^0-9]/g, '')" required>
                </div>
              </div>
            </div>
          </div>
          <div class="form-row">
            <div class="form-group col-md-12">
              <button type="submit" class="btn btn-primary">Submit</button>
              <button type="reset" class="btn btn-secondary">Clear</button>
              <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
            </div>
          </div>
        </form>
      </div>
      </div>
      <!-- <div class="modal-footer">
        
      </div> -->
    </div>
  </div>
</div>
<!-- modal end code -->
<div id="index-container">
      <div style="max-height: 72vh; overflow-y: scroll;">
      <table border="1" >
        <table class="table table-bordered">
          <thead class="thead-dark sticky-top" >
            <tr>
              <th scope="col">Name</th>
              <th scope="col">Address</th>
              <th scope="col">Internet Plan</th>
              <th scope="col">Installation</th>
              <th scope="col">Due Date</th>
              <th scope="col">Monthly Bill</th>
              <th scope="col">Payment Status</th>
              <th scope="col">Action</th>
              <th scope="col">Payment History</th>
            </tr>
          </thead>
          <tbody> 
            <?php
// Connect to the database
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "save_client_info";
$conn = mysqli_connect($servername, $username, $password, $dbname);

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}


// Fetch data from the database
$sql = "SELECT * FROM client_data";
$sql .= " ORDER BY ADDRESS ASC"; // Added line to sort by address
$result = mysqli_query($conn, $sql);
$total_payment = 0;

// Display data in the table
// Display data in the table
if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_assoc($result)) {
        // Display client data in table
        echo "
														<tr>";
        echo "
															<td>" . $row["NAME"] . "</td>";
        echo "
															<td>" . $row["ADDRESS"] . "</td>";
        echo "
															<td>" . $row["INTERNET_PLAN"] . "</td>";
        echo "
															<td>₱" . number_format($row["INSTALLATION"], 2) . "</td>";
        echo "
															<td>" . date('F j, Y', strtotime('+1 month', strtotime($row["DUE_DATE"]))) . "</td>";
        echo "
															<td>₱" . number_format($row["MONTHLY_BILL"], 2) . "</td>";
        echo "
															<td>";
        
          echo "
																<a href='javascript:markAsPaid(" . $row["id"] . ", " . $row["MONTHLY_BILL"] . ", \"" . $row["NAME"] . "\")' class='paid-btn'>Mark as Paid</a>";
        
        echo "
															</td>";
        echo "
															<td>
																<a href='update_info.php?id=" . $row["id"] . "'>Edit</a> ";
        echo "
																<a href='delete_client_info.php?id=" . $row["id"] . "' onclick='return confirmDelete()'><i class='bi bi-trash'></i> Delete</a>
															</td>";



        
         echo "
                              <td>";
                              echo "<a href='payment_history.php?id=" . $row["id"] . "'>View</a>";
                              echo " ";
                              
                              $sql2 = "SELECT * FROM payment_history WHERE client_id = " . $row["id"];
                              $result2 = mysqli_query($conn, $sql2);
                              if (mysqli_num_rows($result2) > 0) {
                                  while ($row2 = mysqli_fetch_assoc($result2)) {
                                      if ($row2["date"] != null) {
                                        echo "<span class='paid-date'>Paid " . date('F', strtotime($row2["date"])) . "</span>";
                                          break;
                                      }
                                  }
                              }
                              echo "</td>";
              
                      echo "
                          </tr>";
        
                                // Fetch payment history for current client
                                 $sql2 = "SELECT SUM(AMOUNT) AS total_payment FROM payment_history WHERE client_id='" . $row["id"] . "'";
                                  $result2 = mysqli_query($conn, $sql2);

                            // Calculate total payment for current client
                              $client_total_payment = 0;
                              while ($row2 = mysqli_fetch_assoc($result2)) {
                                if (isset($row2['total_payment'])) {
                               $client_total_payment += $row2["total_payment"];
                                }
                                  }

                                // // Add current client's total payment to overall total payment
                                // $total_payment += $client_total_payment;
        
                                   }

    

                              } else {
                              "0 results";
                              }

                              // Fetch all the amounts of payments from the payment_history table
                                $sql3 = "SELECT SUM(amount) AS total_payment FROM payment_history";
                                $result3 = mysqli_query($conn, $sql3);

                                // Iterate over the query results and add each payment amount to the total payment variable
                                  while ($row3 = mysqli_fetch_assoc($result3)) {
                                  if (isset($row3['total_payment'])) {
                                      $total_payment += $row3['total_payment'];
                                      }
                                          }

                                  // Check connection
                                  if (!$conn) {
                                   die("Connection failed: " . mysqli_connect_error());
                                      }


                                  // Fetch all the amounts of expenses from the expenses table
                                  $sql4 = "SELECT SUM(amount) AS total_expenses FROM expenses";
                                    $result4 = mysqli_query($conn, $sql4);

                                        // Initialize the total expenses variable
                                        $total_expenses = 0;

                                        // Iterate over the query results and add each expense amount to the total expenses variable
                                          while ($row4 = mysqli_fetch_assoc($result4)) {
                                           if (isset($row4['total_expenses'])) {
                                              $total_expenses += $row4['total_expenses'];
                                           }
                                            }

                                          // Fetch all the amounts of payments from the payment_history table
                                          $sql3 = "SELECT SUM(amount) AS total_payment FROM payment_history";
                                              $result3 = mysqli_query($conn, $sql3);

                                                // Initialize the total payment variable
                                                $total_payment = 0;

                                                // Iterate over the query results and add each payment amount to the total payment variable
                                              while ($row3 = mysqli_fetch_assoc($result3)) {
                                               if (isset($row3['total_payment'])) {
                                                   $total_payment += $row3['total_payment'];
                                                    }
                                                    }

                                                // Calculate the remaining balance
                                                $remaining_balance = $total_payment - $total_expenses;

                                                // Fetch the total amount from the vendo table
                                                $sql5 = "SELECT SUM(amount) AS total_vendo FROM vendo";
                                                  $result5 = mysqli_query($conn, $sql5);

                                                    // Initialize the total vendo variable
                                                    $total_vendo = 0;

                                                  // Iterate over the query results and add each amount to the total vendo variable
                                                  while ($row5 = mysqli_fetch_assoc($result5)) {
                                                   if (isset($row5['total_vendo'])) {
                                                     $total_vendo += $row5['total_vendo'];
                                                          }
                                                        }



                              // Calculate the remaining balance
                              $remaining_balance = $total_payment - $total_expenses + $total_vendo;

                                // Display the total payment amount and remaining balance below the table
                                echo "
															<tr>
																<td colspan='10' style='text-align: center;'>
																	<strong style='font-size: 1.2em;'>Total Income:</strong>
																	<strong style='font-size: 1.2em;'>₱" . number_format($remaining_balance, 2) . "</strong>
																</td>
															</tr>";

                  // Close the database connection
                  mysqli_close($conn);
  ?> 
                </tbody>
        </table>
       
    </div>
    
</div>
<!-- 
//////////////

///////////////

///////////
//////////
//////////
//////////
/
/
/
/
/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 -->
<!-- VENDO.PHP DATA -->

<div class="vendo-container " style="display: none;">
  

     <main>
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header text-center">
                            <h5>OTHER INCOME</h5>
                        </div>
                        <div class="card-body">
                            <form id="vendo-form" method="post" action="add_income.php">
                                <div class="form-group">
                                    <label for="name">Name</label>
                                    <input type="text" class="form-control" id="name" name="name" required>
                                </div>
                                <div class="form-group">
                                    <label for="description">Description</label>
                                    <input type="text" class="form-control" id="description" name="description" required>
                                </div>
                                <div class="form-group">
                                    <label for="date">Date</label>
                                    <input type="date" class="form-control" id="date" name="date" required>
                                </div>
                                <div class="form-group">
                                    <label for="amount">Amount</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <div class="input-group-text">₱</div>
                                        </div>
                                        <input type="number" class="form-control" id="amount" name="amount" oninput="this.value = this.value.replace(/[^0-9]/g, '')" required>
                                    </div>
                               <div class="form-group d-flex align-items-center justify-content-center mt-2">
                                <div class="mr-2">
                                <button type="submit" class="btn btn-primary" name="vendoincome">SAVE</button>
                                </div>
                                <div>
                                <a href="index.php" class="btn btn-warning">Back</a>
                                </div>
                            </div>
                             </div>
                               
                            </form>
                        </div>
                    </div>
                </div>
                <div class="col-md-8 table-wrapper">
                    <table class="table table-striped table-bordered table-hover">
                        <thead class="thead-dark">
                            <tr>
                                <th> Name</th>
                                <th>Description</th>
                                <th>Date</th>
                                <th>Amount</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php
                                // Define database connection variables
                                $host = "localhost";
                                $username = "root";
                                $password = "";
                                $database = "save_client_info";

                                // Create a new database connection
                                $conn = mysqli_connect($host, $username, $password, $database);

                                // Check if the connection was successful
                                if (!$conn) {
                                    die("Connection failed: " . mysqli_connect_error());
                                }

                            // Define a query to retrieve the expense data
                            $sql = "SELECT id, name, description, date, amount FROM vendo";

                            // Execute the query and get the result set
                            $result = mysqli_query($conn, $sql);

                            // Display the result set in a table
                            if (mysqli_num_rows($result) > 0) {
                                while ($row = mysqli_fetch_assoc($result)) {
                                    echo "<tr>";
                                    echo "<td>" . $row["name"] . "</td>";
                                    echo "<td>" . $row["description"] . "</td>";
                                    echo "<td>" . date('F j, Y', strtotime($row["date"])) . "</td>";
                                    echo "<td>₱" . number_format($row["amount"], 2) . "</td>";
                                    echo "<td>";
                                    echo "<button class='btn btn-info btn-sm' onclick='openModal(" . $row["id"] . ")'><i class='far fa-edit'></i></button>";
                                     echo "<form method='post' style='display: inline-block;' action='delete_income.php'>";
                                     echo "<input type='hidden' name='vendo_id' value='" . $row["id"] . "'>";
                                     echo "<button type='submit' class='btn btn-danger btn-sm' name='vendodel' onclick='return confirmDelete();'><i class='far fa-trash-alt'></i></button>";
                                    echo "</form>";
                                    echo "</td>";
                                    echo "</tr>";
                                }

                                // Define a query to retrieve the total amount of vendo
                                $total_query = "SELECT SUM(amount) AS total FROM vendo";

                                // Execute the query and get the result set
                                $total_result = mysqli_query($conn, $total_query);

                                // Get the total amount of vendo from the result set
                                $total = mysqli_fetch_assoc($total_result)['total'];

                                // Display the total amount of vendo in a new table row
                                echo "<tr>";
                                echo "<td colspan='3'></td>";
                                echo "<td>Total: ₱" . number_format($total, 2) . "</td>";
                                echo "<td></td>";
                                echo "</tr>";

                                // Free up the result set and close the database connection
                                mysqli_free_result($result);
                                mysqli_free_result($total_result);
                                mysqli_close($conn);

                            } else {
                                 "No income found";
                            }
                        ?>
                    </tbody>
                </table>

</main>

<div id="success-msg" class="alert alert-success" style="display: none;">Vendo data added successfully.</div>

   <!-- Modal -->
        <div class="modal" tabindex="-1" role="dialog" id="vendo-modal">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <!-- Modal content will be filled dynamically -->
            </div>
        </div>
    </div>

    <script>


        function openModal(id) {
            // Fetch the details of the expense using the ID
            // and display them in the modal
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    var modalContent = document.querySelector('.modal-content');
                    modalContent.innerHTML = this.responseText;
                    modal.style.display = "block";
                }
            };
            xmlhttp.open("GET", "get-expense-details.php?id=" + id, true);
            xmlhttp.send();
        }

        // Get the modal
        var modal = document.getElementById("vendo-modal");

        // Get the <span> element that closes the modal
        var closeBtn = document.querySelector('.close');

        // When the user clicks on <span> (x), close the modal
        closeBtn.onclick = function() {
            modal.style.display = "none";
        }

        // When the user clicks anywhere outside of the modal, close it
        window.onclick = function(event) {
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
    </script>
         
 

       </div>

<!-- VENDO.PHP DATA end-->
<!-- //////////////////////////////////////////////////////////////////////////////////////////////////////////// -->
<!-- //
//
//
//
/
/
//
/
/
/
EXPENSES DATA START //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/ -->
<div class="expenses-container" style="display: none;">
    <main>
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <div class="card ">
                        <div class="card-header text-center">
                            <h5>Add Expense</h5>
                        </div>
                        <div class="card-body">
                            <form id="expenses-form"method="post" action="add_expenses.php">
                                <div class="form-group">
                                    <label for="expenses_name">Expenses Name</label>
                                    <input type="text" class="form-control" id="expenses_name" name="expenses_name" required>
                                </div>
                                <div class="form-group">
                                    <label for="description">Description</label>
                                    <input type="text" class="form-control" id="description" name="description" required>
                                </div>
                                <div class="form-group">
                                    <label for="date">Date</label>
                                    <input type="date" class="form-control" id="date" name="date" required>
                                </div>
                                <div class="form-group">
                                    <label for="amount">Amount</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <div class="input-group-text">₱</div>
                                        </div>
                                        <input type="number" class="form-control" id="amount" name="amount" oninput="this.value = this.value.replace(/[^0-9]/g, '')" required>
                                    </div>
                               <div class="form-group d-flex align-items-center justify-content-center mt-2">
                                <div class="mr-2">
                                <button type="submit" class="btn btn-primary" name="addexpenses">Add Expense</button>
                                </div>
                                <div>
                                <a href="index.php" class="btn btn-warning">Back</a>
                                </div>
                            </div>
                             </div>
                               
                            </form>
                        </div>
                    </div>
                </div>
                <div class="col-md-8 table-wrapper">
                    <table class="table table-striped table-bordered table-hover">
                        <thead class="thead-dark">
                            <tr>
                                <th>Expenses Name</th>
                                <th>Description</th>
                                <th>Date</th>
                                <th>Amount</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php
                                // Define database connection variables
                                $host = "localhost";
                                $username = "root";
                                $password = "";
                                $database = "save_client_info";

                                // Create a new database connection
                                $conn = mysqli_connect($host, $username, $password, $database);

                                // Check if the connection was successful
                                if (!$conn) {
                                    die("Connection failed: " . mysqli_connect_error());
                                }

                            // Define a query to retrieve the expense data
                            $sql = "SELECT id, expenses_name, description, date, amount FROM expenses";

                            // Execute the query and get the result set
                            $result = mysqli_query($conn, $sql);

                            // Display the result set in a table
                            if (mysqli_num_rows($result) > 0) {
                                while ($row = mysqli_fetch_assoc($result)) {
                                    echo "<tr>";
                                    echo "<td>" . $row["expenses_name"] . "</td>";
                                    echo "<td>" . $row["description"] . "</td>";
                                    echo "<td>" . date('F j, Y', strtotime($row["date"])) . "</td>";
                                    echo "<td>₱" . number_format($row["amount"], 2) . "</td>";
                                    echo "<td>";
                                    echo "<button class='btn btn-info btn-sm' onclick='openModal(" . $row["id"] . ")'><i class='far fa-edit'></i></button>";
                                    echo "<form method='post' style='display: inline-block;' action='delete_expenses.php'>";
                                     echo "<input type='hidden' name='expenses_id' value='" . $row["id"] . "'>";
                                    echo "<button type='submit' class='btn btn-danger btn-sm' name='vendodel' onclick='return confirmDelete();'><i class='far fa-trash-alt'></i></button>";
                                    echo "</form>";
                                    echo "</form>";
                                    echo "</td>";
                                    echo "</tr>";
                                }

                                // Define a query to retrieve the total amount of expenses
                                $total_query = "SELECT SUM(amount) AS total FROM expenses";

                                // Execute the query and get the result set
                                $total_result = mysqli_query($conn, $total_query);

                                // Get the total amount of expenses from the result set
                                $total = mysqli_fetch_assoc($total_result)['total'];

                                // Display the total amount of expenses in a new table row
                                echo "<tr id='total-row'>";
                                echo "<td colspan='3'></td>";
                                echo "<td>Total: ₱" . number_format($total, 2) . "</td>";
                                echo "<td></td>";
                                echo "</tr>";

                                // Free up the result set and close the database connection
                                mysqli_free_result($result);
                                mysqli_free_result($total_result);
                                mysqli_close($conn);

                            } else {
                                "No expenses found";
                            }
                        ?>
                    </tbody>
                </table>
            </div>


             <!-- Modal -->
        <div class="modal" tabindex="-1" role="dialog" id="expenses-modal">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <!-- Modal content will be filled dynamically -->
            </div>
        </div>
    </div>

    <script>
        

        function openModal(id) {
            // Fetch the details of the expense using the ID
            // and display them in the modal
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    var modalContent = document.querySelector('.modal-content');
                    modalContent.innerHTML = this.responseText;
                    modal.style.display = "block";
                }
            };
            xmlhttp.open("GET", "get-expense-details.php?id=" + id, true);
            xmlhttp.send();
        }

        // Get the modal
        var modal = document.getElementById("expenses-modal");

        // Get the <span> element that closes the modal
        var closeBtn = document.querySelector('.close');

        // When the user clicks on <span> (x), close the modal
        closeBtn.onclick = function() {
            modal.style.display = "none";
        }

        // When the user clicks anywhere outside of the modal, close it
        window.onclick = function(event) {
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
    </script>
    </main>
          </main>
</div>



<!-- END OF THE EXPENSES DATA -->



<!-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->
<!-- /////////////////////
////////////////////
/////////////////////
////////////////////
/////////////////////
ADDITONAL JS -->

 <script>
// LOADVENDODATA ONCLICK FUNCTION CODE////////////////////////////////////////////////////////////////////////////

$(document).ready(function() {

  // Hide the vendo-container by default
  $('.vendo-container').hide();
  


  // Function to load Vendo data and hide the index-container
window.loadVendoData = function() {
  // Hide the index-container
  $('#index-container').hide();
  $('#expenses-container').hide();

  // Hide the expenses-container
  $('.expenses-container').hide();

  // Show the vendo-container only if it is hidden
  if ($('.vendo-container').is(':hidden')) {
    $('.vendo-container').show();
  }
};

  // Rest of the code for the vendo form submission and data loading
  // ...
});

// LOADEXPENSESDATA ONCLICK FUNCTION CODE//////////////////////////////////////////////////////////////////////////

$(document).ready(function() {
  // Hide the vendo-container by default
  $('.expenses-container').hide();

  // Function to load Vendo data and hide the index-container
  window.loadexpensesData = function() {
  // Hide the index-container
  $('#index-container').hide();
  $('#vendo-container').hide();

  // Hide the vendo-container
  $('.vendo-container').hide();

  // Show the expenses-container only if it is hidden
  if ($('.expenses-container').is(':hidden')) {
    $('.expenses-container').show();
  }
};

  // Rest of the code for the vendo form submission and data loading
  // ...
});

///////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////MODAL CODE //////////////////////////////////////////////////////


</script>


<!-- /////////////////////

ADDITONAL CSS -->
 <style>
            /* CSS code here */
            .container {
                padding-top: 30px;
            }

            .card {
                margin-bottom: 30px;
            }

            .modal-dialog {
                max-width: 600px;
            }

            @media (max-width: 991px) {
                .col-md-4 {
                    margin-bottom: 30px;
                }
            }

          .welcomeh2 {
           font-size: 15px;
           text-align: left;
           }

            .paid-date {
             font-weight: bold;
             color: green;
             }

  </style>

<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

  </body>
</html>
