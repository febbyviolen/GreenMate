//
//  GreenMateList.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/04.
//

import UIKit

class GreenMateList: UICollectionViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var plantType: UILabel!
    @IBOutlet weak var plantName: UILabel!
    
    @IBOutlet weak var third: UIImageView!
    @IBOutlet weak var second: UIImageView!
    @IBOutlet weak var first: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        background.layer.cornerRadius = 10
        img.layer.cornerRadius = 10
        background.layer.shadowOffset = CGSizeMake(0, 1);
        background.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        background.layer.shadowOpacity = 0.1
        background.layer.shadowRadius = 2
        
    }
}
