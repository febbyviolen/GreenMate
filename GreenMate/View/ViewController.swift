//
//  ViewController.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/03.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var selectedPlant: UIImageView!
    @IBOutlet weak var temp: UIView!
    @IBOutlet weak var humidity: UIView!
    @IBOutlet weak var light: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        statusUI(temp)
        statusUI(humidity)
        statusUI(light)
        
        selectedPlant.layer.cornerRadius = 10
        view.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        view.layer.borderWidth = 5
    }

    @IBAction func addPlantButton(_ sender: Any) {
    }
    
}

extension ViewController {
    func statusUI(_ view: UIView){
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        view.layer.shadowRadius = 4
    }
}

