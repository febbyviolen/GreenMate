//
//  AddGreenMateViewController.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/14.
//

import UIKit

class CareViewController: UIViewController {

    var careList = ["물", "물", "물", "물"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var saveBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        saveBtn.layer.cornerRadius = 15
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "careCell")
        
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension CareViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return careList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "careCell", for: indexPath) as! CareCollectionViewCell
        return cell
    }
    
    
}
