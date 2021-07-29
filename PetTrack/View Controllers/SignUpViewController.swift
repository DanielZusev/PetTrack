

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var backBTN: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var userTypeSegment:UISegmentedControl!
    
    var userType: String = "customer"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    @IBAction func userTypeIndexChange(_ sender: Any) {
        switch userTypeSegment.selectedSegmentIndex
        {
        case 0:
            userType = "customer"
        case 1:
            userType = "vet"
        default:
            break
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil  {
            showError(error!)
        }
        else{
            
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            Auth.auth().createUser(withEmail: email, password: pass) { (result, error) in
                if  error != nil {
                    self.showError("Error creating user")
                }
                else {
                    let db = Firestore.firestore()
                    db.collection("users").document(email).setData([
                                                                    "firstName": firstName,
                                                                    "lastName": lastName,
                                                                    "email": email,
                                                                    "userType" : self.userType,
                                                                    "vetEmail": ""]) { (error) in
                        if error != nil {
                            self.showError("User couldnt be saved on database")
                        }
                    }
                    self.transitionToHome(email)
                }
            }
        }
    }
    
    //check fields are valid
    func validateFields() -> String? {
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please Fill in all fields"
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Please make sure  your password is at least 8 charecters, contain a special character and a number"
        }
        
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isEmailValid(cleanedEmail) == false {
            return "Please make sure your email is in correct email form"
        }
        
        return nil
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(_ userEmail: String) {
        saveEmailToPhone()
        
        if userType == "customer" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "CustomerMainTabBarController")
            
            // This is to get the SceneDelegate object from your view controller
            // then call the change root view controller function to change to main tab bar
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            
        }
        else if userType == "vet" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "VetMainTabBarController")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        }
    }
    
    func saveEmailToPhone(){
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
    }
}

