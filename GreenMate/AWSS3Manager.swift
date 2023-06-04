//
//  AWSS3Manager.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/06/02.
//

import Foundation
import UIKit
import AWSS3

typealias progressBlock = (_ progress: Double) -> Void
typealias completionBlock = (_ response: Any?, _ error: Error?) -> Void 

class AWSS3Manager {
    
    let bucketName = "greenmate-test"
    let accessKey = "AKIA5RPIQAMQGHQZWFIB"
    let secretKey = "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"
    let utilityKey = "utility-key"
    
    static let shared = AWSS3Manager()
    private init () { }
    
    func AWSS3Dec() {
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        
        let configuration = AWSServiceConfiguration(region:.APNortheast2, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        let tuConf = AWSS3TransferUtilityConfiguration()
        tuConf.isAccelerateModeEnabled = false
        
        AWSS3TransferUtility.register(
            with: configuration!,
            transferUtilityConfiguration: tuConf,
            forKey: utilityKey
        )
    }
    
    // Upload image using UIImage object
    func uploadImage(image: UIImage, moduleId: String, progress: progressBlock?, completion: completionBlock?) {
        
        AWSS3Dec()
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
            completion?(nil, error)
            return
        }
        
        let tmpPath = NSTemporaryDirectory() as String
        let fileName: String = "\(moduleId)-Greenmate" + (".jpeg")
        let filePath = tmpPath + "/" + fileName
        let fileUrl = URL(fileURLWithPath: filePath)
        
        do {
            try imageData.write(to: fileUrl)
            self.uploadfile(fileUrl: fileUrl, fileName: fileName, contenType: "image", progress: progress, completion: completion)
        } catch {
            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
            completion?(nil, error)
        }
    }
    
    
    // Upload files like Text, Zip, etc from local path url
    func uploadOtherFile(fileUrl: URL, conentType: String, progress: progressBlock?, completion: completionBlock?) {
        let fileName = self.getUniqueFileName(fileUrl: fileUrl)
        self.uploadfile(fileUrl: fileUrl, fileName: fileName, contenType: conentType, progress: progress, completion: completion)
    }
    
    // Get unique file name
    func getUniqueFileName(fileUrl: URL) -> String {
        let strExt: String = "." + (URL(fileURLWithPath: fileUrl.absoluteString).pathExtension)
        return (ProcessInfo.processInfo.globallyUniqueString + (strExt))
    }
    
    //MARK:- AWS file upload
    // fileUrl :  file local path url
    // fileName : name of file, like "myimage.jpeg" "video.mov"
    // contenType: file MIME type
    // progress: file upload progress, value from 0 to 1, 1 for 100% complete
    // completion: completion block when uplaoding is finish, you will get S3 url of upload file here
    private func uploadfile(fileUrl: URL, fileName: String, contenType: String, progress: progressBlock?, completion: completionBlock?) {
        // Upload progress block
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, awsProgress) in
            guard let uploadProgress = progress else { return }
            DispatchQueue.main.async {
                uploadProgress(awsProgress.fractionCompleted)
            }
        }
        // Completion block
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicURL = url?.appendingPathComponent(self.bucketName).appendingPathComponent(fileName)
//                    print("Uploaded to:\(String(describing: publicURL))")
                    if let completionBlock = completion {
                        completionBlock(publicURL?.absoluteString, nil)
                    }
                } else {
                    if let completionBlock = completion {
                        completionBlock(nil, error)
                    }
                }
            })
        }
        // Start uploading using AWSS3TransferUtility
        let awsTransferUtility = AWSS3TransferUtility.default()
        awsTransferUtility.uploadFile(fileUrl, bucket: bucketName, key: fileName, contentType: contenType, expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
            if let error = task.error {
                print("error is: \(error.localizedDescription)")
            }
            if let _ = task.result {
                // your uploadTask
            }
            return nil
        }
    }
    
    // Download file from S3
    func downloadFile(fileName: String, fileURL: URL, progress: progressBlock?, completion: completionBlock?) {
        AWSS3Dec()
        
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = { (task, awsProgress) in
            guard let downloadProgress = progress else { return }
            DispatchQueue.main.async {
                downloadProgress(awsProgress.fractionCompleted)
            }
        }
        
        let completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock = { (task, url, data, error) -> Void in
            DispatchQueue.main.async {
                if let error = error {
                    if let completionBlock = completion {
                        completionBlock(nil, error)
                    }
                } else if let url = url {
                    let fileManager = FileManager.default
                    
                    // Append a unique identifier to the file name
                    let uniqueFileName = self.getUniqueFileName(fileUrl: fileURL)
                    let destinationURL = fileURL.deletingLastPathComponent().appendingPathComponent(uniqueFileName)
                    
                    do {
                        // Remove the existing file if it already exists
                        if fileManager.fileExists(atPath: destinationURL.path) {
                            try fileManager.removeItem(at: destinationURL)
                        }
                        
                        // Move the downloaded file to the destination URL
                        try fileManager.moveItem(at: url, to: destinationURL)
                        
                        if let completionBlock = completion {
                            completionBlock(destinationURL, nil)
                        }
                    } catch {
                        if let completionBlock = completion {
                            completionBlock(nil, error)
                        }
                    }
                }
            }
        }
        
        let awsTransferUtility = AWSS3TransferUtility.default()
        awsTransferUtility.download(to: fileURL, bucket: bucketName, key: fileName, expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
            if let error = task.error {
                print("Error downloading file: \(error.localizedDescription)")
            }
            if let _ = task.result {
                // your downloadTask
            }
            return nil
        }
    }

    
}
