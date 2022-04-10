import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

class Element: CustomStringConvertible {
    
    var name: String
    var attributes: [String: String] = [:]
    var children: [Element] = []
    var characters: String?
    weak var parent: Element?
    
    init(name: String) {
        self.name = name
    }
    
    var description: String {
        return name + "(\(children))"
    }
}

final class SimpleXMLParser: NSObject, XMLParserDelegate {
    
    private var root = Element(name: "Root")
    private var addedElements = [Element]()
    private var continuation: CheckedContinuation<Element, Error>?
    
    func parse(xml: String) async throws -> Element {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else { return }
            self.continuation = continuation
            let parser = XMLParser(data: xml.data(using: .utf8)!)
            parser.delegate = self
            _ = parser.parse()
        }
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        reset()
    }
    
    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        continuation?.resume(throwing: validationError)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        continuation?.resume(throwing: parseError)
    }
    
    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]) {
            let newElement = Element(name: elementName)
            let parentElement = addedElements.last
            newElement.parent = parentElement
            newElement.attributes = attributeDict
            parentElement?.children.append(newElement)
            addedElements.append(newElement)
        }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        addedElements.last?.characters = string
    }
    
    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?) {
            addedElements.removeLast()
        }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        guard let continuation = continuation else {
            return
        }
        continuation.resume(returning: root)
    }
    
    // MARK: - Private
    private func reset() {
        addedElements = []
        root = Element(name: "Root")
        addedElements.append(root)
    }
}
