import UIKit

class ArticleCell : UITableViewCell{
    
    @IBOutlet weak var headline: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    
    
    var article: Article!{
        didSet{
            headline.text = article?.headline
            /*DispatchQueue.main.async(execute: { () -> Void in
                self.articleImage.image = UIImage(data : (self.article?.image)!)
            })*/
            DispatchQueue.main.async {
                if self.article?.image == nil
                {
                    //self.articleImage.image = #imageLiteral(resourceName: "NoImage")
                }
                else{
                    self.articleImage.image = UIImage(data : (self.article?.image)!)
                }
            }
        }
    }
    
    
    
}
