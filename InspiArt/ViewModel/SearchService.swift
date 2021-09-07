import Foundation

public final class SearchService: NSObject {
    
    private var completionHandler: ((APIResponse) -> Void)?
    private var completionHandlerImage: ((ImageAPIResponse) -> Void)?
    private var enteredData: String = ""
    
    public func updateEnteredData(data: String) {
        self.enteredData = data
    }
    
    public func loadArtData(_ completionHandler: @escaping((APIResponse) -> Void)) {
        self.completionHandler = completionHandler
    }
    
    public func loadImageArtData(_ completionHandlerImage: @escaping((ImageAPIResponse) -> Void)) {
        self.completionHandlerImage = completionHandlerImage
    }
    
    public func makeDataRequest() {
        
        guard let urlString = "https://api.artic.edu/api/v1/artworks/search?q=\(enteredData)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let urlRequest = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil, let data = data else { return }
            if let response = try? JSONDecoder().decode(APIResponse.self, from: data) {
                self.completionHandler?(response)
            }
        }.resume()
    }
    
    public func makeImageRequest(imageId: String) {
        
        guard let urlString = "https://api.artic.edu/api/v1/artworks/\(imageId)?fields=image_id,artist_display,title,id".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let urlRequest = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil, let data = data else { return }
            if let response = try? JSONDecoder().decode(ImageAPIResponse.self, from: data) {
                self.completionHandlerImage?(response)
            }
        }.resume()
    }
}

public struct APIResponse: Decodable {
    let data: [APIData]
}

struct APIData: Decodable {
    let id: Int
    let title: String
}

public struct ImageAPIResponse: Decodable {
    let data: ImageAPIData
}

struct ImageAPIData: Decodable {
    let id: Int
    let image_id: String
    let artist_display: String
    let title: String
}



