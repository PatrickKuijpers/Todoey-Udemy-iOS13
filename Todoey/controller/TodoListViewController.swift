import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Release 3.1.2", "Voorstel Sync", "Testcases afronden", "IOS cursus"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.id.ToDoItemCell, for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currentAccessoryType = tableView.cellForRow(at: indexPath)?.accessoryType {
            if (currentAccessoryType == .none) {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
            else {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
            }
        }
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
                self.itemArray.append(newItem)
                self.tableView.reloadData()
            }
        })
        present(alert, animated: true, completion: nil)
    }
}
