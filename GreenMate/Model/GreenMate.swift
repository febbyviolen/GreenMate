//
//  GreenMate.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/15.
//

import Foundation

struct Greenmate: Codable{
    let humidity: Int
    let illuminance: Int
    let moduleId: String
    let nickname: String
    let plantName: String
    let soilWater: Int
    let temperature: Int
    let time: String?
    let userId: String
    
}

struct GreenMateResponse: Decodable {
    let greenmateList: [Greenmate]
}

struct DailyRecordList: Codable {
    let time: String?
    let moduleId: String
    let dailyRecord: String
}

struct DailyRecordListResponse: Decodable {
    let dailyRecordList: [DailyRecordList]
}

struct RegisterModuleResponse: Decodable {
    let result: Int
}
