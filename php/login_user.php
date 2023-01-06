<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);
$sqllogin = "SELECT * FROM user WHERE userEmail = '$email' AND userPassword = '$password'";
$result = $conn-> query($sqllogin);

if($result-> num_rows >0){ 
while ($row = $result -> fetch_assoc()) {
        $userlist = array();
        $userlist['id'] = $row['userId'];
        $userlist['name'] = $row['userName'];
        $userlist['email'] = $row['userEmail'];
        $userlist['regdate'] = $row['userRegDate'];
        $response = array('status' => 'success', 'data' => $userlist);
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
