import Foundation

enum PodfilePatcherError: LocalizedError {
  case podNotFound(String)
}

class PodfilePatcher {

  func patch(podfile: String, args: Args) throws -> String {
    guard let line = findLineWithPod(podfile: podfile, podName: args.podName) else {
      throw PodfilePatcherError.podNotFound(args.podName)
    }

    var podline = PodlineParser().parse(line: line)
    podline.options[args.property] = args.value
    podline.options = filterOptions(podline.options)

    let newPodline = PodlineWriter().write(podline)

    return podfile.replacingOccurrences(of: podfile, with: newPodline)
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
