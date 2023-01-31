<?php
error_reporting(0);
if (!isset($_GET['querySearch'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
$querySearch = $_GET['querySearch'];
include_once("dbconnect.php");
$sqlroom = "SELECT * FROM room WHERE roomName LIKE '%$querySearch%'";

$result = $conn-> query($sqlroom);

if ($result->num_rows > 0) {
    $searcharray["result"] = array();
    while ($row = $result->fetch_assoc()) {
        $searchlist = array();
        $searchlist['roomId'] = $row['roomId'];
        $searchlist['roomName'] = $row['roomName'];
        $searchlist['roomDesc'] = $row['roomDesc'];
        $searchlist['roomCategory'] = $row['roomCategory'];
        $searchlist['roomProperty'] = $row['roomProperty'];
        $searchlist['roomPrice'] = $row['roomPrice'];
        $searchlist['roomState'] = $row['roomState'];
        $searchlist['roomLocality'] = $row['roomLocality'];
        $searchlist['roomLatitude'] = $row['roomLatitude'];
        $searchlist['roomLongitude'] = $row['roomLongitude'];
        $searchlist['roomRegDate'] = $row['roomRegDate'];
        $searchlist['userId'] = $row['userId'];
        array_push($searcharray["result"], $searchlist);
    }
    $response = array('status' => 'success', 'data' => $searcharray);
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
