//
//  CountryUsesCases.swift
//  currency
//
//  Created by Gopinath Vaiyapuri on 28/11/24.
//



protocol CountryUsesCases {
    
    func getCountryList(completion: @escaping(Result<[CountriesModel], Error>) -> Void)
    func getCurrentExchangeRate(completion: @escaping (Result<ExchangeRateModel, any Error>) -> Void)
}


final class CountryRepository {
    
    let request: APIClient
    
    init(_ apiProvider: APIClient) {
        self.request = apiProvider
    }
}

extension CountryRepository: CountryUsesCases {
    
    func getCountryList(completion: @escaping (Result<[CountriesModel], any Error>) -> Void) {
        
        let path = APIConstants.countryList
        let query = ["fields":"name,languages,capital,flags,currencies,cca2,cioc"]
        let req = APIRequest(method: .get, path: path,  fullPath: true, queryItems: query)

        request.perform(req, [CountriesModel].self) { response  in
            switch response {
            case .success(let countries):
               completion(.success(countries))
            case .failure(let err):
                print(err)
                completion(.failure(err))
            }
        }
    }
    
    
    func getCurrentExchangeRate(completion: @escaping (Result<ExchangeRateModel, any Error>) -> Void) {
        
        let path = APIConstants.currencyExchange
        let req = APIRequest(method: .get, path: path,  fullPath: true, queryItems: nil)

        request.perform(req, ExchangeRateModel.self) { response  in
            switch response {
            case .success(let countries):
               completion(.success(countries))
            case .failure(let err):
                print(err)
                completion(.failure(err))
            }
        }
    }
    
    
 //    https://v6.exchangerate-api.com/v6/d87d011f239c8de8ce8a419d/latest/AED
    
}
