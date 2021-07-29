

import UIKit
import Firebase

class VetPetDetailsController: UIViewController {
    
    @IBOutlet weak var petNameLBL: UILabel!
    @IBOutlet weak var petAgeLBL: UILabel!
    @IBOutlet weak var petRaceLBL: UILabel!
    @IBOutlet weak var petColorLBL: UILabel!
    @IBOutlet weak var petLastVisitLBL: UILabel!
    @IBOutlet weak var petMedicalLBL: UILabel!
    @IBOutlet weak var editBTN: UIButton!
    @IBOutlet weak var backBTN: UIButton!
    
    var db: Firestore!
    var email: String!
    var petName:String!
    var petOwnerEmail: String!
    var customerArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email = Utilities.getEmailFromPhone()
        petName = Utilities.getPetFromPhone()
        Utilities.styleFilledButton(backBTN)
        
        db = Firestore.firestore()
        
        loadData()
    }
    
    @IBAction func onEditPress(_ sender: Any) {
        
    }
    
    @IBAction func OnBackPress(_ sender: Any) {
        self.dismiss(animated: true) {
            let vc = PetSearchController()
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    func savePetOwnerToPhone(){
        let defaults = UserDefaults.standard
        defaults.set(self.petOwnerEmail, forKey: "petOwner")
    }
    
    //MARK: Update Data
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        
        db.collection("users").whereField("vetEmail", isEqualTo: self.email!).getDocuments { (querySnapshot, err) in
            if err != nil {
                print("Error getting documents")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let email = data["email"] as? String ?? ""
                    
                    self.customerArr.append(email)
                }
                
                self.db.collection("pets").whereField("ownerEmail", in: self.customerArr).getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
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
                                let ownerEmail = data["ownerEmail"] as? String ?? ""
                                
                                self.petNameLBL.text = name
                                self.petAgeLBL.text = age
                                self.petRaceLBL.text = race
                                self.petColorLBL.text = color
                                self.petMedicalLBL.text = medical
                                self.petLastVisitLBL.text = lastVisit
                                self.petOwnerEmail = ownerEmail
                                
                                self.savePetOwnerToPhone()
                            }
                            
                        }
                    }
                }
            }
        }
    }
}
