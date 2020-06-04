import XCTest
@testable import PodPatchLib

class PodlineParserTests: XCTestCase {

  let parser = PodlineParser()

  func test_parse() {
    let result = parser.parse(line: "  pod 'Pod', :git => 'https://url.com', :branch => 'develop'")
    XCTAssertEqual(result.prefix, "  ")
    XCTAssertEqual(result.podName, "Pod")
    XCTAssertEqual(result.options.count, 2)
    XCTAssertEqual(result.options["git"], "https://url.com")
    XCTAssertEqual(result.options["branch"], "develop")
  }
}
