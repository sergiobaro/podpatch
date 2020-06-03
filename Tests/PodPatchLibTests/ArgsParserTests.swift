import XCTest
@testable import PodPatchLib

class ArgsParserTests: XCTestCase {
    
    let parser = ArgsParser()
    
    func test_missingPodNameError() {
        let args = "podpatch".split(separator: " ").map { String($0) }
        XCTAssertThrowsError(try parser.parse(args: args)) { error in
            XCTAssertEqual(error as? ArgsParserError, .missingPodName)
        }
    }
    
    func test_missingPatchError() {
        let args = "podpatch pod".split(separator: " ").map { String($0) }
        XCTAssertThrowsError(try parser.parse(args: args)) { error in
            XCTAssertEqual(error as? ArgsParserError, .missingPatch)
        }
    }
    
    func test_patchWrongFormatError() {
        let args = "podpatch pod patch".split(separator: " ").map { String($0) }
        XCTAssertThrowsError(try parser.parse(args: args)) { error in
            XCTAssertEqual(error as? ArgsParserError, .patchWrongFormat)
        }
    }
    
    func test_propertyNotSupportedError() {
        let args = "podpatch pod property:value".split(separator: " ").map { String($0) }
        XCTAssertThrowsError(try parser.parse(args: args)) { error in
            XCTAssertEqual(error as? ArgsParserError, .propertyNotSupported("property"))
        }
    }
    
    func test_valuesIsEmptyError() {
        let args = "podpatch pod path:".split(separator: " ").map { String($0) }
        XCTAssertThrowsError(try parser.parse(args: args)) { error in
            XCTAssertEqual(error as? ArgsParserError, .valueIsEmpty("path"))
        }
    }
    
    func test_oneProperty() throws {
        let args = "podpatch pod path:../Core".split(separator: " ").map { String($0) }
        let result = try parser.parse(args: args)
        
        XCTAssertEqual(result.podName, "pod")
        XCTAssertEqual(result.property, "path")
        XCTAssertEqual(result.value, "../Core")
    }
    
    /*

     case missingPodName
     case missingPatch
     case patchWrongFormat
     case propertyNotSupported(String)
     case valueIsEmpty(String)
     */

}
