varying lowp vec2 TexCoordOut;
uniform sampler2D Texture1;
uniform sampler2D Texture2;
uniform highp float MixValue;

void main(void) {
    highp vec4 tex = texture2D(Texture1, TexCoordOut);
    highp vec4 tex2 = texture2D(Texture2, TexCoordOut);
    gl_FragColor = mix(tex, tex2, MixValue);
}
