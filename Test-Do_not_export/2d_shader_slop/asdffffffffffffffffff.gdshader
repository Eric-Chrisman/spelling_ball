shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.rgb = (sin(TIME * 3.0 * UV.y) * (UV.x + UV.y)) * texture(TEXTURE, UV).rgb;
	}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
