import UIKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    var categoryListRepo = CategoryListRepo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryListRepo.retrieveData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navBarBackgroundColor = UIColor(hexString: "1D9BF6") {
            updateNavBarColor(navBarBackgroundColor)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryListRepo.categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categoryListRepo.categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            if let categoryColor = UIColor(hexString: category.backgroundColor) {
                cell.backgroundColor = categoryColor
                cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            }
        }
        else {
            cell.textLabel?.text = "No categories added yet"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.navigation.CategoryToDetailItems, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.category = categoryListRepo.categories?[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(UIAlertAction(title: "Add category", style: .default) { (action) in
            if let newCategoryTitle = textField.text {
                self.addNewCategory(newCategoryTitle)
            }
        })
        present(alert, animated: true, completion: nil)
    }
    
    func addNewCategory(_ title: String) {
        categoryListRepo.addNewCategory(title)
        tableView.reloadData()
    }
    
    override func removeItem(for index: Int) {
        categoryListRepo.removeCategory(for: index)
    }
}
