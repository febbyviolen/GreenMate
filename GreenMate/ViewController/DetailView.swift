//
//  DetailView.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/09.
//

import UIKit
import RxSwift
import RxCocoa

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
    
    @IBOutlet weak var plantBirthday: UILabel!
    @IBOutlet weak var plantName: UILabel!
    @IBOutlet weak var plantType: UILabel!
    
    
    //to receive the selected item from ViewController
    var selectedPlant: GreenMate?
    var disposeBag = DisposeBag()
    var toDoShown = BehaviorRelay<Bool>(value:true)
    var diaryShown = BehaviorRelay<Bool>(value:false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableLogic()
        initData(selectedPlant!)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditDetailView" {
            var VC = segue.destination as? EditDetailView
            VC.
        }
    }
    
}

extension DetailView {
    func tableLogic() {
        toDoShown
            .distinctUntilChanged()
            .map { $0 ? UIColor(named: "darkGreen")! : UIColor.systemGray2 }
            .bind(onNext: { color in
                self.toDoBtn.titleLabel?.textColor = color
            })
            .disposed(by: disposeBag)

        diaryShown
            .distinctUntilChanged()
            .map { $0 ? UIColor(named: "darkGreen")! : UIColor.systemGray2 }
            .bind(onNext: { color in
                self.diaryBtn.titleLabel?.textColor = color
            })
            .disposed(by: disposeBag)

        toDoBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.toDoShown.accept(true)
                self?.diaryShown.accept(false)
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        diaryBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.toDoShown.accept(false)
                self?.diaryShown.accept(true)
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
      
    }
    
    func initData(_ plant: GreenMate) {
        updateUI(with: plant)
        plantName.text = plant.name
        plantType.text = plant.type.name
        plantBirthday.text = "키우기 시작한지 \(plant.light)일"
    }
    
    func updateUI(with plant: GreenMate) {
        // Update the UI elements with the selected plant data
        img.image = UIImage(named: plant.img)
        humidity.text = "\(plant.humidity)%"
        temp.text = "\(plant.temp)°C"
        light.text = "\(plant.light)"
    }
    
    func addShadow(_ view: UIView) {
        view.layer.shadowOffset = CGSizeMake(0, 1);
        view.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 2
    }
}

extension DetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if toDoShown.value{
            return (selectedPlant?.toDo?.count) ?? 0
        } else {
            return (selectedPlant?.diary?.count) ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if toDoShown.value{
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



