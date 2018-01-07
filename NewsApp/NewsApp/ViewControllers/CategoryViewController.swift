import Toast_Swift
import RealmSwift
import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var editButton: UIBarItem!
    
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
        //controleren of dat de searchbar leeg is
        //indien leeg wordt de search segue niet uitgevoerd
        if identifier == "search" {
            return !(self.searchBar.text?.isEmpty)!
        }
        return true
    }
    
    @IBAction func onEditPressed(_ sender: Any) {
        //verplaats rows van plaats
        tableView.setEditing(!(tableView.isEditing), animated: true)
        editButton.title = tableView.isEditing ? "Stop editing" : "Edit rows"
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


extension CategoryViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //rij van plaats veranderen
        if destinationIndexPath.row >= 0 && destinationIndexPath.row < (categories?.count)!
        {
            let cat = categories?[sourceIndexPath.row]
            categories?.remove(at: sourceIndexPath.row)
            categories?.insert(cat!, at: destinationIndexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //rij verwijderen
        categories?.remove(at: indexPath.row)
        tableView.deleteRows(at:[indexPath] ,with: UITableViewRowAnimation.fade)
    }
}

extension CategoryViewController: UISplitViewControllerDelegate {
    
    //zorgt ervoor dat de splitviewcontroller met master start ipv detail
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}


extension CategoryViewController: UISearchBarDelegate{
    //zorgt ervoor dat als er op het toetsenbord op "search" gedrukt wordt dat er ook effectief de search segue wordt uitgevoerd
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "search", sender:  self)
    }
}









