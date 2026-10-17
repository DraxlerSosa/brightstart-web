<?php
require 'db.php';
$data     = json_input();
$fullName = trim($data['full_name'] ?? '');
$email    = trim($data['email'] ?? '');
$username = trim($data['username'] ?? '');
$password = (string)($data['password'] ?? '');
$role     = $data['role'] ?? 'Volunteer';

if ($fullName === '' || $email === '' || $username === '' || $password === '') {
    respond(['success' => false, 'message' => 'All fields are required'], 400);
}
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    respond(['success' => false, 'message' => 'Enter a valid email address'], 400);
}
if (!preg_match('/^[A-Za-z0-9_.]{3,30}$/', $username)) {
    respond(['success' => false, 'message' => 'Username must be 3-30 letters, numbers, . or _'], 400);
}
if (strlen($password) < 8 || !preg_match('/[A-Za-z]/', $password) || !preg_match('/\d/', $password)) {
    respond(['success' => false, 'message' => 'Password must be at least 8 characters with a letter and a number'], 400);
}
// Self-registration can never create an Admin; an existing Admin promotes users.
if (!in_array($role, ['Volunteer', 'Coordinator', 'Management'], true)) $role = 'Volunteer';

$check = $pdo->prepare("SELECT AdminID FROM administrator WHERE Email = ? OR Username = ?");
$check->execute([$email, $username]);
if ($check->fetch()) {
    respond(['success' => false, 'message' => 'Email or username already exists'], 409);
}

$hash = password_hash($password, PASSWORD_BCRYPT);
$pdo->prepare("INSERT INTO administrator (FullName,Email,Username,PasswordHash,Role,Verified) VALUES (?,?,?,?,?,0)")
    ->execute([$fullName, $email, $username, $hash, $role]);

respond(['success' => true, 'message' => 'Account created. Please wait for administrator approval before logging in.']);
