<?php
require 'auth.php';
$u    = requireAuth();
$data = json_input();
$name = trim($data['full_name'] ?? '');
$user = trim($data['username'] ?? '');

if ($name === '' || strlen($name) > 100) respond(['success' => false, 'message' => 'Enter your full name'], 400);
if (!preg_match('/^[A-Za-z0-9_.]{3,30}$/', $user)) {
    respond(['success' => false, 'message' => 'Username must be 3-30 letters, numbers, . or _'], 400);
}
$chk = $pdo->prepare("SELECT 1 FROM administrator WHERE Username = ? AND AdminID <> ?");
$chk->execute([$user, $u['AdminID']]);
if ($chk->fetch()) respond(['success' => false, 'message' => 'That username is already taken'], 409);

$pdo->prepare("UPDATE administrator SET FullName = ?, Username = ? WHERE AdminID = ?")
    ->execute([$name, $user, $u['AdminID']]);
$u['FullName'] = $name;
$u['Username'] = $user;
respond(['success' => true, 'message' => 'Profile updated', 'user' => $u]);
