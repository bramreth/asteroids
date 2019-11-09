shader_type canvas_item;

uniform sampler2D noise;

void fragment(){
	vec4 starColor = vec4(1.0,1.0,1.0,1.0);
	float starSpeed = 15.0;
	float starVariance = 11.0;
	vec2 newUV = UV;
	newUV.x += sin(TIME*0.5);
	newUV.y += cos(TIME*0.5);
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
