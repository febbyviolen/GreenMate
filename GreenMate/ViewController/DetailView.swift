//
//  DetailView.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/09.
//

import UIKit
import RxSwift
import RxCocoa

class DetailView: UIViewController, EditDetailDelegate{
    
    func nameChanged(controller: EditDetailView) {
        plantName.text = controller.textField.text ?? ""
        controller.navigationController?.popViewController(animated: true)
    }
    
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
    var selectedMate: Greenmate?
    var imgsrc: UIImage!
    var disposeBag = DisposeBag()
    var toDoShown = BehaviorRelay<Bool>(value:true)
    var diaryShown = BehaviorRelay<Bool>(value:false)
    var sortedKeysCount :[Int]?
    var sortedValues: [Care]?
    var arrCount = [Int]()
    var sortedKeys: [String]?
    var network = Networking()
    
    var diary = [DailyRecordList]()
    var todo: [Care]?
    var diaryy = PublishSubject<[DailyRecordList]>()
    
    var dict = [String: [Care]]()
    
    
    func getDiary() {
        if let moduleId = selectedMate?.moduleId {
            network.getDailyRecordsFunc(moduleId) { records in
                DispatchQueue.main.async {
                    self.diaryy.onNext(records)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDiary()
//        plantName.text = delegate?.nameChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableLogic()
        initData(selectedMate!)
        
        diaryy.subscribe { [weak self] record in
            self?.diary = record
            self?.changeToDict()
            self?.tableView.reloadData()
        }
        
        
        addShadow(tempBackground)
        addShadow(humidityBackground)
        addShadow(lightBackground)
        
        tempBackground.layer.cornerRadius = 10
        humidityBackground.layer.cornerRadius = 10
        lightBackground.layer.cornerRadius = 10
        img.layer.cornerRadius = 10
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ToDoCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "WithDateCell", bundle: nil), forCellReuseIdentifier: "withDateCell")
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditDetailView" {
            let VC = segue.destination as? EditDetailView
            VC?.selectedPlant = selectedMate
            VC?.imgsrc = imgsrc
            VC?.delegate = self
        }
        else if segue.identifier == "showDeleteGreenMate" {
            let VC = segue.destination as? DeleteGreenMate
            VC?.selectedPlant = selectedMate
        }
        else if segue.identifier == "showCareViewController" {
            let VC = segue.destination as? CareViewController
            VC?.selectedPlant = selectedMate
        }
    }
    
    
}

extension DetailView {
    
    func changeToDict() {
        dict.removeAll()
        for i in diary {
            let time = i.time!.split(separator: " ")[0]
            if (dict[String(time)] != nil) {
                var curr = dict[String(time)]
                curr?.append(Care(rawValue: i.dailyRecord) ?? Care.water)
                dict[String(time)] = curr
            } else {
                dict[String(time)] = [Care(rawValue: i.dailyRecord) ?? Care.water]
            }
        }
        
        tableData()
    }
    
    func tableData() {
        
        sortedKeysCount = dict.sorted{ $0.key > $1.key }.compactMap{ $0.value.count }
        sortedValues = dict.sorted{ $0.key > $1.key }.flatMap { $0.value.reversed() }
        sortedKeys = dict.sorted{ $0.key > $1.key }.compactMap{ $0.key }
        arrCount = sortedKeys!.indices.map { sortedKeysCount!.prefix($0).reduce(0, +) }
    }
    
    func tableLogic() {
        toDoShown
            .map { $0 ? UIColor(named: "darkGreen")! : UIColor.systemGray2 }
            .bind(onNext: { [weak self] color in
                self?.toDoBtn.tintColor = color
            })
            .disposed(by: disposeBag)
        
        diaryShown
            .map { $0 ? UIColor(named: "darkGreen")! : UIColor.systemGray2 }
            .bind(onNext: { [weak self] color in
                self?.diaryBtn.tintColor = color
            })
            .disposed(by: disposeBag)
        
        toDoBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                if self?.toDoShown.value == false {
                    self?.toDoShown.accept(true)
                    self?.diaryShown.accept(false)
                    self?.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        diaryBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                if self?.diaryShown.value == false {
                    self?.toDoShown.accept(false)
                    self?.diaryShown.accept(true)
                    self?.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        
    }
    
    func initData(_ plant: Greenmate) {
        updateUI(with: plant)
        plantName.text = plant.nickname
        plantType.text = plant.plantName
        plantBirthday.text = "키우기 시작한지 \(String(describing: plant.time ?? "0"))일"
    }
    
    
    func updateUI(with plant: Greenmate) {
        // Update the UI elements with the selected plant data
        img.image = imgsrc
        humidity.text = "\(plant.humidity)%"
        temp.text = "\(plant.temperature)°C"
        light.text = "\(plant.illuminance)"
    }
    
    func addShadow(_ view: UIView) {
        view.layer.shadowOffset = CGSizeMake(0, 1);
        view.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 2
    }
    
}

extension DetailView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if toDoShown.value{
            return (todo?.count ?? 0)
        } else {
            return dict.values.flatMap { $0 }.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if toDoShown.value {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ToDoCell
            cell.selectionStyle = .none
            
            let toDo = todo
            cell.icon.image = toDo![indexPath.item].icon
            cell.label.text = toDo![indexPath.item].name
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "withDateCell") as! WithDateCell
            cell.selectionStyle = .none
            
            if arrCount.contains(indexPath.item) {
                cell.backgroundDate.isHidden = false
                cell.month.isHidden = false
                cell.date.isHidden = false
                
                let date = arrCount.firstIndex(of: indexPath.item)!
                let split = sortedKeys?[date].split(separator: "-")
                cell.month.text = "\(split![1])월"
                cell.date.text = "\(split![2])일"
            } else if !arrCount.contains(indexPath.item) {
                cell.backgroundDate.isHidden = true
                cell.month.isHidden = true
                cell.date.isHidden = true
            }
            
            cell.label.text = sortedValues?[indexPath.item].name
            cell.icon.image = sortedValues?[indexPath.item].icon
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if toDoShown.value{
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            
            let care = todo![indexPath.item]
            network.addDailyRecordFunc(selectedMate!.moduleId, care.rawValue) {
                self.getDiary()
            }
            todo?.remove(at: indexPath.item)
        }
    }
    
    
    func formatDateForDisplay(date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter.string(from: date)
    }
}
