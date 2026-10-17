<?php
require 'auth.php';
$u = requireAuth();
respond(['success' => true, 'user' => $u]);
