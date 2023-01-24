//
//  BussinessReviewViewModel.swift
//  IOSHW9
//
//  Created by Gaurav Gudaliya on 25/11/22.
//

import Foundation

class BussinessReviewViewModel: ObservableObject{
    @Published var bussinessReview:BussinessReviewModel?
    @Published var isAPICall: Bool = false
    func fetchBussinessReview(id:String){
        var components = URLComponents()
        components.scheme = GGWebKey.componentsScheme
        components.host = GGWebKey.componentsHost
        components.path = "/getreviews"
        
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
                do {
                    guard let self = self else { return }
                    self.isAPICall = false
                    guard let data = data, error == nil else {
                        return
                    }
                    self.bussinessReview = try JSONDecoder().decode(BussinessReviewModel.self, from: data)
                }
                catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
}
