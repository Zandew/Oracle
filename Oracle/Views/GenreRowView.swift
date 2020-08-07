import SwiftUI

struct GenreRowView: View {
    
    let genre: String
    let pressed: Bool
    
    var body: some View {
        Text(genre)
            .foregroundColor(pressed ? .blue : .white)
    }
}
