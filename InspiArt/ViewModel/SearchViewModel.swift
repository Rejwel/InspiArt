import Foundation

public class SearchViewModel: ObservableObject {
    @Published public private(set) var arts: [Art] = []
    @Published public private(set) var emptySearch: Bool
    
    public let searchService: SearchService
    
    public init(searchService: SearchService) {
        self.searchService = searchService
        self.emptySearch = false
    }
    
    public func restartSearch() {
        emptySearch = false
    }
    
    public func searchData() {
        DispatchQueue.main.async {
            self.arts.removeAll()
            self.searchService.makeDataRequest()
            self.searchService.loadArtData { response in
                if !response.data.isEmpty {
                    for art in response.data {
                        self.searchService.makeImageRequest(imageId: String(art.id))
                        self.searchService.loadImageArtData { imageResponse in
                            DispatchQueue.main.async {
                                let newArt = Art(id: imageResponse.data.id, title: imageResponse.data.title, image_id: imageResponse.data.image_id, artist_display: imageResponse.data.artist_display, when_added: nil)
                                self.arts.append(newArt)
                                self.objectWillChange.send()
                            }
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.emptySearch = true
                    }
                }
            }
        }
    }
    
    public func updateData(data: String) {
        searchService.updateEnteredData(data: data)
    }
    
}
