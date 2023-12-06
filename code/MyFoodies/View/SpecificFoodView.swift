import SwiftUI

struct SpecificFoodView: View {
    @Environment(\.managedObjectContext) var managedObjContext

    var food: Food // Existing Food object

    @State private var showingEditView = false

    var body: some View {
        VStack(alignment: .center) {
            
            ImageBackgroundView(food: food)
                .frame(maxWidth: .infinity, maxHeight: 300)
                .cornerRadius(16)

            VStack(alignment: .leading, spacing: 16) {
                Text(food.name ?? "")
                    .font(.title)
                    .bold()
                RatingView(rating: food.rating)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Place: \(food.place ?? "")")
                        .fontWeight(.medium)
                    Text("Restaurant: \(food.restaurant ?? "")")
                        .fontWeight(.medium)
                    Text("Category: \(food.category ?? "")")
                        .fontWeight(.medium)
                }
                
                VStack(spacing: 16) {
                    HStack(alignment: .top) {
                        NutritionalInfoView(iconName: "flame", value: "250 Kcal")
                        Spacer()
                        NutritionalInfoView(iconName: "circle", value: "30g Carbs")
                    }
                    
                    HStack(alignment: .top) {
                        NutritionalInfoView(iconName: "suit.heart", value: "10g Proteins")
                        Spacer()
                        NutritionalInfoView(iconName: "waveform.path.ecg", value: "15g Fats")
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 5)
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingEditView.toggle()
                }) {
                    Text("Edit")
                        .foregroundColor(.blue)
                        .bold()
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditFoodView(food: food)
        }
    }
}

struct RatingView: View {
    var rating: Double
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= Int(rating) ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
        }
        .font(.title3)
    }
}

struct ImageBackgroundView: View {
    var food: Food
    
    var body: some View {
        if let imageData = food.selectedimage, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct NutritionalInfoView: View {
    var iconName: String
    var value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: iconName)
                .font(.system(size: 24))
                .foregroundColor(.blue)
            
            Text(value)
                .font(.subheadline)
                .bold()
        }
    }
}
