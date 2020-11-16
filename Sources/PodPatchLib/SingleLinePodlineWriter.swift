import Foundation

class SingleLinePodlineWriter: PodlineWriter {
  
  func write(_ podline: Podline, optionsToCommentOut: [String]) -> String {
    let podString = writePod(podline.podName)
    let (validOptions, commentOptions) = splitOptions(podline.options, optionsToCommentOut: optionsToCommentOut)

    let optionsString = writeOptions(validOptions, order: podline.optionsOrder)

    var result = podline.prefix + ([podString] + optionsString).joined(separator: ", ")
    if !commentOptions.isEmpty {
      let commentOptionsString = writeOptions(commentOptions, order: podline.optionsOrder)
      result += (" # " + commentOptionsString.joined(separator: ", "))
    }

    return result
  }
  
  private func writePod(_ podName: String) -> String {
    "pod '\(podName)'"
  }

  private func splitOptions(_ options: [String: String], optionsToCommentOut: [String]) -> ([String: String], [String: String]) {
    var validOptions = [String: String]()
    var commentOptions = [String: String]()

    options.forEach { (option, value) in
      if optionsToCommentOut.contains(option) {
        commentOptions[option] = value
      } else {
        validOptions[option] = value
      }
    }


    return (validOptions, commentOptions)
  }
  
  private func writeOptions(_ options: [String: String], order: [String]) -> [String] {
    order.compactMap { option in
      guard let value = options[option] else { return nil }
      return ":\(option) => \(value)"
    }
  }
}
