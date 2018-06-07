#import "HJMaskedSprite.h"

@implementation HJMaskedSprite


-(void)dealloc
{
    [_maskTexture release];
    [_shaderProgram release];
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
        
        _maskLocation = glGetUniformLocation(self.shaderProgram->_program, "u_overlayTexture");
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
        
        _maskLocation = glGetUniformLocation(self.shaderProgram->_program, "u_overlayTexture");
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
        
        _maskLocation = glGetUniformLocation(self.shaderProgram->_program, "u_overlayTexture");
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
        
        _maskLocation = glGetUniformLocation(self.shaderProgram->_program, "u_overlayTexture");
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
    [_shaderProgram setUniformForModelViewProjectionMatrix];
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture( GL_TEXTURE_2D, [_texture name] );
    glUniform1i(_textureLocation, 0);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture( GL_TEXTURE_2D, [_maskTexture name] );
    glUniform1i(_maskLocation, 1);
    
#define kQuadSize sizeof(_quad.bl)
    long offset = (long)&_quad;
    
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
