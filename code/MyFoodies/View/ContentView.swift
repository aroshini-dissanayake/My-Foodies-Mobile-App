//
//  ContentView.swift
//  MyFoodies
//
//  Created by Aroshini Dissanayake on 2023-06-15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            HomeView()
                .tabItem{
                    Image(systemName: "house")
//                        Text("Home")
                }
            MapPresentView()
                .tabItem{
                    Image(systemName: "map")
//                        Text("Doctor")
                }
            AddFoodView()
                .tabItem {
                    Image (systemName : "plus.circle")
//                        Text("Order")
                }
            ProfileView()
                .tabItem{
                    Image(systemName: "person")
//                        Text("Profile")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
