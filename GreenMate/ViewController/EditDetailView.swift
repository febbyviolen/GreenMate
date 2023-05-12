//
//  EditDetailView.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/09.
//

import UIKit

class EditDetailView: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backIcon")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backIcon")
        
        saveBtn.layer.cornerRadius = 15
        img.layer.cornerRadius = 10
        
    }
    
    @IBAction func saveAction(_ sender: Any) {
    }
    
}
