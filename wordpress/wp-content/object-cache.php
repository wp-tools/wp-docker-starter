<?php
/**
 * Bootstraps WP Redis.
 *
 * @package WordPress
 */

// Windows-friendly symlink.
if ( defined( 'WP_CACHE' ) && true === WP_CACHE ) {
	require_once WP_CONTENT_DIR . '/plugins/wp-redis/object-cache.php';
}
