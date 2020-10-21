import Foundation

struct Podline {
  let prefix: String
  let podName: String
  var options: [String: String]
  var isMultiline: Bool
}

class PodlineParser {

  func parse(line: String) -> Podline {
    let prefix = findPrefix(line)
    let podName = findPodName(line)
    let options = findOptions(line)

    return Podline(
      prefix: prefix,
      podName: podName,
      options: options,
      isMultiline: line.contains("\n")
    )
  }
  
  private func findPrefix(_ line: String) -> String {
    let regex = try! NSRegularExpression(pattern: "^(\\s*)", options: [])
    let matches = regex.matches(in: line)
    return matches.first!.capture(at: 1, in: line)
  }

  private func findPodName(_ line: String) -> String {
    let regex = try! NSRegularExpression(pattern: "pod '(\\w+)'", options: [])
    let matches = regex.matches(in: line)
    return matches.first!.capture(at: 1, in: line)
  }

  private func findOptions(_ line: String) -> [String: String] {
    let regex = try! NSRegularExpression(pattern: ":(\\w+) => ('[^']+'|false|true)", options: [])
    let matches = regex.matches(in: line)

    var result = [String: String]()

    for match in matches {
      let property = match.capture(at: 1, in: line)
      let value = match.capture(at: 2, in: line)

      result[property] = value
    }

    return result
  }
}

private extension String {
  var nsRange: NSRange {
    NSRange(self.startIndex..<self.endIndex, in: self)
  }
}

private extension NSRegularExpression {
  func matches(in string: String) -> [NSTextCheckingResult] {
    matches(in: string, options: [], range: string.nsRange)
  }
}

private extension NSTextCheckingResult {
  func capture(at index: Int, in string: String) -> String {
    let nsRange = self.range(at: index)
    let range = Range(nsRange, in: string)!
    return String(string[range])
  }
}
