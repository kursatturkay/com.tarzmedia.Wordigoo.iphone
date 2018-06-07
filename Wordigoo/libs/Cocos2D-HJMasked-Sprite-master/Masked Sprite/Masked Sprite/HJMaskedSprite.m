/*
 //  HJMaskedSprite.m
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import "HJMaskedSprite.h"

@implementation HJMaskedSprite


-(void)dealloc
{
    [_maskTexture release];
    [shaderProgram_ release];
    [super dealloc];
}

-(id)initWithSprite:(CCSprite*)sprite andImageOverlay:(NSString*)maskFile{
    self = [(HJMaskedSprite *)sprite retain];
    if(self){
        const GLchar * fragmentSource = (GLchar*) [[NSString stringWithContentsOfFile:[CCFileUtils fullPathFromRelativePath:@"Mask.fsh"]
                                                                             encoding:NSUTF8StringEncoding error:nil] UTF8String];
        
        self.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTextureA8Color_vert
                                                        fragmentShaderByteArray:fragmentSource];
        [self.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
        [self.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
        [self.shaderProgram addAttribute:kCCAttributeNameColor index:kCCVertexAttrib_Color];
        [self.shaderProgram link];
        [self.shaderProgram updateUniforms];
        
        _maskLocation = glGetUniformLocation(self.shaderProgram->program_, "u_overlayTexture");
        glUniform1i(_maskLocation, 1);
        _maskTexture = [[CCTextureCache sharedTextureCache] addImage:maskFile];
        [_maskTexture setAliasTexParameters];
        
        [self.shaderProgram use];
        ccGLBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, [_maskTexture name]);
        glActiveTexture(GL_TEXTURE0);
        
    }
    return self;
}

-(id)initWithSprite:(CCSprite*)sprite andMaskSprite:(CCSprite*)maskSprite
{
    self = [(HJMaskedSprite *)sprite retain];
    if (self) {
        const GLchar * fragmentSource = (GLchar*) [[NSString stringWithContentsOfFile:[CCFileUtils fullPathFromRelativePath:@"Mask.fsh"]
                                                                             encoding:NSUTF8StringEncoding error:nil] UTF8String];
        
        self.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTextureA8Color_vert
                                                        fragmentShaderByteArray:fragmentSource];
        [self.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
        [self.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
        [self.shaderProgram addAttribute:kCCAttributeNameColor index:kCCVertexAttrib_Color];
        [self.shaderProgram link];
        [self.shaderProgram updateUniforms];
        
        _maskLocation = glGetUniformLocation(self.shaderProgram->program_, "u_overlayTexture");
        glUniform1i(_maskLocation, 1);
        _maskTexture = [[maskSprite texture] retain];
        [_maskTexture setAliasTexParameters];
        
        [self.shaderProgram use];
        ccGLBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, [_maskTexture name]);
        glActiveTexture(GL_TEXTURE0);
        
    }
    
    return self;
}

-(id)initWithFile:(NSString *)file andMaskSprite:(CCSprite*)maskSprite
{
    self = [super initWithFile:file];
    if (self) {
        const GLchar * fragmentSource = (GLchar*) [[NSString stringWithContentsOfFile:[CCFileUtils fullPathFromRelativePath:@"Mask.fsh"]
                                                                             encoding:NSUTF8StringEncoding error:nil] UTF8String];
        
        self.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTextureA8Color_vert
                                                        fragmentShaderByteArray:fragmentSource];
        [self.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
        [self.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
        [self.shaderProgram addAttribute:kCCAttributeNameColor index:kCCVertexAttrib_Color];
        [self.shaderProgram link];
        [self.shaderProgram updateUniforms];
        
        _maskLocation = glGetUniformLocation(self.shaderProgram->program_, "u_overlayTexture");
        glUniform1i(_maskLocation, 1);
        _maskTexture = [[maskSprite texture] retain];
        [_maskTexture setAliasTexParameters];
        
        [self.shaderProgram use];
        ccGLBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, [_maskTexture name]);
        glActiveTexture(GL_TEXTURE0);
        
    }
    
    return self;
}

-(id)initWithFile:(NSString *)file andImageOverlay:(NSString*)maskFile
{
    self = [super initWithFile:file];
    if (self) {
        const GLchar * fragmentSource = (GLchar*) [[NSString stringWithContentsOfFile:[CCFileUtils fullPathFromRelativePath:@"Mask.fsh"]
                                                                             encoding:NSUTF8StringEncoding error:nil] UTF8String];
        
        self.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTextureA8Color_vert
                                                        fragmentShaderByteArray:fragmentSource];
        [self.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
        [self.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
        [self.shaderProgram addAttribute:kCCAttributeNameColor index:kCCVertexAttrib_Color];
        [self.shaderProgram link];
        [self.shaderProgram updateUniforms];
        
        _maskLocation = glGetUniformLocation(self.shaderProgram->program_, "u_overlayTexture");
        glUniform1i(_maskLocation, 1);
        _maskTexture = [[CCTextureCache sharedTextureCache] addImage:maskFile];
        [_maskTexture setAliasTexParameters];
        
        [self.shaderProgram use];
        ccGLBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, [_maskTexture name]);
        glActiveTexture(GL_TEXTURE0);

        
    }
    
    return self;
}

-(void) draw {
    
    CC_NODE_DRAW_SETUP();
    
    ccGLEnableVertexAttribs(kCCVertexAttribFlag_PosColorTex);
    ccGLBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [shaderProgram_ setUniformForModelViewProjectionMatrix];
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture( GL_TEXTURE_2D, [texture_ name] );
    glUniform1i(_textureLocation, 0);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture( GL_TEXTURE_2D, [_maskTexture name] );
    glUniform1i(_maskLocation, 1);
    
#define kQuadSize sizeof(quad_.bl)
    long offset = (long)&quad_;
    
    // vertex
    NSInteger diff = offsetof( ccV3F_C4B_T2F, vertices);
    glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, kQuadSize, (void*) (offset + diff));
    
    // texCoods
    diff = offsetof( ccV3F_C4B_T2F, texCoords);
    glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, kQuadSize, (void*)(offset + diff));
    
    // color
    diff = offsetof( ccV3F_C4B_T2F, colors);
    glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_UNSIGNED_BYTE, GL_TRUE, kQuadSize, (void*)(offset + diff));
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glActiveTexture(GL_TEXTURE0);
}

@end
