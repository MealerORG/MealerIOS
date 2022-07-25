//
//  WelcomeViewController.swift
//  Mealer
//
//  Created by Nelson Gou on 7/12/22.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
                
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .medium)]
        let title = NSAttributedString(string: "Let's Go!", attributes: attributes)
        button.setAttributedTitle(title, for: .normal)
        button.layer.cornerRadius = 20
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        performSegue(withIdentifier: "welcomeToApp", sender: self)
    }
}
