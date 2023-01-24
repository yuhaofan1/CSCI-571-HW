//
//  KeywordSearchViewModel.swift
//  IOSHW9
//
//  Created by Gaurav Gudaliya on 25/11/22.
//

import Foundation
import SwiftUI

class KeywordSearchViewModel: ObservableObject{
    @Published var searchResult:KeywordSearchModel?
    @Published var bussinessResult:BusinessModel?
    
    var location : String = ""
    var lat : Double = 0.0
    var long : Double = 0.0
    var auto_detect: Bool = false
    var distance : String = ""
    var category : String = ""
    var keyward: String = ""
    @Published var isAPICall: Bool = false
    @Published var isKeywardAPICall: Bool = false
    
    func fetchSeachResult(keyword:String){
        var components = URLComponents()
        components.scheme = GGWebKey.componentsScheme
        components.host = GGWebKey.componentsHost
        components.path = "/getkeyword"
    
        var queryItems:[URLQueryItem] = []
        if keyword.count > 0{
            queryItems.append(URLQueryItem(name: "val", value: keyword))
        }else{
            return
        }
        components.queryItems = queryItems
        guard let url = components.url else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "Get"
        DispatchQueue.main.async {
            self.isKeywardAPICall = true
        }
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _,
            error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isKeywardAPICall = false
                guard let data = data, error == nil else {
                    return
                }
                do {
                    self.searchResult = try JSONDecoder().decode(KeywordSearchModel.self, from: data)
                }
                catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    func fetchSummuryResult(){
        var components = URLComponents()
        components.scheme = GGWebKey.componentsScheme
        components.host = GGWebKey.componentsHost
        components.path = "/getsummary"
//    http://csci5718-env-1.eba-ju4ufqrf.us-west-2.elasticbeanstalk.com/getsummary?keyword=Mexican+Food&radius=10&category=Default&latitude=40.7127753&longitude=-74.0059728
        components.queryItems = [
            URLQueryItem(name: "keyword", value: self.keyward),
            URLQueryItem(name: "radius", value: self.distance),
            URLQueryItem(name: "category", value: self.category),
            URLQueryItem(name: "latitude", value: self.lat.description),
            URLQueryItem(name: "longitude", value: self.long.description),
        ]
        guard let url = components.url else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "Get"
        DispatchQueue.main.async {
            self.isAPICall = true
        }
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _,
            error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isAPICall = false
                guard let data = data, error == nil else {
                    return
                }
                do {
                    self.bussinessResult = try JSONDecoder().decode(BusinessModel.self, from: data)
                }
                catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    func fetchGeoLocationSeachResult(location:String,complitionHandler:@escaping (GeoLocationModel)->Void){
        var components = URLComponents()
        components.scheme = GGWebKey.componentsScheme
        components.host = GGWebKey.componentsHost
        components.path = "/getgeo"
    
        var queryItems:[URLQueryItem] = []
        if location.count > 0{
            queryItems.append(URLQueryItem(name: "val", value: location))
        }else{
            return
        }
        components.queryItems = queryItems
        guard let url = components.url else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "Get"
        DispatchQueue.main.async {
            self.isKeywardAPICall = true
        }
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _,
            error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isKeywardAPICall = false
            }
            guard let data = data, error == nil else {
                return
            }
            do {
                let t = try JSONDecoder().decode(GeoLocationModel.self, from: data)
                complitionHandler(t)
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
}
