import SwiftUI
import PhotosUI

struct EditFoodView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss

    var food: Food // Existing Food object
    let categories = ["Traditional","Chinese", "Italian", "Indian","Other"]

    @State private var name: String
    @State private var place: String
    @State private var category: String
    @State private var restaurant: String
    @State private var rating : Double
    @State private var selectedimage: Data
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedDate = Date()
    
    // Initialize the state variables with the values from the existing Food object
    init(food: Food) {
        self.food = food
        _name = State(initialValue: food.name ?? "")
        _place = State(initialValue: food.place ?? "")
        _restaurant = State(initialValue: food.restaurant ?? "")
        _category = State(initialValue: food.category ?? "")
        _selectedDate = State(initialValue: food.date ?? Date())
        _rating = State(initialValue: food.rating)
        _selectedimage = State(initialValue: food.selectedimage ?? Data(count: 0))
    }

    var body: some View {
        HStack{
                            Text("Edit Information")
                                .font(.title.bold())
                        }
        Form {
            Section {
                TextField("Food Name", text: $name)
            }
                Section {
                TextField("Place", text: $place)
                }
                    Section {
                TextField("Restaurant", text: $restaurant)
                    }
                        Section {
                HStack{
                    Text("Rating: \(Int(rating))")
                    Slider(value: $rating, in: 0...5, step: 1)
                }
                .padding()
                        }
                            Section {

                // Date picker
                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                            }
                                Section {
                HStack {
                    Spacer()
                    //MARK: PhotoPicker
                    PhotosPicker(selection: $selectedItems,
                                 maxSelectionCount: 1,
                                 matching: .images) {
                        if !selectedimage.isEmpty, let uiImage = UIImage(data: selectedimage) {
                            Image(uiImage: uiImage)
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 200, height: 200)
                                .cornerRadius(8)
                                .shadow(radius: 5)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                                .shadow(radius: 5)
                                .foregroundColor(.gray)
                        }
                    }//MARK: PhotoPicker
                    Spacer()
                }//MARK: HStack
                    .onChange(of: selectedItems) { new in
                        guard let items = selectedItems.first else { return }

                        items.loadTransferable(type: Data.self) { result in
                            switch result {
                            case .success(let data):
                                if let data = data {
                                    self.selectedimage = data
                                } else {
                                    print("No data :(")
                                }
                            case .failure(let error):
                                fatalError("\(error)")
                            }
                        }//MARK: loadTransferable
                    }//MARK: onChange
                                }
                                    Section {
                //type picker
                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                    }
                }
            }
        
            Section {
                HStack {
                    Button(action: {
                        // Update the existing Food object instead of creating a new one
                        food.name = name
                        food.date = selectedDate
                        food.place = place
                        food.restaurant = restaurant
                        food.category = category
                        food.rating = rating
                        food.selectedimage = selectedimage
                        
                        // Save the changes
                        try! managedObjContext.save()
                        
                        dismiss()
                    }) {
                        Text("Modify")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(name.count > 2 && place.count > 2 && !selectedimage.isEmpty ? false : true)
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding(.top, 16) // Add top padding to the form
        .padding(.horizontal) // Add horizontal padding to the form
    }
}
