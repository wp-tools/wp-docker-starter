<?php
/**
 * Bootstraps WP Redis Advanced Cache.
 *
 * @package WordPress
 */

if ( defined( 'WP_CACHE' ) && true === WP_CACHE ) {
	require_once WP_CONTENT_DIR . '/plugins/pj-page-cache-red/advanced-cache.php';
}
