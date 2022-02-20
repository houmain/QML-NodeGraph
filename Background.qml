import QtQuick 2.15

ShaderEffect {
  property vector4d color  : Qt.vector4d(1, 1, 1, 1)
  property vector4d color2 : Qt.vector4d(0, 0, 0, 1)
  property double gridSize : 10
  
  property var u_color : color
  property var u_color2 : color2
  property var u_grid_size : gridSize
  property var u_viewport_resolution : Qt.vector2d(width - 1, height - 1)  

  blending: false
  
  vertexShader: "
    uniform highp mat4 qt_Matrix;
    attribute highp vec4 qt_Vertex;
    attribute highp vec2 qt_MultiTexCoord0;
    varying highp vec2 v_texcoord;
    
    void main() {
      v_texcoord = qt_MultiTexCoord0 - vec2(.5, .5);
      gl_Position = qt_Matrix * qt_Vertex;
    }
  "
  
  fragmentShader:
  "
    uniform highp float u_grid_size;
    uniform highp vec2 u_viewport_resolution;
    uniform highp vec4 u_color;
    uniform highp vec4 u_color2;
    varying highp vec2 v_texcoord;
        
    void main() {
      float s = 1.0 / 10.0;
      vec2 cell = fract(v_texcoord * u_viewport_resolution * s);
      gl_FragColor = mix(u_color, u_color2,
        1.0 - step(s, cell.x) * step(s, cell.y));
    }
  "
}
