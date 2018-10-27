import Foundation

struct utils {
    static func getInput() -> String {
        //shamelessly 'borrowed' from: https://www.raywenderlich.com/511-command-line-programs-on-macos-tutorial
        let keyboard = FileHandle.standardInput
        let inputData = keyboard.availableData
        let strData = String(data: inputData, encoding: String.Encoding.utf8)!
        return strData.trimmingCharacters(in: CharacterSet.newlines)
    }
    
    static func load(_ url: String) -> Data? {
        return FileManager.default.contents(atPath: url)
    }
    
    static func parse(_ data: Data) -> View? { return try? JSONDecoder().decode(View.self, from: data) }

    enum selector {
        case classId
        case id
        case className
    }
    
    static func getSelectors(from s: String) -> [selector: String] {
        var selectors = [selector: String]()
        var currentSelector = selector.classId
        let res = s.reduce("") { i, r in
            if r == "#" {
                selectors[currentSelector] = i
                currentSelector = .id
                return ""
            }
            if r == "." {
                selectors[currentSelector] = i
                currentSelector = .className
                return ""
            }
            return i + "\(r)"
        }
        selectors[currentSelector] = res
        
        return selectors
    }
}

