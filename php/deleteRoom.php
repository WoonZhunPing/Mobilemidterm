<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
   
    die();
}
include_once("dbconnect.php");

$roomId = $_POST['roomId'];




$sqlinsert = "DELETE FROM room WHERE roomId = $roomId";
try {
    if ($conn->query($sqlinsert) === true) {
        
       
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
} catch (Exception $e) {
    $response = array('status' => 'error', 'data' => null);
    sendJsonResponse($response);
}
$conn->close();

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}