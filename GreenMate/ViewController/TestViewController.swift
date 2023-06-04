//
//  TestViewController.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/06/02.
//

import UIKit
import AWSS3

class TestViewController: UIViewController {
    
    @IBOutlet var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func upload(_ sender: UIButton) {
        guard let image = img.image else { return }
        AWSS3Manager.shared.uploadImage(image: image, moduleId: "GM001", progress: {[weak self] ( uploadProgress) in
            
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
    
    
    @IBAction func download(_ sender: UIButton) {
        let fileName = "GM001-Greenmate.jpeg" // Specify the file name you want to download
        
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        AWSS3Manager.shared.downloadFile(fileName: fileName, fileURL: fileURL, progress: { (downloadProgress) in
            // Handle the download progress if needed
        }) { (localURL, error) in
            if let error = error {
                print("Error downloading file: \(error.localizedDescription)")
            } else if let localURL = localURL {
                // File downloaded successfully, use the localURL as needed
                print("File downloaded at path: \(localURL)")
                
                DispatchQueue.main.async {
                    if let imageData = try? Data(contentsOf: localURL as! URL) {
                        let image = UIImage(data: imageData)
                        self.img.image = image
                    }
                }
            }
        }
    }

}

