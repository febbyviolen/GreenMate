//
//  ViewController.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/03.
//

import UIKit
import RxSwift
import RxCocoa


class ViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var light: UILabel!
    @IBOutlet weak var tempBackground: UIView!
    @IBOutlet weak var humidityBackground: UIView!
    @IBOutlet weak var lightBackground: UIView!
    @IBOutlet weak var plantList: UICollectionView!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var selectedPlant: UIImageView!
    
    
    //MARK: Properties
    private var viewModel = ViewControllerViewModel()
    
    
    let disposeBag = DisposeBag()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        
        imgUI(selectedPlant)
        statusUI(tempBackground)
        statusUI(humidityBackground)
        statusUI(lightBackground)
        
        plantList.register(UINib(nibName: "GreenMateList", bundle: nil), forCellWithReuseIdentifier: "greenMateList")
        selectedPlant.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewDetail)))
        
        bindTableData()
    }
    
    //to pass the selected item to the DetailView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailView" {
            let nController = segue.destination as? UINavigationController
            let destinationVC = nController?.topViewController as? DetailView
            destinationVC?.sPlant.onNext(viewModel.selectedPlant)
        }
        
    }
}

//MARK: Methods
extension ViewController {
    
    func bindTableData() {
        //bind items
        viewModel.plants.bind(
            to: plantList.rx.items(
                cellIdentifier: "greenMateList",
                cellType: GreenMateList.self)
        ){ row, item, cell in
            
            if row == 0 {
                self.humidity.text = "\(item.humidity)%"
                self.temp.text = "\(item.temp)°C"
                self.light.text = "\(item.light)"
                self.selectedPlant.image = UIImage(named: item.img)
            }
            
            cell.plantName.text = item.name
            cell.img.image = UIImage(named: item.img)
            cell.plantType.text = item.type.name
            
            
            cell.first.isHidden = item.toDo!.contains(Care.water) ? false : true
            cell.second.isHidden = item.toDo!.contains(Care.vitamin) ? false : true
            cell.third.isHidden = item.toDo!.contains(Care.air) ? false : true
            
            
        }.disposed(by: disposeBag)
        
        plantList.rx.modelSelected(GreenMate.self)
            .bind { [weak self] plant in
                self?.viewModel.selectedPlant = plant
                self?.selectedPlant.image = UIImage(named: plant.img)
                self?.humidity.text = "\(plant.humidity)%"
                self?.temp.text = "\(plant.temp)°C"
                self?.light.text = "\(plant.light)"
        }.disposed(by: disposeBag)
        

        //fetch items
        viewModel.fetchItems()
    }
    
    @objc func viewDetail() {
        performSegue(withIdentifier: "showDetailView", sender: viewModel.selectedPlant)
    }
    
    func statusUI(_ view: UIView) {
        view.layer.shadowOffset = CGSizeMake(0, 1);
        view.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 2
        view.layer.cornerRadius = 10
    }
    
    func imgUI (_ view: UIImageView) {
        view.layer.cornerRadius = 10
        view.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        view.layer.borderWidth = 5
        view.layer.shadowOffset = CGSizeMake(0, 2);
        view.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 7
    }
}


class ViewControllerViewModel {
    var plants = BehaviorRelay<[GreenMate]>(value: [])
    var selectedPlant: GreenMate?
    //fetch items from API 
    func fetchItems() {
        let getItems = DataStore.shared.getItems()
        
        //the data has changed
        plants.accept(getItems)
        selectedPlant = getItems.first
    
    }
    
    
}

