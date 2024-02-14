import SwiftUI

struct DetailsArtistInfo: View {
    let artist: DetailsArtistInfoModel
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            ListElement(title: "Name:", subtitle: artist.title)

            if let period = artist.period {
                ListElement(title: "Period:", subtitle: period)
            }
            
        }
    }
}

#Preview {
    let artist = DetailsArtistInfoModel(
        id: 123,
        title: "DaVinci",
        period: "1500 - 1530")
    return DetailsArtistInfo(artist: artist)
}
