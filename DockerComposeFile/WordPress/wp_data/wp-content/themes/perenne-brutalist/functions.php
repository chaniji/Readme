<?php
declare( strict_types = 1 );

add_action( 'wp_enqueue_scripts', function (): void {
	wp_enqueue_style(
		'perenne-brutalist-fonts',
		'https://fonts.googleapis.com/css2?family=Grenze:ital,wght@0,300;0,400;0,600;0,700;1,400&family=Fraunces:ital,wght@0,600;0,700;1,600&family=MonteCarlo&display=swap',
		[],
		null
	);
} );
