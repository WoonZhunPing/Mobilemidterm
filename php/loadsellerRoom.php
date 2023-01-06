<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");

$userId = $_POST['userId'];

$sqlroom = "SELECT * FROM room INNER JOIN user ON room.userId = user.userId WHERE room.userId = '$userId' ORDER BY roomRegDate DESC";
$result = $conn-> query($sqllogin);

if($result-> num_rows >0){ 
while ($row = $result -> fetch_assoc()) {
        $roomlist = array();
        $roomlist['id'] = $row['userId'];
        $roomlist['name'] = $row['userName'];
        $roomlist['email'] = $row['userEmail'];
        $roomlist['regdate'] = $row['userRegDate'];
        $response = array('status' => 'success', 'data' => $roomlist);
        sendJsonResponse($response);
    }
}else{
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}
$conn->close();
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
