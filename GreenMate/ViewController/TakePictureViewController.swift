//
//  TakePictureViewController.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/14.
//

import UIKit

class TakePictureViewController: UIViewController {
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var againBtn: UIButton!
    @IBOutlet weak var img: UIImageView!
    
    var newPlantType :PlantType!
    var moduleId = "" 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        againBtn.layer.cornerRadius = 15
        nextBtn.layer.cornerRadius = 15
        openCameraButtonTapped()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNickNameController" {
            let VC = segue.destination as! NickNameViewController
            VC.type = newPlantType
            VC.img = img.image
            VC.moduleId = moduleId
        }
    }
    
    @IBAction func againButton(_ sender: Any) {
        openCameraButtonTapped()
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        performSegue(withIdentifier: "showNickNameController", sender: self)
        
    }
}

extension TakePictureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openCameraButtonTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        } else {
            img.image = UIImage(named: "plant1")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            // Use the captured image
            // For example, you can display it in an image view
            img.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
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
                img.image = UIImage(named: "applogo")
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
                img.image = UIImage(named: "applogo")
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertVC.addAction(cameraAction)
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
