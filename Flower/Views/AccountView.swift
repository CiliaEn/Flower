//
//  AccountView.swift
//  Flower
//
//  Created by Cilia Ence on 2023-02-17.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AccountView: View {
    @ObservedObject var userManager: UserManager
    
    var body: some View {
        VStack {
            if userManager.user == nil {
                SignInView(userManager: userManager)
            } else {
                Text(userManager.user!.name)
                    .font(.system(size: 36, weight: .bold))
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
                }) { Text("Sign out") }
                    .font(.system(size: 20, weight: .bold))
            }
        }
        .font(.custom("Avenir", size: 18))
        Spacer()
    }
}


struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State var loggedIn = false
    @State var signUp = false
    @ObservedObject var userManager: UserManager
    
    var body: some View {
        if loggedIn {
            AccountView(userManager: userManager)
        } else if signUp {
            SignUpView(userManager: userManager)
        } else {
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
                    Text("LOG IN")
                }
                .buttonStyle(.bordered)
                .tint(.accentColor)
                .font(.custom("Avenir-bold", size: 20))
                .foregroundColor(.blue)
                .padding()
                
                Text("Create an account")
                    .onTapGesture {
                        signUp = true
                    }
                Spacer()
            }
            .font(.custom("Avenir", size: 18))
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

struct SignUpView : View {
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var number: String = ""
    @State private var password: String = ""
    @State var signIn = false
    @ObservedObject var userManager: UserManager
    
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
                        .font(.custom("Avenir-bold", size: 20))
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
struct OrderListView : View {
    
    @ObservedObject var userManager: UserManager
    
    var body: some View {
        Text("Orderhistorik")
            .font(.custom("Avenir", size: 20))
        List{
            if let user = userManager.user {
                ForEach (user.orders) { order in
                    NavigationLink(destination: OrderView(userManager: userManager, order: order)){
                        Text(order.storeName)
                            .font(.custom("Avenir", size: 16))
                        Spacer()
                        Text(order.date)
                            .font(.custom("Avenir", size: 16))
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
                        .font(.custom("Avenir", size: 16))
                    Spacer()
                    Text("\(bouq.price)")
                        .font(.custom("Avenir", size: 16))
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
                .font(.custom("Avenir", size: 20))
            Spacer()
        }
        .padding()
    }
}

