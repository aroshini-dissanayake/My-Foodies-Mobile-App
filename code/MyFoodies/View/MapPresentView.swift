//
//  LandingView.swift
//  MyFoodies
//
//  Created by Aroshini Dissanayake on 2023-06-15.
//

import SwiftUI

//UI Structure
struct MapPresentView: View {

    //MARK: - Properties
    @StateObject var mapController = MapController()
        func onRun (searchKey: String) {
            mapController.searchTerm = searchKey
            mapController.search()
        }

    //MARK: - Body
    var body: some View {
        VStack {
          MapView(mapController: mapController)
        }
          .onAppear(){
            onRun(searchKey: "Restaurants")
        }
    }
}

 
//MARK: - Preview
struct MapPresentView_Previews: PreviewProvider {
    static var previews: some View {
        MapPresentView()
    }
}
