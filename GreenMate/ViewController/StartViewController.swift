//
//  StartViewController.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/06/06.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    var defaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        if let ID = defaults.string(forKey: "UserId") {
            performSegue(withIdentifier: "showViewController", sender: self)
        } else {return}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    @IBAction func nextAction(_ sender: Any) {
        performSegue(withIdentifier: "showSignUpView", sender: self)
    }
    
}


extension StartViewController {
    func setupUI() {
        nextButton.layer.cornerRadius = 15
    }
}
