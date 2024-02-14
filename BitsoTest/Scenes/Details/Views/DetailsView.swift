import SwiftUI

struct DetailsView: View {
    @ObservedObject var viewModel: DetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if !viewModel.isLoading {
                    DetailsArtworkInfo(artwork: viewModel.getArtworkInfo())
                    let artists = viewModel.getArtistsInfo()
                    if !viewModel.isLoading {
                        VStack {
                            Text("Authors").font(.title3)
                            ForEach(artists, id: \.id) { artist in
                                Rectangle().frame(height: 1).tint(.gray).padding(.horizontal, 30)
                                DetailsArtistInfo(artist: artist)
                            }
                        }
                    } else {
                        ProgressView()
                    }
                    Spacer()
                }
            }
        }.task {
            await viewModel.fetchArtistInformation()
        }.padding(.horizontal, 15)
            .navigationTitle("Details")
    }
}
