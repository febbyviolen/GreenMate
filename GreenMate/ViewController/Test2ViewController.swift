//
//  Test2ViewController.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/06/02.
//

import UIKit
import AWSS3

class Test2ViewController: UIViewController {
    @IBOutlet var img: UIImageView!
    
    let bucketName = "greenmate-test"
    let accessKey = "AKIA5RPIQAMQGHQZWFIB"
    let secretKey = "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"
    let utilityKey = "utility-key"
    let fileKey = "greenmate-moduleId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func upload(_ sender: UIButton) {
        upload()
    }
    
    
    @IBAction func download(_ sender: UIButton) {
        download()
    }
    
    func upload() {
        
        print("upload")
        guard let transferUtility = AWSS3TransferUtility.s3TransferUtility(forKey: utilityKey)
        else
        {
            return
        }
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.setValue("public-read", forRequestHeader: "x-amz-acl") //URL로 이미지 읽을 수 있도록 권한 설정 (이 헤더 없으면 못읽음)
        expression.progressBlock = {(task, progress) in
            print("progress \(progress.fractionCompleted)")
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { [weak self] (task, error) -> Void in
            guard let self = self else { return }
            print("task finished")
            
            let url = AWSS3.default().configuration.endpoint.url
            let publicURL = url?.appendingPathComponent(self.bucketName).appendingPathComponent(self.fileKey)
            if let absoluteString = publicURL?.absoluteString {
                print("image url ↓↓")
                print(absoluteString)
            }
            
            if let query = task.request?.url?.query,
               var removeQueryUrlString = task.request?.url?.absoluteString.replacingOccurrences(of: query, with: "") {
                removeQueryUrlString.removeLast() // 맨 뒤 물음표 삭제
                print("업로드 리퀘스트에서 쿼리만 제거한 url ↓↓") //이 주소도 파일 열림
                print(removeQueryUrlString)
            }
        }
        
        
        
        guard let data = UIImage(named: "img")?.pngData()
        else
        {
            return
        }
        
        transferUtility.uploadData(data as Data, bucket: bucketName, key: fileKey, contentType: "image/png", expression: expression,
                                   completionHandler: completionHandler).continueWith
        {
            (task) -> AnyObject? in
            if let error = task.error {
                print("Error: \(error.localizedDescription)")
                
            }
            
            if let _ = task.result {
                print ("upload successful.")
            }
            
            return nil
        }
    }
    
    func download() {
        
        
        guard let transferUtility = AWSS3TransferUtility.s3TransferUtility(forKey: utilityKey)
        else
        {
            return
        }
        
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = {(task, progress) in
            print("progress \(progress.fractionCompleted)")
        }
        
        var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
        completionHandler = { (task, url, data, err) -> Void in
            print("task finished")
            
            DispatchQueue.main.async { [weak self] in
                
                if let d = data {
                    print("img data 있음")
                    self?.img.image = UIImage(data: d)
                }
            }
        }
        
        
        transferUtility.downloadData(fromBucket: bucketName, key: fileKey, expression: expression, completionHandler: completionHandler).continueWith
        {
            (task) -> AnyObject? in
            if let error = task.error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let _ = task.result {
                print ("download successful.")
            }
            return nil
        }
        
    }
}
