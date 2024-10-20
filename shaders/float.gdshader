shader_type canvas_item;

void vertex() {
	VERTEX += vec2(0,4.*sin(TIME*2.));
}

void fragment() {
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
