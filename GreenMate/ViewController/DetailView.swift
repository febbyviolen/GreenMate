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
    
    //delegate
    func nameChanged(controller: EditDetailView) {
        plantNameLabel.text = controller.textField.text ?? ""
        controller.navigationController?.popViewController(animated: true)
    }

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var diaryBtn: UIButton!
    @IBOutlet weak var toDoBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var lightLabel: UILabel!
    @IBOutlet weak var tempBackground: UIView!
    @IBOutlet weak var humidityBackground: UIView!
    @IBOutlet weak var lightBackground: UIView!
    
    @IBOutlet weak var plantBirthdayLabel: UILabel!
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var plantTypeLabel: UILabel!
    
    var viewModel = DetailViewModel()
    var disposeBag = DisposeBag()
    var network = Networking()
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getDiary()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableLogic()
        initData(viewModel.selectedMate!)
        viewModel.diaryy.subscribe { [weak self] record in
            self?.viewModel.diary = record
            self?.viewModel.changeToDict()
            self?.tableView.reloadData()
        }
        setupUI()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ToDoCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "WithDateCell", bundle: nil), forCellReuseIdentifier: "withDateCell")
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditDetailView" {
            let VC = segue.destination as? EditDetailView
            VC?.selectedPlant = viewModel.selectedMate
            VC?.imgsrc = viewModel.imgsrc
            VC?.delegate = self
        }
        else if segue.identifier == "showDeleteGreenMate" {
            let VC = segue.destination as? DeleteGreenMate
            VC?.selectedPlant = viewModel.selectedMate
        }
        else if segue.identifier == "showCareViewController" {
            let VC = segue.destination as? CareViewController
            VC?.selectedPlant = viewModel.selectedMate
        }
    }
    
    
}

extension DetailView {
    
    func tableLogic() {
        viewModel.toDoShown
            .map { $0 ? UIColor(named: "darkGreen")! : UIColor.systemGray2 }
            .bind(onNext: { [weak self] color in
                self?.toDoBtn.tintColor = color
            })
            .disposed(by: disposeBag)
        
        viewModel.diaryShown
            .map { $0 ? UIColor(named: "darkGreen")! : UIColor.systemGray2 }
            .bind(onNext: { [weak self] color in
                self?.diaryBtn.tintColor = color
            })
            .disposed(by: disposeBag)
        
        toDoBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                if self?.viewModel.toDoShown.value == false {
                    self?.viewModel.toDoShown.accept(true)
                    self?.viewModel.diaryShown.accept(false)
                    self?.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        diaryBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                if self?.viewModel.diaryShown.value == false {
                    self?.viewModel.toDoShown.accept(false)
                    self?.viewModel.diaryShown.accept(true)
                    self?.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        
    }
    
    private func initData(_ plant: Greenmate) {
        updateUI(with: plant)
        plantNameLabel.text = plant.nickname
        plantTypeLabel.text = plant.plantName
        plantBirthdayLabel.text = "키우기 시작한지 \(String(describing: plant.time ?? "0"))일"
    }
    
    
    private func updateUI(with plant: Greenmate) {
        // Update the UI elements with the selected plant data
        img.image = viewModel.imgsrc
        humidityLabel.text = "\(plant.humidity)%"
        tempLabel.text = "\(plant.temperature)°C"
        lightLabel.text = "\(plant.illuminance)"
    }
    
    private func addShadow(_ view: UIView) {
        view.layer.shadowOffset = CGSizeMake(0, 1);
        view.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 2
    }
    
    private func formatDateForDisplay(date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter.string(from: date)
    }
    
    private func setupUI(){
        addShadow(tempBackground)
        addShadow(humidityBackground)
        addShadow(lightBackground)
        
        tempBackground.layer.cornerRadius = 10
        humidityBackground.layer.cornerRadius = 10
        lightBackground.layer.cornerRadius = 10
        img.layer.cornerRadius = 10
    }
    
}

extension DetailView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.toDoShown.value{
            return (viewModel.todo?.count ?? 0)
        } else {
            return viewModel.dict.values.flatMap { $0 }.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if viewModel.toDoShown.value {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ToDoCell
            cell.selectionStyle = .none
            
            let toDo = viewModel.todo
            cell.icon.image = toDo![indexPath.item].icon
            cell.label.text = toDo![indexPath.item].name
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "withDateCell") as! WithDateCell
            cell.selectionStyle = .none
            
            if viewModel.arrCount.contains(indexPath.item) {
                cell.backgroundDate.isHidden = false
                cell.month.isHidden = false
                cell.date.isHidden = false
                
                let date = viewModel.arrCount.firstIndex(of: indexPath.item)!
                let split = viewModel.sortedKeys?[date].split(separator: "-")
                cell.month.text = "\(split![1])월"
                cell.date.text = "\(split![2])일"
            } else if !viewModel.arrCount.contains(indexPath.item) {
                cell.backgroundDate.isHidden = true
                cell.month.isHidden = true
                cell.date.isHidden = true
            }
            
            cell.label.text = viewModel.sortedValues?[indexPath.item].name
            cell.icon.image = viewModel.sortedValues?[indexPath.item].icon
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.toDoShown.value{
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            
            let care = viewModel.todo![indexPath.item]
            network.addDailyRecordFunc(viewModel.selectedMate!.moduleId, care.rawValue) {
                self.viewModel.getDiary()
            }
            viewModel.todo?.remove(at: indexPath.item)
        }
    }
}
