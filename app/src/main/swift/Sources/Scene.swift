/*
 * Copyright (C) 2015 Josh A. Beam
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

import Foundation
#if os(macOS)
import OpenGL
#else
import OpenGLES
#endif

let NUM_LIGHTS = 3

class Scene {
    private var program: ShaderProgram
    private var programProjectionMatrixLocation: GLuint
    private var programModelviewMatrixLocation: GLuint
    private var programCameraPositionLocation: GLuint
    private var programLightPositionLocation: GLuint
    private var programLightColorLocation: GLuint

    private var lightPosition = [Float](repeating: 0.0, count: NUM_LIGHTS * 3)
    private var lightColor: [Float] = [1.0, 0.0, 0.0,
                                       0.0, 1.0, 0.0,
                                       0.0, 0.0, 1.0]
    private var lightRotation: Float = 0.0

    private var normalmap: Texture?
    private var renderable: Renderable

    private var cameraRotation: Float = 0.0
    private var cameraPosition: [Float] = [0.0, 0.0, 4.0]

    init() {
        // Create the program, attach shaders, and link.
        program = ShaderProgram()
        program.attachShader("shader.vs", withType: GL_VERTEX_SHADER)
        program.attachShader("shader.fs", withType: GL_FRAGMENT_SHADER)
        program.link()

        // Get uniform locations.
        programProjectionMatrixLocation = program.getUniformLocation("projectionMatrix")!
        programModelviewMatrixLocation = program.getUniformLocation("modelviewMatrix")!
        programCameraPositionLocation = program.getUniformLocation("cameraPosition")!
        programLightPositionLocation = program.getUniformLocation("lightPosition")!
        programLightColorLocation = program.getUniformLocation("lightColor")!

        normalmap = Texture.loadFromFile("normalmap.png")
        renderable = Cylinder(program: program, numberOfDivisions: 36)
    }

    func render(_ projectionMatrix: Matrix4) {
        let translationMatrix = Matrix4.translationMatrix(x: -cameraPosition[0], y: -cameraPosition[1], z: -cameraPosition[2])
        let rotationMatrix = Matrix4.rotationMatrix(angle: cameraRotation, x: 0.0, y: -1.0, z: 0.0)
        let modelviewMatrix = translationMatrix * rotationMatrix

        // Enable the program and set uniform variables.
        program.use()
        glUniformMatrix4fv(GLint(programProjectionMatrixLocation), 1, GLboolean(GL_FALSE), UnsafePointer<GLfloat>(projectionMatrix.matrix))
        glUniformMatrix4fv(GLint(programModelviewMatrixLocation), 1, GLboolean(GL_FALSE), UnsafePointer<GLfloat>(modelviewMatrix.matrix))
        glUniform3fv(GLint(programCameraPositionLocation), 1, UnsafePointer<GLfloat>(cameraPosition))
        glUniform3fv(GLint(programLightPositionLocation), GLint(NUM_LIGHTS), UnsafePointer<GLfloat>(lightPosition))
        glUniform3fv(GLint(programLightColorLocation), GLint(NUM_LIGHTS), UnsafePointer<GLfloat>(lightColor))

        // Render the object.
        renderable.render()

        // Disable the program.
        glUseProgram(0)
    }

    func cycle(_ secondsElapsed: Float) {
        // Update the light positions.
        lightRotation += (Float.pi / 4.0) * secondsElapsed
        for i in 0..<NUM_LIGHTS {
            let radius: Float = 1.75
            let r = (((Float.pi * 2.0) / Float(NUM_LIGHTS)) * Float(i)) + lightRotation

            lightPosition[i * 3 + 0] = cosf(r) * radius
            lightPosition[i * 3 + 1] = cosf(r) * sinf(r)
            lightPosition[i * 3 + 2] = sinf(r) * radius
        }

        // Update the camera position.
        cameraRotation -= (Float.pi / 16.0) * secondsElapsed
        cameraPosition[0] = sinf(cameraRotation) * 4.0
        cameraPosition[1] = 0.0
        cameraPosition[2] = cosf(cameraRotation) * 4.0
    }
}
