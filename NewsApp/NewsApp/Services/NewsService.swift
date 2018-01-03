import Foundation
import UIKit

class NewsService{
    static var key = "45ab4a88ef9749439d1af9d756688e9d"
    
    private static var session = URLSession(configuration: .ephemeral)
    
    static func getNewsByCategory(for category : String, completion: @escaping ([Article]?) -> Void) -> URLSessionTask
    {
        let url = "https://newsapi.org/v2/top-headlines?category=\(category)&language=en&apiKey=\(NewsService.key)"
        
        return downloadNews(for : url, completion: completion)
    }
    
    static func getNewsBySubject(for subject : String, completion: @escaping ([Article]?) -> Void) -> URLSessionTask
    {
        let url = "https://newsapi.org/v2/everything?q=\(subject)&language=en&apiKey=\(NewsService.key)"
        
        return downloadNews(for : url, completion: completion)
    }
    
    private static func downloadNews(for urlString : String, completion: @escaping ([Article]?) -> Void) -> URLSessionTask
    {
        let url = URL(string: urlString)!
        
        return session.dataTask(with: url) { (data, response, error) in
            
            var newsTask: URLSessionTask?
            
            let completion: ([Article]?) -> Void = {
                articles in
                DispatchQueue.main.async {
                    completion(articles)
                }
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers),
                let res = json as? [String : AnyObject] else {
                    return
            }
            
            guard let main = res["articles"] as? [[String : AnyObject]]
                else {
                    return
            }
            
            var articles = [Article]()
            
            let dateFor: DateFormatter = DateFormatter()
            dateFor.dateFormat = "yyyy-MM-dd"
            
            for jsonArticle in main
            {
                if let headline = jsonArticle["title"] as? String, let description = jsonArticle["description"] as? String,
                    let url = jsonArticle["url"] as? String, let imageUrl = jsonArticle["urlToImage"] as? String, let date = jsonArticle["publishedAt"] as? String, let auhtor = jsonArticle["author"] as? String
                {
                    let dateIndex = date.index(date.startIndex, offsetBy: 10)
                    
                    let dated = dateFor.date(from: String(date.prefix(upTo: dateIndex)))
                    
                    let article = Article(headline : headline, description : description, url: url, imageUrl: imageUrl, date : (dated)!, author: auhtor)
                    if imageUrl != "" && imageUrl != " "
                    {
                        newsTask = NewsService.downloadImage(for: article)
                        newsTask?.resume()
                    }
                    
                    articles.append(article)
                }
            }
            completion(articles)
        }
    }
    
    static func downloadSources(completion: @escaping ([Source]?) -> Void) -> URLSessionTask
    {
        let url = URL(string: "https://newsapi.org/v2/sources?language=en&apiKey=\(self.key)")!
        
        return session.dataTask(with: url) { (data, response, error) in
            
            let completion: ([Source]?) -> Void = {
                sources in
                DispatchQueue.main.async {
                    completion(sources)
                }
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers),
                let res = json as? [String : AnyObject] else {
                    return
            }
            
            guard let main = res["sources"] as? [[String : AnyObject]]
                else {
                    return
            }
            
            var sources = [Source]()
            
            let dateFor: DateFormatter = DateFormatter()
            dateFor.dateFormat = "yyyy-MM-dd"
            
            for jsonArticle in main
            {
                if let id = jsonArticle["id"] as? String, let name = jsonArticle["name"] as? String,
                    let descrip = jsonArticle["description"] as? String
                {
                    let source = Source(id: id, name: name, descrip: descrip)
                    sources.append(source)
                }
            }
            completion(sources)
        }
    }
    
    
    private static func downloadImage(for article:Article) -> URLSessionTask
    {
        let url = URL(string:article.imageUrl)!
        return session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            DispatchQueue.main.async {
                if data != nil
                {
                    article.image = Data(data!)
                }
            }
        })
    }
}
