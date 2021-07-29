//
//  ViewController.swift
//  PetTrack
//
//  Created by Daniel Zusev on 04/07/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    func setUpElements() {
       
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(logInButton)
        
    }

    @IBAction func signUpTapped(_ sender: Any) {
        
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        
    }
}

