attribute vec3 Position;
uniform mat4 Projection;

attribute vec2 TexCoordIn;
varying vec2 TexCoordOut;

void main(void) {
    TexCoordOut = TexCoordIn;
    gl_Position = Projection * vec4(Position, 1.0);
}
