//
//  LandingView.swift
//  MyFoodies
//
//  Created by Aroshini Dissanayake on 2023-06-15.
//


import SwiftUI

struct BusinessView: View {
    @ObservedObject var mapController: MapController
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(mapController.selectedBusinessName)
                        .font(.title)
                    
                    Text(mapController.selectedBusinessPlacemark)
                }
                Spacer()
                
                Button {
                    mapController.isBusinessViewShowing.toggle()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
            HStack {
                ForEach(mapController.actions) { action in
                    Button {
                        action.handler()
                    } label: {
                        VStack {
                            Image(systemName:  action.image)
                            Text(action.title)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding()
    }
}

struct BusinessView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessView(mapController: MapController())
            .previewLayout(.sizeThatFits)
    }
}
