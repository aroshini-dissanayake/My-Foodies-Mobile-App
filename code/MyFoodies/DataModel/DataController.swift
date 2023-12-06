//
//  DataController.swift
//  MyFoodies
//
//  Created by Aroshini Dissanayake on 2023-06-15.
//

import Foundation
import CoreData

class DataController : ObservableObject {
    let container = NSPersistentContainer(name: "FoodModel")
    
    init() {
        container.loadPersistentStores {
            desc, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved")
        }catch {
            print("Failed to saved")
        }
    }
    func addFood(name:String,restaurant: String, place:String, category:String,rating:Double, context:NSManagedObjectContext){
        let food = Food(context: context)
        food.name = name
        food.id = UUID()
        food.place = place
        food.category = category
        food.restaurant = restaurant
        food.date = Date()
        food.rating = rating
        save(context: context)
    }
    
    func editFood(food: Food, name:String,restaurant: String, place:String, category:String,rating:Double, context:NSManagedObjectContext){
        food.date = Date()
        food.name = name
        food.place = place
        food.restaurant = restaurant
        food.category = category
        food.rating = rating
        save(context: context)
    }
}
