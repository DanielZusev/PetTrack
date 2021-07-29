

import UIKit

protocol MyCustomCustomerCellDelegate:AnyObject {
    func didTapButton(with title: String)
}

class CustomCustomerCell: UITableViewCell {
    
    weak var delegate: MyCustomCustomerCellDelegate?
    
    @IBOutlet weak var customerImage: UIImageView!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var moreDetailsBTN: UIButton!
    
    static let identifier = "CustomCustomerCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CustomCustomerCell", bundle: nil)
    }
    
    
    public func configure(with name: String, imageName: String){
        customerName.text = name
        customerImage.image = UIImage(named: imageName)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func onDetailsPressed(_ sender: Any) {
        savePetToPhone()
        delegate?.didTapButton(with: customerName.text ?? "")
        
    }
    
    func savePetToPhone(){
        let defaults = UserDefaults.standard
        defaults.set(self.customerName.text, forKey: "customer")
    }
    
}
