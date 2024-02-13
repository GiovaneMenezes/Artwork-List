import SwiftUI

struct DetailsArtworkInfo: View {
    let artwork: DetailsArtworkInfoModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text(artwork.title).font(.title2).multilineTextAlignment(.center)
            
            if let imageURL = artwork.imageURL {
                AsyncImage(
                    url: imageURL,
                    content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    },
                    placeholder: {
                        ProgressView()
                    }
                )
            }
            
            if let placeOfOrigin = artwork.placeOfOrigin {
                ListElement(title: "Place of Origin:", subtitle: placeOfOrigin)
            }
            
            if let dateDisplay = artwork.dateDisplay {
                ListElement(title: "Date", subtitle: dateDisplay)
            }
            
            
            if !artwork.materialTitles.isEmpty {
                VStack(alignment: .leading) {
                    Text("Material:").font(.headline)
                    VStack {
                        ForEach(artwork.materialTitles, id: \.self) { materialTitle in
                            Text(materialTitle.capitalized).frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    let artwork = DetailsArtworkInfoModel(
        id: 123,
        imageURL: nil,
        title: "Monalisa",
        placeOfOrigin: "Veneza",
        dateDisplay: "1500",
        materialTitles: ["Tint", "Canvas"])
    return DetailsArtworkInfo(artwork: artwork)
}
