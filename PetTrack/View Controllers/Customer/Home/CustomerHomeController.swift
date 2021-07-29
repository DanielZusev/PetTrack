

import UIKit
import Firebase

class CustomerHomeController: UIViewController {
    
    @IBOutlet weak var petView: UITableView!
    
    
    var petArr = [Pet]()
    var db: Firestore!
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        petView.register(CustomPetCell.nib(), forCellReuseIdentifier: CustomPetCell.identifier)
        petView.delegate = self
        petView.dataSource = self
        
        email = Utilities.getEmailFromPhone()
        
        db = Firestore.firestore()
    }
}

//MARK: Table View Config
extension CustomerHomeController: UITableViewDelegate, UITableViewDataSource, MyCustomPetCellDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = petView.dequeueReusableCell(withIdentifier: CustomPetCell.identifier, for: indexPath) as! CustomPetCell
        
        let pet = petArr[indexPath.row]
        customCell.configure(with: pet.name, imageName: "pets")
        customCell.delegate = self
        return customCell
    }
    
    func didTapButton(with title: String){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier:"PetDetailsController") {
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
        self.petArr.removeAll()
        
        db.collection("pets").whereField("ownerEmail", isEqualTo: email!).getDocuments { (querySnapshot, err) in
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
                    
                    let pet = Pet(name: name, ownerEmail: self.email, age: age, race: race, color: color, medical: medical,lastVisit: lastVisit)
                    self.petArr.append(pet)
                }
            }
            self.petView.reloadData()
        }
    }
}



