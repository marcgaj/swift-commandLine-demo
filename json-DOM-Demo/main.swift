import Foundation

print("please enter the location of the file to import >")
let fileLoc = utils.getInput()

guard let data = utils.load(fileLoc) else {
   print("Could not load file")
    exit(EXIT_FAILURE)
}

guard let root = utils.parse(data) else {
    print("Failed parsing data into JSON model")
    exit(EXIT_FAILURE)
}

print("successfully loaded json\r\n")
print("please type exit at any time to quit")

while true {
    print("please enter query >")
    let query = utils.getInput()
    if query == "exit" { exit(EXIT_SUCCESS) }
    
    let results = root.find(query)
    print("Total of \(results.count) results found.")
    
    let encoder = JSONEncoder()
    print("{ \"results\" : [")
    for view in results {
        if let data = try? encoder.encode(view),
            let str = NSString(data: data, encoding: String.Encoding.ascii.rawValue){
            print("\(str),")
        }
        else {
            print("Failed to parse object for printing")
            exit(EXIT_FAILURE)
        }
    }
    print("]}\r\n")
}



