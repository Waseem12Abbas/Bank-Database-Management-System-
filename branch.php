//PHP Script to Handle Form Submission
<?php
// Include the database connection file
include 'db_connect.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $branchID = $_POST['branchID'];
    $branchName = $_POST['branchName'];
    $branchAddress = $_POST['branchAddress'];

    // SQL query to insert data into Branches table
    $sql = "INSERT INTO Branches (BranchID, BranchName, BranchAddress) VALUES ('$branchID', '$branchName', '$branchAddress')";

    if ($conn->query($sql) === TRUE) {
        echo "New branch added successfully";
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }
}

// Close the connection
$conn->close();
?>
