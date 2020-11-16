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
    podline.options = genOptions(podline, args: args)
    podline.optionsOrder = genOptionsOrder(podline, args: args)

    let keepOptions = optionsToKeep(podline.options)
    let optionsToCommentOut = Array(Set(podline.options.keys).subtracting(keepOptions))

    let podlineWriter = PodlineWriterFactory.writer(for: podline)
    let newPodline = podlineWriter.write(podline, optionsToCommentOut: optionsToCommentOut)
    
    return podfile.replacingOccurrences(of: lineWithPod, with: newPodline)
  }
  
  private func optionsToKeep(_ options: [String: String]) -> [String] {
    guard options.keys.contains(PodProperty.path.rawValue) else {
      return Array(options.keys)
    }
    
    var options = options
    options.removeValue(forKey: PodProperty.branch.rawValue)
    options.removeValue(forKey: PodProperty.git.rawValue)
    
    return Array(options.keys)
  }

  private func genOptionsOrder(_ podline: Podline, args: Args) -> [String] {
    if podline.optionsOrder.contains(args.property.rawValue) {
      return podline.optionsOrder
    }
    
    return [args.property.rawValue] + podline.optionsOrder
  }

  private func genOptions(_ podline: Podline, args: Args) -> [String: String] {
    var options = podline.options

    if args.property == .branch {
      options[PodProperty.path.rawValue] = nil
    }
    options[args.property.rawValue] = "'\(args.value)'"

    return options
  }
}
