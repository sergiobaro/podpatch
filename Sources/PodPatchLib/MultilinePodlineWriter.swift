import Foundation

class MultilinePodlineWriter: PodlineWriter {
  
  func write(_ podline: Podline, optionsToCommentOut: [String]) -> String {
    var lines = [String]()

    let firstLine = podline.prefix + "pod '\(podline.podName)',"
    lines.append(firstLine)

    let lastOption = podline.optionsOrder.last ?? ""
    let lastLineIsComment = optionsToCommentOut.contains(lastOption)

    podline.optionsOrder.enumerated().forEach { index, option in
      guard let value = podline.options[option] else { return }

      let isCommented = optionsToCommentOut.contains(option)
      var nextOptionIsCommented = false
      if podline.optionsOrder.indices.contains(index + 1) {
        nextOptionIsCommented = optionsToCommentOut.contains(podline.optionsOrder[index + 1])
      }

      let comma: String
      if option == lastOption {
        comma = ""
      } else if !isCommented && nextOptionIsCommented && lastLineIsComment {
        comma = ""
      } else {
        comma = ","
      }

      let commented = isCommented ? "# " : ""


      let line = podline.prefix + "  \(commented):\(option) => \(value)\(comma)"
      lines.append(line)
    }

    return lines.joined(separator: "\n")
  }
}
