//
//  DetailView.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/09.
//

import UIKit

class DetailView: UIViewController {
    
    var toDo = ["물주기", "환기하기", "영양관리"]
    var isToDo = true

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var diaryBtn: UIButton!
    @IBOutlet weak var toDoBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var light: UILabel!
    @IBOutlet weak var tempBackground: UIView!
    @IBOutlet weak var humidityBackground: UIView!
    @IBOutlet weak var lightBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addShadow(tempBackground)
        addShadow(humidityBackground)
        addShadow(lightBackground)
        
        tempBackground.layer.cornerRadius = 10
        humidityBackground.layer.cornerRadius = 10
        lightBackground.layer.cornerRadius = 10
        img.layer.cornerRadius = 10
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ToDoCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "WithDateCell", bundle: nil), forCellReuseIdentifier: "withDateCell")
    }
    
    @IBAction func toDoButton(_ sender: Any) {
        isToDo = true
        diaryBtn.subtitleLabel?.textColor = UIColor.systemGray3
        toDoBtn.subtitleLabel?.textColor = UIColor(named: "darkGreen")
        tableView.reloadData()
    }
    
    @IBAction func diaryButton(_ sender: Any) {
        isToDo = false
        diaryBtn.subtitleLabel?.textColor = UIColor(named: "darkGreen")
        toDoBtn.subtitleLabel?.textColor = UIColor.systemGray3
        tableView.reloadData()
    }
    
}

extension DetailView {
    func addShadow(_ view: UIView) {
        view.layer.shadowOffset = CGSizeMake(0, 1);
        view.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 2
    }
}

extension DetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isToDo {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ToDoCell
            cell.label.text = toDo[indexPath.item]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "withDateCell") as! WithDateCell
            if indexPath.item == 0 {
                cell.backgroundDate.isHidden = false
                cell.month.isHidden = false
                cell.date.isHidden = false
            } else {
                cell.backgroundDate.isHidden = true
                cell.month.isHidden = true
                cell.date.isHidden = true
            }
            
            cell.label.text = toDo[indexPath.item]
            return cell
        }
    }
}




