<?php
require 'auth.php';
$data     = json_input();
$email    = trim($data['email'] ?? '');
$password = (string)($data['password'] ?? '');

if ($email === '' || $password === '') {
    respond(['success' => false, 'message' => 'Email and password are required'], 400);
}

$stmt = $pdo->prepare("SELECT * FROM administrator WHERE Email = ?");
$stmt->execute([$email]);
$user = $stmt->fetch();

// Same message for unknown email and wrong password (no account enumeration)
if (!$user || !password_verify($password, $user['PasswordHash'])) {
    respond(['success' => false, 'message' => 'Invalid email or password'], 401);
}
if ((int)$user['Verified'] === 0) {
    respond(['success' => false, 'message' => 'Your account is pending administrator approval'], 403);
}

unset($user['PasswordHash'], $user['GoogleSub']);
respond([
    'success' => true,
    'message' => 'Login successful',
    'token'   => issueToken((int)$user['AdminID']),
    'user'    => $user,
]);
