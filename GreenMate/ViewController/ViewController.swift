//
//  ViewController.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/03.
//

import UIKit

struct Plant {
    var name: String
    var type : String
    var img : String
}
class ViewController: UIViewController {

    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var light: UILabel!
    @IBOutlet weak var tempBackground: UIView!
    @IBOutlet weak var humidityBackground: UIView!
    @IBOutlet weak var lightBackground: UIView!
    @IBOutlet weak var plantList: UICollectionView!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var selectedPlant: UIImageView!
    
    var plant = [Plant(name: "그린조아", type: "몰라", img: "plant1"), Plant(name: "그리니", type: "카페", img: "plant2"), Plant(name: "그린조아", type: "몰라", img: "plant1"), Plant(name: "그린조아", type: "몰라", img: "plant1")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        
        selectedPlant.layer.cornerRadius = 10
        selectedPlant.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        selectedPlant.layer.borderWidth = 5
        selectedPlant.layer.shadowOffset = CGSizeMake(0, 2);
        selectedPlant.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        selectedPlant.layer.shadowOpacity = 0.1
        selectedPlant.layer.shadowRadius = 7
        
        addShadow(tempBackground)
        addShadow(humidityBackground)
        addShadow(lightBackground)
        tempBackground.layer.cornerRadius = 10
        humidityBackground.layer.cornerRadius = 10
        lightBackground.layer.cornerRadius = 10
        
        plantList.dataSource = self
        plantList.delegate = self
        plantList.register(UINib(nibName: "GreenMateList", bundle: nil), forCellWithReuseIdentifier: "greenMateList")
        
        selectedPlant.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewDetail)))
        
    }
    
}

//MARK: function들
extension ViewController {
    @IBAction func addPlantButton(_ sender: Any) {
        
    }
    
    @objc func viewDetail() {
        performSegue(withIdentifier: "showDetailView", sender: self)
    }
    
    func addShadow(_ view: UIView) {
        view.layer.shadowOffset = CGSizeMake(0, 1);
        view.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 2
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plant.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = plantList.dequeueReusableCell(withReuseIdentifier: "greenMateList", for: indexPath) as! GreenMateList
        
        cell.plantName.text = plant[indexPath.item].name
        cell.plantType.text = plant[indexPath.item].type
        cell.img.image = UIImage(named: plant[indexPath.item].img)
        
        return cell
    }
}

