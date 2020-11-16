import XCTest
@testable import PodPatchLib

class SingleLinePodlineWriterTests: XCTestCase {
  
  let writer = SingleLinePodlineWriter()
  
  func test_write_path() {
    let podline = Podline(
      prefix: "",
      podName: "Pod",
      optionsOrder: ["path"],
      options: ["path": "'../Pod'"],
      isMultiline: false
    )

    let result = writer.write(podline, optionsToCommentOut: [])

    XCTAssertEqual(result, "pod 'Pod', :path => '../Pod'")
  }
  
  func test_write_branch() {
    let podline = Podline(
      prefix: "",
      podName: "Pod",
      optionsOrder: ["git", "branch"],
      options: [
        "git": "'https://git.com/pod'",
        "branch": "'feature/branch'"
      ],
      isMultiline: false
    )

    let result = writer.write(podline, optionsToCommentOut: [])
    XCTAssertEqual(result, "pod 'Pod', :git => 'https://git.com/pod', :branch => 'feature/branch'")
  }
  
  func test_write_path_withPrefix() {
    let podline = Podline(
      prefix: "  ",
      podName: "Pod",
      optionsOrder: ["path"],
      options: ["path": "'../Pod'"],
      isMultiline: false
    )

    let result = writer.write(podline, optionsToCommentOut: [])

    XCTAssertEqual(result, "  pod 'Pod', :path => '../Pod'")
  }
  
  func test_write_path_withCommentedOptions() {
    let podline = Podline(
      prefix: "  ",
      podName: "Pod",
      optionsOrder: ["path", "git", "branch"],
      options: [
        "path": "'../Pod'",
        "git": "'https://git.com/pod'",
        "branch": "'feature/branch'"
      ],
      isMultiline: false
    )

    let result = writer.write(podline, optionsToCommentOut: ["git", "branch"])
    XCTAssertEqual(result, "  pod 'Pod', :path => '../Pod' # :git => 'https://git.com/pod', :branch => 'feature/branch'")
  }
}
