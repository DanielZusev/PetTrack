

import UIKit
import Firebase

class EditPetController: UIViewController {
    
    @IBOutlet weak var petName: UITextField!
    @IBOutlet weak var petAge: UITextField!
    @IBOutlet weak var petRace: UITextField!
    @IBOutlet weak var petColor: UITextField!
    @IBOutlet weak var petLastVisit: UITextField!
    @IBOutlet weak var petMedical: UITextView!
    @IBOutlet weak var saveBTN: UIButton!
    
    var db: Firestore!
    var email: String!
    var petOwnerEmail: String!
    var documentId: String!
    
    var pet: Pet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email = Utilities.getEmailFromPhone()
        petName.text = Utilities.getPetFromPhone()
        petOwnerEmail = Utilities.getpetOwnerFromPhone()
        Utilities.styleFilledButton(saveBTN)
        
        db = Firestore.firestore()
        
        loadData()
        
    }
    
    func loadData() {
        
        db.collection("pets").whereField("ownerEmail", isEqualTo: petOwnerEmail!).getDocuments { (querySnapshot, err) in
            if err != nil {
                print("Error getting documents:")
            } else {
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    let name = data["name"] as? String ?? ""
                    
                    if name == self.petName.text {
                        let age = data["age"] as? String ?? ""
                        let race = data["race"] as? String ?? ""
                        let color = data["color"] as? String ?? ""
                        let medical = data["medical"] as? String ?? ""
                        let lastVisit = data["lastVisit"] as? String ?? ""
                        
                        self.pet = Pet(name: name, ownerEmail: self.petOwnerEmail, age: age, race: race, color: color, medical: medical, lastVisit: lastVisit)
                        
                        self.petName?.text = name
                        self.petAge?.text = age
                        self.petRace?.text = race
                        self.petColor?.text = color
                        self.petLastVisit?.text = lastVisit
                        self.petMedical?.text = medical
                        self.documentId = document.documentID
                    }
                }
            }
            
        }
    }
    
    
    @IBAction func onSave(_ sender: Any) {
        if checkIfDataChanged() {
            db.collection("pets").document(self.documentId).setData(["name": self.pet.name ,
                                                                     "age": self.pet.age,
                                                                     "race" : self.pet.race,
                                                                     "color": self.pet.color,
                                                                     "medical": self.pet.medical,
                                                                     "lastVisit": self.pet.lastVisit], merge: true)
            
            self.dismiss(animated: true) {
                let vc = VetPetDetailsController()
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func checkIfDataChanged() -> Bool {
        if self.pet.name.lowercased() != self.petName.text?.lowercased() ||
            self.pet.age.lowercased() != self.petAge.text?.lowercased() ||
            self.pet.race.lowercased() != self.petRace.text?.lowercased() ||
            self.pet.color.lowercased() != self.petColor.text?.lowercased() ||
            self.pet.lastVisit.lowercased() != self.petLastVisit.text?.lowercased() ||
            self.pet.medical.lowercased() != self.petMedical.text?.lowercased() {
            
            
            let newPet = Pet(name: self.petName.text!, ownerEmail: petOwnerEmail, age: self.petAge.text!, race: self.petRace.text!, color: self.petColor.text!, medical: self.petMedical.text!, lastVisit: self.petLastVisit.text!)
            
            self.pet = newPet
            return true
        }
        return false
    }
    
}
