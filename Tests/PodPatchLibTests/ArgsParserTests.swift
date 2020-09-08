import XCTest
@testable import PodPatchLib

class ArgsParserTests: XCTestCase {
    
    let parser = ArgsParser()
    
    func test_missingPodNameError() {
        let args = "".split(separator: " ").map { String($0) }
        XCTAssertThrowsError(try parser.parse(args: args)) { error in
            XCTAssertEqual(error as? ArgsParserError, .missingPodName)
        }
    }
    
    func test_missingPatchError() {
        let args = "pod".split(separator: " ").map { String($0) }
        XCTAssertThrowsError(try parser.parse(args: args)) { error in
            XCTAssertEqual(error as? ArgsParserError, .missingPatch)
        }
    }
    
    func test_patchWrongFormatError() {
        let args = "pod patch".split(separator: " ").map { String($0) }
        XCTAssertThrowsError(try parser.parse(args: args)) { error in
            XCTAssertEqual(error as? ArgsParserError, .patchWrongFormat)
        }
    }
    
    func test_propertyNotSupportedError() {
        let args = "pod property:value".split(separator: " ").map { String($0) }
        XCTAssertThrowsError(try parser.parse(args: args)) { error in
            XCTAssertEqual(error as? ArgsParserError, .propertyNotSupported("property"))
        }
    }
    
    func test_valuesIsEmptyError() {
        let args = "pod path:".split(separator: " ").map { String($0) }
        XCTAssertThrowsError(try parser.parse(args: args)) { error in
            XCTAssertEqual(error as? ArgsParserError, .valueIsEmpty("path"))
        }
    }
    
    func test_oneProperty() throws {
        let args = "pod path:../Core".split(separator: " ").map { String($0) }
        let result = try parser.parse(args: args)
        
        XCTAssertEqual(result.podName, "pod")
        XCTAssertEqual(result.property, PodProperty.path)
        XCTAssertEqual(result.value, "../Core")
    }
}
