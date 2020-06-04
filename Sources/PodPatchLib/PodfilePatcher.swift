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
    podline.options[args.property] = args.value
    podline.options = filterOptions(podline.options)

    let newPodline = PodlineWriter().write(podline)

    return podfile.replacingOccurrences(of: lineWithPod, with: newPodline)
  }

  private func findLineWithPod(podfile: String, podName: String) -> String? {
    podfile
      .split(separator: "\n")
      .first { $0.contains("pod '\(podName)'") }
      .map { String($0) }
  }

  private func filterOptions(_ options: [String: String]) -> [String: String] {
    if options.keys.contains("path") {
      return ["path": options["path"]!]
    }

    return options
  }
}
