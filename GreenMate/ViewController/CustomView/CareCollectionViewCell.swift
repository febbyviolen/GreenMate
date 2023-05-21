//
//  CareCollectionViewCell.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/14.
//

import UIKit

class CareCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        background.layer.cornerRadius = 20
        background.layer.borderColor = UIColor(named: "lightGreen")?.cgColor
        background.layer.borderWidth = 1
    }
    
    func setSelectedStyle() {
        background.layer.backgroundColor = UIColor(named: "lightGreen")?.cgColor
        icon.tintColor = .white
    }

    func setDeselectedStyle() {
        background.layer.backgroundColor = UIColor(named: "background")?.cgColor
        icon.tintColor = UIColor(named: "darkGreen")
    }


}
