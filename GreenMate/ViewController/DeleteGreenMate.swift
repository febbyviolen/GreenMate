//
//  DeleteGreenMate.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/14.
//

import UIKit

class DeleteGreenMate: UIViewController {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false;

        background.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 15
        saveBtn.layer.cornerRadius = 15
        
        self.isModalInPresentation = true
            
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
