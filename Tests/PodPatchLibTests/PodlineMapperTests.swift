import XCTest
@testable import PodPatchLib

class PodlineMapperTests: XCTestCase {

  let mapper = PodlineMapper()

  func test_map_path() throws {
    let podline = Podline(
      prefix: "",
      podName: "Pod",
      optionsOrder: ["git", "branch"],
      options: ["git": "'https://url.com'", "branch" : "'develop'"],
      isMultiline: false
    )
    let args = Args(podName: "Pod", property: .path, value: "value")

    let result = mapper.map(podline: podline, args: args)

    XCTAssertEqual(result.optionsOrder, ["path", "git", "branch"])
    XCTAssertEqual(Set(result.optionsToCommentOut), Set(["git", "branch"]))
    XCTAssertEqual(Set(result.options.keys), Set(["path", "git", "branch"]))
  }

  func test_map_branch() throws {
    let podline = Podline(
      prefix: "",
      podName: "Pod",
      optionsOrder: ["git", "branch"],
      options: ["git": "'https://url.com'", "branch" : "'develop'"],
      isMultiline: false
    )
    let args = Args(podName: "Pod", property: .branch, value: "another/branch")

    let result = mapper.map(podline: podline, args: args)

    XCTAssertEqual(result.optionsOrder, ["git", "branch"])
    XCTAssertTrue(result.optionsToCommentOut.isEmpty)
    XCTAssertEqual(Set(result.options.keys), Set(["git", "branch"]))
  }

  func test_map_withBranch_fromPath() throws {
    let podline = Podline(
      prefix: "",
      podName: "Pod",
      optionsOrder: ["path", "git", "branch"],
      options: ["path": "'../Pod'", "git": "'https://url.com'", "branch" : "'develop'"],
      isMultiline: false
    )

    let args = Args(podName: "Pod", property: .branch, value: "another/branch")

    let result = mapper.map(podline: podline, args: args)

    XCTAssertEqual(result.optionsOrder, ["git", "branch"])
    XCTAssertTrue(result.optionsToCommentOut.isEmpty)
    XCTAssertEqual(Set(result.options.keys), Set(["git", "branch"]))
  }
}
