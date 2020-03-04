import Foundation
import UIKit
import RealmSwift

class TodoListRepo {
    
    let SORT_BY = "dateCreated"
    let SORT_ASCENDING = true
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    var category: Category? {
        didSet {
            retrieveData()
        }
    }
    
    func retrieveData() {
        todoItems = category?.items.sorted(byKeyPath: SORT_BY, ascending: SORT_ASCENDING)
    }
        
    func addNewItem(_ title: String, for category: Category) {
        do {
            try realm.write {
                let newItem = Item(title)
                category.items.append(newItem)
            }
        } catch {
            print("Error saving new Item(\(title)): \(error)")
        }
    }
    
    func toggleDone(at index: Int) {
        if let item = todoItems?[index] {
            do {
                try realm.write {
                    item.toggleDone()
                }
            } catch {
                print("Error updating Item(\(item.title)): \(error)")
            }
        }
    }
    
    func searchItem(_ searchText: String) {
        print("searchItem: \(searchText)")

        if (!searchText.isEmpty) {
            let filterPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            todoItems = todoItems?.filter(filterPredicate).sorted(byKeyPath: SORT_BY, ascending: SORT_ASCENDING)
        }
        else {
            retrieveData() // No filter = load all data
        }
    }
}
