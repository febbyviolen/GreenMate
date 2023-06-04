//
//  EmptyViewController.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/06/01.
//

import UIKit

class EmptyViewController: UIViewController {

    @IBOutlet weak var plantRegister: UIButton!
    @IBOutlet weak var moduleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        plantRegister.layer.cornerRadius = 15
        moduleButton.layer.cornerRadius = 15
        
    }
    
    @IBAction func plantBtnFunc(_ sender: Any) {
        
    }
    
    

}
