import SwiftUI

// Button to toggle between map styles
struct MapStyleButton: View {
    
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                Spacer()
                Button(action: {
                    viewModel.changeMapStyle() // Change map style
                }) {
                    viewModel.currentMapStyle.1 // Display current map style icon
                        .resizable()
                        .scaledToFit()
                        .frame(height: 22)
                        .padding(.all, 12)
                        .foregroundStyle(Color(.systemOrange))
                        .background(BlurBackgroundView(style: .systemThickMaterial))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .padding(.trailing, -12)
                .padding(.top, -20)
            }
            .padding(.trailing, 0)
            Spacer()
        }
        .padding()
    }
}
