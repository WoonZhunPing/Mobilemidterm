<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
   
    die();
}
include_once("dbconnect.php");

$roomId = $_POST['roomId'];
$roomName = $_POST['roomName'];
$roomDesc = $_POST['roomDesc'];
$roomCategory = $_POST['roomCategory'];
$roomProperty = $_POST['roomProperty'];
$roomPrice = $_POST['roomPrice'];
$roomState = $_POST['roomState'];
$roomLocality = $_POST['roomLocality'];
$roomLatitude =$_POST['roomLatitude'];
$roomLongitude =$_POST['roomLongtitude'];
$userId = $_POST['userId'];
// $image = $_POST['image'];
// $image1 = $_POST['image1'];
// $image2 = $_POST['image2'];


$sqlinsert = "UPDATE room SET roomName = '$roomName', 
roomDesc = '$roomDesc', 
roomCategory = '$roomCategory', 
roomProperty = '$roomProperty', 
roomPrice = '$roomPrice', 
roomState ='$roomState', 
roomLocality = '$roomLocality', 
roomLatitude = '$roomLatitude', 
roomLongitude = '$roomLongitude' 
WHERE roomId = '$roomId'";
try {
    if ($conn->query($sqlinsert) === true) {
        
        // $decoded_string = base64_decode($image);
        // $decoded_string1 = base64_decode($image1);
        // $decoded_string2 = base64_decode($image2);
		// 	$filename = mysqli_insert_id($conn);
		// 	$path = 'C:/xampp1/htdocs/homestay/assets/roomImages/'.$filename.'_1.png';
        //     $path1 = 'C:/xampp1/htdocs/homestay/assets/roomImages/'.$filename.'_2.png';
        //     $path2 = 'C:/xampp1/htdocs/homestay/assets/roomImages/'.$filename.'_3.png';
		// 	file_put_contents($path, $decoded_string);
        //     file_put_contents($path1, $decoded_string1);
        //     file_put_contents($path2, $decoded_string2);
         
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