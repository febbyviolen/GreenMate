//
//  AddGreenMateViewController.swift
//  GreenMate
//
//  Created by Ebbyy on 2023/05/14.
//

import UIKit
import RxSwift
import RxCocoa

class CareViewController: UIViewController {
    
    var careListRelay = BehaviorRelay<[Care]>(value: [])
    let disposeBag = DisposeBag()
    var selectedPlant: GreenMate!
    
    var selectedItems = [Care]()
    let picker = UIDatePicker()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        
        careListRelay.accept(care)
        collectionViewBinding()

        collectionView.allowsMultipleSelection = true
        collectionView.register(UINib(nibName: "CareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "careCell")
        saveBtn.layer.cornerRadius = 15
        
        date.text = formatDateForDisplay(date: Date())
        showCalendar()

    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        if !selectedItems.isEmpty{
            for i in selectedItems {
                selectedPlant.addDiary(i, for: date.text!)
            }
            DataStore.shared.editItem(selectedPlant)
            print(DataStore.shared.getItems())
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension CareViewController {
    
    func showCalendar() {
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .date
        picker.maximumDate = .now
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneBtn], animated: true)
        
        date.inputAccessoryView = toolbar
        date.inputView = picker
    }
    
    @objc func datePickerValueChanged() {
           let selectedDate = picker.date
           let formattedDate = formatDateForDisplay(date: selectedDate)
           date.text = formattedDate
       }
    
    func formatDateForDisplay(date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter.string(from: date)
    }
    
    @objc func doneTapped() {
        self.view.endEditing(true)
    }
    
    func collectionViewBinding() {
        careListRelay
            .bind(to: collectionView.rx.items(
                cellIdentifier: "careCell",
                cellType: CareCollectionViewCell.self)
            ) { _, item, cell in
                // Configure the cell with item
                cell.icon.image = item.icon
                cell.label.text = item.name
                cell.background.backgroundColor = UIColor(named: "background")
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let cell = self?.collectionView.cellForItem(at: indexPath) as? CareCollectionViewCell else { return }
                self?.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                cell.setSelectedStyle()
                if let selectedCare = self?.careListRelay.value[indexPath.item] {
                    self?.selectedItems.append(selectedCare)
                }
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.itemDeselected
            .subscribe(onNext: { [weak self] indexPath in
                guard let cell = self?.collectionView.cellForItem(at: indexPath) as? CareCollectionViewCell else { return }
                self?.collectionView.deselectItem(at: indexPath, animated: false)
                cell.setDeselectedStyle()
                if let selectedCare = self?.careListRelay.value[indexPath.item] {
                    self?.selectedItems.removeAll(where: { $0 == selectedCare })
                }
            })
            .disposed(by: disposeBag)
    }
}

