import Foundation
import RealmSwift

class Senators: Object {
    dynamic var state = ""
    dynamic var state_name = ""
    dynamic var name = ""
    dynamic var full_address = ""
    dynamic var address_line1 = ""
    dynamic var address_city = ""
    dynamic var address_state = ""
    dynamic var address_zip = 0
    dynamic var party = ""
    dynamic var phone = ""
    dynamic var url = ""
    dynamic var facebook = ""
    dynamic var twitter = ""
    dynamic var youtube = ""
    
    
    static func senatorsFor(state: String) -> Array<Senators>? {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        
        guard let dirPath = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true).first else {
            return nil
        }
        
        let marchActionsRealmURL = URL(fileURLWithPath: dirPath).appendingPathComponent("senators.realm")
        let fileManager = FileManager.default
        let fileUrl: URL
        
        if fileManager.fileExists(atPath: marchActionsRealmURL.path) {
            fileUrl = marchActionsRealmURL
        } else {
            fileUrl = Bundle.main.url(forResource: "senators", withExtension: "realm")!
        }
        
        let realmConfig = Realm.Configuration( fileURL: fileUrl, readOnly: true)
        let realm = try! Realm(configuration: realmConfig)
        let statePredicate = NSPredicate.init(format: "state == '\(state)'")
        let senators = realm.objects(Senators.self).filter(statePredicate)
        
        return Array(senators)
    }
    
    static func senatorsTwitterHandlesFor(state: String) -> Array<String>? {
        if let senators = Senators.senatorsFor(state: state) {
            return senators.map{ "@\($0.twitter)" }
        }
        return nil
    }
}
