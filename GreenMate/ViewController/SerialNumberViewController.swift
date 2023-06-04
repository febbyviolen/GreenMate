//
//  SerialNumberViewController.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/14.
//

import UIKit
import ProgressHUD
import RxCocoa
import RxSwift

class SerialNumberViewController: UIViewController {
    
    var network = Networking()
    @IBOutlet weak var textField: UITextField!
    var respond = PublishSubject<Int>()
    var plantData = [String]()
    var img: UIImage!
    
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
        
        respond.subscribe { respond in
            if self.textField.text == "" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    ProgressHUD.showError("그린메이트 못 찾았습니다")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    ProgressHUD.dismiss()
                }
            } else if respond == 1 {
                ProgressHUD.showSucceed("그린메이트 찾았습니다!", delay: 1)
                if self.plantData.isEmpty {
                    self.performSegue(withIdentifier: "greenMateFound", sender: self)
                } else {
                    self.uploadPictToAWSS3()
                    self.network.relationModuleFunc([self.textField.text ?? "", self.plantData[0], self.plantData[1], "testURL"])
                    self.performSegue(withIdentifier: "backToMain", sender: self)
                    
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    ProgressHUD.showError("그린메이트 못 찾았습니다")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    ProgressHUD.dismiss()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "greenMateFound" {
            let nController = segue.destination as? UINavigationController
            let vc = nController?.topViewController as? SelectPlantTypeViewController
            vc?.moduleId = textField.text ?? ""
        }
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
        
        network.registerModuleFunc(textField.text ?? "") { [weak self] response in
            self?.respond.onNext(response!)
        }
        
    }
    
    func uploadPictToAWSS3() {
        guard let image = img else { return }
        AWSS3Manager.shared.uploadImage(image: image, moduleId: textField.text ?? "" , progress: {[weak self] ( uploadProgress) in
            
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
