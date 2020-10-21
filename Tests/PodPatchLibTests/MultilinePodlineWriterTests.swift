import XCTest
@testable import PodPatchLib

class MultilinePodlineWriterTests: XCTestCase {
  
  let writer = MultilinePodlineWriter()
  
  func test_write_path_multiline() {
    let podline = Podline(
      prefix: "  ",
      podName: "Pod",
      options: ["path": "'../Pod'", "inhibit_warnings": "false"],
      isMultiline: true
    )
    let result = writer.write(podline, commentedOptions: ["git": "'https://git.com/pod'", "branch": "'feature/branch'"])
    
    let expected = """
      pod 'Pod',
        :path => '../Pod',
        # :git => 'https://git.com/pod',
        # :branch => 'feature/branch',
        :inhibit_warnings => false
    """
    XCTAssertEqual(expected, result)
  }
  
  func test_write_branch_multiline() {
    let podline = Podline(
      prefix: "  ",
      podName: "Pod",
      options: ["git": "'https://git.com/pod'", "branch": "'feature/branch'", "inhibit_warnings": "false"],
      isMultiline: true
    )
    let result = writer.write(podline, commentedOptions: [:])
    
    let expected = """
      pod 'Pod',
        :git => 'https://git.com/pod',
        :branch => 'feature/branch',
        :inhibit_warnings => false
    """
    XCTAssertEqual(expected, result)
  }
}
