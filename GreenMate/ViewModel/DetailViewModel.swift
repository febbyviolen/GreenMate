//
//  DetailViewModel.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/06/04.
//

import Foundation
import RxSwift
import RxCocoa

class DetailViewModel {
    var selectedMate: Greenmate?
    var toDoShown = BehaviorRelay<Bool>(value:true)
    var diaryShown = BehaviorRelay<Bool>(value:false)
    var sortedKeysCount :[Int]?
    var sortedValues: [Care]?
    var arrCount = [Int]()
    var sortedKeys: [String]?
    var network = Networking()
    
    var diary = [DailyRecordList]()
    var todo: [Care]?
    var diaryy = PublishSubject<[DailyRecordList]>()
    var dict = [String: [Care]]()
    
    var imgsrc: UIImage!
    
    func getDiary() {
        if let moduleId = selectedMate?.moduleId {
            network.getDailyRecordsFunc(moduleId) { records in
                self.diaryy.onNext(records)
            }
        }
    }
    
    func changeToDict() {
        dict.removeAll()
        for i in diary {
            let time = i.time!.split(separator: " ")[0]
            if (dict[String(time)] != nil) {
                var curr = dict[String(time)]
                curr?.append(Care(rawValue: i.dailyRecord) ?? Care.water)
                dict[String(time)] = curr
            } else {
                dict[String(time)] = [Care(rawValue: i.dailyRecord) ?? Care.water]
            }
        }
        
        tableData()
    }
    
    func tableData() {
        sortedKeysCount = dict.sorted{ $0.key > $1.key }.compactMap{ $0.value.count }
        sortedValues = dict.sorted{ $0.key > $1.key }.flatMap { $0.value.reversed() }
        sortedKeys = dict.sorted{ $0.key > $1.key }.compactMap{ $0.key }
        arrCount = sortedKeys!.indices.map { sortedKeysCount!.prefix($0).reduce(0, +) }
    }
    
    
}
