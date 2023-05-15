//
//  SerialNumberViewController.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/14.
//

import UIKit
import ProgressHUD

class SerialNumberViewController: UIViewController {
    
    lazy var saveBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitle("계속하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        button.backgroundColor = UIColor(named: "softGreen")
        button.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        button.layer.cornerRadius = 15
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        view.addSubview(saveBtn)
        NSLayoutConstraint.activate([
            saveBtn.heightAnchor.constraint(equalToConstant: 50),
            saveBtn.widthAnchor.constraint(equalToConstant: 333),
            saveBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveBtn.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10)
                ])
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorBackground = UIColor(named: "background")!
        ProgressHUD.colorAnimation = UIColor(named: "softGreen")!
        
        
        DispatchQueue.main.async {
            ProgressHUD.show()
        }
        
        // Delay the execution of the dismiss method for 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Hide the progress indicator
            ProgressHUD.showSucceed("그린메이트 찾았습니다!", delay: 1.5)
            self.performSegue(withIdentifier: "greenMateFound", sender: self)
        }
    }

}
