

import UIKit
import Firebase

class AddPetPopUpController: UIViewController {
    
    @IBOutlet weak var petNameTF: UITextField!
    @IBOutlet weak var petAgeTF: UITextField!
    @IBOutlet weak var petRaceTF: UITextField!
    @IBOutlet weak var petColorTF: UITextField!
    @IBOutlet weak var petMedicalTF: UITextField!
    @IBOutlet weak var addBTN: UIButton!
    @IBOutlet weak var errorLBL: UILabel!
    
    var db: Firestore!
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email = Utilities.getEmailFromPhone()
        
        db = Firestore.firestore()
        
        setUpElements()
    }
    
    
    @IBAction func addPetTapped(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil  {
            showError(error!)
        }
        else{
            let name = petNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let age = petAgeTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let race = petRaceTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let color = petColorTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let medical = petMedicalTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            db.collection("pets").addDocument(data:[
                                                "name": name,
                                                "ownerEmail": self.email!,
                                                "age": age,
                                                "race" : race,
                                                "color": color
                                                ,"medical": medical,
                                                "lastVisit": ""]) { (error) in
                if error != nil {
                    self.showError("Pet couldnt be saved on database")
                }
            }
            self.dismiss(animated: true) {
                let vc = CustomerProfileController()
                self.present(vc, animated: true, completion: nil)
            }
            
        }
    }
    
    
    func setUpElements() {
        errorLBL.alpha = 0
        
        Utilities.styleTextField(petNameTF)
        Utilities.styleTextField(petAgeTF)
        Utilities.styleTextField(petRaceTF)
        Utilities.styleTextField(petColorTF)
        Utilities.styleTextField(petMedicalTF)
        Utilities.styleFilledButton(addBTN)
    }
    
    func validateFields() -> String? {
        
        if  petNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                petAgeTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                petRaceTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                petColorTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                petMedicalTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please Fill in all fields"
        }
        
        return nil
    }
    
    func showError(_ message:String) {
        errorLBL.text = message
        errorLBL.alpha = 1
    }
}
