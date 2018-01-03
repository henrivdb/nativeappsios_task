import RealmSwift
import UIKit

class SavedArticlesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var articles : Results <Article>?
    
    private var newsTask: URLSessionTask?
    
    private var indexPath: IndexPath!
    
    override func viewDidLoad() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        articles = try! Realm().objects(Article.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch  segue.identifier {
        case "showArticle"?:
            let articleViewController = segue.destination as! ArticleViewController
            let selection = tableView.indexPathForSelectedRow!
            articleViewController.article = articles![selection.row]
            tableView.deselectRow(at: selection, animated: true)
        default:
            fatalError("Unknown segue")
        }
    }
    
}


extension SavedArticlesViewController: UITableViewDataSource
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

extension SavedArticlesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
            let article = (self.articles?[indexPath.row])!
            let realm = try! Realm()
            try! realm.write {
                realm.delete(article)
            }
            completionHandler(true)
        }
        
        //saveAction.backgroundColor = UIColor.gray
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}






