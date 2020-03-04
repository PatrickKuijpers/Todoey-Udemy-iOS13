import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
    required init() {
        super.init()
    }
    
    required init(_ name: String) {
        super.init()
        self.name = name
    }
}
