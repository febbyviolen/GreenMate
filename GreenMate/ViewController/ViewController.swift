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
    @IBOutlet weak var statusStack: UIStackView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var titlestack2: UIStackView!
    @IBOutlet weak var titlestack: UIStackView!
    
    //MARK: Properties
    private var viewModel = ViewControllerViewModel()
    let disposeBag = DisposeBag()
    var networking = Networking()
    var toDo = [[Care]]()
 
    
    //MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        
        viewModel.fetch()
        viewModel.plantCount.subscribe(onNext: { count in
            if count == 0 {
                ProgressHUD.animationType = .circleStrokeSpin
                ProgressHUD.colorBackground = UIColor(named: "background")!
                ProgressHUD.colorAnimation = UIColor(named: "softGreen")!
                
//                ProgressHUD.show()
                self.selectedPlant.showAnimatedGradientSkeleton()
                self.statusStack.showAnimatedGradientSkeleton()
                self.titlestack.showAnimatedGradientSkeleton()
                self.titlestack2.showAnimatedGradientSkeleton()
                self.userProfile.showAnimatedGradientSkeleton()
                self.addButton.showAnimatedGradientSkeleton()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.performSegue(withIdentifier: "showIsEmpty", sender: self)
//                    ProgressHUD.dismiss()
                    
                }
            }
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.timer?.invalidate()
    }
    
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
        viewModel.startTimer()
        updateStatusData()
    }
    
    //to pass the selected item to the DetailView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailView" {
            let nController = segue.destination as? UINavigationController
            let destinationVC = nController?.topViewController as? DetailView
            destinationVC?.selectedMate = viewModel.selectedMate
            destinationVC?.todo = toDo[viewModel.selectedIndex]
            destinationVC?.imgsrc = selectedPlant.image
        }
        
    }
}

//MARK: Methods
extension ViewController {
    
    func bindTableData() {
        
        plantList.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                
                let plant = viewModel.greenmates.value[indexPath.row]
                
                self.viewModel.selectedMate = plant
                self.humidity.text = "\(plant.humidity)%"
                self.temp.text = "\(plant.temperature)°C"
                self.light.text = "\(plant.illuminance)"
                self.selectedPlant.showAnimatedSkeleton()
                viewModel.downloadImg(plant.moduleId) { image in
                    self.selectedPlant.hideSkeleton()
                    self.selectedPlant.image = image
                }
            }
            .disposed(by: disposeBag)
        
        //bind items
        viewModel.greenmates.bind(
            to: plantList.rx.items(
                cellIdentifier: "greenMateList",
                cellType: GreenMateList.self)
        ){ [self] row, item, cell in
            
            if row == 0 {
                self.humidity.text = "\(item.soilWater)%"
                self.temp.text = "\(item.temperature)°C"
                self.light.text = "\(item.illuminance)"
                self.selectedPlant.showAnimatedSkeleton()
                viewModel.downloadImg(item.moduleId) { image in
                    self.selectedPlant.hideSkeleton()
                    self.selectedPlant.image = image
                }
            }
            
            cell.plantName.text = item.nickname
            cell.plantType.text = item.plantName
            cell.img.showAnimatedSkeleton()
            viewModel.downloadImg(item.moduleId) { image in
                cell.img.hideSkeleton()
                cell.img.image = image
            }
            
            var todo = [Care]()
            if item.soilWater <= 200 {
                cell.first.isHidden = false
                todo.append(.water)
            }
            if item.illuminance <= 50 {
                cell.second.isHidden = false
                todo.append(.vitamin)
            }
            if item.temperature <= 20 {
                cell.third.isHidden = false
                todo.append(.air)
            }
            
            self.toDo.append(todo)
            self.viewModel.selectedIndex = row
        }.disposed(by: disposeBag)
        
        plantList.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                
                let plant = viewModel.greenmates.value[indexPath.row]
                
                self.viewModel.selectedMate = plant
                self.selectedPlant.showAnimatedSkeleton()
                viewModel.downloadImg(plant.moduleId) { image in
                    self.selectedPlant.hideSkeleton()
                    self.selectedPlant.image = image
                }
                self.humidity.text = "\(plant.humidity)%"
                self.temp.text = "\(plant.temperature)°C"
                self.light.text = "\(plant.illuminance)"
            }
            .disposed(by: disposeBag)

    }
    
    func updateStatusData(){
        viewModel.stat
            .asObservable()
            .subscribe { val in
            self.humidity.text = "\(val.element![1])%"
            self.temp.text = "\(val.element![2])°C"
            self.light.text = "\(val.element![0])"
            
            }.disposed(by: disposeBag)
    }
    
    @objc func viewDetail() {
        performSegue(withIdentifier: "showDetailView", sender: self)
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
    var greenmates = BehaviorRelay<[Greenmate]>(value: [])
    var selectedMate: Greenmate?
    var selectedIndex = 0
    var network = Networking()
    var timer: Timer?
    
    var plantCount = PublishSubject<Int>()
    
    var stat = BehaviorRelay<[Int]>(value: [0, 0, 0])
    
    func fetch(){
        network.getUserAllDataFunc(["masterUser", "greenmate1234"]) { [weak self] greenmate in
            self?.greenmates.accept(greenmate)
            self?.selectedMate = greenmate.first
            self?.plantCount.onNext(greenmate.count)
        }
    }
    
    @objc func fetchEvery5() {
        network.getUserAllDataFunc(["masterUser", "greenmate1234"]) { [weak self] greenmate in
            self?.updateStatusData(greenmate)
        }
    }
    
    func updateStatusData(_ greenmate: [Greenmate]) {
        let selected = greenmate.filter{$0.moduleId == selectedMate?.moduleId}
        stat.accept([selected.first?.illuminance ?? 0, selected.first?.soilWater ?? 0, selected.first?.temperature ?? 0])
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(fetchEvery5), userInfo: nil, repeats: true)
    }
    
    func downloadImg(_ moduleId: String, completion: @escaping (_ image: UIImage) -> Void){
        let fileName = "\(moduleId)-Greenmate.jpeg" // Specify the file name you want to download
        var image = UIImage(named: "plant1")!
        
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        
        AWSS3Manager.shared.downloadFile(fileName: fileName, fileURL: fileURL, progress: { (downloadProgress) in
            // Handle the download progress if needed
        }) { (localURL, error) in
            if let error = error {
                print("Error downloading file: \(error.localizedDescription)")
                completion(image)
            } else if let localURL = localURL {
                // File downloaded successfully, use the localURL as needed
                print("File downloaded at path: \(localURL)")
                
                if let imageData = try? Data(contentsOf: localURL as! URL) {
                    image = UIImage(data: imageData) ?? UIImage(named: "plant1")!
                    completion(image)
                }
                
            }
        }
    }
}

