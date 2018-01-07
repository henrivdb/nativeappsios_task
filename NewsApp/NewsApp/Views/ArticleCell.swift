import UIKit

class ArticleCell : UITableViewCell{
    
    @IBOutlet weak var headline: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    
    private var session = URLSession(configuration: .ephemeral)
    
    var newsTask: URLSessionTask?
    
    var article: Article!{
        didSet{
            headline.text = article?.headline
            if self.article.image != nil {
                self.articleImage.image = UIImage(data : (self.article.image)!)
            }else
            {
                let url = URL(string :  article.imageUrl)
                if url == nil
                {
                    setNoImage()
                }
                else{
                    newsTask = downloadImage(for: url!)
                    newsTask?.resume()
                }
                
            }
        }
    }
    
    private func downloadImage(for imageurl:URL) -> URLSessionTask
    {
        return session.dataTask(with: imageurl, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil{
                    self.setNoImage()
                    return
                }
                self.article?.image = Data(data!)
                self.articleImage.image = UIImage(data : data!)
            }
            
        })
    }
    
    private func setNoImage()
    {
        self.articleImage.image = #imageLiteral(resourceName: "NoImage")
        self.article?.image = UIImagePNGRepresentation(#imageLiteral(resourceName: "NoImage"))
    }
}
