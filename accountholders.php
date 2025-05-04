<?php

// db_connect.php
include 'db_connect.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Collecting form data
    $AccountHolderID = $_POST['AccountHolderID'];
    $AccountID = $_POST['AccountID'];
    $CustomerID = $_POST['CustomerID'];
    $HolderType = $_POST['HolderType'];

     
    // SQL query to insert data into account_holders table
    $sql = "INSERT INTO accountholders (AccountHolderID, AccountID, CustomerID, HolderType) 
            VALUES (?, ?, ?, ?)";

    // Prepare statement to prevent SQL injection
    $stmt = $conn->prepare($sql);
    if (!$stmt) {
        die("Statement preparation failed: " . $conn->error);
    }

    // Bind parameters (assuming all are strings, adjust if needed)
    $stmt->bind_param("ssss", $AccountHolderID, $AccountID, $CustomerID, $HolderType);

    if ($stmt->execute()) {
    // Success message with green background and icon
    echo '<div style="padding: 15px; margin: 15px 0; background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; border-radius: 8px; display: flex; align-items: center; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-check-circle" viewBox="0 0 16 16" style="margin-right: 10px;">
                <path d="M10.97 4.97a.235.235 0 0 0-.342 0l-3.58 3.58-1.44-1.44a.235.235 0 0 0-.342.342l1.75 1.75a.25.25 0 0 0 .35 0l4-4a.235.235 0 0 0 0-.342z"/>
                <path d="M8 15A7 7 0 1 0 8 1a7 7 0 0 0 0 14zm0 1A8 8 0 1 1 8 0a8 8 0 0 1 0 16z"/>
            </svg>
            <strong>Success!</strong> New account holder added successfully.
          </div>';
} else {
    // Error message with red background and icon
    echo '<div style="padding: 15px; margin: 15px 0; background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; border-radius: 8px; display: flex; align-items: center; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-exclamation-circle" viewBox="0 0 16 16" style="margin-right: 10px;">
                <path d="M8 15A7 7 0 1 0 8 1a7 7 0 0 0 0 14zm0 1A8 8 0 1 1 8 0a8 8 0 0 1 0 16z"/>
                <path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 4.995c-.1-.078-.1-.25-.1-.346V4.65c0-.4.4-.5.5-.5h.1c.4 0 .5.1.5.5V7c0 .4-.1.5-.5.5H7c-.4 0-.5-.1-.5-.5V5l.1-.005z"/>
            </svg>
            <strong>Error:</strong> ' . htmlspecialchars($stmt->error) . '
          </div>';
}

    

    // Closing statement and connection
    $stmt->close();
    $conn->close();
}
?>
