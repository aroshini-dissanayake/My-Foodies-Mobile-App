import SwiftUI
import MapKit

struct ProfileView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Image("profile_picture")
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .shadow(radius: 6)
                .aspectRatio(contentMode: .fit)
            
            Text("Sharanya Sithara")
                .font(.title)
                .bold()
            
            Text("Food Lover")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Divider()
                .padding(.horizontal)
            
            InfoRowView(systemImageName: "envelope", text: "sithara99@example.com")
            InfoRowView(systemImageName: "phone", text: "0773109222")
            InfoRowView(systemImageName: "location", text: "Colombo, Sri Lanka")
            
            Map(coordinateRegion: $region)
                .frame(height: 200)
                .cornerRadius(10)
            
            Spacer()
        }
        .padding()
    }
}

struct InfoRowView: View {
    let systemImageName: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: systemImageName)
                .foregroundColor(.blue)
            
            Text(text)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
