<?php
/**
 * Single sign-on with Google.
 * The Android app signs in with Google, gets an ID token and POSTs it here.
 * We verify it with Google, then issue our own API token.
 * Env: GOOGLE_CLIENT_ID (the *Web* OAuth client id), SSO_AUTO_APPROVE (0/1).
 */
require 'auth.php';
$data    = json_input();
$idToken = trim($data['id_token'] ?? '');
$client  = env_or('GOOGLE_CLIENT_ID');

if ($client === '')  respond(['success' => false, 'message' => 'Google sign-in is not configured on the server'], 503);
if ($idToken === '') respond(['success' => false, 'message' => 'Missing Google token'], 400);

$ch = curl_init('https://oauth2.googleapis.com/tokeninfo?id_token=' . urlencode($idToken));
curl_setopt_array($ch, [CURLOPT_RETURNTRANSFER => true, CURLOPT_TIMEOUT => 8]);
$raw  = curl_exec($ch);
$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

$g = $raw ? json_decode($raw, true) : null;
if ($code !== 200 || !is_array($g)) {
    respond(['success' => false, 'message' => 'Google sign-in failed. Please try again.'], 401);
}
$issOk = in_array($g['iss'] ?? '', ['accounts.google.com', 'https://accounts.google.com'], true);
if (($g['aud'] ?? '') !== $client || !$issOk
    || ($g['email_verified'] ?? '') !== 'true' || (int)($g['exp'] ?? 0) < time()) {
    respond(['success' => false, 'message' => 'Google sign-in could not be verified'], 401);
}

$email = strtolower($g['email']);
$sub   = $g['sub'];
$name  = $g['name'] ?? explode('@', $email)[0];

$st = $pdo->prepare("SELECT * FROM administrator WHERE Email = ?");
$st->execute([$email]);
$user = $st->fetch();

if (!$user) {
    // First SSO login: create a Volunteer account (approval gate stays on by default)
    $base = preg_replace('/[^A-Za-z0-9_.]/', '', explode('@', $email)[0]);
    $uname = substr($base !== '' ? $base : 'user', 0, 24);
    $chk = $pdo->prepare("SELECT 1 FROM administrator WHERE Username = ?");
    $chk->execute([$uname]);
    if ($chk->fetch()) $uname .= random_int(100, 999);
    $approved = env_or('SSO_AUTO_APPROVE', '0') === '1' ? 1 : 0;
    $pdo->prepare("INSERT INTO administrator (FullName,Email,Username,PasswordHash,Role,Verified,GoogleSub) VALUES (?,?,?,?,?,?,?)")
        ->execute([$name, $email, $uname, password_hash(bin2hex(random_bytes(16)), PASSWORD_BCRYPT), 'Volunteer', $approved, $sub]);
    $st->execute([$email]);
    $user = $st->fetch();
} elseif (empty($user['GoogleSub'])) {
    $pdo->prepare("UPDATE administrator SET GoogleSub = ? WHERE AdminID = ?")->execute([$sub, $user['AdminID']]);
}

if ((int)$user['Verified'] === 0) {
    respond(['success' => false, 'message' => 'Your account is pending administrator approval'], 403);
}

unset($user['PasswordHash'], $user['GoogleSub']);
respond(['success' => true, 'message' => 'Login successful',
         'token' => issueToken((int)$user['AdminID']), 'user' => $user]);
