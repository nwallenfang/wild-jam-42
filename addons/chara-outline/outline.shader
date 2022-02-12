/*
	アウトライン検出シェーダー by あるる（きのもと 結衣）
	Outline Shader by Yui Kinomoto @arlez80

	MIT License
*/

shader_type canvas_item;
render_mode unshaded;

uniform float luma_coef = 1024.0;
uniform float line_size = 1.0;

void fragment( )
{
	vec2 pixel_scale = SCREEN_PIXEL_SIZE * line_size;
	vec3 color = texture( SCREEN_TEXTURE, SCREEN_UV ).rgb;

	vec3 x = (
	-	texture( SCREEN_TEXTURE, SCREEN_UV + vec2( -1.0, 0.0 ) * pixel_scale ).rgb
	+	texture( SCREEN_TEXTURE, SCREEN_UV + vec2(  1.0, 0.0 ) * pixel_scale ).rgb
	);
	vec3 y = (
	-	texture( SCREEN_TEXTURE, SCREEN_UV + vec2( 0.0, -1.0 ) * pixel_scale ).rgb
	+	texture( SCREEN_TEXTURE, SCREEN_UV + vec2( 0.0,  1.0 ) * pixel_scale ).rgb
	);
	vec3 filtered = sqrt( x * x + y * y );

	COLOR = vec4( vec3( clamp( filtered.r * luma_coef, 0.0, 1.0 ) ), 1.0 );
//	COLOR = vec4( vec3( clamp( ( filtered.r - color.g - filtered.g ) * luma_coef, 0.0, 1.0 ) ), 1.0 );
}
