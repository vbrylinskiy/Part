import Foundation
import OpenGLES


public class Shader {
    
    public private(set) var program:GLuint = 0
    
    
    public init(vertex:String, fragment:String)
    {
        let vertexID = glCreateShader(GLenum(GL_VERTEX_SHADER))
        defer{ glDeleteShader(vertexID) }
        if let errorMessage = Shader.compileShader(shader: vertexID, source: vertex) {
            fatalError(errorMessage)
        }
        let fragmentID = glCreateShader(GLenum(GL_FRAGMENT_SHADER))
        defer{ glDeleteShader(fragmentID) }
        if let errorMessage = Shader.compileShader(shader: fragmentID, source: fragment) {
            fatalError(errorMessage)
        }
        self.program = glCreateProgram()
        if let errorMessage = Shader.linkProgram(program: program, vertex: vertexID, fragment: fragmentID) {
            fatalError(errorMessage)
        }
    }
    
    
    public convenience init(vertexFile:String, fragmentFile:String)
    {
        do {
            let vertexData = try NSData(contentsOfFile: vertexFile,
                                        options: [.uncached, .alwaysMapped])
            let fragmentData = try NSData(contentsOfFile: fragmentFile,
                                          options: [.uncached, .alwaysMapped])
            let vertexString = NSString(data: vertexData as Data, encoding: String.Encoding.utf8.rawValue)
            let fragmentString = NSString(data: fragmentData as Data, encoding: String.Encoding.utf8.rawValue)
            self.init(vertex: String(vertexString!), fragment: String(fragmentString!))
        }
        catch let error as NSError {
            fatalError(error.localizedFailureReason!)
        }
    }
    
    
    deinit
    {
        glDeleteProgram(program)
    }
    
    
    public func use()
    {
        glUseProgram(program)
    }
    
    
    private static func compileShader(shader: GLuint, source: String) -> String?
    {
        var shaderStringUTF8 = (source as NSString).utf8String
        var shaderStringLength: GLint = GLint(Int32(source.characters.count))
        
        glShaderSource(shader, 1, &shaderStringUTF8, &shaderStringLength)
        
        glCompileShader(shader)
        var success:GLint = 0
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &success)
        if success != GL_TRUE {
            var logSize:GLint = 0
            glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &logSize)
            if logSize == 0 { return "" }
            var infoLog = [GLchar](repeating: 0, count: Int(logSize))
            glGetShaderInfoLog(shader, logSize, nil, &infoLog)
            return String(validatingUTF8: infoLog)
        }
        return nil
    }
    
    
    private static func linkProgram(program: GLuint, vertex: GLuint, fragment: GLuint) -> String?
    {
        glAttachShader(program, vertex)
        glAttachShader(program, fragment)
        glLinkProgram(program)
        var success:GLint = 0
        glGetProgramiv(program, GLenum(GL_LINK_STATUS), &success)
        if success != GL_TRUE {
            var logSize:GLint = 0
            glGetProgramiv(program, GLenum(GL_INFO_LOG_LENGTH), &logSize)
            if logSize == 0 { return "" }
            var infoLog = [GLchar](repeating: 0, count: Int(logSize))
            glGetProgramInfoLog(program, logSize, nil, &infoLog)
            return String(validatingUTF8: infoLog)
        }
        return nil
    }
    
}
