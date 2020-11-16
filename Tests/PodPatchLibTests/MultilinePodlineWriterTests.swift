import XCTest
@testable import PodPatchLib

class MultilinePodlineWriterTests: XCTestCase {
  
  let writer = MultilinePodlineWriter()

  func test_write_path_multiline_lastOptionIsCommented() {
    let podline = Podline(
      prefix: "  ",
      podName: "Pod",
      optionsOrder: ["path", "git", "branch"],
      options: ["path": "'../Pod'",
                "git": "'https://git.com/pod'",
                "branch": "'feature/branch'",],
      isMultiline: true
    )
    let result = writer.write(podline, optionsToCommentOut: ["git", "branch"])

    let expected = """
      pod 'Pod',
        :path => '../Pod'
        # :git => 'https://git.com/pod',
        # :branch => 'feature/branch'
    """
    XCTAssertEqual(expected, result)
  }
  
  func test_write_path_multiline() {
    let podline = Podline(
      prefix: "  ",
      podName: "Pod",
      optionsOrder: ["path", "git", "branch", "inhibit_warnings"],
      options: ["path": "'../Pod'",
                "git": "'https://git.com/pod'",
                "branch": "'feature/branch'",
                "inhibit_warnings": "false"],
      isMultiline: true
    )
    let result = writer.write(podline, optionsToCommentOut: ["git", "branch"])
    
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
      optionsOrder: ["git", "branch", "inhibit_warnings"],
      options: ["git": "'https://git.com/pod'", "branch": "'feature/branch'", "inhibit_warnings": "false"],
      isMultiline: true
    )
    let result = writer.write(podline, optionsToCommentOut: [])
    
    let expected = """
      pod 'Pod',
        :git => 'https://git.com/pod',
        :branch => 'feature/branch',
        :inhibit_warnings => false
    """
    XCTAssertEqual(expected, result)
  }
}
