//
//  CountryPickerController.swift
//  currency
//
//  Created by Gopinath Vaiyapuri on 22/11/24.
//

import UIKit
import Combine

class CountryPickerController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchHolderView: UIView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var viewModel: CurrencyViewModel?
    
    private var cancellables: Set<AnyCancellable> = []
    
    var yesSearchEnabled: Bool = false
    
    var handler:((IndexPath, Bool)->())?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCollectionView()
        self.setBasicTheme()
        viewModel?.getCountryList()
        self.bindViewModel()
        self.setupSearchTextField()
        self.registerTestCases()
    }
    
    func registerTestCases(){
        searchTextField.accessibilityIdentifier = "searchTextField"
        collectionView.accessibilityIdentifier = "CountryPickerCollection"


    }
    
    private func bindViewModel() {
        viewModel?.$filteredCountryList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setBasicTheme() {
        searchHolderView.setRadiusCorner(radius: 5, color: ColorUtils.whiteColor)
        searchHolderView.setLayer(borderWidth: 0.5, color: ColorUtils.lightGrayColor)
    }

    private func registerCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.backgroundColor = ColorUtils.whiteColor
        collectionView.backgroundColor = ColorUtils.whiteColor
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib(nibName: "\(GridCollectionCell.self)", bundle: .main), forCellWithReuseIdentifier: GridCollectionCell.identifier)
        collectionView.register(UINib(nibName: "\(TitleCell.self)", bundle: .main), forCellWithReuseIdentifier: TitleCell.identifier)
       
        collectionView.register(UINib(nibName: "\(TitleCell.self)", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCell.identifier)
    }
    
    private func setupSearchTextField() {
        searchTextField.delegate = self
        searchTextField.placeholder = "Search countries"
        searchTextField.addTarget(self, action: #selector(searchTextDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func searchTextDidChange(_ textField: UITextField) {
          guard let query = textField.text, !query.isEmpty else {
              yesSearchEnabled = false
              viewModel?.resetFilteredCountries()
             
              return
          }
          yesSearchEnabled = true
          viewModel?.filterCountries(with: query)
      }
    
}

extension CountryPickerController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        viewModel?.resetFilteredCountries()
        return true
    }
}

extension CountryPickerController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 , !self.yesSearchEnabled {
            let width: CGFloat = collectionView.frame.size.width / 5
            let height: CGFloat = width + (width / 2)
            return CGSize(width: width, height: height)
        }
        return CGSize(width: collectionView.frame.size.width, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let handle = handler {
            handle(indexPath, self.yesSearchEnabled)
            self.dismiss(animated: true)
        }
    }
}

extension CountryPickerController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleCell.identifier, for: indexPath) as? TitleCell else {
            return UICollectionReusableView()
        }
        
        header.title = indexPath.section == 0 && !self.yesSearchEnabled ? "Popular Countries" : "All Countries"
        header.titleLable.textColor = ColorUtils.blackColor
        header.titleLable.textAlignment = .left
        header.imageHolderView.isHidden = true
        header.backgroundColor = ColorUtils.whiteColor
        
        return header
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return self.yesSearchEnabled ? 1 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0, !self.yesSearchEnabled {
            return 5
        }
        return viewModel?.filteredCountryList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0, !self.yesSearchEnabled {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionCell.identifier, for: indexPath) as? GridCollectionCell else {
                return UICollectionViewCell()
            }
            cell.tileLabel.text = viewModel?.favCountries[indexPath.item]
            cell.imageView.image = UIImage(named:"\(viewModel?.favCountries[indexPath.item] ?? "")")
            
          
            cell.backgroundColor = ColorUtils.lightGrayColor
            
            cell.imageView.accessibilityIdentifier = "countryFlag"
            cell.tileLabel.accessibilityIdentifier = "\(viewModel?.favCountries[indexPath.item] ?? "")"

            
            return cell
        } else {
            guard let titleCell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCell.identifier, for: indexPath) as? TitleCell else {
                return UICollectionViewCell()
            }
            titleCell.title = viewModel?.filteredCountryList[indexPath.row].name?.common ?? ""
            titleCell.titleLable.textColor = ColorUtils.blackColor
            titleCell.titleLable.textAlignment = .left
            titleCell.imageHolderView.isHidden = false
            titleCell.imageView.image = UIImage(named: "india") // Set placeholder
            
            if let imageUrlString = viewModel?.filteredCountryList[indexPath.item].flags?.png {
                ImageCacheManagement.instance.getImagefromUrl(urlImage: imageUrlString) { imagedata, cached in
                    DispatchQueue.main.async {
                        if let img = imagedata {
                            titleCell.imageView.image = img
                        }
                    }
                }
            }
            
            return titleCell
        }
    }
}

