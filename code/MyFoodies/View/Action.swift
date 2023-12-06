//
//  Action.swift
//  MyFoodies
//
//  Created by Aroshini Dissanayake on 2023-06-15.
//

import Foundation

struct Action : Identifiable {
    let id = UUID()
    let title: String
    let image: String
    let handler: ()-> Void
}
