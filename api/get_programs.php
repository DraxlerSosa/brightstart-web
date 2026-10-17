<?php
require 'auth.php'; $authUser = requireAuth();
$stmt = $pdo->query("SELECT * FROM tblprogram ORDER BY ProgramID DESC");
echo json_encode(["success"=>true,"data"=>$stmt->fetchAll(PDO::FETCH_ASSOC)]);
