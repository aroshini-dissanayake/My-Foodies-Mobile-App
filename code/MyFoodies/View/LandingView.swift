import SwiftUI

extension Color {
    static let maroon = Color(red: 128/255, green: 0/255, blue: 0/255)
}

struct LandingView: View {
    @State private var isActive = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("applogo")
                .resizable()
                .frame(width: 200, height: 200)
            
            Text("My Foodies")
                .font(
                    .custom(
                        "AmericanTypewriter",
                        size: 48)
                )
                .fontWeight(.semibold)
                .padding(.top, 24)
            
            Text("Discover and organize your favourite foods!")
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.top, 16)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    isActive = true
                }
            }) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.maroon)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            .fullScreenCover(isPresented: $isActive) {
                ContentView()
            }
        }
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
