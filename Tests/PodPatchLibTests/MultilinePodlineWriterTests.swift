import XCTest
@testable import PodPatchLib

class MultilinePodlineWriterTests: XCTestCase {
  
  let writer = MultilinePodlineWriter()

  func test_write_path_multiline_lastOptionIsCommented() {
    let podToWrite = PodToWrite(
      prefix: "  ",
      podName: "Pod",
      optionsOrder: ["path", "git", "branch"],
      options: ["path": "'../Pod'",
                "git": "'https://git.com/pod'",
                "branch": "'feature/branch'",],
      isMultiline: true,
      optionsToCommentOut: ["git", "branch"]
    )

    let result = writer.write(podToWrite)

    let expected = """
      pod 'Pod',
        :path => '../Pod'
        # :git => 'https://git.com/pod',
        # :branch => 'feature/branch'
    """
    XCTAssertEqual(expected, result)
  }

  func test_write_path_multiline() {
    let podToWrite = PodToWrite(
      prefix: "  ",
      podName: "Pod",
      optionsOrder: ["path", "git", "branch", "inhibit_warnings"],
      options: ["path": "'../Pod'",
                "git": "'https://git.com/pod'",
                "branch": "'feature/branch'",
                "inhibit_warnings": "false"],
      isMultiline: true,
      optionsToCommentOut: ["git", "branch"]
    )

    let result = writer.write(podToWrite)

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
    let podToWrite = PodToWrite(
      prefix: "  ",
      podName: "Pod",
      optionsOrder: ["git", "branch", "inhibit_warnings"],
      options: ["git": "'https://git.com/pod'", "branch": "'feature/branch'", "inhibit_warnings": "false"],
      isMultiline: true,
      optionsToCommentOut: []
    )

    let result = writer.write(podToWrite)

    let expected = """
      pod 'Pod',
        :git => 'https://git.com/pod',
        :branch => 'feature/branch',
        :inhibit_warnings => false
    """
    XCTAssertEqual(expected, result)
  }
}
