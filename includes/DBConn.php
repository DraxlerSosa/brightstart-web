<?php
// Reads the same environment variables as api/db.php (Azure App Service settings),
// falling back to local XAMPP defaults.
function _env($k, $d) { $v = getenv($k); return ($v === false || $v === '') ? $d : $v; }
$db_host     = _env('DB_HOST', 'localhost');
$db_user     = _env('DB_USER', 'root');
$db_password = _env('DB_PASS', '');
$db_name     = _env('DB_NAME', 'brightstart');
$db_port     = (int)_env('DB_PORT', '3306');

mysqli_report(MYSQLI_REPORT_OFF);
$conn = mysqli_init();
if (_env('DB_SSL', '0') === '1') {
    $conn->ssl_set(null, null, _env('DB_SSL_CA', '/etc/ssl/certs/ca-certificates.crt'), null, null);
    $conn->options(MYSQLI_OPT_SSL_VERIFY_SERVER_CERT, false);
}
if (!@$conn->real_connect($db_host, $db_user, $db_password, $db_name, $db_port)) {
    error_log('DB connection failed: ' . $conn->connect_error);
    die("<p style='color:red;font-family:Arial;'><strong>Service temporarily unavailable.</strong> Please try again later.</p>");
}
$conn->set_charset("utf8mb4");
?>