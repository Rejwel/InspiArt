import SwiftUI
import Kingfisher

struct ArtView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var isFavourite = false
    
    private var art: Art
    private var url: URL
    
    init(art: Art, url: URL) {
        self.art = art
        self.url = url
    }
    
    var body: some View {
        ZStack {
            VStack {
                NavigationLink(
                    destination: InnerCardView(isFavourite: $isFavourite, art: art, url: url, completionAddArt: {
                        addArt(art: art)
                    }, completionRemoveArt: {
                        deleteArt(art: art)
                    }),
                    label: {
                        CardView(art: art, url: url)
                    })
                    .buttonStyle(FlatLinkStyle())
            }
        }
    }
}

extension ArtView {
    
    func addArt(art: Art) {
        
        let savedArt = SavedArt(context: managedObjectContext)
        savedArt.id = Int64(art.id)
        savedArt.artist_display = art.artist_display
        savedArt.image_id = art.image_id
        savedArt.title = art.title
        savedArt.when_added = Date.init()
        PersistenceController.shared.save()
        
    }
    
    func deleteArt(art: Art) {
        PersistenceController.shared.delete(artId: String(art.id))
    }
}

struct CardView: View {
    
    @State private var imageLoaded: Bool = false
    
    var art: Art
    var url: URL
    
    var body: some View {
        HStack {
            Spacer()
            KFImage(url)
                .cacheMemoryOnly()
                .placeholder({ ArtCardPlaceholder().onDisappear{ imageLoaded = true }})
                .resizable()
                .scaledToFit()
                .frame(width: 300)
                .overlay(
                    ZStack {
                        if imageLoaded {
                            LinearGradient(gradient: .init(colors: [.black, .black.opacity(0)]), startPoint: .bottom, endPoint: .top).opacity(0.8)
                        }
                        HStack{
                            VStack {
                                Spacer()
                                Text(art.title)
                                    .lineLimit(1)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .shadow(radius: 5)
                                Text(art.artist_display)
                                    .multilineTextAlignment(.center)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .padding(.bottom, 15)
                                    .shadow(radius: 5)
                            }
                        }
                        .padding()
                    }
                )
                .cornerRadius(20)
                .padding(.top, 50)
            Spacer()
        }
    }
}

struct ArtCardPlaceholder: View {
    var body: some View {
        Rectangle()
            .fill(Color.placeholderColor)
            .frame(width: 300, height: 400, alignment: .center)
            .cornerRadius(20)
    }
}

struct InnerArtCardPlaceholder: View {
    var body: some View {
        Rectangle()
            .fill(Color.placeholderColor)
            .frame(maxHeight: 450, alignment: .center)
            .scaledToFill()
    }
}

struct InnerCardView: View {
    
    @State private var isInAnimation: Bool = false
    @State private var heartAnimation: Bool = false
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var isFavourite: Bool
    var art: Art
    var url: URL
    var completionAddArt: () -> ()
    var completionRemoveArt: () -> ()
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    ZStack {
                        KFImage(url)
                            .cacheMemoryOnly()
                            .placeholder({ InnerArtCardPlaceholder() })
                            .resizable()
                            .scaledToFit()
                            .overlay(
                                VStack {
                                    HStack {
                                        Spacer()
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 35, height: 35)
                                            .overlay(
                                                FavouriteIconButton(isInDatabase: FetchRequest(entity: SavedArt.entity(), sortDescriptors: [], predicate: NSPredicate(format: "id == %d" , art.id)), isFavouriteImage: $isFavourite, art: art, completionAddArt: completionAddArt, completionRemoveArt: completionRemoveArt)
                                            )
                                            .padding(.top, 35)
                                            .padding(.trailing, 35)
                                    }
                                    Spacer()
                                }
                            )
                            .onTapGesture(count: 2) {
                                if !isInAnimation {
                                    addToFavourite()
                                    withAnimation(.spring())
                                    {
                                        heartAnimation.toggle()
                                    }
                                }
                                isInAnimation = true
                            }
                        if  heartAnimation {
                            heartBlink(isFavourite: $isFavourite)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                        heartAnimation.toggle()
                                        isInAnimation = false
                                    }
                                }
                        }
                    }
                    ZStack {
                        VStack {
                            HStack {
                                Text(art.title)
                                    .font(.headline)
                                    .padding()
                            }
                            HStack {
                                Spacer()
                                Text(art.artist_display)
                                    .font(.subheadline)
                                    .padding(.trailing, 30)
                            }
                        }
                    }.animation(nil)
                }
            }
        }
    }
}

struct heartBlink: View {
    @Binding var isFavourite: Bool
    
    var body: some View {
        VStack {
            if isFavourite {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.red)
                    .opacity(0.9)
                    .transition(AnyTransition.opacity)
            } else {
                EmptyView()
            }
        }
    }
}

struct FavouriteIcon: View {
    @FetchRequest var isInDatabase: FetchedResults<SavedArt>
    @Binding var isFavouriteImage: Bool
    
    var body: some View {
        Image(systemName: isInDatabase.count > 0 ? "heart.fill" : "heart")
            .foregroundColor(isInDatabase.count > 0 ? Color.red : Color.black)
            .onAppear {
                isFavouriteImage = isInDatabase.count > 0 ? true : false
            }
    }
}

struct FavouriteIconButton: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest var isInDatabase: FetchedResults<SavedArt>
    @Binding var isFavouriteImage: Bool
    var art: Art
    var completionAddArt: () -> ()
    var completionRemoveArt: () -> ()
    
    
    
    var body: some View {
        Button(action: {
            if isFavouriteImage {
                completionRemoveArt()
                isFavouriteImage.toggle()
            }
            else {
                completionAddArt()
                isFavouriteImage.toggle()
            }
        }, label: {
            Image(systemName: isFavouriteImage ? "heart.fill" : "heart")
                .foregroundColor(isFavouriteImage ? Color.red : Color.black)
        })
        .onAppear {
            isFavouriteImage = isInDatabase.count > 0 ? true : false
        }
    }
}

struct FlatLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

extension Color {
    static let placeholderColor: Color = Color(UIColor.systemGray3)
}

extension InnerCardView {
    func addToFavourite() {
        if isFavourite {
            completionRemoveArt()
            isFavourite.toggle()
        }
        else {
            completionAddArt()
            isFavourite.toggle()
        }
    }
}


