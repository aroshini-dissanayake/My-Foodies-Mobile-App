import SwiftUI
import PhotosUI

struct AddFoodView: View {

    @Environment(\.managedObjectContext) var managedObjContext

    @Environment(\.dismiss) var dismiss

   

    let categories = ["Traditional","Chinese", "Italian", "Indian","Other"]

   

    @State private var name = ""

    @State private var category = ""

    @State private var place = ""
    
    @State private var restaurant = ""

    @State private var rating : Double = 0

    @State private var selectedimage: Data = .init(count: 0)

    @State private var selectedItems: [PhotosPickerItem] = []

    @State private var selectedDate = Date()

    @State private var isActive = false

   

    var body: some View {

        Form {

            Section {

                HStack{

                    Text("Food Name:")

                    TextField("Enter Food Name", text: $name)

                }

                HStack{

                    Text("Place Name:")

                    TextField("Enter Place Name", text: $place)

                }
                
                HStack{

                    Text("Restaurant Name:")

                    TextField("Enter Restaurant Name", text: $restaurant)

                }

               

                VStack {

                    Text("Rating : \(Int(rating))")

                    Slider(value:$rating, in:0...5, step:1)

                }

                .padding()

               

                // Date picker

                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)

               

                //type picker

                Picker("Category", selection: $category) {

                    ForEach(categories, id: \.self) { category in

                        Text(category)

                    }

                }

                Spacer()

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

                    }

                    //MARK: PhotoPicker

                    Spacer()

                }

                //MARK: HStack

                .onChange(of: selectedItems) { new in

                    guard let items = selectedItems.first else { return

                       

                       

                    }//MARK: items

                   

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

               

                VStack {

                    Spacer()

                    Spacer()

                    Button(action: {

                        //MARK: Lets add data to the database( CoreData )

                        let new = Food(context: self.managedObjContext)

                        new.id = UUID()

                        new.place = self.place
                        new.restaurant = self.restaurant
                        new.name = self.name

                        new.category = self.category
                       new.date = self.selectedDate
                       new.rating = self.rating

                        new.selectedimage = self.selectedimage

                       

                        //MARK: Lets save the data permanently

                        try! self.managedObjContext.save()

                       

                        //MARK: Lets dismiss the AdddataView

                        dismiss()

                       

                        self.name = ""

                        self.place = ""
                        self.restaurant = ""
                        self.selectedimage.count = 0

                    })

                    {

                        HStack {

                            Image(systemName: "checkmark.circle")

                                .font(.title)

                                .foregroundColor(.white)

                                .frame(width: 24, height: 24) // Adjust the width and height as desired

                           

                            Text("Save")

                                .foregroundColor(.white)

                                .font(.headline)

                                .padding(.horizontal, 8) // Adjust the padding as desired

                               

                                }

                        }

                    }

                    .buttonStyle(.borderedProminent)

                    .frame(width: 300, height: 40) // Adjust the width and height as desired

                    .background(Color.green) // Replace "green" with the desired color

                    .cornerRadius(10)

                    .disabled(self.name.count > 2 && self.selectedimage.count != 0 ? false : true)

                    .fullScreenCover(isPresented: $isActive) {

                        HomeView()

                    Spacer()

                }

            }

        }

    }

   

    struct AddFoodView_Previews: PreviewProvider {

        static var previews: some View {

            AddFoodView()

        }

    }

}
