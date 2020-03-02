import Foundation
import UIKit
import CoreData

class CategoryListRepo {
    
    private let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Category]()
    
    func retrieveData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
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
       
    func addNewCategory(_ name: String) {
        let newCategory = Category(context: context)
        newCategory.name = name

        categoryArray.append(newCategory)
        
        saveData()
    }
}
