import XCTest
@testable import PodPatchLib

class PodfilePatcherTests: XCTestCase {

  let patcher = PodfilePatcher()

  func test_patch_withPath() throws {
    let podfile = """
        pod 'Pod', :git => 'https://url.com', :branch => 'develop'
        """
    let args = Args(podName: "Pod", property: "path", value: "../Pod")

    let result = try patcher.patch(podfile: podfile, args: args)

    let expected = """
        pod 'Pod', :path => '../Pod'
        """
    XCTAssertEqual(result, expected)
  }

  func test_patch_withBranch() throws {
    let podfile = """
    pod 'Pod', :git => 'https://url.com', :branch => 'develop'
    """
    let args = Args(podName: "Pod", property: "branch", value: "another/branch")

    let result = try patcher.patch(podfile: podfile, args: args)

    let expected = """
    pod 'Pod', :git => 'https://url.com', :branch => 'another/branch'
    """
    XCTAssertEqual(result, expected)
  }
}
