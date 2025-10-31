shader_type canvas_item;

uniform float strength = 5.0;
uniform float dynamics = 5.0;
uniform float speed = 5.0;

void vertex() {
	VERTEX.y += sin(VERTEX.x * dynamics + TIME * 0.5 * speed) * strength;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
