import Foundation

class PodlineWriter {
    
  private let pathOptionsOrder = ["path"]
  private let gitOptionsOrder = ["git", "branch"]

  func write(_ podline: Podline) -> String {
    let podString = writePod(podline.podName)
    let optionsString = writeOptions(podline.options)

    return podline.prefix + ([podString] + optionsString).joined(separator: ", ")
  }

  private func writePod(_ podName: String) -> String {
    return "pod '\(podName)'"
  }

  private func writeOptions(_ options: [String: String]) -> [String] {
    let optionsOrder = order(for: options)
    
    return optionsOrder.compactMap { option in
      guard let value = options[option] else {
        return nil
      }
      return ":\(option) => '\(value)'"
    }
  }
  
  private func order(for options: [String: String]) -> [String] {
    if options.keys.contains("path") {
      return pathOptionsOrder
    }
    return gitOptionsOrder
  }
}
