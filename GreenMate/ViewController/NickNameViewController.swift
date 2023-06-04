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
    var moduleId = "" 
    @IBOutlet weak var label: UITextField!
    var network = Networking()
    
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSerialNumber" {
            let vc = segue.destination as! SerialNumberViewController
            vc.plantData.append(contentsOf: [type.name, label.text ?? " "])
            vc.img = img
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func nextAction() {
        if moduleId == "" {
            performSegue(withIdentifier: "showSerialNumber", sender: self)
        } else {
            uploadToAWSS3()
            network.relationModuleFunc([moduleId, type.name, label.text ?? " ", "testURL"])
            performSegue(withIdentifier: "backToMain", sender: self)
        }
    }
    
    func uploadToAWSS3() {
        guard let image = img else { return }
        AWSS3Manager.shared.uploadImage(image: image, moduleId: moduleId, progress: {[weak self] ( uploadProgress) in
            
            guard let strongSelf = self else { return }
            //            strongSelf.progressView.progress = Float(uploadProgress)
            
        }) {[weak self] (uploadedFileUrl, error) in
            
            guard let strongSelf = self else { return }
            if let finalPath = uploadedFileUrl as? String {
//                print("Uploaded file url: " + finalPath)
            } else {
                print("\(String(describing: error?.localizedDescription))")
            }
        }
    }

}
