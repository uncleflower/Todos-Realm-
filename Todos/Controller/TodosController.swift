import UIKit
import Realm
import RealmSwift

class TodosController: UITableViewController {
    
//    var todos:[Todo] = []
    var todos: Results<Todo>?
    var row = 0
    
    let realm = try! Realm()
    
    
//    @IBAction func batchDelete(_ sender: Any) {
//
//        if let indexPaths = tableView.indexPathsForSelectedRows {
//            for indexPath in indexPaths {
//                    todos.remove(at: indexPath.row)
//            }
////            saveData()
//            tableView.beginUpdates()
//            tableView.deleteRows(at: indexPaths, with: .automatic)
//            tableView.endUpdates()
//        }
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "123")

//        print(Realm.Configuration.defaultConfiguration.fileURL)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        navigationItem.leftBarButtonItem = editButtonItem
//        editButtonItem.title = "编辑"
        
        todos = realm.objects(Todo.self)
    }
    
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//        editButtonItem.title = isEditing ? "完成" : "编辑"
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todos?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo", for: indexPath) as! TodoCell

        
        if let todos = todos {
            cell.checkMark.text = todos[indexPath.row].checked ? "√" : ""
            cell.todo.text = todos[indexPath.row].name
        }
        // Configure the cell...
        return cell
    }
    
    //当用户选择cell之后发生什么事情
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
        do{
            try realm.write {
                todos![indexPath.row].checked = !todos![indexPath.row].checked
            }
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
        do{
            try realm.write {
                realm.delete(todos![indexPath.row])
            }
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//        let todo = todos[fromIndexPath.row]
//        todos.remove(at: fromIndexPath.row)
//        todos.insert(todo, at: to.row)
//
//        tableView.reloadData()
    }
 

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addTodo" {
            let vc = segue.destination as! TodoController
            vc.delegate = self
        }else if segue.identifier == "editTodo"{
            let vc = segue.destination as! TodoController
            let cell = sender as! TodoCell
            row = tableView.indexPath(for: cell)!.row
            vc.name = todos?[row].name
            vc.delegate = self
        }
    }

}
extension TodosController:TodoDelegate,UISearchBarDelegate {
    func didAdd(name: String) {
        //添加数据
        let todo = Todo()
        todo.name = name
        saveData(todo:todo)
        //更新视图
        tableView.reloadData()
    }
    
    func didEdit(name: String) {
        //改数据
        do{
            try realm.write {
                todos![row].name = name
            }
        }catch{
            print(error)
        }
        //更新视图
        tableView.reloadData()
        
    }
    func saveData(todo:Todo) {
        do{
            try realm.write {
                realm.add(todo)
            }
        }catch{
            print(error)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        todos = realm.objects(Todo.self)
        
        todos = realm.objects(Todo.self).filter("name CONTAINS %@", searchBar.text!).sorted(byKeyPath: "createdAT", ascending: false)
        
        
        
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty {
            todos = realm.objects(Todo.self)
            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    
}
