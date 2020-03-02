import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var todoListRepo = TodoListRepo()

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        todoListRepo.retrieveData()
        searchBar.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListRepo.itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.id.ToDoItemCell, for: indexPath)
        let currentItem = todoListRepo.itemArray[indexPath.row]
        cell.textLabel?.text = currentItem.title
        cell.accessoryType = currentItem.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todoListRepo.toggleDone(at: indexPath.row)
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
            if let newItemTitle = textField.text {
                self.addNewItem(newItemTitle)
            }
        })
        present(alert, animated: true, completion: nil)
    }
    
    func addNewItem(_ newItemTitle: String) {
        todoListRepo.addNewItem(newItemTitle)
        tableView.reloadData()
    }
}

//MARK: - SearchBar
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoListRepo.searchItem(searchBar.text!)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            todoListRepo.retrieveData()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
