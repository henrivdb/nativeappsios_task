import Toast_Swift
import RealmSwift
import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var categories : [String]?
    
    private var indexPath: IndexPath!
    
    override func viewDidLoad() {
        categories = ["Business", "Entertainment", "Gaming", "General", "Health-and-medical", "Music", "Politics" ,"Science-and-Nature" ,"Sport", "Technology"]
        tableView.rowHeight = UITableViewAutomaticDimension
        splitViewController!.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let seg =  segue.identifier
        if seg == "showArticles"
        {
            let articlesViewController = segue.destination as! ArticlesViewController
            let selection = tableView.indexPathForSelectedRow!
            articlesViewController.category = categories?[selection.row]
            tableView.deselectRow(at: selection, animated: true)
        }
        else if seg == "search"{
            let search = searchBar.text
            let articlesViewController = segue.destination as! ArticlesViewController
            articlesViewController.subject = search
            
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "search" {
            return !(self.searchBar.text?.isEmpty)!
        }
        return true
    }
}




extension CategoryViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categories?[indexPath.row]
        cell.textLabel!.text = category
        return cell
    }
    
}

extension CategoryViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}

/*extension CategoryViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        // Do not collapse when the tasks view controller is showing, only when the empty view controller is showing.
        let isShowingTasks = (secondaryViewController as? UINavigationController)?.topViewController is ArticlesViewController
        return !isShowingTasks
    }
}*/






