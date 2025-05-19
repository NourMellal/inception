<?php
define('DB_NAME', getenv('MYSQL_DATABASE'));
define('DB_USER', getenv('MYSQL_USER'));
define('DB_PASSWORD', getenv('MYSQL_PASSWORD'));
define('DB_HOST', 'mariadb');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

// Authentication Unique Keys and Salts
define('AUTH_KEY',         'z++C+.DQC*t16XDV&v8!sR|@->FIaA>yF>3~5m-./;rAiW/|C-5 BphEjzZf8-@=');
define('SECURE_AUTH_KEY',  ':_>9a% zlTmgkS!*mP18~(DKFhx<Y75Aq?v-5!.W8 gF`WZ?-sSzbt]z-h?h.@v3');
define('LOGGED_IN_KEY',    't|9k>8<1g`khfa_$)+9=+@xA,vE;AD:u3R-z|YAeoHOI6|w_VGD&_P%0SsqaJqu[');
define('NONCE_KEY',        'wONvbm[x)4}gtsZ~-|wn#(B.vaq;esMl|Qi_Z5k6bN+F0+kQP{,9xSrA3`b8liO+');
define('AUTH_SALT',        '=k)%Ue:-a2*_<&U{Uj<N][%p[jA]2<J6Z]pcH&Tq|I]o+Y[&rvf&yH6j-I(WR7q`');
define('SECURE_AUTH_SALT', 'BT#$_~|9C>][K%1izEtk(lRh;Q]8Y(Jdit=AlE~xNz-sXs&[Qm8I#2sK)4K#M5rc');
define('LOGGED_IN_SALT',   'SKHrEK,0b:nYc,.|0YP[Qy|1Ao!yb*0f{.fSH:Pk[w399+@j@[Oy,Pp?<hX*g[K/');
define('NONCE_SALT',       '5O6H gNQj7vt1+{5~C<nGPtd/jbR<y;]_CG7/7BW_9c9ibzdz7]1Id}h^u>WtA(H');

$table_prefix = 'wp_';
define('WP_DEBUG', true);

if (!defined('ABSPATH'))
    define('ABSPATH', dirname(__FILE__) . '/');

require_once(ABSPATH . 'wp-settings.php');