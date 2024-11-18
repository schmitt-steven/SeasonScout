import SwiftUI

struct ExpandableAvailabilityView: View {
    let title: String
    let content: String
    
    @State var isExpanded: Bool = true
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation(.smooth) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .imageScale(.medium)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
            }
            
            Group {
                if isExpanded {
                    Text(content)
                        .frame(maxWidth: .infinity, alignment: .leading) // Left-align text
                        .padding([.bottom, .horizontal], 20)
                }
            }
        }
        .background(Color(UIColor.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 15)) // Use RoundedRectangle for clarity
        .padding([.leading, .trailing], 20)
        .shadow(color: .gray, radius: 2)
    }
}
