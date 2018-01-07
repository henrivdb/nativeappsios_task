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
        let cleanedSubject = subject.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\\", with: "")
        let url = "https://newsapi.org/v2/everything?q=\(cleanedSubject)&language=en&apiKey=\(NewsService.key)"
        
        return downloadNews(for : url, completion: completion)
    }
    
    static func getNewsBySource(for source : String, completion: @escaping ([Article]?) -> Void) -> URLSessionTask
    {
        let url = "https://newsapi.org/v2/top-headlines?sources=\(source)&apiKey=\(NewsService.key)"
        
        return downloadNews(for : url, completion: completion)
    }
    
    private static func downloadNews(for urlString : String, completion: @escaping ([Article]?) -> Void) -> URLSessionTask
    {
        let url = URL(string: urlString)!
        
        return session.dataTask(with: url) { (data, response, error) in
            
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
            
            guard let arts = res["articles"] as? [[String : AnyObject]]
                else {
                    return
            }
            
            var articles = [Article]()
            
            let dateFor: DateFormatter = DateFormatter()
            dateFor.dateFormat = "yyyy-MM-dd"
            
            for art in arts
            {
                if let headline = art["title"] as? String, let descrip = art["description"] as? String,
                    let url = art["url"] as? String, let imageUrl = art["urlToImage"] as? String, let date = art["publishedAt"] as? String, let auhtor = art["author"] as? String
                {
                    let dateIndex = date.index(date.startIndex, offsetBy: 10)
                    
                    let dated = dateFor.date(from: String(date.prefix(upTo: dateIndex)))
                    
                    let article = Article(headline : headline, descrip : descrip, url: url, imageUrl: imageUrl, date : (dated)!, author: auhtor)
                    
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
            
            guard let srcs = res["sources"] as? [[String : AnyObject]]
                else {
                    return
            }
            
            var sources = [Source]()
            
            let dateFor: DateFormatter = DateFormatter()
            dateFor.dateFormat = "yyyy-MM-dd"
            
            for src in srcs
            {
                if let id = src["id"] as? String, let name = src["name"] as? String,
                    let descrip = src["description"] as? String
                {
                    let source = Source(id: id, name: name, descrip: descrip)
                    sources.append(source)
                }
            }
            completion(sources)
        }
    }
}
