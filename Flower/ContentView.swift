//
//  ContentView.swift
//  Flower
//
//  Created by Cilia Ence on 2023-01-25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import GoogleMaps

//first comment

struct ContentView: View {
    
   // @StateObject var stores = Stores()
    @State private var searchText = ""
   
    @ObservedObject var userManager = UserManager()
    @ObservedObject var firestoreManager = FirestoreManager()
    
    var searchResults: [Store] {
        if searchText.isEmpty {
            return firestoreManager.stores.list
        } else {
            return firestoreManager.stores.list.filter { $0.name.contains(searchText) }
        }
    }
    
    var body: some View {
        TabView{
            //Home page
            NavigationStack{
                List {
                    ForEach(searchResults, id: \.self) { store in
                        
                        NavigationLink(destination: StoreView(store: store, userManager: userManager)){
                            RowView(store: store)
                            
                        }
                    }
                }
                .frame(width: 420)
            }
            
            .searchable(text: $searchText)
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .onAppear(){
                firestoreManager.listenToFirestore()
                userManager.getUser()
                
            }
            //Search page
            NavigationStack {
                if (searchText != ""){
                    List {
                        ForEach(searchResults, id: \.self) { store in
                            
                            NavigationLink(destination: StoreView(store: store, userManager: userManager)){
                                RowView(store: store)
                            }
                        }
                    }
                } else {
                    SearchView(userManager: userManager)
                }
            }
            .searchable(text: $searchText)
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            .onAppear(){
                firestoreManager.listenToFirestore()
            }
            //shopping cart page
            NavigationStack{
                Text("Your cart is empty!")
                
                
                if let user = userManager.user {
                    if let order = user.activeOrder {
                        
                        List {
                            ForEach(order.bouquets) { bouquet in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(bouquet.name)
                                        Text("\(bouquet.price)kr")
                                    }
                                    Spacer()
                                    
                                }
                            }
                        }
                        Button(action: {
                            let date = Date()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd/MM/yyyy"
                            let dateString = dateFormatter.string(from: date)
                            order.date = dateString
                            user.orders.append(order)
                            user.activeOrder = nil
                            userManager.saveUserToFirestore()
                        }) {
                            Text("Buy")
                        }
                    }
                }
              
            }
            .tabItem {
                Image(systemName: "bag.fill")
                Text("Cart")
            }
            .onAppear(){
                userManager.getUser()
                
            }
         
            //Account page
            NavigationStack{
                if userManager.user != nil {
                    AccountView(userManager: userManager)
                } else {
                    SignInView(userManager: userManager)
                }
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Account")
            }
            
            .onAppear(){
                userManager.getUser()
            }
        }
    }
     
}

struct SignUpView : View {
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var number: String = ""
    @State private var password: String = ""
    @State var signIn = false
    @ObservedObject var userManager: UserManager
   // @State var user : User?
    
    
    var body: some View {
        
        if userManager.user != nil {
            AccountView(userManager: userManager)
        } else if signIn {
            SignInView(userManager: userManager)
        } else{
            VStack {
                Spacer()
                TextField("Username", text: $name)
                    .padding()
                    .padding(.leading, 50)
                    .padding(.bottom, 20)
                TextField("Phone number", text: $number)
                    .padding()
                    .padding(.leading, 50)
                    .padding(.bottom, 20)
                TextField("Email", text: $email)
                    .padding()
                    .padding(.leading, 50)
                    .padding(.bottom, 20)
                SecureField("Password", text: $password)
                    .padding()
                    .padding(.leading, 50)
                    .padding(.bottom, 20)
                Button(action: signUp) {
                    Text("SIGN UP")
                }
                .buttonStyle(.bordered)
                .tint(.accentColor)
                .font(.system(size: 20))
                .foregroundColor(.blue)
                .padding()
                Text("Already have an account, Log in")
                .onTapGesture {
                    signIn = true
                }
                Spacer()
            }
        }
    }
    
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error signing up \(error)")
            } else {
                let newUser = User(name: self.name, phoneNumber: self.number, email: self.email)
                print("Sign up succesful")
                let userData = try! JSONEncoder().encode(newUser)
                let userDictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(result!.user.uid)
                userRef.setData(userDictionary) { (error) in
                    if let error = error {
                        print("Error saving  \(error)")
                    } else {
                        userManager.user = newUser
                        print("Saving user to db successful")
                    }
                }
            }
        }
    }
}

struct SignInView : View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State var loggedIn = false
    @State var signUp = false
    @ObservedObject var userManager: UserManager
    
    var body: some View {
        if loggedIn {
            AccountView(userManager: userManager)
        }
        else if signUp {
            SignUpView(userManager: userManager)
        }
            else {
            VStack {
                Spacer()
                TextField("Email", text: $email)
                    .padding()
                    .padding(.leading, 50)
                    .padding(.bottom, 20)
                
                SecureField("Password", text: $password)
                    .padding()
                    .padding(.leading, 50)
                    .padding(.bottom, 20)
                
                Button(action: login) {
                    Text("Login")
                }
                .buttonStyle(.bordered)
                .tint(.accentColor)
                .font(.system(size: 20))
                .foregroundColor(.blue)
                .padding()
                    Text("Create an account")
                    .onTapGesture {
                        signUp = true
                    }
                Spacer()
                
            }
        }
       }
    func login() {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    print("Error logging in \(error)")
                } else {
                    // Login successful
                    userManager.getUser()
                    loggedIn = true
                }
            }
        }
    
}

struct AccountView : View {
    @ObservedObject var userManager: UserManager
    
    
    var body: some View {
        VStack{
            if userManager.user == nil {
                SignInView(userManager: userManager)
            } else{
                
                Text(userManager.user!.name)
                        .font(.system(size: 36))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                Text(userManager.user!.phoneNumber)
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        .padding()
                    
                NavigationLink(destination: OrderListView(userManager: userManager)){
                    ItemView(img: "list.bullet.clipboard", text: "Beställningar")
                }
                    
                    ItemView(img: "dollarsign.square", text: "Betalning")
                    ItemView(img: "megaphone", text: "Kampanjer")
                    ItemView(img: "questionmark.circle", text: "Hjälp")
                    ItemView(img: "gearshape", text: "Inställningar")
                    Spacer()
                    Button(action: {
                        userManager.signOut()
                        print("sign out succeed")
                    }) { Text("Sign out")}
                
            }
            
        }
        Spacer()
    }
}

struct OrderListView : View {
    
    @ObservedObject var userManager: UserManager
    
    var body: some View {
        Text("Orderhistorik")
            .font(.system(size: 20))
        List{
            if let user = userManager.user {
                ForEach (user.orders) { order in
                    NavigationLink(destination: OrderView(userManager: userManager, order: order)){
                        Text(order.date)
                    }
                }
            }
        }
        .onAppear(){
            userManager.getUser()
        }
    }
}

struct OrderView : View {
    
    @ObservedObject var userManager: UserManager
    let order : Order
    
    var body: some View {
        
        List {
            ForEach (order.bouquets) { bouq in
                
                    HStack{
                        Text(bouq.name)
                        Spacer()
                        Text("\(bouq.price)")
                    }
            }
        }
    }
}


struct ItemView : View {
    
    let img : String
    let text : String
    
    var body: some View {
        HStack{
            Image(systemName: img)
                .font(.system(size: 20))
            Text(text)
                .font(.system(size: 20))
            Spacer()
        }
        .padding()
    }
}



struct StoreView : View {
    
    let store : Store
    @ObservedObject var userManager: UserManager
    
    var body: some View{
        VStack{
            Image(store.image)
                .resizable()
                .frame(width: 400, height: 240)
            HStack {
                Text(store.name)
                Text("\(store.deliveryFee)kr - " + store.deliveryTime)
            }
            NavigationLink(destination: MapView(store: store)) {
                                Text("Visa på kartan")
                            }

            List(store.bouquets) { bouq in
                BouquetView(userManager: userManager, bouq: bouq, store: store)
            }
        }
    }
}

import MapKit

struct MapView : View {
    
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var firestoreManager = FirestoreManager()
    
  //  @StateObject var stores = Stores()
    
    let store : Store
    
    @State var region = MKCoordinateRegion()
    @State private var userTrackingMode = MapUserTrackingMode.none
   
    var body : some View {
        VStack{
            
            Map(coordinateRegion: $region,
                interactionModes: [.all],
                showsUserLocation: true,
                userTrackingMode: $userTrackingMode,
                annotationItems: firestoreManager.stores.list) { store in
                
                MapAnnotation(coordinate: store.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                    MapPinView(store: store)
                }
            }
             .tint(Color(.systemBlue))
        }
        .onAppear() {
            firestoreManager.listenToFirestore()
            userTrackingMode = .none
            locationManager.requestLocationPermission()
            setRegion(store: store)
        }
        .overlay(
                        Button(action: {
                            userTrackingMode = .follow
                        }) {
                            Image(systemName: "location")
                                .font(.title)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        .padding(.trailing)
                        .padding(.bottom, 40),
                        alignment: .bottomTrailing
                    )
            
    }
    
    func setRegion(store: Store) {
        region = MKCoordinateRegion(center: store.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        print("hejhopp")
    }
}

struct MapPinView: View {
    
    var store : Store
    var body: some View {
        VStack {
            Text(store.name)
                .font(.callout)
                        .padding(5)
                        .background(Color(.white))
                        .cornerRadius(10)
            Image(systemName: "mappin.circle.fill")
                    .font(.title)
                    .foregroundColor(.red)
                  
                  Image(systemName: "arrowtriangle.down.fill")
                    .font(.caption)
                    .foregroundColor(.red)
                    .offset(x: 0, y: -5)
            
        }
    }
}

struct RowView: View {
    let store: Store
    
    var body: some View {
        VStack{
            Image(store.image)
                .resizable()
                .frame(width: 397, height: 160)
            
                Text(store.name)
                Text("\(store.deliveryFee)kr - " + store.deliveryTime)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
        }
    }
}

struct BouquetView: View {

    @ObservedObject var userManager: UserManager
  
    let bouq : Bouquet
    let store : Store
    
    
    var body: some View {
        HStack{
            VStack{
                Text(bouq.name)
                Text("\(bouq.price)")
            }
            Spacer()
            VStack{
                Image(bouq.image)
                    .resizable()
                    .frame(width: 80, height: 80)
                Button(action: {
                    
                    if let user = userManager.user{
                        
                        if let order = user.activeOrder {
                            order.addBouquet(bouq)
                            print("adding bouq to existing order")
                        }
                            else {
                                //create new order and add bouquet and add order to user
                                let newOrder = Order(storeName: store.name, bouquets: [], date: "")
                                newOrder.addBouquet(bouq)
                                user.activeOrder = newOrder
                                print("creating new order")
                                
                            }
                        userManager.saveUserToFirestore()
                    }
                    
                }) { Text("Buy")}
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SearchView: View {
    
    let userManager : UserManager
    
    var body: some View {
        VStack{
            HStack{
                FastSearchView(colour: "offers", img: "percent", text: "Kampanjer")
                FastSearchView(colour: "near", img: "mappin.and.ellipse", text: "Nära mig")
            }
            HStack{
                FastSearchView(colour: "fast", img: "box.truck.badge.clock", text: "Snabb leverans")
               
                FastSearchView(colour: "best", img: "medal", text: "Bäst omdömen")
            }
            Text("Mina beställningar")
                .font(.system (size: 20))
            List{
                if let user = userManager.user {
                    ForEach(user.orders) { order in
                        Text(order.storeName)
                       
                    }

                }
            }
            Spacer()
        }
    }
}

struct FastSearchView: View {
    
    let colour : String
    let img : String
    let text : String
    
    var body: some View {
        ZStack{
            Image(colour)
                .resizable()
                .frame(width: 180, height: 160)
                .cornerRadius(10)
            VStack{
                Image(systemName: img)
                    .resizable()
                    .frame(width: 50, height: 48)
                Text(text)
                    .font(.system (size: 20))
                
            }
        }
    }
}
