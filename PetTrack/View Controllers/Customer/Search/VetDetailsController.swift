
import UIKit
import Firebase

class VetDetailsController: UIViewController {
    
    @IBOutlet weak var vetName: UILabel?
    @IBOutlet weak var vetEmail: UILabel?
    @IBOutlet weak var chooseVetBTN: UIButton!
    @IBOutlet weak var backBTN: UIButton!
    
    var db: Firestore!
    var email: String!
    var vet:String!
    var vetEmailString:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email = Utilities.getEmailFromPhone()
        vet = Utilities.getVetFromPhone()
        Utilities.styleFilledButton(backBTN)
        
        db = Firestore.firestore()
        
        loadData()
    }
    
    func loadData() {
        
        db.collection("users").whereField("userType", isEqualTo: "vet").getDocuments { (querySnapshot, err) in
            if err != nil {
                print("Error getting documents:")
            } else {
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    let firstName = data["firstName"] as? String ?? ""
                    let lastName = data["lastName"] as? String  ?? ""
                    let name = "\(firstName) \(lastName)"
                    
                    if name == self.vet {
                        let email = data["email"] as? String ?? ""
                        
                        self.vetName?.text = "Name: \(name)"
                        self.vetEmail?.text = "Email: \(email)"
                        self.vetEmailString = email
                    }
                }
            }
            
        }
    }
    
    @IBAction func onBackPress(_ sender: Any) {
        self.dismiss(animated: true) {
            let vc = CustomerSearchController()
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func onChooseBTN(_ sender: Any) {
        db.collection("users").document(email).setData(["vetEmail": vetEmailString ?? ""], merge: true)
        self.onBackPress(self)
    }
}
