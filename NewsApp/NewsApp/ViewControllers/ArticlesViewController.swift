import Toast_Swift
import RealmSwift
import UIKit

class ArticlesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    private var articles : [Article]?
    
    private var newsTask: URLSessionTask?
    
    private var indexPath: IndexPath!
    
    var category: String?
    
    var subject: String?
    
    override func viewDidLoad() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        newsTask?.cancel()
        if subject != nil
        {
            navItem.title = "Search results for \"\(subject!)\""
            newsTask = NewsService.getNewsBySubject(for : subject!, completion: { (arts) in
                self.articles = arts!
                self.tableView.reloadData()
            })
        }
        if category != nil
        {
            navItem.title = category
            newsTask = NewsService.getNewsByCategory(for : category!, completion: { (arts) in
                self.articles = arts!
                self.tableView.reloadData()
                
            })
        }
        newsTask!.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "showArticle"
        {
            let articleViewController = (segue.destination as! UINavigationController).topViewController as! ArticleViewController
            let selection = tableView.indexPathForSelectedRow!
            articleViewController.article = articles![selection.row]
            tableView.deselectRow(at: selection, animated: true)
        }
    }
    
}


extension ArticlesViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath)
            as! ArticleCell
        cell.article = articles?[indexPath.row]
        return cell
    }
    
}

extension ArticlesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let saveAction = UIContextualAction(style: .normal, title: "Save") {
            (action, view, completionHandler) in
            let realm = try! Realm()
            try! realm.write {
                realm.add((self.articles?[indexPath.row])!)
                self.view.makeToast("Article saved")
            }
            completionHandler(true)
        }
        
        saveAction.backgroundColor = UIColor.gray
        
        return UISwipeActionsConfiguration(actions: [saveAction])
    }
    
}



