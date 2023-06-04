//
//  dummyDatabase.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/20.
//

import Foundation
import RxSwift
import RxCocoa


var GREENMATEDATA = [Greenmate]()

class DataManagement {
    static let shared = DataManagement()
    
    private let itemsRelay = BehaviorRelay<[Greenmate]>(value: [])
    
    var items: Observable<[Greenmate]> {
        return itemsRelay.asObservable()
    }
    
    private init() {
        // Set initial value for the itemsRelay
        for i in GREENMATEDATA.enumerated() {
            var carelist = [Care]()
            if i.element.illuminance <= 50 { carelist.append(Care.vitamin) }
            if i.element.temperature <= 20 { carelist.append(Care.water) }
            if i.element.humidity <= 200 { carelist.append(Care.air) }
            
//            for j in carelist {GREENMATEDATA[i.offset].addTodo(j)}
        }
        
        itemsRelay.accept(GREENMATEDATA)
    }
    
    func getItems() -> [Greenmate] {
        return itemsRelay.value
    }
    
    func updateItems(_ newItems: [Greenmate]) {
        itemsRelay.accept(newItems)
    }
}

