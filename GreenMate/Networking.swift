//
//  Networking.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/29.
//

import Foundation
import Alamofire

class Networking {
    
    let userIDParameters: [String: Any] = [
        "id": "masterUser",
        "password": "greenmate1234"
    ]
    
    let USERID =  "masterUser"
    
    
    
    let headers: HTTPHeaders = [
        "Content-Type": "application/json"
    ]
    
    let getUserAllData = "http://3.39.202.153:8080/getUserAllData.do"
    let getDailyRecords = "http://3.39.202.153:8080/getDailyRecords.do"
    let addDailyRecord = "http://3.39.202.153:8080/addDailyRecord.do"
    let deleteModule = "http://3.39.202.153:8080/deleteGreenmate.do"
    let registerModule = "http://3.39.202.153:8080/checkModuleExistence.do"
    let relationModule = "http://3.39.202.153:8080/relationModule.do"
    let updateGreenMateNickName = "http://3.39.202.153:8080/updateGreenmateNickname.do"
    
    func getUserAllDataFunc(_ parameters : [String], completion: @escaping ([Greenmate]) -> Void) {
        AF.request(getUserAllData, method: .post, parameters: userIDParameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: GreenMateResponse.self) { [weak self] response in
                switch response.result {
                case .success(let greenMateResponse):
                    let greenMates = greenMateResponse.greenmateList
                    completion(greenMates)
                    
                case .failure(let error):
                    // Handle the failure
                    print("Request failed with error: \(error)")
                }
            }
    }
    
    func getDailyRecordsFunc(_ moduleId : String, completion: @escaping ([DailyRecordList]) -> Void) {
        let IDParameters: [String: Any] = [
            "moduleId": "\(moduleId)"
        ]
        
        AF.request(getDailyRecords, method: .post, parameters: IDParameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: DailyRecordListResponse.self) { response in
                switch response.result {
                case .success(let dailyRecordListResponse):
                    let dailyRecordList = dailyRecordListResponse.dailyRecordList
                    completion(dailyRecordList)
                    
                case .failure(let error):
                    // Handle the failure
                    print(error)
                    completion([])
                }
                
            }
        
    }
    
    func addDailyRecordFunc(_ parameter : String ,_ care : String, completion: @escaping () -> Void) {
        let param: [String: Any] = [
            "moduleId": "\(parameter)",
            "dailyRecord": "\(care)"
        ]
        AF.request(addDailyRecord, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).response { response in
            completion()
            //            debugPrint(response)
        }
    }
    
    func deleteModuleFunc(_ parameter: String) {
        let param: [String: Any] = [
            "moduleId": "\(parameter)"
        ]
        
        AF.request(deleteModule, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).response { response in
            debugPrint(response)
        }
    }
    
    func registerModuleFunc(_ moduleId: String, completion: @escaping (Int?) -> Void) {
        let parameter: [String: Any] = [
            "moduleId": moduleId
        ]
        
        AF.request(registerModule, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: RegisterModuleResponse.self) { response in
                switch response.result {
                case .success(let registerModuleResponse):
                    print(registerModuleResponse.result)
                    completion(registerModuleResponse.result)
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completion(nil)
                }
            }
    }

  
    func relationModuleFunc(_ parameters: [String]) {
        AF.request(relationModule, method: .post, parameters: [
            "moduleId": parameters[0],
            "userId": USERID,
            "plantName": parameters[1],
            "nickname": parameters[2],
            "photo":parameters[3]
        ], encoding: JSONEncoding.default, headers: headers).response { response in
            debugPrint(response)
        }
    }

    
    func updateGreenMateNickNameFunc(_ parameters : [String]) {
        let parameter: [String: Any] = [
            "moduleId" : parameters[0],
            "nickname" : parameters[1]
        ]
        
        AF.request(updateGreenMateNickName, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).response { response in
//            debugPrint(response)
        }
    }
}
