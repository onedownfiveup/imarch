import Foundation
import RealmSwift

class MarchActions: Object {
    dynamic var day = 0
    dynamic var identifier = 0
    dynamic var title = ""
    dynamic var type = ""
    dynamic var recipient = ""
    dynamic var message = ""
    dynamic var subject = ""
    dynamic var about = ""
    dynamic var additional_links = ""
    
    func additionalLinksArray() -> Array<String>? {
        return additional_links.characters.split{$0 == ","}.map(String.init)
    }    
}

