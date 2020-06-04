import XCTest
@testable import PodPatchLib

class PodlineWriterTests: XCTestCase {
  
  let writer = PodlineWriter()
  
  func test_write_path() {
    let podline = Podline(prefix: "", podName: "Pod", options: ["path": "../Pod"])
    let result = writer.write(podline)
    XCTAssertEqual(result, "pod 'Pod', :path => '../Pod'")
  }
  
  func test_write_branch() {
    let podline = Podline(prefix: "",  podName: "Pod", options: ["git": "https://git.com/pod", "branch": "feature/branch"])
    let result = writer.write(podline)
    XCTAssertEqual(result, "pod 'Pod', :git => 'https://git.com/pod', :branch => 'feature/branch'")
  }
  
  func test_write_withPrefix() {
    let podline = Podline(prefix: "  ", podName: "Pod", options: ["path": "../Pod"])
    let result = writer.write(podline)
    XCTAssertEqual(result, "  pod 'Pod', :path => '../Pod'")
  }
}
