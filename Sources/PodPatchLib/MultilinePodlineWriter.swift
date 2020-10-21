import Foundation

class MultilinePodlineWriter: PodlineWriter {
  
  private let order = ["path", "git", "branch", "inhibit_warnings"]
  
  func write(_ podline: Podline, commentedOptions: [String : String]) -> String {
    var lines = [String]()
    
    let firstLine = podline.prefix + "pod '\(podline.podName)'"
    lines.append(firstLine)
    
    let allOptions = podline.options.merging(commentedOptions, uniquingKeysWith: { (current, _) in current })
    
    order.forEach { option in
      if let value = allOptions[option] {
        let commented = commentedOptions.keys.contains(option) ? "# " : ""
        let line = podline.prefix + "  \(commented):\(option) => \(value)"
        lines.append(line)
      }
    }
    
    return lines.joined(separator: ",\n")
  }
}
