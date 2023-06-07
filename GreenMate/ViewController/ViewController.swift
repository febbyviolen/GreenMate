//
//  ViewController.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/03.
//

import UIKit
import RxSwift
import RxCocoa
import ProgressHUD
import SkeletonView


class ViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var lightLabel: UILabel!
    @IBOutlet weak var tempBackground: UIView!
    @IBOutlet weak var humidityBackground: UIView!
    @IBOutlet weak var lightBackground: UIView!
    @IBOutlet weak var plantList: UICollectionView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var selectedPlantImageView: UIImageView!
    @IBOutlet weak var statusStackView: UIStackView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var titlestack2: UIStackView!
    @IBOutlet weak var titlestack: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK: Properties
    private var viewModel = ViewControllerViewModel()
    let disposeBag = DisposeBag()
    var networking = Networking()
    var toDo = [[Care]]()
 
    
    //MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetch()
        viewModel.plantCount
            .subscribe(onNext: { count in
            if count == 0 {
                ProgressHUD.animationType = .circleStrokeSpin
                ProgressHUD.colorBackground = UIColor(named: "background")!
                ProgressHUD.colorAnimation = UIColor(named: "softGreen")!
                
                self.selectedPlantImageView.showAnimatedGradientSkeleton()
                self.statusStackView.showAnimatedGradientSkeleton()
                self.titlestack.showAnimatedGradientSkeleton()
                self.titlestack2.showAnimatedGradientSkeleton()
                self.userProfileImageView.showAnimatedGradientSkeleton()
                self.addButton.showAnimatedGradientSkeleton()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.performSegue(withIdentifier: "showIsEmpty", sender: self)
                }
            }
        }).disposed(by: disposeBag)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.timer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
        bindTableData()
        viewModel.startTimer()
        plantList.register(UINib(nibName: "GreenMateList", bundle: nil), forCellWithReuseIdentifier: "greenMateList")
        selectedPlantImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewDetail)))
        
    }
    
    //to pass the selected item to the DetailView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailView" {
            guard let nController = segue.destination as? UINavigationController,
                  let destinationVC = nController.topViewController as? DetailView else {return}
            destinationVC.viewModel.selectedMate = viewModel.selectedMate
            destinationVC.viewModel.todo = toDo[viewModel.selectedIndex]
            destinationVC.viewModel.imgsrc = selectedPlantImageView.image
        }
        
    }
}

//MARK: Methods
extension ViewController {
    
    private func bindTableData() {
        
        //bind items
        viewModel.greenmates.bind(
            to: plantList.rx.items(
                cellIdentifier: "greenMateList",
                cellType: GreenMateList.self)
        ){ [weak self] row, item, cell in
            
            if row == 0 {
                self?.humidityLabel.text = self?.viewModel.soilWaterHandle(item.soilWater)
                self?.tempLabel.text = self?.viewModel.temperatureHandle(item.temperature)
                self?.lightLabel.text = self?.viewModel.lightHandle(item.illuminance)
                self?.selectedPlantImageView.showAnimatedSkeleton()
                self?.viewModel.downloadImg(item.moduleId) { image in
                    self?.selectedPlantImageView.hideSkeleton()
                    self?.selectedPlantImageView.image = image
                }
            }
            
            cell.plantName.text = item.nickname
            cell.plantType.text = item.plantName
            cell.img.showAnimatedSkeleton()
            self?.viewModel.downloadImg(item.moduleId) { image in
                cell.img.hideSkeleton()
                cell.img.image = image
            }
            
            var todo = [Care]()
            if self?.viewModel.soilWaterHandle(item.soilWater) == "나쁨" {
                todo.append(.water)
            }
            if self?.viewModel.lightHandle(item.illuminance) == "나쁨" {
                todo.append(.vitamin)
            }
            if self?.viewModel.temperatureHandle(item.illuminance) == "나쁨" {
                todo.append(.air)
            }
            
            self?.toDo.append(todo)
            self?.viewModel.selectedIndex = row
        }.disposed(by: disposeBag)
        
        plantList.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                let plant = viewModel.greenmates.value[indexPath.row]
                
                self.viewModel.selectedMate = plant
                self.selectedPlantImageView.showAnimatedSkeleton()
                
//                if self.viewModel.imgStorage[]
                viewModel.downloadImg(plant.moduleId) { image in
                    self.selectedPlantImageView.hideSkeleton()
                    self.selectedPlantImageView.image = image
                }
                self.humidityLabel.text = viewModel.soilWaterHandle(plant.soilWater)
                self.tempLabel.text = viewModel.temperatureHandle(plant.temperature)
                self.lightLabel.text = viewModel.lightHandle(plant.illuminance)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func updateStatusData(){
        viewModel.stat
            .asObservable()
            .subscribe { val in
                self.humidityLabel.text = self.viewModel.soilWaterHandle(val.element![1])
                self.tempLabel.text = self.viewModel.soilWaterHandle(val.element![2])
                self.lightLabel.text = self.viewModel.soilWaterHandle(val.element![0])
                
            }.disposed(by: disposeBag)
    }
    
    @objc func viewDetail() {
        performSegue(withIdentifier: "showDetailView", sender: self)
    }
    
    private func setupUI() {
        imgUI(selectedPlantImageView)
        statusUI(tempBackground)
        statusUI(humidityBackground)
        statusUI(lightBackground)
        updateStatusData()
    }
    
    private func statusUI(_ view: UIView) {
        view.layer.shadowOffset = CGSizeMake(0, 1);
        view.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 2
        view.layer.cornerRadius = 10
    }
    
    private func imgUI (_ view: UIImageView) {
        view.layer.cornerRadius = 10
        view.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        view.layer.borderWidth = 5
        view.layer.shadowOffset = CGSizeMake(0, 2);
        view.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 7
    }
    
    
}


