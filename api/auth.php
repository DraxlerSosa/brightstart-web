<?php
/**
 * Token authentication. Include in every protected endpoint:
 *     require 'auth.php';
 *     $authUser = requireAuth();                 // any approved user
 *     $authUser = requireAuth(['Admin']);        // restrict by role
 * Tokens are random 256-bit values; only their SHA-256 hash is stored.
 */
require_once __DIR__ . '/db.php';

const TOKEN_LIFETIME_DAYS = 7;

function bearer_token(): ?string {
    $h = $_SERVER['HTTP_AUTHORIZATION'] ?? $_SERVER['REDIRECT_HTTP_AUTHORIZATION'] ?? '';
    if ($h === '' && function_exists('getallheaders')) {
        foreach (getallheaders() as $k => $v) {
            if (strtolower($k) === 'authorization') { $h = $v; break; }
        }
    }
    return preg_match('/^Bearer\s+(\S+)$/i', $h, $m) ? $m[1] : null;
}

function issueToken(int $adminId): string {
    global $pdo;
    $pdo->prepare("DELETE FROM tblauthtoken WHERE ExpiresAt < NOW()")->execute();
    $token = bin2hex(random_bytes(32));
    $pdo->prepare("INSERT INTO tblauthtoken (AdminID, TokenHash, ExpiresAt)
                   VALUES (?, ?, DATE_ADD(NOW(), INTERVAL " . TOKEN_LIFETIME_DAYS . " DAY))")
        ->execute([$adminId, hash('sha256', $token)]);
    return $token;
}

function requireAuth(array $roles = []): array {
    global $pdo;
    $token = bearer_token();
    if (!$token) respond(['success' => false, 'message' => 'Authentication required'], 401);

    $st = $pdo->prepare(
        "SELECT a.AdminID, a.FullName, a.Email, a.Username, a.Role, a.Verified
           FROM tblauthtoken t JOIN administrator a ON a.AdminID = t.AdminID
          WHERE t.TokenHash = ? AND t.ExpiresAt > NOW()");
    $st->execute([hash('sha256', $token)]);
    $user = $st->fetch();

    if (!$user || (int)$user['Verified'] !== 1) {
        respond(['success' => false, 'message' => 'Session expired. Please log in again.'], 401);
    }
    if ($roles && !in_array($user['Role'], $roles, true)) {
        respond(['success' => false, 'message' => 'You do not have permission to do that'], 403);
    }
    return $user;
}

function valid_password(string $p): bool {
    return strlen($p) >= 8 && preg_match('/[A-Za-z]/', $p) && preg_match('/\d/', $p);
}
