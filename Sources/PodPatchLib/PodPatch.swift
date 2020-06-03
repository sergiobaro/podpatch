import Foundation

public class PodPatch {
    
    public init() { }
    
    public func run( _ args: [String]) throws {
        let podfile = try readPodfile()
        let args = try ArgsParser().parse(args: args)
        let result = try PodfilePatcher().patch(podfile: podfile, args: args)
        try writePodfile(result)
    }
    
    private func readPodfile() throws -> String {
        try String(contentsOfFile: "Podfile")
    }
    
    private func writePodfile(_ podfile: String) throws {
        try podfile.write(toFile: "Podfile", atomically: true, encoding: .utf8)
    }
}
