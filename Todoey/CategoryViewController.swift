import UIKit

class CategoryViewController: UITableViewController {
    
    var categoryListRepo = CategoryListRepo()
    
    override func viewDidLoad() {
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        categoryListRepo.retrieveData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryListRepo.categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.id.CategoryCell, for: indexPath)
        cell.textLabel?.text = categoryListRepo.categories?[indexPath.row].name ?? "No categories added yet"
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
}
