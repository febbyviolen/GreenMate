//
//  ViewControllerViewModel.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/06/04.
//

import Foundation
import RxCocoa
import RxSwift

class ViewControllerViewModel {
    var greenmates = BehaviorRelay<[Greenmate]>(value: [])
    var selectedMate: Greenmate?
    var selectedIndex = 0
    var network = Networking()
    var timer: Timer?
    var plantCount = PublishSubject<Int>()
    var stat = BehaviorRelay<[Int]>(value: [0, 0, 0])
    
    
    func fetch(){
        
        let defaults = UserDefaults.standard
        guard let USERID = defaults.string(forKey: "UserId") else {return}
        guard let USERPASS = defaults.string(forKey: "UserPassword") else {return}
        
        network.getUserAllDataFunc([USERID, USERPASS]) { [weak self] greenmate in
            self?.greenmates.accept(greenmate)
            self?.selectedMate = greenmate.first
            self?.plantCount.onNext(greenmate.count)
        }
    }
    
    @objc func fetchEveryFive() {
        network.getUserAllDataFunc(["masterUser", "greenmate1234"]) { [weak self] greenmate in
            self?.updateStatusData(greenmate)
        }
    }
    
    func updateStatusData(_ greenmate: [Greenmate]) {
        let selected = greenmate.filter{$0.moduleId == selectedMate?.moduleId}
        stat.accept([selected.first?.illuminance ?? 0, selected.first?.soilWater ?? 0, selected.first?.temperature ?? 0])
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(fetchEveryFive), userInfo: nil, repeats: true)
    }
    
    func downloadImg(_ moduleId: String, completion: @escaping (_ image: UIImage) -> Void){
        let fileName = "\(moduleId)-Greenmate.jpeg" // Specify the file name you want to download
        var image = UIImage(named: "plant1")!
        
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        
        AWSS3Manager.shared.downloadFile(fileName: fileName, fileURL: fileURL, progress: { (downloadProgress) in
            // Handle the download progress if needed
        }) { (localURL, error) in
            if let error = error {
                print("Error downloading file: \(error.localizedDescription)")
                completion(image)
            } else if let localURL = localURL {
                // File downloaded successfully, use the localURL as needed
                print("File downloaded at path: \(localURL)")
                
                if let imageData = try? Data(contentsOf: localURL as! URL) {
                    image = UIImage(data: imageData) ?? UIImage(named: "plant1")!
                    completion(image)
                }
                
            }
        }
    }
    
    func downloadProfileImg(_ userID: String, completion: @escaping (_ image: UIImage) -> Void){
        let fileName = "\(userID)-Profile" + (".jpeg") 
        var image = UIImage()
        
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        
        AWSS3Manager.shared.downloadFile(fileName: fileName, fileURL: fileURL, progress: { (downloadProgress) in
            // Handle the download progress if needed
        }) { (localURL, error) in
            if let error = error {
                print("Error downloading file: \(error.localizedDescription)")
                completion(image)
            } else if let localURL = localURL {
                // File downloaded successfully, use the localURL as needed
                print("File downloaded at path: \(localURL)")
                
                if let imageData = try? Data(contentsOf: localURL as! URL) {
                    image = UIImage(data: imageData) ?? UIImage(named: "plant1")!
                    completion(image)
                }
                
            }
        }
    }
    
    func soilWaterHandle(_ stat: Int) -> String{
        if stat < 25 {
            return "나쁨"
        } else if stat > 38 {
            return "나쁨"
        }
        return "좋음"
    }
    
    func temperatureHandle(_ stat: Int) -> String{
        if stat <= 15 {
            return "나쁨"
        }
        return "좋음"
    }
    
    func lightHandle(_ stat: Int) -> String{
        if stat < 15 {
            return "나쁨"
        } else if stat > 25 {
            return "나쁨"
        }
        return "좋음"
    }
}

