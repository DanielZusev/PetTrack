

import UIKit
import Firebase

class VetHomeController: UIViewController {
    
    
    @IBOutlet weak var customerView: UITableView!
    
    var customerArr = [User]()
    var db: Firestore!
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerView.register(CustomCustomerCell.nib(), forCellReuseIdentifier: CustomCustomerCell.identifier)
        customerView.delegate = self
        customerView.dataSource = self
        
        email = Utilities.getEmailFromPhone()
        
        db = Firestore.firestore()
    }
}

extension VetHomeController: UITableViewDelegate, UITableViewDataSource, MyCustomCustomerCellDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = customerView.dequeueReusableCell(withIdentifier: CustomCustomerCell.identifier, for: indexPath) as! CustomCustomerCell
        
        let customer = customerArr[indexPath.row]
        customCell.configure(with: "\(customer.firstName!) \(customer.lastName!)", imageName: "user")
        customCell.delegate = self
        return customCell
    }
    
    func didTapButton(with title: String){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier:"CustomerDetailsController") {
            vc.modalTransitionStyle   = .crossDissolve;
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    //MARK: Update Data
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        self.customerArr.removeAll()
        
        db.collection("users").whereField("vetEmail", isEqualTo: email!).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let firstName = data["firstName"] as? String ?? ""
                    let lastName = data["lastName"] as? String ?? ""
                    let userType = data["userType"] as? String ?? ""
                    let vetEmail = data["vetEmail"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    
                    
                    let customer = User(firstName: firstName, lastName: lastName, userType: userType, email: email, vetEmail: vetEmail)
                    self.customerArr.append(customer)
                }
            }
            self.customerView.reloadData()
        }
    }
    
}
