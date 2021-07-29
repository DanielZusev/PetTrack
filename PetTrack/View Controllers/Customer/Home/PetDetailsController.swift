

import UIKit
import Firebase

class PetDetailsController: UIViewController {
    
    @IBOutlet weak var name: UILabel?
    @IBOutlet weak var age: UILabel?
    @IBOutlet weak var race: UILabel?
    @IBOutlet weak var color: UILabel?
    @IBOutlet weak var lastVisit: UILabel?
    @IBOutlet weak var medical: UILabel?
    @IBOutlet weak var backBTN: UIButton!
    
    var db: Firestore!
    var email: String!
    var petName:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email = Utilities.getEmailFromPhone()
        petName = Utilities.getPetFromPhone()
        Utilities.styleFilledButton(backBTN)
        
        db = Firestore.firestore()
        
        loadData()
    }
    
    func loadData() {
        
        db.collection("pets").whereField("ownerEmail", isEqualTo: email!).getDocuments { (querySnapshot, err) in
            if err != nil {
                print("Error getting documents:")
            } else {
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    let name = data["name"] as? String ?? ""
                    
                    if name == self.petName {
                        let age = data["age"] as? String ?? ""
                        let race = data["race"] as? String ?? ""
                        let color = data["color"] as? String ?? ""
                        let medical = data["medical"] as? String ?? ""
                        let lastVisit = data["lastVisit"] as? String ?? ""
                        
                        self.name?.text = "Name: \(name)"
                        self.age?.text = "Age: \(age)"
                        self.race?.text = "Race: \(race)"
                        self.color?.text = "Color: \(color)"
                        self.lastVisit?.text = "Last Visit: \(lastVisit)"
                        self.medical?.text = "Medical: \(medical)"
                    }
                }
            }
            
        }
    }
    
    @IBAction func onBackPress(_ sender: Any) {
        self.dismiss(animated: true) {
            let vc = CustomerHomeController()
            self.present(vc, animated: true, completion: nil)
        }
    }
}
