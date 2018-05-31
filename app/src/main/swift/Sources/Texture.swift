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
#if !os(Android)
import CoreGraphics
#endif
#if os(macOS)
import OpenGL
#else
import OpenGLES
#endif

class Texture {
    private(set) var textureId: GLuint
    private(set) var width: UInt
    private(set) var height: UInt

    init(textureId: GLuint, width: UInt, height: UInt) {
        self.textureId = textureId
        self.width = width
        self.height = height
    }

    deinit {
        glDeleteTextures(1, &textureId)
    }

    static func loadFromFile(_ filePath: String) -> Texture? {
        let fullPath = Bundle.main.resourcePath! + "/" + filePath
        #if !os(Android)
        let dataProvider = CGDataProvider(filename: fullPath)
        if dataProvider == nil {
            return nil
        }

        let image = CGImage(pngDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: false, intent: CGColorRenderingIntent.defaultIntent)
        let imageData = image?.dataProvider?.data

        // Get the image data, dimensions, and number of components.
        let data = CFDataGetBytePtr(imageData)
        let width = UInt((image?.width)!)
        let height = UInt((image?.height)!)
        let numComponents = (image?.bitsPerPixel)! / 8

        // Determine the GL texture format based on the number of components.
        var format: GLint
        switch numComponents {
            case 1: format = GL_RED
            case 3: format = GL_RGB
            case 4: format = GL_RGBA
            default:
                return nil
        }
        #else
        // workaround when CoreGraphics is not available
        let imageData = NSData(contentsOfFile: fullPath)!
        withExtendedLifetime(imageData) {}
        let data = imageData.bytes
        let width = UInt(512)
        let height = UInt(512)
        let format = GL_RGBA
        #endif

        // Generate and bind texture.
        var textureId: GLuint = 0
        glGenTextures(1, &textureId)
        glBindTexture(GLenum(GL_TEXTURE_2D), textureId)

        // Set parameters.
        glPixelStorei(GLenum(GL_UNPACK_ALIGNMENT), 1)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_REPEAT)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_REPEAT)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR)

        // Set the texture data.
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, format, GLsizei(width), GLsizei(height), 0, GLenum(format), GLenum(GL_UNSIGNED_BYTE), data)

        return Texture(textureId: textureId, width: width, height: height)
    }
}
