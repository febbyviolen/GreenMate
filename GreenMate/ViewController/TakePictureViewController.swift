//
//  TakePictureViewController.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/14.
//

import UIKit
import ProgressHUD

class TakePictureViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var againBtn: UIButton!
    @IBOutlet weak var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ProgressHUD.dismiss()
            ProgressHUD.remove()
        }
        
        againBtn.layer.cornerRadius = 15
        nextBtn.layer.cornerRadius = 15
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func againButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }

    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension TakePictureViewController : UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true)

        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        img.image = image
    }

}
