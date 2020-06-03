import Foundation

public class PodPatch {
    
    public init() { }
    
    public func run( _ args: [String]) throws {
        let podfile = try readPodfile()
        let args = try ArgsParser().parse(args: args)
        
    }
    
    private func readPodfile() throws -> String {
        try String(contentsOfFile: "Podfile")
    }
}
