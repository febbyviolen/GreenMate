//
//  NickNameViewController.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/15.
//

import UIKit

class NickNameViewController: UIViewController {
    
    var img: UIImage!
    var type: PlantType!
    @IBOutlet weak var label: UITextField!
    
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
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func nextAction() {
        var newGreenMate = GreenMate(name: label.text!, img: "plant1", type: type, light: 0, temp: 0, humidity: 0)
        DataStore.shared.addItems(newGreenMate)
        performSegue(withIdentifier: "backToMain", sender: self)
    }

}
