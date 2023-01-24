//
//  reservation_form.swift
//  IOSHW9
//
//  Created by yuhao on 11/16/22.
//

import SwiftUI

struct Pre_ReservationForm: View {
    @State private var showingSheet = false
    
    var body: some View {
        Button("Show Sheet") {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            ReservationForm()
                .foregroundColor(.gray)
        }
    }
}

struct ReservationForm: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingEmailAlert = false
    @State private var email = ""
    @State private var date = Date()
    @EnvironmentObject private var bussines: Business
    @EnvironmentObject private var reservation:ReservationViewModel
    @State private var showingSuccess = false
    @State private var Hours = "10"
    @State private var Minits = "00"
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .year, value: 10, to: Date()) ?? Date()
        return Date()...endDate
    }()
    var body: some View {
        ZStack{
            Form{
                Section{
                    Text("Reservation Form")
                        .foregroundColor(.black)
                        .font(.title)
                        .bold()
                }
                Section{
                    Text(self.bussines.name ?? "")
                        .foregroundColor(.black)
                        .font(.title)
                        .bold()
                }
                Section{
                    HStack {
                        Text("Email:")
                            .foregroundColor(.black)
                        TextField("Email", text: $email)
                            .foregroundColor(.black)
                    }
                    HStack {
                        DatePicker(selection: $date,in:dateRange, displayedComponents: [.date], label: {
                            Text("Date/Time:")
                                .foregroundColor(.black)
                        })
                        HStack{
                            Picker(Hours, selection: $Hours) {
                                ForEach(["10","11","12","13","14","15","16","17"], id: \.self) {
                                    Text($0)
                                }
                            }
                            .padding(0)
                            Text(":")
                                .padding(0)
                            Picker(Minits, selection: $Minits) {
                                ForEach(["00","15","30","45"], id: \.self) {
                                    Text($0)
                                }
                            }
                            .padding(0)
                        }.frame(width: 120)
                        .foregroundColor(.black)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(8)
                        .labelsHidden()
                    }
                    HStack {
                        Spacer()
                        Button {
                            if !self.isValidEmailAddress(emailAddressString: email){
                                showingEmailAlert = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showingEmailAlert = false
                                }
                            }else{
                                self.reservation.addNewReservation(id: self.bussines.id ?? "", name: self.bussines.name ?? "", date: self.date, time: "\(Hours):\(Minits)", email: self.email)
                                self.showingSuccess = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    self.showingSuccess = false
                                    self.dismiss()
                                }
                            }
                        } label: {
                            Text("  Submit ")
                                .multilineTextAlignment(.leading)
                                .font(Font.custom("Helvetica Neue", size: 15.0))
                                .padding(15)
                                .foregroundColor(Color.white)
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                    }
                }
                
            }
            if showingSuccess{
                ZStack{
                    Color.green
                        .ignoresSafeArea()
                    VStack(alignment: .center, spacing:30){
                        Spacer()
                        Text("Congratulations!")
                            .bold()
                        Text("You have successfully made an reservation at \(self.bussines.name ?? "")")
                            .multilineTextAlignment(.center)
                        Spacer()
                        Button(action: {
                            self.dismiss()
                        }){
                            Text("Done")
                                .bold()
                                .font(Font.custom("Helvetica Neue", size: 15.0))
                                .padding(15)
                                .padding(.horizontal,20)
                                .foregroundColor(Color.green)
                                .background(Color.white)
                                .cornerRadius(12)
                        }.buttonStyle(PlainButtonStyle())
                    }
                    .padding(20)
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear{
            UIDatePicker.appearance().minuteInterval = 15
        }
        .toast(isShowing: $showingEmailAlert, text: Text("Please enter a valid email."))
    }
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
}

struct ReservationForm_Previews: PreviewProvider {
    static var previews: some View {
        Pre_ReservationForm()
    }
}
