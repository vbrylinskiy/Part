attribute vec3 StartPosition;
attribute vec3 EndPosition;
uniform mat4 Projection;

attribute vec2 TexCoordIn;
varying vec2 TexCoordOut;

uniform highp float MixValue;

void main(void) {
    TexCoordOut = TexCoordIn;
    gl_Position = Projection * vec4(mix(StartPosition, EndPosition, MixValue), 1.0);
}
