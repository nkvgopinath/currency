//
//  CurrencyDashBoardController.swift
//  currency
//
//  Created by Gopinath Vaiyapuri on 22/11/24.
//

import UIKit
import Combine

class CurrencyDashBoardController: UIViewController {

    @IBOutlet weak var navigation: NavigationBarView!
    
    @IBOutlet weak var countryPickerView: PickerView!
    
    @IBOutlet weak var deliverMethod: PickerView!
    
    @IBOutlet weak var depositView: DepositView!
    
    @IBOutlet weak var exchangePaymentView: PickerView!
    
    var viewModel:CurrencyViewModel?
    
    private var cancellables: Set<AnyCancellable> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.basicThemeSetup()
        self.regiesterTest()

    }
    
    func regiesterTest(){
        countryPickerView.accessibilityIdentifier = "countryPickerView"
        deliverMethod.accessibilityIdentifier = "deliverMethod"
        navigation.accessibilityIdentifier = "NavigationBarView"
        depositView.accessibilityIdentifier = "DepositView"
        exchangePaymentView.accessibilityIdentifier = "exchangePaymentView"

    }
    
    
    func basicThemeSetup(){
        self.view.backgroundColor =  ColorUtils.greenColor
        navigation.contentView.backgroundColor = ColorUtils.greenColor
        navigation.titleLabel.text = "Money Transfer"
        
        countryPickerView.titleLabel.text = "Country"
        countryPickerView.setRadiusCorner(radius: 8)
        countryPickerView.placeHolderLabel.text = "Select Country"

        countryPickerView.presentPickerHandler = {
            self.viewModel?.openCountryList()
        }
        
        deliverMethod.titleLabel.text = "Delivery Method"
        deliverMethod.setRadiusCorner(radius: 8)
        deliverMethod.placeHolderLabel.text = "Bank Account"
        
        
        deliverMethod.presentPickerHandler = {
            self.viewModel?.openDeliverMethod()
        }
        
        depositView.setRadiusCorner(radius: 8)

        exchangePaymentView.titleLabel.text = "Excepted Payment Method "
        exchangePaymentView.setRadiusCorner(radius: 8)
        exchangePaymentView.placeHolderLabel.text = "Select Payment Method"
        exchangePaymentView.setRadiusCorner(radius: 8)
        
        viewModel?.$slectedCountry
            .receive(on: DispatchQueue.main)
            .sink { [weak self] countryData in
                if let country = countryData, country.currencies?.first?.key != "AED" {
                    self?.countryPickerView.placeHolderLabel.text = country.name?.common ?? ""
                    self?.depositView.deliveryCountryName.text = country.currencies?.first?.key ?? ""
                    self?.depositView.deliveryMethodField.text = ""
                    self?.depositView.deliveryTextfField.text = ""
                    
                    if let value = self?.viewModel?.getCurrencyValue() {
                        self?.depositView.exchangeRateView.isHidden = false

                        self?.depositView.updateExchangeLable(amount:value  , currency: country.currencies?.first?.key ?? "" )
                    }else {
                        self?.depositView.exchangeRateView.isHidden = true
                    }
                    
                  
                    if let imageUrlString = country.flags?.png {
                        ImageCacheManagement.instance.getImagefromUrl(urlImage: imageUrlString) { imagedata, cached in
                            DispatchQueue.main.async {
                                if let img = imagedata {
                                    self?.depositView.deliveryCountryImage.image  = img
                                }
                            }
                        }
                    }
                }else {
                    self?.countryPickerView.placeHolderLabel.text =  "Select Country"
                }
               
            }.store(in: &cancellables)
        
        
        viewModel?.$selectedPaymentType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] paymentType in
                
                if let paytype = paymentType {
                    self?.deliverMethod.placeHolderLabel.text =  paytype
                }else {
                    self?.deliverMethod.placeHolderLabel.text =  "Select Payment"
                }
               
            }.store(in: &cancellables)
                
        depositView.deliveryMethodField.delegate = self
        depositView.deliveryMethodField.addTarget(self, action: #selector(searchTextDidChange(_:)), for: .editingChanged)

        
        depositView.changeHandler = {
            
            guard let amountText = self.depositView.deliveryMethodField.text, !amountText.isEmpty, let amount = Double(amountText), amount > 0 else {
                DispatchQueue.main.async {
                    self.depositView.deliveryTextfField.text = ""
                }
                  return
              }
            
            DispatchQueue.main.async {
                self.depositView.deliveryTextfField.text = self.viewModel?.calculateCurrencyValue(amount: amount)
            }
        }
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }


    @objc private func searchTextDidChange(_ textField: UITextField) {
        guard let amountText = textField.text, !amountText.isEmpty, let amount = Double(amountText), amount > 0 else {
            DispatchQueue.main.async {
                self.depositView.deliveryTextfField.text = ""
            }
              return
          }
        
        DispatchQueue.main.async {
            self.depositView.deliveryTextfField.text = self.viewModel?.calculateCurrencyValue(amount: amount)
        }
      }
    
}

extension CurrencyDashBoardController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel?.resetFilteredCountries()
        return true
    }
}
