<?php
require 'auth.php'; $authUser = requireAuth(['Admin','Coordinator']);
$id = $_GET['id'] ?? 0;
$pdo->prepare("DELETE FROM tblvolunteer WHERE VolunteerID=?")->execute([$id]);
echo json_encode(["success"=>true,"message"=>"Volunteer deleted"]);
