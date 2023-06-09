//
//  WelcomeViewController.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/06/06.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        self.navigationController?.isNavigationBarHidden = true

    }
    
    @IBAction func welcomeButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "showViewController", sender: self)
    }
    
}

extension WelcomeViewController {
    func setupUI() {
        welcomeButton.layer.cornerRadius = 15
        textLabel.text = "\(name)님! 환영합니다"
    }
    
}
