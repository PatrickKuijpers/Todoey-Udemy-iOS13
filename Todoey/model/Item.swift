import Foundation

struct Item: Codable {
    let title: String
    var done: Bool = false
    
    init(_ title: String) {
        self.title = title
    }
    
    mutating func toggleDone() {
        done = !done
    }
}
