import XCTest
@testable import PodPatchLib

class SingleLinePodlineWriterTests: XCTestCase {
  
  let writer = SingleLinePodlineWriter()
  
  func test_write_path() {
    let podToWrite = PodToWrite(
      prefix: "",
      podName: "Pod",
      optionsOrder: ["path"],
      options: ["path": "'../Pod'"],
      isMultiline: false,
      optionsToCommentOut: []
    )

    let result = writer.write(podToWrite)

    XCTAssertEqual(result, "pod 'Pod', :path => '../Pod'")
  }
  
  func test_write_branch() {
    let podToWrite = PodToWrite(
      prefix: "",
      podName: "Pod",
      optionsOrder: ["git", "branch"],
      options: [
        "git": "'https://git.com/pod'",
        "branch": "'feature/branch'"
      ],
      isMultiline: false,
      optionsToCommentOut: []
    )

    let result = writer.write(podToWrite)
    XCTAssertEqual(result, "pod 'Pod', :git => 'https://git.com/pod', :branch => 'feature/branch'")
  }

  func test_write_path_withPrefix() {
    let podToWrite = PodToWrite(
      prefix: "  ",
      podName: "Pod",
      optionsOrder: ["path"],
      options: ["path": "'../Pod'"],
      isMultiline: false,
      optionsToCommentOut: []
    )

    let result = writer.write(podToWrite)
    XCTAssertEqual(result, "  pod 'Pod', :path => '../Pod'")
  }

  func test_write_path_withCommentedOptions() {
    let podToWrite = PodToWrite(
      prefix: "  ",
      podName: "Pod",
      optionsOrder: ["path", "git", "branch"],
      options: [
        "path": "'../Pod'",
        "git": "'https://git.com/pod'",
        "branch": "'feature/branch'"
      ],
      isMultiline: false,
      optionsToCommentOut: ["git", "branch"]
    )

    let result = writer.write(podToWrite)
    XCTAssertEqual(result, "  pod 'Pod', :path => '../Pod' # :git => 'https://git.com/pod', :branch => 'feature/branch'")
  }
}
