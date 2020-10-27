import XCTest
@testable import PodPatchLib

class PodlineFinderTests: XCTestCase {
  
  let finder = PodlineFinder()
  
  func test_oneline() {
    let podfile = """
    pod 'Pod1', :git => 'https://url.com/pod1', :branch => 'develop'
    pod 'Pod2', :git => 'https://url.com/pod2', :branch => 'develop'
    pod 'Pod3', :git => 'https://url.com/pod3', :branch => 'develop'
    """
    
    let result = finder.findLinesWithPod(podfile: podfile, podName: "Pod2")
    
    XCTAssertEqual("pod 'Pod2', :git => 'https://url.com/pod2', :branch => 'develop'", result)
  }
  
  func test_multiline() {
    let podfile = """
      pod 'Pod1',
        :git => 'https://url.com/pod1',
        :branch => 'develop',
        :inhibit_warnings => false
      pod 'Pod2',
        :git => 'https://url.com/pod2',
        :branch => 'develop',
        :inhibit_warnings => false
    """
    
    let result = finder.findLinesWithPod(podfile: podfile, podName: "Pod1")
    
    let expected = """
      pod 'Pod1',
        :git => 'https://url.com/pod1',
        :branch => 'develop',
        :inhibit_warnings => false
    """
    XCTAssertEqual(expected, result)
  }
    
  func test_multline_end() {
      let podfile = """
        pod 'Pod1',
          :git => 'https://url.com/pod1',
          :branch => 'develop',
          :inhibit_warnings => false
        pod 'Pod2',
          :git => 'https://url.com/pod2',
          :branch => 'develop',
          :inhibit_warnings => false
      end
      """
      
      let result = finder.findLinesWithPod(podfile: podfile, podName: "Pod2")
      
      let expected = """
        pod 'Pod2',
          :git => 'https://url.com/pod2',
          :branch => 'develop',
          :inhibit_warnings => false
      """
      XCTAssertEqual(expected, result)
  }
    
  func test_multiline_target() {
    let podfile = """
        pod 'Pod1',
          :git => 'https://url.com/pod1',
          :branch => 'develop',
          :inhibit_warnings => false
        pod 'Pod2',
          :git => 'https://url.com/pod2',
          :branch => 'develop',
          :inhibit_warnings => false
      
      target 'BMITests' do
        inherit! :search_paths
      end
    """
    
    let result = finder.findLinesWithPod(podfile: podfile, podName: "Pod2")
    
    let expected = """
        pod 'Pod2',
          :git => 'https://url.com/pod2',
          :branch => 'develop',
          :inhibit_warnings => false
    """
    XCTAssertEqual(expected, result)
  }
}
