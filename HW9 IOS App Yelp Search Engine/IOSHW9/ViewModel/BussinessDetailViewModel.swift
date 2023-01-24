//
//  BussinessDetailViewModel.swift
//  IOSHW9
//
//  Created by Gaurav Gudaliya on 25/11/22.
//

import Foundation
class BussinessDetailViewModel: ObservableObject{
    @Published var bussines:BussinessDetailModel?
    @Published var isAPICall: Bool = false
    func fetchBussinessDetailResult(id:String){
        var components = URLComponents()
        components.scheme = GGWebKey.componentsScheme
        components.host = GGWebKey.componentsHost
        components.path = "/getdetails"
        
        components.queryItems = [
            URLQueryItem(name: "bus_id", value: id),
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
                    self.bussines = try JSONDecoder().decode(BussinessDetailModel.self, from: data)
                }
                catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
}
