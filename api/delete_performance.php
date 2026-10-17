<?php
require 'auth.php'; $authUser = requireAuth(['Admin','Coordinator']);
$id = $_GET['id'] ?? 0;
$pdo->prepare("DELETE FROM tblperformance WHERE PerformanceID=?")->execute([$id]);
echo json_encode(["success"=>true,"message"=>"Performance deleted"]);
