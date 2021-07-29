

import UIKit
import Firebase

class CustomerSearchController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var vetView: UITableView!
    
    var vetArr = [User]()
    var filteredData: [User] = []
    var db: Firestore!
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vetView.register(CustomVetCell.nib(), forCellReuseIdentifier: CustomVetCell.identifier)
        vetView.delegate = self
        vetView.dataSource = self
        
        searchBar.delegate = self
        
        email = Utilities.getEmailFromPhone()
        
        db = Firestore.firestore()
        
    }
    
}

//MARK: Table View Config
extension CustomerSearchController: UITableViewDelegate, UITableViewDataSource , UISearchBarDelegate, MyCustomVetCellDelegate {
    
    func didTapButton(with title: String) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier:"VetDetailsController") {
            vc.modalTransitionStyle   = .crossDissolve;
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = vetView.dequeueReusableCell(withIdentifier: CustomVetCell.identifier, for: indexPath) as! CustomVetCell
        
        let vet = filteredData[indexPath.row]
        customCell.configure(with: "\(vet.firstName!) \(vet.lastName!)", imageName: "user")
        customCell.delegate = self
        return customCell
    }
    
    //MARK: Search Bar Config
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        
        if searchText == "" {
            filteredData = vetArr
        }
        else {
            if !vetArr.isEmpty {
                for user in vetArr {
                    if user.firstName!.lowercased().contains(searchText.lowercased()) {
                        filteredData.append(user)
                    }
                }
            }
        }
        
        self.vetView.reloadData()
    }
    
    //MARK: Update Data
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        self.vetArr.removeAll()
        
        db.collection("users").whereField("userType", isEqualTo: "vet").getDocuments { (querySnapshot, err) in
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
                    
                    
                    let vet = User(firstName: firstName, lastName: lastName, userType: userType, email: email, vetEmail: vetEmail)
                    self.vetArr.append(vet)
                }
            }
            self.filteredData = self.vetArr
            self.vetView.reloadData()
        }
    }
}


