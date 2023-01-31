<?php
error_reporting(0);
if (!isset($_GET['userId'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
$userId = $_GET['userId'];
include_once("dbconnect.php");
$sqlroom = "SELECT * FROM user WHERE userId = '$userId'";

$result = $conn-> query($sqlroom);

if ($result->num_rows > 0) {
    $userarray["users"] = array();
    while ($row = $result->fetch_assoc()) {
        $userlist = array();
        $userlist['id'] = $row['userId'];
        $userlist['name'] = $row['userName'];
        $userlist['email'] = $row['userEmail'];
        $userlist['regdate'] = $row['userRegDate'];
        $userlist['telephone'] = $row['telephone'];
     
        array_push($userarray["users"], $userlist);
    }
    $response = array('status' => 'success', 'data' => $userarray);
    sendJsonResponse($response);
} 
else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
