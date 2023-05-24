//
//  SelectType.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/21.
//

import UIKit

class SelectType: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var icon: UIStackView!
    @IBOutlet weak var background: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        background.layer.cornerRadius = 15
        addShadow(background)
        
    }
    
    override var isSelected: Bool {
            didSet {
                if isSelected{
                    updateBorder()
                } else {
                    resetBorder()
                }
            }
        }
    
    func configure(with plant: PlantType, isSelected: Bool) {
        label.text = plant.name
        self.isSelected = isSelected
    }

    func updateBorder() {
        background.layer.borderColor = UIColor(named: "lightGreen")?.cgColor
        background.layer.borderWidth = 1
    }
    
    func resetBorder() {
        background.layer.borderColor = UIColor(named: "background")?.cgColor
        background.layer.borderWidth = 0
    }
    
    func addShadow(_ view: UIView) {
        view.layer.shadowOffset = CGSizeMake(0, 1);
        view.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 2
    }
}
