shader_type canvas_item;

uniform sampler2D noise;

void fragment(){
	vec4 starColor = vec4(1.0,1.0,1.0,1.0);
	float starSpeed = 5.0;
	float starVariance = 1.0;
	vec2 newUV = UV;
	newUV.x += sin(TIME*0.005);
	newUV.y += cos(TIME*0.005);
	vec4 normal = texture(noise, newUV);
	COLOR = normal;
	COLOR = texture(TEXTURE, UV);
	
	if(COLOR.r + normal.r >  0.8){
		COLOR = starColor * (1.0 - (starSpeed+1.0)*starVariance*0.5);
	}
	if(COLOR.r == 0.0){
		COLOR.a = 0.0;	
	}
}

void light(){
	vec4 c = texture(TEXTURE, UV);
	
	if(c.r >  0.2){
		LIGHT = c;
	}
}