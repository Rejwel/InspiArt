import Foundation
import SwiftUI
import CoreData

struct YourArtView: View {
    @State private var buttonOpened: Bool = false
    @State private var sortDescriptor: NSSortDescriptor = NSSortDescriptor(keyPath: \SavedArt.id, ascending: true)
    
    var body: some View {
        NavigationView {
            ZStack {
                resultView(sortDescriptor: sortDescriptor)
                sortButton(buttonOpened: $buttonOpened, sortDescriptor: $sortDescriptor)
            }
            .navigationTitle("Your art")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct resultView: View {
    
    @FetchRequest
    var savedArts: FetchedResults<SavedArt>
    
    init(sortDescriptor: NSSortDescriptor?) {
        let request: NSFetchRequest<SavedArt> = SavedArt.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \SavedArt.id, ascending: true)]
        
        if let sortDescriptor = sortDescriptor {
            request.sortDescriptors = [sortDescriptor]
        }
        _savedArts = FetchRequest<SavedArt>(fetchRequest: request)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if savedArts.isEmpty {
                Text("There will be your favourite arts")
                    .bold()
                    .font(.headline)
                    .foregroundColor(.gray)
                    .opacity(0.8)
                    .padding(.top, 30)
                    .padding()
            }
            else {
                ForEach(savedArts, id:\.self) { savedArt in
                    ArtView(art: Art(id: Int(savedArt.id), title: savedArt.title ?? "", image_id: savedArt.image_id ?? "", artist_display: savedArt.artist_display ?? "", when_added: savedArt.when_added ?? nil), url: Functions.getFullURL(url: savedArt.image_id ?? ""))
                }
            }
        }
    }
}

struct sortButton: View {
    @Binding var buttonOpened: Bool
    @Binding var sortDescriptor: NSSortDescriptor
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.spring())
                    {
                        buttonOpened = true
                    }
                }
                , label: {
                    ZStack {
                        Capsule()
                            .fill(Color(UIColor.systemGray3))
                            .frame(width: 55, height: !buttonOpened ? 55 : 180)
                        VStack {
                            if !buttonOpened {
                                Image(systemName: "chevron.up")
                                    .foregroundColor(.white)
                            }
                            else {
                                VStack {
                                    Button(action: {
                                        buttonOpened = false
                                        withAnimation(.spring())
                                        {
                                            sortDescriptor = NSSortDescriptor(keyPath: \SavedArt.when_added, ascending: true)
                                        }
                                    }, label: {
                                        Image(systemName: "calendar")
                                            .foregroundColor(.white)
                                    })
                                    Button(action: {
                                        buttonOpened = false
                                        withAnimation(.spring())
                                        {
                                            sortDescriptor = NSSortDescriptor(keyPath: \SavedArt.title, ascending: true)
                                        }
                                        
                                    }, label: {
                                        Image(systemName: "paintbrush.pointed.fill")
                                            .foregroundColor(.white)
                                            .padding([.bottom,.top], 35)
                                    })
                                    Button(action: {
                                        buttonOpened = false
                                        withAnimation(.spring())
                                        {
                                            sortDescriptor = NSSortDescriptor(keyPath: \SavedArt.artist_display, ascending: true)
                                        }
                                        
                                    }, label: {
                                        Image(systemName: "person.fill")
                                            .foregroundColor(.white)
                                    })
                                }
                            }
                        }
                    }
                })
                .buttonStyle(NoAnimationButton())
                .padding(.bottom, 35)
                .padding(.trailing, 35)
            }
        }
    }
}

struct NoAnimationButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}


struct YourArtView_Preview: PreviewProvider {
    static var previews: some View {
        YourArtView()
    }
}
