//
//  SignUpViewController.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/06/06.
//

import UIKit

class SignUpViewController: UIViewController {
    
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

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var network = Networking()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(saveBtn)
        setupUI()
        
        NSLayoutConstraint.activate([
            saveBtn.heightAnchor.constraint(equalToConstant: 50),
            saveBtn.widthAnchor.constraint(equalToConstant: 333),
            saveBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveBtn.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10)
        ])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSignUpDetailView" {
            guard let VC = segue.destination as? SignUpDetailViewController else {return}
            VC.data = [idTextField.text ?? "", passwordTextField.text ?? ""]
        }
    }

    @objc func nextAction() {
        network.loginFunc([idTextField.text ?? "", passwordTextField.text ?? "" ]) { [weak self] info in
            print("result: \(info)")
            if info == nil {
                self?.performSegue(withIdentifier: "showSignUpDetailView", sender: self)
            } else {
                self?.defaults.set(self?.idTextField.text ?? "", forKey: "UserId")
                self?.defaults.set(self?.passwordTextField.text ?? "", forKey: "UserPassword")
                self?.defaults.set(info?.first?.name , forKey: "UserName")
                
                self?.performSegue(withIdentifier: "showViewController", sender: self)
            }
        }
        
        
    }
    
    func setupUI() {
        passwordTextField.textContentType = .oneTimeCode
    }

}
