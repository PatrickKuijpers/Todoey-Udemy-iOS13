import UIKit
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    var todoListRepo = TodoListRepo()
    var category: Category? {
        didSet {
            todoListRepo.category = category
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let safeCategory = category {
            title = safeCategory.name
            
            if let categoryColor = UIColor(hexString: safeCategory.backgroundColor) {
                updateNavBarColor(categoryColor)
                
                searchBar.barTintColor = categoryColor
                searchBar.searchTextField.backgroundColor = FlatWhite()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListRepo.todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoListRepo.todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            if let safeCategory = category, let backgroundColor = UIColor(hexString: safeCategory.backgroundColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoListRepo.todoItems!.count)) {
                cell.backgroundColor = backgroundColor
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor, returnFlat: true)
            }
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "No items added"
        }
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
    
    func addNewItem(_ title: String) {
        todoListRepo.addNewItem(title, for: category)
        tableView.reloadData()
    }
    
    override func removeItem(for index: Int) {
        todoListRepo.removeItem(at: index)
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
