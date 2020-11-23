import Foundation

struct PodToWrite {
  let prefix: String
  let podName: String
  var optionsOrder: [String]
  var options: [String: String]
  var isMultiline: Bool
  let optionsToCommentOut: [String]
}

protocol PodlineWriter {
  func write(_ podToWrite: PodToWrite) -> String
}

class PodlineWriterFactory {
  
  static func writer(for podToWrite: PodToWrite) -> PodlineWriter {
    podToWrite.isMultiline ? MultilinePodlineWriter() : SingleLinePodlineWriter()
  }
}
