import XCTest
@testable import PediatricTools

final class ToolInfoCatalogTests: XCTestCase {

    private let expectedToolIDs: Set<String> = [
        "apgar", "ballard", "pews", "flacc", "gcs", "pram", "pecarn", "phoenix",
        "dosage", "ivfluid", "bsa", "corrected", "growth", "dehydration", "fena",
        "ett", "gfr", "qtc", "bp", "bilirubin"
    ]

    func testCatalogContains20Tools() {
        XCTAssertEqual(ToolInfoCatalog.all.count, 20)
    }

    func testAllToolIDsPresent() {
        let catalogIDs = Set(ToolInfoCatalog.all.map(\.id))
        XCTAssertEqual(catalogIDs, expectedToolIDs)
    }

    func testNoDuplicateToolIDs() {
        let ids = ToolInfoCatalog.all.map(\.id)
        XCTAssertEqual(ids.count, Set(ids).count, "Duplicate tool IDs found")
    }

    func testAllToolsHaveNonEmptyLinks() {
        for tool in ToolInfoCatalog.all {
            XCTAssertFalse(tool.links.isEmpty, "\(tool.id) has no links")
        }
    }

    func testAllToolsHaveNonEmptyParameters() {
        for tool in ToolInfoCatalog.all {
            XCTAssertFalse(tool.parameters.isEmpty, "\(tool.id) has no parameters")
        }
    }

    func testAllToolsHaveNonEmptyReferenceKeys() {
        for tool in ToolInfoCatalog.all {
            XCTAssertFalse(tool.referenceKeys.isEmpty, "\(tool.id) has no reference keys")
        }
    }

    func testAllLinkURLsAreValid() {
        for tool in ToolInfoCatalog.all {
            for link in tool.links {
                XCTAssertTrue(link.url.absoluteString.hasPrefix("http"),
                              "\(tool.id) link \(link.id) has invalid URL: \(link.url)")
            }
        }
    }

    func testInfoForValidToolID() {
        let info = ToolInfoCatalog.info(for: "apgar")
        XCTAssertNotNil(info)
        XCTAssertEqual(info?.id, "apgar")
    }

    func testInfoForInvalidToolIDReturnsNil() {
        XCTAssertNil(ToolInfoCatalog.info(for: "nonexistent"))
    }
}
