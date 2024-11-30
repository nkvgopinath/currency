//
//  CurrencyViewModel.swift
//  currency
//
//  Created by Gopinath Vaiyapuri on 22/11/24.
//

import Combine

class CurrencyViewModel{
    
    private let coordinator: CurrencyCoordinator?

    private let repository: CountryRepository?

    @Published var countryList: [CountriesModel]

    var popularCountries: [String] = []
    
    @Published var filteredCountryList: [CountriesModel] = []

    @Published var slectedCountry:CountriesModel?
    
    @Published var selectedPaymentType:String?
    
    var exchangeRateList: [String: Double] = [:]

    var favCountries: [String] = ["India","Pakistan","Philippines","Nepal", "Sri Lanka"]
    
  
    
 
    init(coordinator: CurrencyCoordinator?, repository: CountryRepository?) {
        self.coordinator = coordinator
        self.repository = repository
        self.countryList = []
        self.getCurrencyExchange()
    }
    
    
    func openCountryList(){
        coordinator?.showScreen(.country)
    }
    
    
    func openDeliverMethod(){
        coordinator?.showScreen(.bank)

    }
    
    func exceptedDeliveryMethod(){
        coordinator?.showScreen(.paymentMethod)

    }
    
    
    
    func filterCountries(with query: String) {
        if query.isEmpty {
            filteredCountryList = countryList
        } else {
            filteredCountryList = countryList.filter {
                $0.name?.common?.lowercased().contains(query.lowercased()) ?? false
            }
        }
    }

    func resetFilteredCountries() {
        filteredCountryList = countryList
    }
    
    
    
    func getCountryList(){
        
        repository?.getCountryList()  { response in
            switch response{
            case .success(let country):
                self.filteredCountryList = country
                self.countryList = country
                break
            case .failure(let error):
                self.coordinator?.viewController?.showAlert(message: error.localizedDescription)
                break
            }
        }
    }
    
    
    func getCurrencyExchange(){
        repository?.getCurrentExchangeRate() { response in
            switch response{
            case .success(let exchange):
                if let exchangeData = exchange.conversion_rates {
                    self.exchangeRateList = exchangeData
                }
                break
            case .failure(let error):
                self.coordinator?.viewController?.showAlert(message: error.localizedDescription)
                break
            }
            
        }
    }
    
    
    func getCurrencyValue() -> Double? {

        guard let selectedCurrency = slectedCountry?.currencies?.keys.first else {
            self.coordinator?.viewController?.showAlert(message: "Conversion Error: No currency selected.")
            return nil
        }

        guard let rate = exchangeRateList[selectedCurrency] else {
            self.coordinator?.viewController?.showAlert(message: "Conversion Error: Exchange rate not found.")
            return nil
        }

        return rate
    }
    

    func calculateCurrencyValue(amount: Double) -> String {

        guard let selectedCurrency = slectedCountry?.currencies?.keys.first else {
            self.coordinator?.viewController?.showAlert(message: "Conversion Error: No currency selected.")
            return ""
        }

        guard let rate = exchangeRateList[selectedCurrency] else {
            self.coordinator?.viewController?.showAlert(message: "Conversion Error: Exchange rate not found.")
            return ""
        }

        let convertedAmount = amount * rate
        return String(format: "%.2f", convertedAmount)
    }
    
}

