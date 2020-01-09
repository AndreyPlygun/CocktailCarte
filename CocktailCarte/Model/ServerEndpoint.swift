//
//  ServerEndpoint.swift
//  CoctailDB
//
//  Created by Admin on 19.07.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

enum ServerEndpoint {
    case searchCocktailByName(term: String)
    case searchIngredientByName(term: String)
    case filterByAlcoholic(isAlcoholic: Bool)
    case filterByCategory(category: String)
    case lookupDrinkDetails(id: String)
    case listCategoriesFilters
    
    private var baseURL: String {
        return "https://www.thecocktaildb.com/"
    }
    
    private var path: String {
        switch self {
        case .searchCocktailByName, .searchIngredientByName:
            return "/api/json/v1/1/search.php"
        case .filterByAlcoholic, .filterByCategory:
            return "/api/json/v1/1/filter.php"
        case .lookupDrinkDetails:
            return "/api/json/v1/1/lookup.php"
        case .listCategoriesFilters:
            return "/api/json/v1/1/list.php"
        }        
    }
    
    private struct ParameterKeys {
        static let name = "s"
        static let id = "i"
        static let alcoholic = "a"
        static let category = "c"
    }
    
    private var parameters: [String : Any] {
        switch self {
        case .searchCocktailByName(let term):
            let parameters: [String : Any] = [ParameterKeys.name : term]
            return parameters
        case .searchIngredientByName(let term):
            let parameters: [String : Any] = [ParameterKeys.id : term]
            return parameters
        case .filterByAlcoholic(let isAlcoholic):
            var parameterVaule: String
            parameterVaule = isAlcoholic ? "Alcoholic" : "Non_Alcoholic"
            let parameters: [String : Any] = [ParameterKeys.alcoholic : parameterVaule]
            return parameters
        case .lookupDrinkDetails(let id):
            let parameters: [String : Any] = [ParameterKeys.id : id]
            return parameters
        case .listCategoriesFilters:
            let parameters: [String : Any] = [ParameterKeys.category : "list"]
            return parameters
        case .filterByCategory(let category):
            let parameters: [String : Any] = [ParameterKeys.category : category]
            return parameters
        }
    }
    
    private var queryComponents: [URLQueryItem] {
        var components = [URLQueryItem]()
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.append(queryItem)
        }
        return components
    }
    
    var request: URLRequest {
        var components = URLComponents(string: baseURL)!
        components.path = path
        components.queryItems = queryComponents
        let url = components.url!
        return URLRequest(url: url)
    }
}
