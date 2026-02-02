shader_type canvas_item;
uniform float strength = 1;
uniform float speed = 3.0;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    vec2 uv = UV; // 0 to 1
    uv.y += sin(uv.x * 10.0 + TIME * speed) * strength;
    COLOR = texture(TEXTURE, uv);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
