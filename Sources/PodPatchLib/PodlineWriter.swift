import Foundation

protocol PodlineWriter {
  func write(_ podline: Podline, commentedOptions: [String: String]) -> String
}

class PodlineWriterFactory {
  
  static func writer(for podline: Podline) -> PodlineWriter {
    podline.isMultiline ? MultilinePodlineWriter() : SingleLinePodlineWriter()
  }
}
