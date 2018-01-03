import RealmSwift
import UIKit

class Article: Object{
    
    @objc dynamic var headline : String = ""
    @objc dynamic var descrip : String = ""
    @objc dynamic var url : String = ""
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var image : Data?
    @objc dynamic var author : String = ""
    
    convenience init(headline:String, description:String, url:String, imageUrl:String, date:Date, author:String)
    {
        self.init()
        self.headline = headline
        self.descrip = description
        self.url = url
        self.imageUrl = imageUrl
        self.date = date
        self.author = author
    }
    
}

