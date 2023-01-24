//
//  BussinesReviewView.swift
//  IOSHW9
//
//  Created by Gaurav Gudaliya on 25/11/22.
//

import SwiftUI

struct BussinesReviewView: View {
    @EnvironmentObject private var bussines: Business
    @ObservedObject var bussinesReview = BussinessReviewViewModel()
    var body: some View {
        VStack{
            if self.bussinesReview.isAPICall{
                ProgressView {
                    HStack{
                        Spacer()
                        Text("Please wait....")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
            }else{
                if self.bussinesReview.bussinessReview?.reviews == nil{
                    Text("There is no any review.")
                        .foregroundColor(.gray)
                }else{
                    List(bussinesReview.bussinessReview?.reviews ?? [],id: \.id){ review in
                        BusinessReviewView(review:review)
                    }
                }
            }
        }
        
        .onAppear{
            self.bussinesReview.fetchBussinessReview(id:self.bussines.id ?? "")
        }
    }
}
struct BusinessReviewView: View {
    let review:Review
    var body: some View {
        VStack(spacing:10) {
            
            HStack{
                Text(review.user?.name ?? "")
                    .bold()
                Spacer()
                Text((review.rating ?? 0).description+"/5")
                    .bold()
            }
            Text(review.text ?? "")
                .foregroundColor(.gray)
            Text(review.timeCreated ?? "")
        }
    }
}

struct BussinesReviewView_Previews: PreviewProvider {
    static var previews: some View {
        BussinesReviewView()
    }
}
