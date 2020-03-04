import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var category = LinkingObjects(fromType: Category.self, property: "items")

    required init() {
        super.init()
    }
    
    required init(_ title: String) {
        super.init()
        self.title = title
    }
    
    func toggleDone() {
        done = !done
    }
}
