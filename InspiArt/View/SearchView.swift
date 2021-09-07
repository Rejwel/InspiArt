import Foundation
import SwiftUI


struct SearchView: View {
    
    @ObservedObject private var searchViewModel = SearchViewModel(searchService: SearchService())
    
    @State var searchingText = String()
    @State private var isEditing: Bool = false
    
    var body: some View {
        
        SearchNavigation(text: $searchingText, search: search, cancel: cancel) {
            ScrollView(showsIndicators: false) {
                VStack {
                    if searchViewModel.arts.isEmpty {
                        Text("Type an author or art...")
                            .bold()
                            .font(.headline)
                            .foregroundColor(.gray)
                            .opacity(0.8)
                            .padding(.top, 30)
                    }
                    if !searchViewModel.emptySearch {
                        ForEach(searchViewModel.arts, id: \.self) { art in
                            ArtView(art: art, url: Functions.getFullURL(url: art.image_id))
                        }
                    }
                    else {
                        Text("Arts not found")
                            .bold()
                            .font(.headline)
                            .foregroundColor(.gray)
                            .opacity(0.8)
                            .padding(.top, 30)
                    }
                }
            }
            .navigationTitle("Search for art")
            .navigationBarTitleDisplayMode(.inline)
        }
        .ignoresSafeArea()
    }
}

struct SearchView_Preview: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

extension SearchView {
    func search() {
        searchViewModel.restartSearch()
        searchViewModel.updateData(data: searchingText)
        searchViewModel.searchData()
    }
    
    func cancel() {
        searchingText = ""
    }
}
