import UIKit

class TodoListViewController: UITableViewController {

    var todoListRepo = TodoListRepo()
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getItems().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.id.ToDoItemCell, for: indexPath)
        let currentItem = getItems()[indexPath.row]
        cell.textLabel?.text = currentItem.title
        cell.accessoryType = currentItem.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todoListRepo.toggleDone(indexPath.row)
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(UIAlertAction(title: "Add item", style: .default) { (action) in
            if let newItem = textField.text {
                self.addNewItem(Item(newItem))
            }
        })
        present(alert, animated: true, completion: nil)
    }
    
    func getItems() -> [Item] {
        return todoListRepo.retrieveData()
    }
    
    func addNewItem(_ newItem: Item) {
        todoListRepo.addNewItem(newItem)
        tableView.reloadData()
    }
}
