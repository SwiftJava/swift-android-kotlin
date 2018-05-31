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

class Cylinder: Renderable {
    private var numVertices = 0
    private var vertexArrayId: GLuint = 0
    private var bufferIds = [GLuint](repeating: 0, count: 5)

    init(program: ShaderProgram, numberOfDivisions divisions: Int) {
        let divisionsf = Float(divisions)

        numVertices = (divisions + 1) * 2
        let size = numVertices * 3
        let tcSize = numVertices * 2

        // Generate vertex data.
        var p = [Float](repeating: 0.0, count: size)
        var tc = [Float](repeating: 0.0, count: tcSize)
        var t = [Float](repeating: 0.0, count: size)
        var b = [Float](repeating: 0.0, count: size)
        var n = [Float](repeating: 0.0, count: size)
        for i in 0...divisions {
            let r1 = ((Float.pi * 2.0) / divisionsf) * Float(i)
            let r2 = r1 + Float.pi / 2.0

            let c1 = cosf(r1)
            let s1 = sinf(r1)
            let c2 = cosf(r2)
            let s2 = sinf(r2)

            let j = i * 6
            let k = i * 4

            // vertex positions
            p[j+0] = c1
            p[j+1] = 1.0
            p[j+2] = -s1
            p[j+3] = c1
            p[j+4] = -1.0
            p[j+5] = -s1

            // vertex texture coordinates
            tc[k+0] = 1.0 / divisionsf * Float(i) * 3.0
            tc[k+1] = 0.0
            tc[k+2] = tc[k+0]
            tc[k+3] = 1.0

            // vertex tangents
            t[j+0] = c2
            t[j+1] = 0.0
            t[j+2] = -s2
            t[j+3] = c2
            t[j+4] = 0.0
            t[j+5] = -s2

            // vertex bitangents
            b[j+0] = 0.0
            b[j+1] = 1.0
            b[j+2] = 0.0
            b[j+3] = 0.0
            b[j+4] = 1.0
            b[j+5] = 0.0

            // vertex normals
            n[j+0] = c1
            n[j+1] = 0.0
            n[j+2] = -s1
            n[j+3] = c1
            n[j+4] = 0.0
            n[j+5] = -s1
        }

        // Get the program's vertex data locations.
        let vertexPositionLocation = program.getAttributeLocation("vertexPosition")!
        let vertexTexCoordsLocation = program.getAttributeLocation("vertexTexCoords")!
        let vertexTangentLocation = program.getAttributeLocation("vertexTangent")!
        let vertexBitangentLocation = program.getAttributeLocation("vertexBitangent")!
        let vertexNormalLocation = program.getAttributeLocation("vertexNormal")!

        // Create vertex array.
        glGenVertexArrays(1, &vertexArrayId)
        glBindVertexArray(vertexArrayId)

        // Create buffers.
        bufferIds = [GLuint](repeating: 0, count: 5)
        glGenBuffers(5, &bufferIds)

        // Create position buffer.
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), bufferIds[0])
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<Float>.size * size, p, GLenum(GL_STATIC_DRAW))

        // Create position attribute array.
        glEnableVertexAttribArray(vertexPositionLocation)
        glVertexAttribPointer(vertexPositionLocation, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, nil)

        // Create texture coordinates buffer.
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), bufferIds[1])
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<Float>.size * tcSize, tc, GLenum(GL_STATIC_DRAW))

        // Create texture coordinates attribute array.
        glEnableVertexAttribArray(vertexTexCoordsLocation)
        glVertexAttribPointer(vertexTexCoordsLocation, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, nil)

        // Create tangent buffer.
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), bufferIds[2])
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<Float>.size * size, t, GLenum(GL_STATIC_DRAW))

        // Create tangent attribute array.
        glEnableVertexAttribArray(vertexTangentLocation)
        glVertexAttribPointer(vertexTangentLocation, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, nil)

        // Create bitangent buffer.
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), bufferIds[3])
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<Float>.size * size, b, GLenum(GL_STATIC_DRAW))

        // Create bitangent attribute array.
        glEnableVertexAttribArray(vertexBitangentLocation)
        glVertexAttribPointer(vertexBitangentLocation, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, nil)

        // Create normal buffer.
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), bufferIds[4])
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<Float>.size * size, n, GLenum(GL_STATIC_DRAW))

        // Create normal attribute array.
        glEnableVertexAttribArray(vertexNormalLocation)
        glVertexAttribPointer(vertexNormalLocation, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, nil)
    }

    deinit {
        glDeleteBuffers(5, &bufferIds)
        glDeleteVertexArrays(1, &vertexArrayId)
    }

    func render() {
        glBindVertexArray(vertexArrayId)
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, GLint(numVertices))
    }
}
