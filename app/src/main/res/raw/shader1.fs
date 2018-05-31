/*
 * Copyright (C) 2010-2012 Josh A. Beam
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *   1. Redistributions of source code must retain the above copyright
 *      notice, this list of conditions and the following disclaimer.
 *   2. Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

const int NUM_LIGHTS = 3;
const lowp vec3 AMBIENT = vec3(0.1, 0.1, 0.1);
const lowp float MAX_DIST = 2.5;
const lowp float MAX_DIST_SQUARED = MAX_DIST * MAX_DIST;

uniform sampler2D normalmap;
uniform lowp vec3 lightColor[NUM_LIGHTS];

varying lowp vec2 fragmentTexCoords;
varying lowp vec3 cameraVector;
varying lowp vec3 lightVector[NUM_LIGHTS];

void
main()
{
	// initialize diffuse/specular lighting
	lowp vec3 diffuse = vec3(0.0, 0.0, 0.0);
	lowp vec3 specular = vec3(0.0, 0.0, 0.0);

	// get the fragment normal and camera direction
	lowp vec3 fragmentNormal = (texture2D(normalmap, fragmentTexCoords).rgb * 2.0) - 1.0;
	lowp vec3 normal = normalize(fragmentNormal);
	lowp vec3 cameraDir = normalize(cameraVector);

	// loop through each light
	for(int i = 0; i < NUM_LIGHTS; ++i) {
		// calculate distance between 0.0 and 1.0
		lowp float dist = min(dot(lightVector[i], lightVector[i]), MAX_DIST_SQUARED) / MAX_DIST_SQUARED;
		lowp float distFactor = 1.0 - dist;

		// diffuse
		lowp vec3 lightDir = normalize(lightVector[i]);
		lowp float diffuseDot = dot(normal, lightDir);
		diffuse += lightColor[i] * clamp(diffuseDot, 0.0, 1.0) * distFactor;

		// specular
		lowp vec3 halfAngle = normalize(cameraDir + lightDir);
		lowp vec3 specularColor = min(lightColor[i] + 0.5, 1.0);
		lowp float specularDot = dot(normal, halfAngle);
		specular += specularColor * pow(clamp(specularDot, 0.0, 1.0), 16.0) * distFactor;
	}

	lowp vec4 sample = vec4(1.0, 1.0, 1.0, 1.0);
	gl_FragColor = vec4(clamp(sample.rgb * (diffuse + AMBIENT) + specular, 0.0, 1.0), sample.a);
}
