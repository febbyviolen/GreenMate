//
//  ShowSignUpDetailViewViewController.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/06/06.
//

import UIKit

class SignUpDetailViewController: UIViewController, UINavigationControllerDelegate {
    
    lazy var saveBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        button.backgroundColor = UIColor(named: "softGreen")
        button.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        button.layer.cornerRadius = 15
        return button
    }()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    let defaults = UserDefaults.standard
    
    //loginData [ID, password] 
    var data = [String]()
    var network = Networking()
    var viewModel = SignUpDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePicker)))
        
        view.addSubview(saveBtn)
        NSLayoutConstraint.activate([
            saveBtn.heightAnchor.constraint(equalToConstant: 50),
            saveBtn.widthAnchor.constraint(equalToConstant: 333),
            saveBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveBtn.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10)
        ])
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWelcomeView" {
            guard let VC = segue.destination as? WelcomeViewController else {return}
            VC.name = nameTextField.text ?? ""
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func nextAction() {
        data.append(nameTextField.text ?? "")
        viewModel.signUp(data)
        
        uploadToAWSS3()
        
        //save data in local
        defaults.set(data[0], forKey: "UserId")
        defaults.set(data[1], forKey: "UserPassword")
        defaults.set(nameTextField.text ?? "친구" , forKey: "UserName")
        
        performSegue(withIdentifier: "showWelcomeView", sender: self)
    }
    
    @objc func imagePicker() {
        showImagePickerOptions()
    }
}


extension SignUpDetailViewController: UIImagePickerControllerDelegate {
    func showImagePickerOptions() {
        let alertVC = UIAlertController(title: "사진 업로드", message: "", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "카메라로 촬영하기", style: .default) { [weak self] (action) in
            guard let self = self else {return}
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                present(imagePicker, animated: true, completion: nil)
            } else {
                imageView.image = UIImage(named: "applogo")
            }
        }
        
        let libraryAction = UIAlertAction(title: "사진 선택하기", style: .default){ [weak self] (action) in
            guard let self = self else {return}
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false
                present(imagePicker, animated: true, completion: nil)
            } else {
                imageView.image = UIImage(named: "applogo")
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertVC.addAction(cameraAction)
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        self.imageView.image = image
        self.imageView.layer.cornerRadius = (self.imageView.frame.size.width ?? 0) / 2
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadToAWSS3() {
        guard let image = imageView.image else { return }
        AWSS3Manager.shared.uploadProfileImage(image: image, userID: data[0], progress: {[weak self] ( uploadProgress) in
            
            guard let strongSelf = self else { return }
            //            strongSelf.progressView.progress = Float(uploadProgress)
            
        }) {[weak self] (uploadedFileUrl, error) in
            
            guard let strongSelf = self else { return }
            if let finalPath = uploadedFileUrl as? String {
                print("Uploaded file url: " + finalPath)
            } else {
                print("\(String(describing: error?.localizedDescription))")
            }
        }
    }
}
