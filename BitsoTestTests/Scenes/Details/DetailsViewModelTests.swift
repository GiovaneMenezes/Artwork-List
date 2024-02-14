import XCTest
@testable import BitsoTest

class DetailsViewModelTests: XCTestCase {
    func test_fetchArtistInformation_successfulResponse() async throws {
        let artistsRepository = IArtistsRepositorySpy(getArtistResponse: .success(artist))
        let sut = await DetailsViewModel(artwork: artwork, artistsRepository: artistsRepository)
        
        await MainActor.run {
            XCTAssertEqual(sut.getArtistsInfo().count, 0)
            XCTAssertFalse(artistsRepository.getArtistWasCalled)
            XCTAssertNil(sut.errorMessage)
            XCTAssertTrue(sut.isLoading)
        }
        
        await sut.fetchArtistInformation()
        
        await MainActor.run {
            XCTAssertEqual(sut.getArtistsInfo().count, 1)
            XCTAssertTrue(artistsRepository.getArtistWasCalled)
            XCTAssertNil(sut.errorMessage)
            XCTAssertFalse(sut.isLoading)
        }
    }
    
    func test_fetchArtistInformation_failureResponse() async throws {
        let response = ErrorExample.example1
        let artistsRepository = IArtistsRepositorySpy(getArtistResponse: .failure(response))
        let sut = await DetailsViewModel(artwork: artwork, artistsRepository: artistsRepository)
        
        await MainActor.run {
            XCTAssertEqual(sut.getArtistsInfo().count, 0)
            XCTAssertFalse(artistsRepository.getArtistWasCalled)
            XCTAssertNil(sut.errorMessage)
            XCTAssertTrue(sut.isLoading)
        }
        
        await sut.fetchArtistInformation()
        
        await MainActor.run {
            XCTAssertEqual(sut.getArtistsInfo().count, 0)
            XCTAssertTrue(artistsRepository.getArtistWasCalled)
            XCTAssertEqual(sut.errorMessage, response.localizedDescription)
            XCTAssertFalse(sut.isLoading)
        }
    }
    
    func test_getArtistsInfo() async throws {
        let artistsRepository = IArtistsRepositorySpy(getArtistResponse: .success(artist))
        let sut = await DetailsViewModel(artwork: artwork, artistsRepository: artistsRepository)
        
        await sut.fetchArtistInformation()
        
        let artistInfo = await sut.getArtistsInfo()
        XCTAssertEqual(artistInfo.first?.id, artist.id)
        XCTAssertEqual(artistInfo.first?.title, artist.title)
        XCTAssertEqual(artistInfo.first?.period, "1500 - 1530")
    }
    
    func test_getArtworkInfo() async throws {
        let artistsRepository = IArtistsRepositorySpy(getArtistResponse: .success(artist))
        let sut = await DetailsViewModel(artwork: artwork, artistsRepository: artistsRepository)
        
        let artworkInfo = await sut.getArtworkInfo()
        XCTAssertEqual(artworkInfo.id, artwork.id)
        XCTAssertEqual(artworkInfo.title, artwork.title)
        XCTAssertEqual(artworkInfo.imageURL?.absoluteString, "https://www.artic.edu/iiif/2/aaaa-aaa/full/843,/0/default.jpg")
        XCTAssertEqual(artworkInfo.materialTitles, artwork.materialTitles)
    }
}

extension DetailsViewModelTests {
    var artwork: Artwork {
        Artwork(id: 123,
                imageID: "aaaa-aaa",
                title: "Monalisa",
                placeOfOrigin: "Italy",
                dateDisplay: "1500",
                artistIDs: [1],
                artistTitles: ["Davinci"],
                materialTitles: ["Tint", "Canvas"])
    }
    
    var artist: Artist {
        Artist(
            id: 1,
            title: "Davinci",
            birthDate: 1500,
            deathDate: 1530,
            isArtist: true,
            description: nil)
    }
}
