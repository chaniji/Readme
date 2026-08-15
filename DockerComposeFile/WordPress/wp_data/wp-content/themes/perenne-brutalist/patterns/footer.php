<?php declare( strict_types = 1 ); ?>
<?php
/**
 * Title: footer
 * Slug: perenne/footer
 * Inserter: no
 */
?>
<!-- wp:group {"className":"nv-footer","layout":{"type":"constrained"}} -->
<div class="wp-block-group nv-footer"><!-- wp:paragraph -->
<p><?php /* Translators: 1. is the start of a 'a' HTML element, 2. is the end of a 'a' HTML element */
echo sprintf( esc_html__( 'Designed with %1$sWordPress%2$s, in the spirit of Nouvelle', 'perenne' ), '<a href="' . esc_url( 'https://wordpress.org' ) . '" rel="nofollow">', '</a>' ); ?></p>
<!-- /wp:paragraph --></div>
<!-- /wp:group -->
