import XCTest
@testable import BitsoTest

class PeriodFormatterTests: XCTestCase {
    func test_period() {
        XCTAssertEqual(PeriodFormatter.period(start: 1900, end: 1950), "1900 - 1950")
        XCTAssertEqual(PeriodFormatter.period(start: nil, end: 1950), "1950")
        XCTAssertEqual(PeriodFormatter.period(start: 1900, end: nil), "1900 - Now")
        XCTAssertEqual(PeriodFormatter.period(start: nil, end: nil), "")
    }
}
