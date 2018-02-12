<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'wordpress');

/** MySQL database username */
define('DB_USER', 'root');

/** MySQL database password */
define('DB_PASSWORD', 'secretpw');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8mb4');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'SFT75]~b0V1{XcJ#zR4N3ufgk^JT;DB~rD(/A_(PS#aI5#pF06SlcU@+({)ZLxVI');
define('SECURE_AUTH_KEY',  'O }{8qBY-8 2(-f8EiGkGd`nKt?}APRwg)0jM-a8h}k3Ae8[.q|4:7Qax?J6-CHT');
define('LOGGED_IN_KEY',    '3PRk!rD#2)$md5,V<o_Cz,;:iYj,M@93eRoa%`^,!jw3=4@26oXik97!}v|vh$t?');
define('NONCE_KEY',        'FwYg<qRad[8,Sr-~`d@+R6W/;rDjjVXKoWi/3L;/Ng|g@LEcbW%/CE{p`*kvM.lJ');
define('AUTH_SALT',        '$j&bT74:BeSp n[J55R)MRp4GqzeLB*G:Q|uim;5$g% 3KrXw-p#q:FU=vx=@+|@');
define('SECURE_AUTH_SALT', '9:W^?IuO-dEqe#K:e*^a%|+2nu[?Z)Px*&2y$YYL:FV{CH$v9=UlEzYM$ujz_/T#');
define('LOGGED_IN_SALT',   '@l)Y/_5W9LGi|xYvYi{s5>GSavuB|%^j^fi]83Sw]~01hqt[v{,5#(?ebi5<uLw0');
define('NONCE_SALT',       'T=!e/FMIY6I8nsB0)6i9rwb(@j>sIsh`1CL-dZkp1E*A&C.at{7GogN=/w& 4 ]A');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
