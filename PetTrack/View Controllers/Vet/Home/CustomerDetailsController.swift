
import UIKit
import Firebase

class CustomerDetailsController: UIViewController {
    
    @IBOutlet weak var customerNameLBL: UILabel?
    @IBOutlet weak var customerEmailTF: UILabel?
    @IBOutlet weak var removeCustomerBTN: UIButton!
    @IBOutlet weak var backBTN: UIButton!
    
    var db: Firestore!
    var email: String!
    var customer:String!
    var customerEmailString:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email = Utilities.getEmailFromPhone()
        customer = Utilities.getCustomerFromPhone()
        Utilities.styleFilledButton(backBTN)
        
        db = Firestore.firestore()
        
        loadData()
    }
    
    func loadData() {
        
        db.collection("users").whereField("vetEmail", isEqualTo: self.email!).getDocuments { (querySnapshot, err) in
            if err != nil {
                print("Error getting documents:")
            } else {
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    let firstName = data["firstName"] as? String ?? ""
                    let lastName = data["lastName"] as? String  ?? ""
                    let name = "\(firstName) \(lastName)"
                    
                    if name == self.customer {
                        let email = data["email"] as? String ?? ""
                        
                        self.customerNameLBL?.text = "Name: \(name)"
                        self.customerEmailTF?.text = "Email: \(email)"
                        self.customerEmailString = email
                    }
                }
            }
            
        }
    }
    
    @IBAction func onRemovePress(_ sender: Any) {
        db.collection("users").document(customerEmailString).setData(["vetEmail": ""], merge: true)
        self.onBackPress(self)
    }
    
    @IBAction func onBackPress(_ sender: Any) {
        self.dismiss(animated: true) {
            let vc = VetHomeController()
            self.present(vc, animated: true, completion: nil)
        }
    }
}
