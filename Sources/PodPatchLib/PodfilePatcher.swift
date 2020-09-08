import Foundation

enum PodfilePatcherError: LocalizedError, Equatable {
  case podNotFound(String)
    
  var errorDescription: String? {
    switch self {
    case .podNotFound(let podName):
      return "Pod '\(podName)' not found in Podfile"
    }
  }
}

class PodfilePatcher {

  func patch(podfile: String, args: Args) throws -> String {
    guard let lineWithPod = findLineWithPod(podfile: podfile, podName: args.podName) else {
      throw PodfilePatcherError.podNotFound(args.podName)
    }

    var podline = PodlineParser().parse(line: lineWithPod)
    if args.property == .branch {
      podline.options[PodProperty.path.rawValue] = nil
    }
    podline.options[args.property.rawValue] = args.value
    let filteredOptions = filterOptions(podline.options)
    let commentedOptions = discardedOptions(from: podline.options, validOptions: filteredOptions)
    podline.options = filteredOptions

    let newPodline = PodlineWriter().write(podline, commentedOptions: commentedOptions)

    return podfile.replacingOccurrences(of: lineWithPod, with: newPodline)
  }

  private func findLineWithPod(podfile: String, podName: String) -> String? {
    podfile
      .split(separator: "\n")
      .first { $0.contains("pod '\(podName)'") }
      .map { String($0) }
  }

  private func filterOptions(_ options: [String: String]) -> [String: String] {
    if options.keys.contains(PodProperty.path.rawValue) {
      return [PodProperty.path.rawValue: options[PodProperty.path.rawValue]!]
    }

    return options
  }
  
  private func discardedOptions(from options: [String: String], validOptions: [String: String]) -> [String: String] {
    var result = options
    for key in validOptions.keys {
      result.removeValue(forKey: key)
    }
    
    return result
  }
}
