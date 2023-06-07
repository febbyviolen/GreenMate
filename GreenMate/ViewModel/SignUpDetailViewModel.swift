//
//  WelcomeViewModel.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/06/06.
//

import Foundation

class SignUpDetailViewModel{
    var network = Networking()
    
    func signUp(_ data: [String]) {
        network.signUpFunc(data)
    }
}
