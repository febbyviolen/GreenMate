//
//  GreenMate.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/15.
//

import Foundation

struct GreenMate: Codable{
    var ID = UUID()
    var name: String
    var img: String
    var type: PlantType
    var light: Int
    var temp: Int
    var humidity: Int
    var toDo: [Care]?
    var diary: [String:[Care]]?
    
    init(name: String, img: String = "plant1", type: PlantType, light: Int, temp: Int, humidity: Int, toDo: [Care]? = [Care](), diary: [String:[Care]]? = [String: [Care]]()) {
        self.name = name
        self.img = img
        self.type = type
        self.light = light
        self.temp = temp
        self.humidity = humidity
        self.diary = diary
        self.toDo = toDo
    }
    
    func getID() -> UUID {
       return ID
    }
    
    mutating func addTodo(_ todo: Care) {
        if toDo == nil {
            toDo = [Care]()
        }
        
        toDo?.append(todo)
    }
    
    mutating func deleteTodo (_ todo: Care) {
        var index = toDo?.firstIndex(of: todo)!
        toDo?.remove(at: index!)
    }
    
    mutating func addDiary(_ newDiary: Care, for date: String) {
        if diary == nil {
            diary = [String: [Care]]()
        }
        
        if var caresForDate = diary?[date] {
            caresForDate.append(newDiary)
            diary?[date] = caresForDate
        } else {
            diary?[date] = [newDiary]
        }
    }
    
    mutating func changeName(_ newName: String) {
        name = newName
    }
}

enum PlantType: Codable {
    case rosemary, monstera, asparagusnanus, coffeenamu, tableyaja, hongkongyaja
    
    var name: String {
        switch self {
        case .rosemary:
            return "로즈마리"
        case .monstera:
            return "몬스테라"
        case .asparagusnanus:
            return "아스파라거스 나누스"
        case .coffeenamu:
            return "커피나무"
        case .tableyaja:
            return "테이블 야자"
        case .hongkongyaja:
            return "홍콩 야자"
        }
    }
}
