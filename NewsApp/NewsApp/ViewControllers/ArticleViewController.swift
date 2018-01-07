import UIKit
import SafariServices

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var headline: UILabel!
    @IBOutlet weak var descrip: UITextView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var extra: UILabel!
    
    var article: Article?
    
    override func viewDidLoad() {
        headline.text = article?.headline
        descrip.text = article?.descrip
        DispatchQueue.main.async {
            if self.article?.image != nil
            {
            self.image.image = UIImage(data : (self.article?.image)!)
            }
            else
            {
                self.image.image = #imageLiteral(resourceName: "NoImage")

            }
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_GB")
        extra.text = "\((article?.author)!) - \(dateFormatter.string(from: (article?.date)!))"
    }
    
    @IBAction func onFullArticlePressed(_ sender: Any) {
        let svc = SFSafariViewController(url: URL(string: (article?.url)!)!)
        present(svc, animated: true, completion: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        //backbutton weergeven wanneer gecollapsed
        super.traitCollectionDidChange(previousTraitCollection)
        if !splitViewController!.isCollapsed {
            navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem
        }
    }
    
}


