import XCTest
@testable import PodPatchLib

class PodfilePatcherTests: XCTestCase {

  let patcher = PodfilePatcher()

  func test_patch_podNotFoundError() throws {
    let podfile = """
    pod 'OtherPod', :git => 'https://url.com', :branch => 'develop'
    """
    let args = Args(podName: "Pod", property: .path, value: "value")
    
    XCTAssertThrowsError(try patcher.patch(podfile: podfile, args: args)) { error in
      XCTAssertEqual(error as? PodfilePatcherError, .podNotFound("Pod"))
    }
  }
  
  func test_patch_withPath() throws {
    let podfile = """
    pod 'Pod', :git => 'https://url.com', :branch => 'develop'
    """
    let args = Args(podName: "Pod", property: .path, value: "../Pod")

    let result = try patcher.patch(podfile: podfile, args: args)

    let expected = """
    pod 'Pod', :path => '../Pod' # :git => 'https://url.com', :branch => 'develop'
    """
    XCTAssertEqual(result, expected)
  }

  func test_patch_withBranch() throws {
    let podfile = """
    pod 'Pod', :git => 'https://url.com', :branch => 'develop'
    """
    let args = Args(podName: "Pod", property: .branch, value: "another/branch")

    let result = try patcher.patch(podfile: podfile, args: args)

    let expected = """
    pod 'Pod', :git => 'https://url.com', :branch => 'another/branch'
    """
    XCTAssertEqual(result, expected)
  }

  func test_patch_withBranch_fromPath() throws {
    let podfile = """
    pod 'Pod', :path => '../Pod' # :git => 'https://url.com', :branch => 'develop'
    """

    let args = Args(podName: "Pod", property: .branch, value: "another/branch")
    let result = try patcher.patch(podfile: podfile, args: args)

    let expected = """
    pod 'Pod', :git => 'https://url.com', :branch => 'another/branch'
    """
    XCTAssertEqual(result, expected)
  }

  func test_patch_multipleLines_withBranch() throws {
    let podfile = """
    pod 'Pod1', :git => 'https://url.com/pod1', :branch => 'develop'
    pod 'Pod2', :git => 'https://url.com/pod2', :branch => 'develop'
    pod 'Pod3', :git => 'https://url.com/pod3', :branch => 'develop'
    """
    let args = Args(podName: "Pod2", property: .branch, value: "another/branch")

    let result = try patcher.patch(podfile: podfile, args: args)

    let expected = """
    pod 'Pod1', :git => 'https://url.com/pod1', :branch => 'develop'
    pod 'Pod2', :git => 'https://url.com/pod2', :branch => 'another/branch'
    pod 'Pod3', :git => 'https://url.com/pod3', :branch => 'develop'
    """
    XCTAssertEqual(result, expected)
  }
  
  func test_path_withSpaces() throws {
    let podfile = """
      pod 'Pod', :git => 'https://url.com', :branch => 'develop'
    """
    let args = Args(podName: "Pod", property: .path, value: "../Pod")

    let result = try patcher.patch(podfile: podfile, args: args)

    let expected = """
      pod 'Pod', :path => '../Pod' # :git => 'https://url.com', :branch => 'develop'
    """
    XCTAssertEqual(result, expected)
  }
  
  func test_multiline() throws {
    let podfile = """
      pod 'Pod',
        :git => 'https://url.com',
        :branch => 'develop',
        :inhibit_warnings => false
    """
    let args = Args(podName: "Pod", property: .path, value: "../Pod")
    
    let result = try patcher.patch(podfile: podfile, args: args)
    
    let expected = """
      pod 'Pod',
        :path => '../Pod',
        # :git => 'https://url.com',
        # :branch => 'develop',
        :inhibit_warnings => false
    """
    XCTAssertEqual(result, expected)
  }
    
  func test_multiline_fromPathToBranch() throws {
    let podfile = """
      pod 'Pod1',
        :path => '../Pod1',
        # :git => 'https://git.com/pod1',
        # :branch => 'develop',
        :inhibit_warnings => false
    """
    let args = Args(podName: "Pod1", property: .branch, value: "develop")
    
    let result = try patcher.patch(podfile: podfile, args: args)
    
    let expected = """
      pod 'Pod1',
        :git => 'https://git.com/pod1',
        :branch => 'develop',
        :inhibit_warnings => false
    """
    XCTAssertEqual(result, expected)
  }
}
