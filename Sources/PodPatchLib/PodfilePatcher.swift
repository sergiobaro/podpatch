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
    guard let lineWithPod = PodlineFinder().findLinesWithPod(podfile: podfile, podName: args.podName) else {
      throw PodfilePatcherError.podNotFound(args.podName)
    }
    
    var podline = PodlineParser().parse(line: lineWithPod)
    if args.property == .branch {
      podline.options[PodProperty.path.rawValue] = nil
    }
    podline.options[args.property.rawValue] = "'\(args.value)'"
    let validOptions = optionsToKeep(podline.options)
    let commentedOptions = optionsToComment(from: podline.options, validOptions: validOptions)
    podline.options = validOptions
    
    let newPodline = PodlineWriterFactory.writer(for: podline).write(podline, commentedOptions: commentedOptions)
    
    return podfile.replacingOccurrences(of: lineWithPod, with: newPodline)
  }
  
  private func optionsToKeep(_ options: [String: String]) -> [String: String] {
    guard options.keys.contains(PodProperty.path.rawValue) else { return options }
    
    var options = options
    options.removeValue(forKey: PodProperty.branch.rawValue)
    options.removeValue(forKey: PodProperty.git.rawValue)
    
    return options
  }
  
  private func optionsToComment(from options: [String: String], validOptions: [String: String]) -> [String: String] {
    var result = options
    for key in validOptions.keys {
      result.removeValue(forKey: key)
    }
    
    return result
  }
}
