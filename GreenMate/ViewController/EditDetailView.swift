//
//  EditDetailView.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/09.
//

import UIKit

protocol EditDetailDelegate {
    func nameChanged(controller: EditDetailView)
}

class EditDetailView: UIViewController{
    
    var delegate: EditDetailDelegate! = nil
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var img: UIImageView!
    
    var selectedPlant: Greenmate!
    var network = Networking()
    var imgsrc: UIImage!
    
    lazy var saveBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        button.backgroundColor = UIColor(named: "softGreen")
        button.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        button.layer.cornerRadius = 15
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        img.image = imgsrc
        textField.placeholder = selectedPlant?.nickname
        
        img.layer.cornerRadius = 15
        view.addSubview(saveBtn)
        
        
        NSLayoutConstraint.activate([
            saveBtn.heightAnchor.constraint(equalToConstant: 50),
            saveBtn.widthAnchor.constraint(equalToConstant: 333),
            saveBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveBtn.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10)
        ])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDeleteGreenMate2" {
            let VC = segue.destination as? DeleteGreenMate
            VC?.selectedPlant = selectedPlant
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if textField.text != "" {
            network.updateGreenMateNickNameFunc([selectedPlant.moduleId, textField.text!])
            delegate.nameChanged(controller: self)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
 
    
        
    
}


