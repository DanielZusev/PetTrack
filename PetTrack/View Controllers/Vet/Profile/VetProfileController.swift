
import UIKit
import Firebase

class VetProfileController: UIViewController {
    
    var db: Firestore!
    var email: String!
    
    @IBOutlet weak var vetNameLBL: UILabel!
    @IBOutlet weak var vetEmailLBL: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email = Utilities.getEmailFromPhone()
        db = Firestore.firestore()
        
        db.collection("users").document(email).getDocument { result, err in
            if err != nil {
                print("Error getting documents")
            }
            else {
                if let result = result {
                    _ = result.data()
                    let firstName = result["firstName"] as? String ?? ""
                    let lastName = result["lastName"] as? String ?? ""
                    
                    self.vetNameLBL.text = "\(firstName) \(lastName)"
                    self.vetEmailLBL.text = self.email
                }
            }
        }
    }
}
