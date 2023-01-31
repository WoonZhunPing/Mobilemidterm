<?php
include_once("dbconnect.php");
$results_per_page = 6;
$pageno = (int)$_GET['pageno'];
$page_first_result = ($pageno - 1) * $results_per_page;

$sqlroom = "SELECT * FROM room ";
$result = $conn->query($sqlroom);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);

$sqlroom = $sqlroom."LIMIT $page_first_result , $results_per_page";
$result = $conn->query($sqlroom);

if ($result->num_rows > 0) {
    $roomarray["rooms"] = array();
    while ($row = $result->fetch_assoc()) {
        $roomlist = array();
        $roomlist['roomId'] = $row['roomId'];
        $roomlist['roomName'] = $row['roomName'];
        $roomlist['roomDesc'] = $row['roomDesc'];
        $roomlist['roomCategory'] = $row['roomCategory'];
        $roomlist['roomProperty'] = $row['roomProperty'];
        $roomlist['roomPrice'] = $row['roomPrice'];
        $roomlist['roomState'] = $row['roomState'];
        $roomlist['roomLocality'] = $row['roomLocality'];
        $roomlist['roomLatitude'] = $row['roomLatitude'];
        $roomlist['roomLongitude'] = $row['roomLongitude'];
        $roomlist['roomRegDate'] = $row['roomRegDate'];
        $roomlist['userId'] = $row['userId'];
        array_push($roomarray["rooms"], $roomlist);
    }
    $response = array('status' => 'success', 'numofpage'=>"$number_of_page",'numberofresult'=>"$number_of_result",'data' => $roomarray);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
