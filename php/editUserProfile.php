<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);

    die();
}
include_once("dbconnect.php");

$userName = $_POST["userName"];
$userEmail = $_POST["userEmail"];
$telephone = $_POST["telephone"];
$userId = $_POST['userId'];
$image = $_POST['image'];


$sqlinsert = "UPDATE user SET userName = '$userName', 
userEmail = '$userEmail', 
telephone = '$telephone'
WHERE userId = '$userId'";
try {
    if ($conn->query($sqlinsert) === true) {

        $decoded_string = base64_decode($image);

        $filename = mysqli_insert_id($conn);
        $path = 'C:/xampp1/htdocs/homestay/assets/userProfileImages/' . $filename . '.png';
        file_put_contents($path, $decoded_string);


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
