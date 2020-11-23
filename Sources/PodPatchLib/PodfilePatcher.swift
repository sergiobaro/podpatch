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
    
    let podline = PodlineParser().parse(line: lineWithPod)
    let podToWrite = PodlineMapper().map(podline: podline, args: args)

    let podlineWriter = PodlineWriterFactory.writer(for: podToWrite)
    let newPodline = podlineWriter.write(podToWrite)
    
    return podfile.replacingOccurrences(of: lineWithPod, with: newPodline)
  }
}
