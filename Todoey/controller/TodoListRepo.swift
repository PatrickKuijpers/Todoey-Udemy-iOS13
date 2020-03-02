import Foundation

struct TodoListRepo {
    
    let decoder  = PropertyListDecoder()
    let encoder  = PropertyListEncoder()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var itemArray = [Item]()
    
    init() {
        print("Location: \(dataFilePath!)")
    }
    
    mutating fileprivate func initDummyData() {
        let newItem1 = Item("Release 3.1.2")
        let newItem2 = Item("Voorstel Sync")
        let newItem3 = Item("Testcases afronden")
        let newItem4 = Item("iOS cursus")
        itemArray.append(newItem1)
        itemArray.append(newItem2)
        itemArray.append(newItem3)
        itemArray.append(newItem4)
    }
    
    mutating func addNewItem(_ newItem: Item) {
        itemArray.append(newItem)
        saveData()
    }
    
    mutating func toggleDone(_ index: Int) {
        itemArray[index].toggleDone()
        saveData()
    }
    
    func retrieveData() -> [Item] {
        if let data = try? Data(contentsOf: dataFilePath!) {
            do {
                return try decoder.decode([Item].self, from: data)
            }
            catch {
                print("Error decoding itemArray: \(error)")
            }
        }
        return [Item]() // Nothing found? return empty list!
    }
    
    func saveData() {
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch {
            print("Error encoding itemArray: \(error)")
        }
    }
}
