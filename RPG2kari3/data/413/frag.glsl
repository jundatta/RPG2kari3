precision mediump float;

uniform float uFrameCount;

varying vec3 vNormal;
varying vec3 vPosition;

void main() {
	vec3 ambientColor = vec3(0.0, 0.0, 1.0);
	vec3 diffuseColor = vec3(0.0, 1.0, 0.0);
	vec3 specularColor = vec3(1.0, 0.0, 0.0);

	float time = uFrameCount *  0.1;
	vec3 lightPos = vec3(-50. * cos(time), 20.* sin(time), -50.);
	vec3 lightDir = normalize(lightPos - vPosition);
	float lambertian = max(dot(-vNormal, lightDir), 0.0);
	float specular = 0.0; 
	if(lambertian > 0.0) {
		vec3 reflectLight = reflect(-lightDir, vNormal); 
		vec3 viewerDir = normalize(-vPosition);
		float specAngle = max(dot(reflectLight, viewerDir), 0.0);
		specular = pow(specAngle, 128.);
	}
	gl_FragColor = vec4(ambientColor + lambertian * diffuseColor + specular * specularColor, 1.0);
}
