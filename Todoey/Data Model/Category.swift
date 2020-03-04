import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var backgroundColor: String = UIColor.black.hexValue()
    let items = List<Item>()
    
    required init() {
        super.init()
    }
    
    required init(_ name: String) {
        super.init()
        self.name = name
        self.backgroundColor = UIColor.randomFlat().hexValue()
    }
}
