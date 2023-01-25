//
//  ContentView.swift
//  Flower
//
//  Created by Cilia Ence on 2023-01-25.
//

import SwiftUI

//first comment

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
