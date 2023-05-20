//
//  GreenMate.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/15.
//

import Foundation

struct GreenMate: Codable{
    var name: String
    var img: String
    var type: PlantType
    var light: Int
    var temp: Int
    var humidity: Int
    var toDo: [ToDo]?
    var diary: [Diary]?
    
    init(name: String, img: String = "plant1", type: PlantType, light: Int, temp: Int, humidity: Int) {
        self.name = name
        self.img = img
        self.type = type
        self.light = light
        self.temp = temp
        self.humidity = humidity
    }
    
    mutating func addTodo(_ todo: ToDo) {
        if toDo == nil { toDo = [ToDo]()}
        toDo?.append(todo)
    }
    
    mutating func addDiary(_ newDiary: Diary) {
        if diary == nil { diary = [Diary]()}
        diary?.append(newDiary)
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

struct ToDo: Codable{
    var name: Care
    var done: Bool

}

struct Diary: Codable{
    var name: Care
    var done: Bool

}

