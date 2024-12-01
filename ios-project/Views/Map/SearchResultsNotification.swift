struct searchResultsNotification: View {
    
    let viewController: MapViewController
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "checkmark.circle")
                Text("\(viewController.marketsFoundInUserRegion.count) Ergebnisse")
            }
            Spacer()
        }
        .background(Color(.systemGray6))
        .padding()
    }
}