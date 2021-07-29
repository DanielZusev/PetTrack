

import UIKit

protocol MyCustomVetPetCellDelegate:AnyObject {
    func didTapButton(with title: String)
}

class CustomVetPetCell: UITableViewCell {
    
    weak var delegate: MyCustomVetPetCellDelegate?
    
    static let identifier = "CustomVetPetCell"
    
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var moreDetailsBTN: UIButton!
    
    static func nib() -> UINib {
        return UINib(nibName: "CustomVetPetCell", bundle: nil)
    }
    
    
    public func configure(with name: String, imageName: String){
        petName.text = name
        petImage.image = UIImage(named: imageName)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        savePetToPhone()
        delegate?.didTapButton(with: petName.text ?? "")
        
    }
    
    func savePetToPhone(){
        let defaults = UserDefaults.standard
        defaults.set(self.petName.text, forKey: "pet")
    }
}
