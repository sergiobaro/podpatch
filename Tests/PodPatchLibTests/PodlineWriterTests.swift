import XCTest
@testable import PodPatchLib

class PodlineWriterTests: XCTestCase {

  let writer = PodlineWriter()

  func test_write() {
    let podline = Podline(podName: "Pod", options: ["path": "../Pod"])
    let result = writer.write(podline)
    XCTAssertEqual(result, "pod 'Pod', :path => '../Pod'")
  }

}
