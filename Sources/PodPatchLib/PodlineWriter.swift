import Foundation

class PodlineWriter {

  func write(_ podline: Podline) -> String {
    let podString = writePod(podline.podName)
    let optionsString = writeOptions(podline.options)

    return ([podString] + optionsString).joined(separator: ", ")
  }

  private func writePod(_ podName: String) -> String {
    return "pod '\(podName)'"
  }

  private func writeOptions(_ options: [String: String]) -> [String] {
    return options.map({ (property, value) in
      return ":\(property) => '\(value)'"
    })
  }
}
