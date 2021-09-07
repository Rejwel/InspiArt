import Foundation

class Functions {
    public static func getFullURL(url: String) -> URL! {
        return URL(string: "https://www.artic.edu/iiif/2/\(url)/full/843,/0/default.jpg")
    }
}
