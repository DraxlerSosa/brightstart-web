<?php
require 'auth.php';
$token = bearer_token();
if ($token) {
    $pdo->prepare("DELETE FROM tblauthtoken WHERE TokenHash = ?")->execute([hash('sha256', $token)]);
}
respond(['success' => true, 'message' => 'Logged out']);
