import Toast_Swift
import RealmSwift
import UIKit

class SourcesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var sources : [Source]?
    
    private var newsTask: URLSessionTask?
    
    private var indexPath: IndexPath!
    
    
    override func viewDidLoad() {
        tableView.rowHeight = UITableViewAutomaticDimension
        newsTask?.cancel()
        newsTask = NewsService.downloadSources(completion: { (sources) in
            self.sources = sources!
            self.tableView.reloadData()
        })
        newsTask!.resume()
    }
}


extension SourcesViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sourceCell", for: indexPath)
        let source = sources?[indexPath.row]
        cell.textLabel!.text = source?.name
        cell.detailTextLabel!.text = source?.descrip
        return cell
    }
    
}



