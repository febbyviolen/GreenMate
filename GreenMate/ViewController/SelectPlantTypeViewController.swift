//
//  SelectPlantTypeViewController.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/21.
//

import UIKit
import ProgressHUD

class SelectPlantTypeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var filteredPlants: [PlantType] = []
    private var selectedPlant: PlantType?
    
    lazy var saveBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitle("계속하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        button.backgroundColor = UIColor(named: "softGreen")
        button.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        button.layer.cornerRadius = 15
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ProgressHUD.dismiss()
            ProgressHUD.remove()
        }
        
        view.addSubview(saveBtn)
        NSLayoutConstraint.activate([
            saveBtn.heightAnchor.constraint(equalToConstant: 50),
            saveBtn.widthAnchor.constraint(equalToConstant: 333),
            saveBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveBtn.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
       
        tableView.register(UINib(nibName: "SelectType", bundle: nil), forCellReuseIdentifier: "selectType")
        
        filteredPlants = plantType
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTakePictureController" {
            var VC = segue.destination as! TakePictureViewController
            VC.newPlantType = selectedPlant
        }
    }

}

extension SelectPlantTypeViewController {
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func nextAction() {
        if selectedPlant == nil {
            //타입 선택 알림
        } else {
            performSegue(withIdentifier: "showTakePictureController", sender: self)
        }
    }
    
}

extension SelectPlantTypeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPlants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectType", for: indexPath) as! SelectType
        
        let plant = filteredPlants[indexPath.row]
        let isSelected = plant == selectedPlant
        
        cell.configure(with: plant, isSelected: isSelected)
        cell.selectionStyle = .none
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //deselect if the last selected is the same as the one that is selected now
        if selectedPlant == filteredPlants[indexPath.row] {
            selectedPlant = nil
        } else {
            selectedPlant = filteredPlants[indexPath.row]
        }
        
        tableView.reloadData()
    }
}

extension SelectPlantTypeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // Display all plants when search text is empty
            filteredPlants = plantType
        } else {
            // Filter plants based on search text
            filteredPlants = plantType.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        tableView.reloadData()
    }
}
