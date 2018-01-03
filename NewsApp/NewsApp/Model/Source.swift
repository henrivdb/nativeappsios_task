import RealmSwift
import UIKit

class Source: Object{
    
    @objc dynamic var id : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var descrip : String = ""
    
    convenience init(id:String, name:String, descrip:String)
    {
        self.init()
        self.id = id
        self.name = name
        self.descrip = descrip
    }
    
}


