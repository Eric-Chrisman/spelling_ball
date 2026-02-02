shader_type canvas_item;

const float SPEED = 1.0;
const float MAGITUDE = 100.0;

void vertex() {
	// Called for every vertex the material is visible on.
	if (VERTEX.y < 0.0) {
		VERTEX.r += sin(TIME * SPEED) * MAGITUDE;
	}
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
