import XCTest
@testable import Reports

class HTMLSummaryRendererTests: XCTestCase {

    var tempFile: String = {
        let dirPath = NSTemporaryDirectory()
        return dirPath.appending("\(UUID().uuidString).html")
    }()

    func testHTMLSummaryRenderer() async {
        do {
            try """
        <h1> This is h1 </h1>
        <h2> This is h2 </h2>
        <h3> This is h3 </h3>
        <h4> This is h4 </h4>
        <h5> This is h5 </h5>
        
        Link:
        <a href="https://google.com"> Google </a>
        
        Unordered List:
        <ul>
          <li> Item 1 </li>
          <li> Item 2 </li>
          <li> Item 3 </li>
        </ul>
        
        Ordered List:
        <ol>
          <li> Item 1 </li>
          <li> Item 2 </li>
          <li> Item 3 </li>
        </ol>
        
        Table:
        <table>
          <tr>
            <th>Name</th>
            <th>Age</th>
          </tr>
          <tr>
            <td>Michael</td>
            <td>20</td>
          </tr>
          <tr>
            <td>Henry</td>
            <td>21</td>
          </tr>
        </table>
        """.data(using: .utf8)!.write(to: URL(fileURLWithPath: tempFile))
            
            let expectation = """
         This is h1
        ===========
        
        
         This is h2
        -----------
        
        
        ###  This is h3
        
        
        ####  This is h4
        
        
        #####  This is h5
        
        
        
        Link:
         [Google](https://google.com)\u{20}
        
        Unordered List:
        * Item 1
        * Item 2
        * Item 3
        
        
        
        Ordered List:
        1. Item 1
        2. Item 2
        3. Item 3
        
        
        
        Table:
        
        
        | Name | Age |
        | --- | --- |
        | Michael | 20 |
        | Henry | 21 |
        
        
        
        """
            let htmlSummaryRenderer = HTMLSummaryRenderer(path: tempFile)
            let md = try await htmlSummaryRenderer.render()
            XCTAssertEqual(md, expectation)
        } catch {
            XCTFail("fail")
        }
        
    }
    
    override func tearDown() {
        super.tearDown()
        try? FileManager.default.removeItem(atPath: tempFile)
    }
}
