<!-- db_connect.php -->
<?php
$servername = "localhost";
$username = "root";
$password = ""; // Default password for XAMPP is blank
$dbname = "Banking_database"; // Replace with your actual database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
