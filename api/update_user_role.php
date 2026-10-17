<?php
require 'auth.php'; $authUser = requireAuth(['Admin']);
$r    = json_decode(file_get_contents("php://input"), true);
$id   = $r['admin_id'] ?? 0;
$role = $r['role'] ?? 'Volunteer';
if (!in_array($role, ['Admin','Coordinator','Volunteer','Management'], true)) respond(['success'=>false,'message'=>'Invalid role'], 400);
$pdo->prepare("UPDATE administrator SET Role=? WHERE AdminID=?")->execute([$role,$id]);
echo json_encode(["success"=>true,"message"=>"Role updated"]);
