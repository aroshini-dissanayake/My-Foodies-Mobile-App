import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) var managedObjContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Food.date, ascending: false)]) var food: FetchedResults<Food>

    @State private var showingAddView = false
    @State private var showingDeleteAlert = false
    @State private var showingMapView = false
    @State private var selectedimage: Data = .init(count: 0)
    @State private var deletionIndexSet: IndexSet?
    @State private var selectedCategory: String? // New state for selected category
    @State private var searchText = ""

    private var categories: [String] { // Sample categories
        ["All", "Traditional", "Italian", "Indian", "Chinese", "Other"]
    }
    
    private var categoryImages: [String: String] { // Define category images
        ["All": "all",
         "Traditional": "traditional",
         "Italian": "italian",
         "Indian": "indian",
         "Chinese": "chinese",
         "Other": "other"]
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                SearchBar(text: $searchText)
                    .padding(.horizontal, 16)
                Text("Featured") // Title for the advertisements section
                    .font(.title2)
                    .bold()
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        AdvertisementView(imageName: "ad1")
                        AdvertisementView(imageName: "ad2")
                        AdvertisementView(imageName: "ad3")
                        AdvertisementView(imageName: "ad4")
                    }
                    .padding(.horizontal, 16)
                }
                
                Text("Categories")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                VStack {
                                    Image(categoryImages[category] ?? "") // Use category image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(50)
                                    Text(category)
                                        .font(.headline)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .foregroundColor(category == selectedCategory ? .white : .primary)
                                        .background(category == selectedCategory ? Color.blue : Color.clear)
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }

                List {
                    ForEach(filteredFood) { food in // Use filteredFood based on selected category and search text
                        if searchText.isEmpty || food.name?.localizedCaseInsensitiveContains(searchText) ?? false {
                            NavigationLink(destination: SpecificFoodView(food: food)) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        if let imageData = food.selectedimage, let uiImage = UIImage(data: imageData) {
                                            Image(uiImage: uiImage)
                                                .renderingMode(.original)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(maxWidth: .infinity, maxHeight: 200)
                                                .cornerRadius(16)
                                                .shadow(radius: 6)
                                        }
                                        VStack(alignment: .leading, spacing: 4) {
                                            if let name = food.name {
                                                Text(name)
                                                    .font(.headline)
                                                    .foregroundColor(.primary)
                                            }
                                            if let restaurant = food.restaurant {
                                                Text(restaurant)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                            if let category = food.category {
                                                Text(category)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                            HStack(spacing: 4) {
                                                ForEach(0..<Int(food.rating), id: \.self) { _ in
                                                    Image(systemName: "star.fill")
                                                        .foregroundColor(.yellow)
                                                }
                                                ForEach(Int(food.rating)..<5, id: \.self) { _ in
                                                    Image(systemName: "star")
                                                        .foregroundColor(.yellow)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        deletionIndexSet = indexSet
                        showingDeleteAlert.toggle()
                    }
                }
                .listStyle(.plain)
                .navigationBarItems(trailing: logoImage) // Display logo next to food list

                
            }
            .navigationTitle("Food List")
                    }
           
        .navigationViewStyle(.stack)
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Delete Food"),
                message: Text("Are you sure you want to delete this?"),
                primaryButton: .cancel(),
                secondaryButton: .destructive(Text("Delete")) {
                    deleteFood()
                }
            )
        }
    }

    private var filteredFood: [Food] {
        var filteredFood = Array(food)
        
        if let selectedCategory = selectedCategory, selectedCategory != "All" {
            filteredFood = filteredFood.filter { $0.category == selectedCategory }
        }
        
        return filteredFood
    }

    private func deleteFood() {
        if let indexSet = deletionIndexSet {
            withAnimation {
                indexSet.map { food[$0] }.forEach(managedObjContext.delete)
                saveContext()
            }
        }
        deletionIndexSet = nil
    }

    private func saveContext() {
        do {
            try managedObjContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    private var logoImage: some View {
        Image("applogo") // Replace "applogo" with your logo image name
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 80, height: 80)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct AdvertisementView: View {
    var imageName: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 120)
                .cornerRadius(8)
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                    
                        if !text.isEmpty {
                            Button(action: {
                                text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Text("Cancel")
                        .foregroundColor(.blue)
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
        .padding(.bottom, 16) // Add bottom padding to separate the search bar from the food list
    }
}
