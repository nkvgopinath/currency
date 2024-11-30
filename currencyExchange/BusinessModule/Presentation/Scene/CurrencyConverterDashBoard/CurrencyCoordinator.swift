//
//  CurrencyCoordinator.swift
//  currency
//
//  Created by Gopinath Vaiyapuri on 22/11/24.
//

import Foundation


class CurrencyCoordinator: Coordinate {
    
    weak var viewController: CurrencyDashBoardController?
       
       func showScreen(_ screen: Screen) {
           switch screen {
           case .country:
               let vc = CountryPickerController()
               vc.viewModel = viewController?.viewModel
               vc.modalPresentationStyle = .pageSheet
               
               if let sheet = vc.sheetPresentationController {
                   sheet.detents = [.medium(), .large()]
                   sheet.preferredCornerRadius = 40
               }
               
               vc.handler = { indexPath, yesSearch in
                   guard let viewModel = self.viewController?.viewModel else { return }
                   let section = indexPath.section
                   let item = indexPath.item
                   
                   if section == 0, !yesSearch {
                       let selectedCountry = viewModel.favCountries[item]
                       if let selectedData = viewModel.filteredCountryList.first(where: { $0.name?.common == selectedCountry }) {
                           viewModel.slectedCountry = selectedData
                       }
                   } else {
                       viewModel.slectedCountry = viewModel.filteredCountryList[item]
                   }
               }
               
               viewController?.navigationController?.present(vc, animated: true, completion: nil)
           
           case .bank:
               let vc = DeliveryMethodController()
               vc.selectedType = viewController?.viewModel?.selectedPaymentType ?? ""
               
               vc.handleTap = { typeData in
                   if !typeData.isEmpty {
                       self.viewController?.viewModel?.selectedPaymentType = typeData
                   }
               }
               
               viewController?.present(vc, animated: true, completion: nil)
           
           case .paymentMethod:
               // Implementation for paymentMethod screen
               print("Navigate to Payment Method Screen")
           }
       }
       
       func showError(_ error: String) {
           guard let viewController = viewController else { return }
           viewController.showAlert(message: error)
       }
   }

   extension CurrencyCoordinator {
       enum Screen {
           case country, bank, paymentMethod
       }
   }
