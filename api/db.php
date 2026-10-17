<?php
/**
 * Shared bootstrap for every API endpoint.
 * Configuration comes from environment variables (Azure App Service ->
 * Settings -> Environment variables), with local XAMPP defaults as a fallback.
 */
ini_set('display_errors', '0');          // never leak PHP errors to clients
error_reporting(E_ALL);

function env_or(string $key, string $default = ''): string {
    $v = getenv($key);
    return ($v === false || $v === '') ? $default : $v;
}

function respond(array $payload, int $status = 200): void {
    http_response_code($status);
    echo json_encode($payload);
    exit();
}

function json_input(): array {
    $d = json_decode(file_get_contents('php://input'), true);
    return is_array($d) ? $d : [];
}

// --- Headers ---------------------------------------------------------------
header('Content-Type: application/json; charset=utf-8');
$cors = env_or('CORS_ORIGIN', '');
if ($cors !== '') {
    header('Access-Control-Allow-Origin: ' . $cors);
    header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, Authorization');
}
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(204); exit(); }

// --- Global error handling: generic message out, detail to the server log --
set_exception_handler(function (Throwable $e) {
    error_log('[BrightStart API] ' . get_class($e) . ': ' . $e->getMessage());
    if ($e instanceof PDOException && (string)$e->getCode() === '23000') {
        respond(['success' => false, 'message' => 'Invalid reference or duplicate value'], 400);
    }
    respond(['success' => false, 'message' => 'Server error. Please try again.'], 500);
});

// --- Database --------------------------------------------------------------
$host = env_or('DB_HOST', 'localhost');
$db   = env_or('DB_NAME', 'brightstart');
$user = env_or('DB_USER', 'root');
$pass = env_or('DB_PASS', '');
$port = env_or('DB_PORT', '3306');

$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
];
if (env_or('DB_SSL', '0') === '1') {      // Azure Database for MySQL requires TLS
    $options[PDO::MYSQL_ATTR_SSL_CA] = env_or('DB_SSL_CA', '/etc/ssl/certs/ca-certificates.crt');
    $options[PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT] = false;
}

try {
    $pdo = new PDO("mysql:host=$host;port=$port;dbname=$db;charset=utf8mb4", $user, $pass, $options);
} catch (PDOException $e) {
    error_log('[BrightStart API] DB connect failed: ' . $e->getMessage());
    respond(['success' => false, 'message' => 'Service temporarily unavailable'], 503);
}
