
import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(logInButton)
        
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil  {
            showError(error!)
        }
        else{
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: email, password: pass) { result, err in
                if err != nil {
                    self.showError("Wrong log In Details")
                }
                else {
                    self.transitionToHome(email)
                }
            }
        }
        
    }
    
    func validateFields() -> String? {
        
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please Fill in all fields"
        }
        
        return nil
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(_ userEmail: String) {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let db = Firestore.firestore()
        db.collection("users").document(email).getDocument { result, err in
            if err != nil {
                self.showError("User not signed in")
            }
            else {
                if let result = result {
                    let data = result.data()
                    let userType = data!["userType"] as? String ?? ""
                    
                    self.saveEmailToPhone()
                    
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
            }
        }
    }
    
    func saveEmailToPhone(){
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
    }
}
