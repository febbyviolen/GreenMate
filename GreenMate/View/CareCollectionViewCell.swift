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
        background.layer.borderColor = UIColor(named: "softGreen")?.cgColor
        background.layer.borderWidth = 1
    }

}
