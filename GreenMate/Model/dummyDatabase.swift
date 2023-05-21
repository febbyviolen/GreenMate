//
//  dummyDatabase.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/20.
//

import Foundation
import RxSwift
import RxCocoa

var ITEMS = [GreenMate(name: "잇지", img: "plant2", type: .coffeenamu, light: 200, temp: 30, humidity: 73, diary: (["2023-05-21": [Care.vitamin], "2023-04-21": [Care.air, Care.vitamin]])),
             GreenMate(name: "엣지", type: .hongkongyaja, light: 400, temp: 10, humidity: 70),
             GreenMate(name: "구린", type: .rosemary, light: 550, temp: 40, humidity: 75),
             GreenMate(name: "구름", img: "plant2", type: .asparagusnanus, light: 500, temp: 20, humidity: 80),
             GreenMate(name: "로제", type: .rosemary, light: 300, temp: 26, humidity: 77)]

class DataStore {
    static let shared = DataStore()
    
    private let itemsRelay = BehaviorRelay<[GreenMate]>(value: [])
    
    var items: Observable<[GreenMate]> {
        return itemsRelay.asObservable()
    }
    
    private init() {
        // Set initial value for the itemsRelay
        for i in ITEMS.enumerated() {
            var carelist = [Care]()
            if i.element.light <= 50 { carelist.append(Care.vitamin) }
            if i.element.temp <= 20 { carelist.append(Care.water) }
            if i.element.humidity <= 200 { carelist.append(Care.air) }
            
            for j in carelist {ITEMS[i.offset].addTodo(j)}
        }
        
        itemsRelay.accept(ITEMS)
    }
    
    func addItems(_ newItems: GreenMate) {
        var currentItems = itemsRelay.value
        currentItems.append(newItems)
        itemsRelay.accept(currentItems)
    }
    
    func deleteItems(_ itemsToDelete: GreenMate) {
        var currentItems = itemsRelay.value
        let index = currentItems.firstIndex(where: {$0.ID == itemsToDelete.ID})
        currentItems.remove(at: index!)
        itemsRelay.accept(currentItems)
    }
    
    func editItem(_ updatedItem: GreenMate) {
        var currentItems = itemsRelay.value
        if let index = currentItems.firstIndex(where: { $0.ID == updatedItem.ID }) {
            currentItems[index] = updatedItem
            itemsRelay.accept(currentItems)
        }
    }
    
    func getItems() -> [GreenMate] {
        return itemsRelay.value
    }
}
