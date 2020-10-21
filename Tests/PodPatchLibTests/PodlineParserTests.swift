import XCTest
@testable import PodPatchLib

class PodlineParserTests: XCTestCase {

  let parser = PodlineParser()

  func test_parse() {
    let line = "  pod 'Pod', :git => 'https://url.com', :branch => 'develop'"
    let result = parser.parse(line: line)
    XCTAssertEqual(result.prefix, "  ")
    XCTAssertEqual(result.podName, "Pod")
    XCTAssertEqual(result.options.count, 2)
    XCTAssertEqual(result.options["git"], "'https://url.com'")
    XCTAssertEqual(result.options["branch"], "'develop'")
  }
  
  func test_parse_withComment() {
    let line = "  pod 'Pod', :path => '../Pod' # :git => 'https://url.com', :branch => 'develop'"
    let result = parser.parse(line: line)
    XCTAssertEqual(result.prefix, "  ")
    XCTAssertEqual(result.podName, "Pod")
    XCTAssertEqual(result.options.count, 3)
    XCTAssertEqual(result.options["path"], "'../Pod'")
    XCTAssertEqual(result.options["git"], "'https://url.com'")
    XCTAssertEqual(result.options["branch"], "'develop'")
  }
    
  func test_parse_multiline() {
    let line = """
      pod 'Pod',
        :git => 'https://url.com',
        :branch => 'develop',
        :inhibit_warnings => false
    """
    let result = parser.parse(line: line)
    
    XCTAssertEqual(result.prefix, "  ")
    XCTAssertEqual(result.podName, "Pod")
    XCTAssertEqual(result.options.count, 3)
    XCTAssertEqual(result.options["git"], "'https://url.com'")
    XCTAssertEqual(result.options["branch"], "'develop'")
    XCTAssertEqual(result.options["inhibit_warnings"], "false")
  }
}
