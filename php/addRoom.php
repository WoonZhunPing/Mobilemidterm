<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");


$roomName = $_POST['roomName'];
$roomDesc = $_POST['roomDesc'];
$roomCategory = $_POST['roomCategory'];
$roomProperty = $_POST['roomProperty'];
$roomPrice = $_POST['roomPrice'];
$roomState = $_POST['roomState'];
$roomLocality = $_POST['roomLocality'];


$sqlinsert = "INSERT INTO room (roomName,roomDesc,roomCategory,roomProperty,roomPrice,roomState,roomLocality) VALUES('$roomName','$roomDesc','$roomCategory','$roomProperty','$roomPrice','$roomState','$roomLocality')";
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