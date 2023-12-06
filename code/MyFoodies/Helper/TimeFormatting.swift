//
//  TimeFormatting.swift
//  MyFoodies
//
//  Created by Aroshini Dissanayake on 2023-06-16.
//

import Foundation

func formatDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.mm.dd"
    let formattedDate = dateFormatter.string(from: date)
    return formattedDate

}
