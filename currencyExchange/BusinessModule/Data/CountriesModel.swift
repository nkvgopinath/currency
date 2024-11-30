//
//  CountriesModel.swift
//  currency
//
//  Created by Gopinath Vaiyapuri on 28/11/24.
//



struct CountriesModel: Codable {
    let flags: Flags?
    let name: Name?
    let cca2, cioc: String?
    let currencies: [String: Currency]?
    let capital: [String]?
    let languages: [String: String]?
}

struct Currency: Codable {
    let name, symbol: String?
}

struct Flags: Codable {
    let png: String?
    let svg: String?
    let alt: String?
}

struct Name: Codable {
    let common, official: String?
    let nativeName: [String: NativeName]?
}

struct NativeName: Codable {
    let official, common: String?
}



