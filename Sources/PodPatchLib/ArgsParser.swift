import Foundation

struct Args {
    let podName: String
    let property: String
    let value: String
}

enum ArgsParserError: LocalizedError, Equatable {
    case missingPodName
    case missingPatch
    case patchWrongFormat
    case propertyNotSupported(String)
    case valueIsEmpty(String)
    
    var errorDescription: String? {
        switch self {
        case .missingPodName:
            return "The name of the pod is missing"
        case .missingPatch:
            return "The patch part is missing"
        case .patchWrongFormat:
            return "The patch has the wrong format"
        case .propertyNotSupported(let property):
            return "The property '\(property)' is not supported, only \(ArgsParser.supportedProperties) are supported"
        case .valueIsEmpty(let property):
            return "Value is empty for property '\(property)'"
        }
    }
}

class ArgsParser {
    
    static let supportedProperties = ["path", "branch"]
    
    func parse(args: [String]) throws -> Args {
        guard args.count >= 1 else {
            throw ArgsParserError.missingPodName
        }
        guard args.count >= 2 else {
            throw ArgsParserError.missingPatch
        }
        
        let podName = args[0]
        if podName.isEmpty {
            throw ArgsParserError.missingPodName
        }
        
        let patch = args[1].components(separatedBy: ":")
        guard patch.count == 2 else {
            throw ArgsParserError.patchWrongFormat
        }
        
        let property = patch[0]
        let value = patch[1]
        
        guard Self.supportedProperties.contains(property) else {
            throw ArgsParserError.propertyNotSupported(property)
        }
        if value.isEmpty {
            throw ArgsParserError.valueIsEmpty(property)
        }
        
        return Args(podName: podName, property: property, value: value)
    }
}
