import Foundation
import UIKit
import CoreData

class TodoListRepo {
    
    private let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
            
//    mutating fileprivate func initDummyData() {
//        let newItem1 = Item("Release 3.1.2")
//        let newItem2 = Item("Voorstel Sync")
//        let newItem3 = Item("Testcases afronden")
//        let newItem4 = Item("iOS cursus")
//        itemArray.append(newItem1)
//        itemArray.append(newItem2)
//        itemArray.append(newItem3)
//        itemArray.append(newItem4)
//    }
    
    func retrieveData(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
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
        
    func addNewItem(_ newItemTitle: String) {
        let newItem = Item(context: context)
        newItem.title = newItemTitle
        newItem.done = false

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
        if (!searchText.isEmpty) {
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            
            request.predicate = predicate
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        }
        retrieveData(with: request)
    }
}
