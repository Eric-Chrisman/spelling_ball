shader_type canvas_item;

const vec4 TARGET_COLOR = vec4(0, 0, 0, 255);
const vec4 DESIRED_COLOR = vec4(255, 255, 255, 255);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (all(lessThan(COLOR - TARGET_COLOR, vec4(10)))) {
		COLOR = DESIRED_COLOR;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
