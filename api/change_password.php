<?php
require 'auth.php';
$u    = requireAuth();
$data = json_input();
$cur  = (string)($data['current_password'] ?? '');
$new  = (string)($data['new_password'] ?? '');

if (!valid_password($new)) {
    respond(['success' => false, 'message' => 'New password must be at least 8 characters with a letter and a number'], 400);
}
$st = $pdo->prepare("SELECT PasswordHash FROM administrator WHERE AdminID = ?");
$st->execute([$u['AdminID']]);
$hash = $st->fetchColumn();
if (!$hash || !password_verify($cur, $hash)) {
    respond(['success' => false, 'message' => 'Current password is incorrect'], 400);
}
$pdo->prepare("UPDATE administrator SET PasswordHash = ? WHERE AdminID = ?")
    ->execute([password_hash($new, PASSWORD_BCRYPT), $u['AdminID']]);
// Sign out every other device
$pdo->prepare("DELETE FROM tblauthtoken WHERE AdminID = ? AND TokenHash <> ?")
    ->execute([$u['AdminID'], hash('sha256', bearer_token())]);
respond(['success' => true, 'message' => 'Password changed']);
