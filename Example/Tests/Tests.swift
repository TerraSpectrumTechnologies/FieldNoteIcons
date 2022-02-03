import XCTest
import FieldNoteIcons

@testable import FieldNoteIcons

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatAllSVGNamesAreLowerCase() {
        let icons = FieldNoteIcons.iconList()
        for icon in icons {
            let lowerCaseStringToCheck = icon.lowercased()
            XCTAssertTrue(icon == lowerCaseStringToCheck)
        }
    }
    
    func testThatIconListOnlyReturnsSVGs() {
        let icons = FieldNoteIcons.iconList()
        for icon in icons {
            XCTAssertTrue(FieldNoteIcons.iconExists(name: icon))
        }
    }
    
    func testIconExistsReturnsTrueWhenIconExists() {
        let icons = FieldNoteIcons.iconList()
        let existingIcon = FieldNoteIcons.iconExists(name: icons.first!)
        
        XCTAssertTrue(existingIcon)
    }
    
    func testIconExistsReturnsTrueWhenUsingUpperCaseName() {
        let icons = FieldNoteIcons.iconList()
        let existingIcon = FieldNoteIcons.iconExists(name: icons.first!.uppercased())
        
        XCTAssertTrue(existingIcon)
    }
    
    func testIconExistsDoesNotCrashWhenIconDoesNotExist() {
         let nonExistentIcon = FieldNoteIcons.iconExists(name: "BogusIconWeWillNeverHave...Hopefully")
        
        XCTAssertFalse(nonExistentIcon)
    }
    
    func testPinIconForHexColorsReturnsIcon() {
        let icons = FieldNoteIcons.iconList()
        var gotPinIcon = false
        for icon in icons {
            let pinIcon = FieldNoteIcons.pinIcon(name: icon, size: CGSize(width: 40, height: 40), primaryColorHex: "000000")
            if pinIcon != nil {
                gotPinIcon = true
                return
            }
        }
        XCTAssertTrue(gotPinIcon)
    }
    
    func testColorWithHexStringReturnsWhiteWhenGivenInvalidHex() {
        let color = FieldNoteIcons.colorWithHexString(hexString: "GarbageHexString")
        
        XCTAssertEqual(color, .white)
    }
    
    func testIconListPerformance() {
        self.measure() {
            _ = FieldNoteIcons.iconList()
        }
    }
    
    func testIconForNamePerformance() {
        self.measure() {
            _ = FieldNoteIcons.icon(name: "mower", size: CGSize(width: 40, height: 40), primaryColor: .black)
        }
    }
}
