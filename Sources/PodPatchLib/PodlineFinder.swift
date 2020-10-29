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
        if belongsToPod(line) {
          lines.append(String(line))
        } else {
          found = false
        }
      }
    }
    
    return lines.isEmpty ? nil : lines.joined(separator: "\n")
  }
    
  private func belongsToPod(_ line: Substring) -> Bool {
    line.trimmingCharacters(in: .whitespaces).starts(with: ":") ||
        line.trimmingCharacters(in: .whitespaces).starts(with: "# :")
  }
}
