import Foundation
import UIKit
import RealmSwift

class CategoryListRepo {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    func retrieveData() {
        categories = realm.objects(Category.self)
    }
    
    private func saveData(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving Category[\(category.name)] in Realm: \(error)")
        }
    }
       
    func addNewCategory(_ name: String) {
        let newCategory = Category(name)

        saveData(category: newCategory)
    }
    
    func removeCategory(for index: Int) {
        if let category = categories?[index] {
            do {
                try realm.write {
                    realm.delete(category)
                }
            } catch {
                print("Error deleting Category[\(category.name)] in Realm: \(error)")
            }
        }
    }
}
