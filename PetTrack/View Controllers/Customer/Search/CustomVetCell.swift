
import UIKit

protocol MyCustomVetCellDelegate:AnyObject {
    func didTapButton(with title: String)
}

class CustomVetCell: UITableViewCell {
    
    weak var delegate: MyCustomVetCellDelegate?
    
    @IBOutlet weak var vetAvatar: UIImageView!
    @IBOutlet weak var vetName: UILabel!
    @IBOutlet weak var vetDetailsBTN: UIButton!
    
    static let identifier = "CustomVetCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CustomVetCell", bundle: nil)
    }
    
    
    public func configure(with name: String, imageName: String){
        vetName.text = name
        vetAvatar.image = UIImage(named: imageName)
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
        saveVetToPhone()
        delegate?.didTapButton(with: vetName.text ?? "")
        
    }
    
    func saveVetToPhone(){
        let defaults = UserDefaults.standard
        defaults.set(self.vetName.text, forKey: "vet")
    }
}
