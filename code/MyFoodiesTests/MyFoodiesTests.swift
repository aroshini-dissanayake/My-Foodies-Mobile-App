//
//  MyFoodiesTests.swift
//  MyFoodiesTests
//
//  Created by Aroshini Dissanayake on 2023-06-15.
//

import XCTest
import CoreData
@testable import MyFoodies

final class MyFoodiesTests: XCTestCase {
    
    var dataController: DataController!
       var context: NSManagedObjectContext!
       
       override func setUp() {
           super.setUp()
           
           dataController = DataController()
           context = dataController.container.viewContext
       }
       
       override func tearDown() {
           super.tearDown()
           
           // Clean up the Core Data objects
           let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Food")
           let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
           
           do {
               try context.execute(deleteRequest)
               try context.save()
           } catch {
               print("Failed to delete test data: \(error)")
           }
           
           dataController = nil
           context = nil
       }

    func testAddFood() {
        // Given
               let foodName = "Pizza"
               let restaurant = "Italian Pizzeria"
               let place = "New York"
               let category = "Italian"
               let rating = 4.5
               
               // When
               dataController.addFood(name: foodName, restaurant: restaurant, place: place, category: category, rating: rating, context: context)
               
               // Then
               let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
               
               do {
                   let foods = try context.fetch(fetchRequest)
                   
                   XCTAssertEqual(foods.count, 1)
                   
                   let food = foods.first
                   
                   XCTAssertEqual(food?.name, foodName)
                   XCTAssertEqual(food?.restaurant, restaurant)
                   XCTAssertEqual(food?.place, place)
                   XCTAssertEqual(food?.category, category)
                   XCTAssertEqual(food?.rating, rating)
                   
               } catch {
                   XCTFail("Failed to fetch food: \(error)")
               }
    }

    func testEditFood() {
        // Given
        let foodName = "Burger"
        let restaurant = "Fast Food Joint"
        let place = "Chicago"
        let category = "American"
        let rating = 4.0
        
        let food = Food(context: context)
        food.name = "Pizza"
        food.id = UUID()
        food.place = "New York"
        food.category = "Italian"
        food.restaurant = "Italian Pizzeria"
        food.date = Date()
        food.rating = 4.5
        
        try? context.save()
        
        // When
        dataController.editFood(food: food, name: foodName, restaurant: restaurant, place: place, category: category, rating: rating, context: context)
        
        // Then
        XCTAssertEqual(food.name, foodName)
        XCTAssertEqual(food.restaurant, restaurant)
        XCTAssertEqual(food.place, place)
        XCTAssertEqual(food.category, category)
        XCTAssertEqual(food.rating, rating)
    }

}
