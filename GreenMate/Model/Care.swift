//
//  Care.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/15.
//

import Foundation
import UIKit

enum Care: String, Codable, CaseIterable {
    case water = "water", vitamin = "vitamin", air = "air"
    
    var name: String {
        switch self {
        case .water:
            return "물주기"
        case .vitamin:
            return "영양관리"
        case .air:
            return "환기하기"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .water:
            return UIImage(named: "wateringCan")!
        case .vitamin:
            return UIImage(systemName: "cross.vial")!
        case .air:
            return UIImage(systemName: "wind")!
        }
    }
}

var care = Care.allCases

