//
//  PlantType.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/22.
//

import Foundation

enum PlantType: Codable, CaseIterable{
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

func getPlantType(fromString string: String) -> PlantType? {
    return PlantType.allCases.first { "\($0.name)" == string }
}

var plantType = PlantType.allCases
