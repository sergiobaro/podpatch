import Foundation

class PodlineFinder {
  
  func findLinesWithPod(podfile: String, podName: String) -> String? {
    var lines = [String]()
    var found = false
    
    podfile.split(separator: "\n").forEach { line in
      if !found {
        if line.contains("pod '\(podName)'") {
          found = true
          lines.append(String(line))
        }
      } else if found {
        if !line.contains("pod '") && !line.match(pattern: "end$") {
          lines.append(String(line))
        } else {
          found = false
        }
      }
    }
    
    return lines.isEmpty ? nil : lines.joined(separator: "\n")
  }
}

private extension String.SubSequence {
    
    func match(pattern: String) -> Bool {
        self.range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
