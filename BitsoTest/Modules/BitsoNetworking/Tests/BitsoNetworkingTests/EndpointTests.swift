import XCTest
@testable import BitsoNetworking

class EndpointTests: XCTestCase {
    func test_urlRequest_requestQueryParameters() throws {
        let endpoint = TestingEndpoint.requestQueryParameters
        XCTAssertEqual(endpoint.urlRequest().url?.absoluteString,
                       "https://www.justatest.com/requestQueryParameters?boolean=false&integer=321&string=String")
    }
}
