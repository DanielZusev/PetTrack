
import UIKit
import Firebase

class CustomerProfileController: UIViewController {
    
    @IBOutlet weak var customerNameLBL: UILabel!
    @IBOutlet weak var customerEmailLBL: UILabel!
    
    @IBOutlet weak var addPetBTN: UIButton!
    @IBOutlet weak var customerVetNameLBL: UILabel!
    
    var db: Firestore!
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        email = Utilities.getEmailFromPhone()
        db = Firestore.firestore()
        
    }
    //MARK: Update Data
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        db.collection("users").document(email).getDocument { result, err in
            if err != nil {
                print("Error getting documents")
            }
            else {
                if let result = result {
                    _ = result.data()
                    let firstName = result["firstName"] as? String ?? ""
                    let lastName = result["lastName"] as? String ?? ""
                    _ = result["userType"] as? String ?? ""
                    let vetEmail = result["vetEmail"] as? String ?? ""
                    let email = result["email"] as? String ?? ""
                    
                    self.customerNameLBL.text = "\(firstName) \(lastName)"
                    self.customerEmailLBL.text = email
                    self.customerVetNameLBL.text = vetEmail
                    
                }
            }
        }
    }
    
    @IBAction func onAddpressed(_ sender: Any) {
    }
}
