<?php
require 'auth.php'; $authUser = requireAuth(['Admin','Coordinator']);
$id = $_GET['id'] ?? 0;
$pdo->prepare("DELETE FROM tblstudent WHERE StudentID=?")->execute([$id]);
echo json_encode(["success"=>true,"message"=>"Student deleted"]);
