//
//  yelpbusinesses.swift
//  IOSHW9
//
//  Created by yuhao on 11/20/22.
//

import SwiftUI


//FruitModel object includes below variables
struct FruitModel: Identifiable{
    let id: String = UUID().uuidString
    let name: String
    let count: Int
    
}

class FruitViewModel: ObservableObject {
    //fruitArray is made up of FruitModel objects
    @ Published var fruitArray: [FruitModel] = []
    func getFruits(){
        // fruit object 1,2,3
        let fruit1 = FruitModel(name: "A", count: 3)
        let fruit2 = FruitModel(name: "B", count: 3)
        let fruit3 = FruitModel(name: "C", count: 3)
        // append fruit object to the fruit array
        fruitArray.append(fruit1)
        fruitArray.append(fruit2)
        fruitArray.append(fruit3)
    }

    
}

struct yelpbusinesses: View {
    
    //initiate an var called fruitViewModel and type FruitViewModel array
    @ObservedObject var fruitViewModel: FruitViewModel = FruitViewModel()
    
    var body: some View {
        NavigationView{
            List{
                //for each fruitArray object in fruitViewModel array
                ForEach(fruitViewModel.fruitArray) { fruit in
                    HStack{
                        
                        Text("\(fruit.count)")
                        Text(fruit.name)
                    }
                }
            }
        }
        .navigationTitle("Fruit list")
        .onAppear{
            //fruitViewModel object method getFruits which append three FruitModel objects into the array. 
            fruitViewModel.getFruits()
        }
    }
}

struct yelpbusinesses_Previews: PreviewProvider {
    static var previews: some View {
        yelpbusinesses()
    }
}
