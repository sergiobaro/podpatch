import Foundation

enum PodProperty: String, CaseIterable {
  case path
  case branch
}

struct Args {
    let podName: String
    let property: PodProperty
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
    
    static let supportedProperties = PodProperty.allCases
    
    func parse(args: [String]) throws -> Args {
        guard args.count >= 1 else {
            throw ArgsParserError.missingPodName
        }
        guard args.count >= 2 else {
            throw ArgsParserError.missingPatch
        }
        
        let podName = args[0]
        let patch = args[1].components(separatedBy: ":")
        guard patch.count == 2 else {
            throw ArgsParserError.patchWrongFormat
        }
        
        let property = patch[0]
        let value = patch[1]

        guard let podOption = PodProperty(rawValue: property) else {
            throw ArgsParserError.propertyNotSupported(property)
        }
        if value.isEmpty {
            throw ArgsParserError.valueIsEmpty(property)
        }
        
        return Args(podName: podName, property: podOption, value: value)
    }
}
