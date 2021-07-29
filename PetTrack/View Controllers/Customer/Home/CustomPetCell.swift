

import UIKit

protocol MyCustomPetCellDelegate:AnyObject {
    func didTapButton(with title: String)
}

class CustomPetCell: UITableViewCell {
    
    weak var delegate: MyCustomPetCellDelegate?
    
    @IBOutlet weak var petPic: UIImageView!
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var detailsBTN: UIButton!
    
    static let identifier = "CustomPetCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CustomPetCell", bundle: nil)
    }
    
    
    public func configure(with name: String, imageName: String){
        petName.text = name
        petPic.image = UIImage(named: imageName)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func onDetailsPressed(_ sender: Any) {
        savePetToPhone()
        delegate?.didTapButton(with: petName.text ?? "")
        
    }
    
    func savePetToPhone(){
        let defaults = UserDefaults.standard
        defaults.set(self.petName.text, forKey: "pet")
    }
}
