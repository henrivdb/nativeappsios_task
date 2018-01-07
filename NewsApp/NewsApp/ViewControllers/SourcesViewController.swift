import Toast_Swift
import RealmSwift
import UIKit

class SourcesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    private var newsTask: URLSessionTask?
    
    private var indexPath: IndexPath!
    
    private var sources : [Source]!
    
    private var allSources : [Source]!
    
    
    override func viewDidLoad() {
        tableView.rowHeight = UITableViewAutomaticDimension
        newsTask?.cancel()
        newsTask = NewsService.downloadSources(completion: { (sources) in
            self.sources = sources!
            self.allSources = sources
            self.tableView.reloadData()
        })
        newsTask!.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "showArticles"
        {
            let articlesViewController = segue.destination as! ArticlesViewController
            let selection = tableView.indexPathForSelectedRow!
            articlesViewController.source = sources?[selection.row].id
            tableView.deselectRow(at: selection, animated: true)
        }
    }
    
}


extension SourcesViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sourceCell", for: indexPath)
        cell.textLabel!.text = sources?[indexPath.row].name
        cell.detailTextLabel!.text = sources?[indexPath.row].descrip
        return cell
    }
    
}


extension SourcesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty
        {
            sources = allSources
        }
        else
        {
        sources = allSources.filter({ (s) -> Bool in
            if s.name.lowercased().contains(searchText.lowercased())
            {
                return true
            }
            return false
        })
        }
        tableView.reloadData()
    }

}




