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

//first comment

struct ContentView: View {
    
    @StateObject var stores = Stores()
    @State private var searchText = ""
    
    
    var searchResults: [Store] {
        if searchText.isEmpty {
            return stores.list
        } else {
            return stores.list.filter { $0.name.contains(searchText) }
        }
    }
    
    var body: some View {
        TabView{
            NavigationStack{
                List {
                    ForEach(searchResults, id: \.self) { store in
                        
                        NavigationLink(destination: StoreView(store: store)){
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
                listenToFirestore()
            }
            NavigationStack {
                if (searchText != ""){
                    List {
                        ForEach(searchResults, id: \.self) { store in
                            
                            NavigationLink(destination: StoreView(store: store)){
                                RowView(store: store)
                            }
                        }
                    }
                }
                SearchView()
            }
            .searchable(text: $searchText)
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            .onAppear(){
                listenToFirestore()
            }
            
            Text("shopping cart")
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text("Cart")
                }
            
            NavigationStack{
                //SignUpView()
                SignInView()
                
            }
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Account")
                }
        }
    }
    
    
    
    func saveToFirestore (_ storeName : String, _ fee: Int, _ time : String, _ img: String, _ bouquets: [Bouquet]) {
        let db = Firestore.firestore()
        let store = Store(name: storeName, deliveryFee: fee, deliveryTime: time, image: img, bouquets: bouquets )
        
        do {
            _ = try db.collection("stores").addDocument(from: store)
        }
        catch {
            print("Could not save to firestore")
        }
    }
    
    func listenToFirestore() {
        let db = Firestore.firestore()
        
        db.collection("stores").addSnapshotListener { snapshot, err in
            guard let snapshot = snapshot else{return}
            
            if let err = err {
                print("Error getting document \(err)")
            } else {
                stores.list.removeAll()
                for document in snapshot.documents {
                    
                    let result = Result {
                        try document.data(as: Store.self)
                    }
                    switch result {
                    case .success(let store) :
                        stores.list.append(store)
                    case .failure(let error) :
                        print ("Error decoding store: \(error)")
                    }
                }
            }
        }
    }
}

struct SignUpView : View {
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var number: String = ""
    @State private var password: String = ""
    @State var loggedIn = false
    @State var signIn = false
    @State private var user: User? = nil
    
    var body: some View {
        
        if loggedIn {
            AccountView()
        } else if signIn {
            SignInView()
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
                let user = User(name: self.name, phoneNumber: self.number, email: self.email)
                print("Sign up succesful")
                let userData = try! JSONEncoder().encode(user)
                let userDictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(result!.user.uid)
                userRef.setData(userDictionary) { (error) in
                    if let error = error {
                        print("Error saving  \(error)")
                    } else {
                        loggedIn = true
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
    @State private var user: User? = nil
    
    var body: some View {
        if loggedIn {
            AccountView()
        }
        else if signUp {
            SignUpView()
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
                    loggedIn = true
                }
            }
        }
}

struct AccountView : View {
    @State private var user: User? = nil
    @State var signedOut = false
    
    var body: some View {
        VStack{
            if signedOut {
                SignInView()
            } else{
                if let user = user {
                    Text(user.name)
                        .font(.system(size: 36))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    Text(user.phoneNumber)
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        .padding()
                    
                    
                    ItemView(img: "list.bullet.clipboard", text: "Beställningar")
                    ItemView(img: "dollarsign.square", text: "Betalning")
                    ItemView(img: "megaphone", text: "Kampanjer")
                    ItemView(img: "questionmark.circle", text: "Hjälp")
                    ItemView(img: "gearshape", text: "Inställningar")
                    Spacer()
                    Button(action: {
                        try! Auth.auth().signOut()
                        signedOut = true
                        print("sign out succeed")
                    }) { Text("Sign out")}
                }
            }
            
        }
        .onAppear() {
            getUser()
        }
        Spacer()
    }
    
    func getUser() {
            guard let user = Auth.auth().currentUser else { return }
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(user.uid)
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let name = document.get("name") as? String ?? ""
                    let email = document.get("email") as? String ?? ""
                    let phoneNumber = document.get("phoneNumber") as? String ?? ""
                    self.user = User(name: name, phoneNumber: phoneNumber, email: email)
                } else {
                    // Handle error
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
    
    var body: some View{
        VStack{
            Image(store.image)
                .resizable()
                .frame(width: 400, height: 240)
            Text(store.name)
            Text("\(store.deliveryFee)kr - " + store.deliveryTime)
            List(store.bouquets) { bouq in
                BouquetView(bouq: bouq)
            }
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
    let bouq : Bouquet
    
    var body: some View {
        HStack{
            VStack{
                Text(bouq.name)
                Text("\(bouq.price)")
            }
            Spacer()
            Image(bouq.image)
                .resizable()
                .frame(width: 80, height: 80)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

struct SearchView: View {
    var body: some View {
        VStack{
            HStack{
                ZStack{
                    Image("offers")
                        .resizable()
                        .frame(width: 180, height: 160)
                    VStack{
                        Image(systemName: "percent")
                            .resizable()
                            .frame(width: 50, height: 48)
                        
                        Text("Kampanjer")
                            .font(.system (size: 20))
                           
                    }
                }
                ZStack{
                    Image("near")
                        .resizable()
                        .frame(width: 180, height: 160)
                    VStack{
                        Image(systemName: "mappin.and.ellipse")
                            .resizable()
                            .frame(width: 50, height: 55)
                        
                        Text("Nära mig")
                            .font(.system (size: 20))
                           
                    }
                }
            }
            HStack{
                ZStack{
                    Image("fast")
                        .resizable()
                        .frame(width: 180, height: 160)
                    VStack{
                        Image(systemName: "box.truck.badge.clock")
                            .resizable()
                            .frame(width: 65, height: 50)
                        
                        Text("Snabb leverans")
                            .font(.system (size: 20))
                           
                    }
                }
                ZStack{
                    Image("best")
                        .resizable()
                        .frame(width: 180, height: 160)
                    VStack{
                        Image(systemName: "medal")
                            .resizable()
                            .frame(width: 50, height: 55)
                        
                        Text("Bäst omdömen")
                            .font(.system (size: 20))
                           
                    }
                }

            }
            Text("Mina beställningar")
                .font(.system (size: 20))
            
            Spacer()
        }
    }
}
