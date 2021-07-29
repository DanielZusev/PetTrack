
import UIKit
import Firebase

class PetSearchController: UIViewController {
    
    @IBOutlet weak var serachBar: UISearchBar!
    @IBOutlet weak var petView: UITableView!
    
    var petArr = [Pet]()
    var customerArr = [String]()
    var filteredData: [Pet] = []
    var db: Firestore!
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        petView.register(CustomVetPetCell.nib(), forCellReuseIdentifier: CustomVetPetCell.identifier)
        petView.delegate = self
        petView.dataSource = self
        
        serachBar.delegate = self
        
        email = Utilities.getEmailFromPhone()
        
        db = Firestore.firestore()
    }
    
}


//MARK: Table View Config
extension PetSearchController: UITableViewDelegate, UITableViewDataSource , UISearchBarDelegate, MyCustomVetPetCellDelegate {
    
    func didTapButton(with title: String) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier:"VetPetDetailsController") {
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
        let customCell = petView.dequeueReusableCell(withIdentifier: CustomVetPetCell.identifier, for: indexPath) as! CustomVetPetCell
        
        let pet = filteredData[indexPath.row]
        customCell.configure(with: pet.name, imageName: "user")
        customCell.delegate = self
        return customCell
    }
    
    //MARK: Search Bar Config
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        
        if searchText == "" {
            filteredData = petArr
        }
        else {
            if !petArr.isEmpty {
                for pet in petArr {
                    if pet.name.lowercased().contains(searchText.lowercased()) {
                        filteredData.append(pet)
                    }
                }
            }
        }
        
        self.petView.reloadData()
    }
    
    //MARK: Update Data
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        self.petArr.removeAll()
        self.customerArr.removeAll()
        
        db.collection("users").whereField("vetEmail", isEqualTo: self.email!).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
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
                            let age = data["age"] as? String ?? ""
                            let race = data["race"] as? String ?? ""
                            let color = data["color"] as? String ?? ""
                            let medical = data["medical"] as? String ?? ""
                            let lastVisit = data["lastVisit"] as? String ?? ""
                            let ownerEmail = data["ownerEmail"] as? String ?? ""
                            
                            let pet = Pet(name: name, ownerEmail: ownerEmail, age: age, race: race, color: color, medical: medical,lastVisit: lastVisit)
                            self.petArr.append(pet)
                        }
                    }
                    self.filteredData = self.petArr
                    self.petView.reloadData()
                }
            }
        }
    }
}

