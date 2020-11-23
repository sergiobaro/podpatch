import Foundation

class MultilinePodlineWriter: PodlineWriter {

  func write(_ podToWrite: PodToWrite) -> String {
    var lines = [String]()

    let firstLine = podToWrite.prefix + "pod '\(podToWrite.podName)',"
    lines.append(firstLine)

    let lastOption = podToWrite.optionsOrder.last ?? ""
    let lastLineIsComment = podToWrite.optionsToCommentOut.contains(lastOption)

    podToWrite.optionsOrder.enumerated().forEach { index, option in
      guard let value = podToWrite.options[option] else { return }

      let isCommented = podToWrite.optionsToCommentOut.contains(option)
      var nextOptionIsCommented = false
      if podToWrite.optionsOrder.indices.contains(index + 1) {
        nextOptionIsCommented = podToWrite.optionsToCommentOut.contains(podToWrite.optionsOrder[index + 1])
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


      let line = podToWrite.prefix + "  \(commented):\(option) => \(value)\(comma)"
      lines.append(line)
    }

    return lines.joined(separator: "\n")
  }
}
