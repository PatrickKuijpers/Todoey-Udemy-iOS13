import Foundation
import UIKit
import CoreData

class TodoListRepo {
    
    private let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    var category: Category? {
        didSet {
            retrieveData()
        }
    }
    
    func retrieveData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//        if let safeCategory = category {
            let categoryPredicate = NSPredicate(format: "category.name MATCHES %@", category!.name!)
//        }
        
        if let additionalPredicate = predicate {
            print("additionalPredicate: \(additionalPredicate)")
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            request.predicate = compoundPredicate
        }
        else {
            print("categoryPredicate: \(categoryPredicate)")
            request.predicate = categoryPredicate
        }

        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
    private func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
        
    func addNewItem(_ title: String, for category: Category) {
        self.category = category
        
        let newItem = Item(context: context)
        newItem.title = title
        newItem.done = false
        newItem.category = category

        itemArray.append(newItem)
        
        saveData()
    }
    
    func toggleDone(at index: Int) {
        itemArray[index].done = !itemArray[index].done
//        itemArray[index].toggleDone()

        saveData()
    }
    
    func searchItem(_ searchText: String) {
        print("searchItem: \(searchText)")

        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        if (!searchText.isEmpty) {
            retrieveData(with: request, predicate: NSPredicate(format: "title CONTAINS[cd] %@", searchText))
        }
        else {
            retrieveData(with: request)
        }
    }
}
