import SwiftUI
import Kingfisher

struct ContentView: View {
    @State var showsAlwaysPopover = false
    @ObservedObject var keywordSearchVM = KeywordSearchViewModel()
    @StateObject var locationManager = LocationManager()
    @ObservedObject var reservation = ReservationViewModel()
    @State var keyword : String = ""
    @State var distance : String = ""
    var category = ["Default", "Arts and Entertainment", "Health and Medical", "Hotels and Travel", "Food", "Professional Services"]
    @State var selectedCategory = "Default"
    @State var location : String = ""
    @State var auto_detect: Bool = false
    static let long: NSNumber = 0.0
    
    var disabledForm : Bool{
        keyword.isEmpty || distance.isEmpty || (location.isEmpty && !auto_detect)
    }
    
    var body: some View {
        
        NavigationView {
            List {
                Section {
                    TextField("Keyword:", text: $keyword)
                        .onSubmit {
                            if keyword.count > 0{
                                self.showsAlwaysPopover = true
                                self.keywordSearchVM.fetchSeachResult(keyword: keyword)
                            }
                        }
                        .alwaysPopover(isPresented: $showsAlwaysPopover) {
                            VStack{
                                if self.keywordSearchVM.isKeywardAPICall{
                                    ProgressView {
                                        HStack{
                                            Spacer()
                                            Text("loading....")
                                                .foregroundColor(.gray)
                                            Spacer()
                                        }
                                    }
                                    .frame(width: 200)
                                }
                                ForEach(self.keywordSearchVM.searchResult?.categories ?? [],id: \.title) { result in
                                    Text(result.title ?? "")
                                                .onTapGesture {
                                                    self.showsAlwaysPopover = false
                                                    self.keyword = result.title ?? ""
                                                }
                                }
                                ForEach(self.keywordSearchVM.searchResult?.terms ?? [],id: \.text) { result in
                                    Text(result.text ?? "")
                                                .onTapGesture {
                                                    self.showsAlwaysPopover = false
                                                    self.keyword = result.text ?? ""
                                                }
                                }
                            }.padding()
                        }
                    TextField("Distance", text: $distance)
                        .keyboardType(.numberPad)
                    VStack {
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(category, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    if !auto_detect{
                        TextField("Location", text: $location)
                    }
                    Toggle(isOn: $auto_detect) {
                        Text("Auto-detect my location")
                    }
                    HStack {
                        Button(action: {
                            self.keywordSearchVM.keyward = keyword
                            self.keywordSearchVM.category = self.selectedCategory
                            if self.auto_detect{
                                self.locationManager.updateLocation(complitionHandler: { (result) in
                                    switch result{
                                    case .success(let t):
                                        self.keywordSearchVM.location = self.location
                                        self.keywordSearchVM.lat = t.coordinate.latitude
                                        self.keywordSearchVM.long = t.coordinate.longitude
                                        self.keywordSearchVM.fetchSummuryResult()
                                        break
                                    case .failer( _ ):
                                        break
                                    }
                                })
                            }else{
                                self.keywordSearchVM.fetchGeoLocationSeachResult(location: self.location) { location in
                                    if let location = location.results?.first{
                                        self.keywordSearchVM.location = self.location
                                        self.keywordSearchVM.lat = (location.geometry?.location?.lat ?? 0.0)
                                        self.keywordSearchVM.long = (location.geometry?.location?.lng ?? 0.0)
                                    }
                                    self.keywordSearchVM.fetchSummuryResult()
                                }
                            }
                        }){
                            Text("Submit")
                                .bold()
                                .font(Font.custom("Helvetica Neue", size: 15.0))
                                .padding(15)
                                .padding(.horizontal,20)
                                .foregroundColor(Color.white)
                                .background(disabledForm ? Color.gray : Color.red)
                                .cornerRadius(12)
                        }
                        .disabled(disabledForm)
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                        Button(action: {
                            self.keywordSearchVM.searchResult = nil
                            self.keywordSearchVM.bussinessResult = nil
                            keyword = "";
                            distance = "";
                            selectedCategory = "Default"
                            location = ""
                            auto_detect = false;
                        }){
                            Text("Clear")
                                .bold()
                                .font(Font.custom("Helvetica Neue", size: 15.0))
                                .padding(15)
                                .padding(.horizontal,20)
                                .foregroundColor(Color.white)
                                .background(Color.blue)
                                .cornerRadius(12)
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
                
                Section{
                    Text("Results")
                        .font(.title)
                        .bold()
                    if self.keywordSearchVM.isAPICall{
                        ProgressView {
                            HStack{
                                Spacer()
                                Text("Please wait....")
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                        }
                    }
                    if  ((self.keywordSearchVM.bussinessResult?.businesses ?? []).count == 0){
                        if self.keywordSearchVM.bussinessResult?.businesses != nil{
                            Text("No Result Available")
                                .foregroundColor(.red)
                        }
                    }else{
                        ForEach(self.keywordSearchVM.bussinessResult?.businesses ?? [], id: \.id) { item in
                            NavigationLink {
                                BusinessDetailsTabView()
                                    .environmentObject(item)
                                    .environmentObject(self.reservation)
                            } label: {
                                BusinessRowView(bussines: item)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Business Search")
            .toolbar{
                Button(action: {}, label: {
                    NavigationLink(destination: ReservationView().environmentObject(self.reservation)) {
                        Label("my_reservations", systemImage:  "calendar.badge.plus")
                    }
                 })
            }
            .onAppear{
                self.reservation.getAllReservationList()
            }
        }.navigationViewStyle(.stack)
    }
}
struct BusinessRowView: View {
    let bussines:Business
    var body: some View {
        HStack {
            KFImage(URL(string: bussines.imageURL ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .cornerRadius(5)
            Text(bussines.name ?? "")
            Spacer()
            Text((bussines.rating ?? 0.0).description)
                .bold()
                .padding(.trailing,10)
            Text(String(format: "%.2f",(bussines.distance ?? 0.0)/1000))
                .bold()
        }
    }
}

struct PopoverContent: View {
    var body: some View {
        Text("This should be presented\nin a popover.")
            .font(.subheadline)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


