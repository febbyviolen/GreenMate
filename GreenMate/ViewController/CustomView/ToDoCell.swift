//
//  ToDoCell.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/09.
//

import UIKit

class ToDoCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var background: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addShadow(background)
        background.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addShadow(_ view: UIView) {
        view.layer.shadowOffset = CGSizeMake(0, 1);
        view.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 2
    }
    
}
