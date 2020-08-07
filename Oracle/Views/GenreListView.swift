import SwiftUI

struct GenreListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var selected: [Bool]
    
    init() {
        var array = Array(repeating: false, count: 126)
        for genre in UserData.queue {
            let idx = AlamoRequest.genreList.firstIndex(of: genre)!
            array[idx] = true
        }
        _selected = State(initialValue: array)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back")
                }
                Spacer()
                Button(action: {
                    self.selected = Array(repeating: false, count: 126)
                    UserData.queue = []
                    for _ in 0..<5 {
                        let random = Int.random(in: 0..<126)
                        if self.selected[random] == false {
                            self.selected[random] = true
                            UserData.add(genre: AlamoRequest.genreList[random])
                        }
                    }
                }) {
                    Text("Randomize")
                }
            }
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    self.generateContent(in: geometry)
                }
            }
        }
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(AlamoRequest.genreList, id: \.self) { genre in
                self.item(genre: genre)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if genre == AlamoRequest.genreList.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if genre == AlamoRequest.genreList.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
    }

    func item(genre: String) -> some View {
        Button(action : {
            if UserData.queue.firstIndex(of: genre) != nil {
                UserData.remove(genre: genre)
            }else {
                let ret = UserData.add(genre: genre)
                if ret != nil {
                    self.selected[AlamoRequest.genreList.firstIndex(of: ret!)!].toggle()
                }
            }
            self.selected[AlamoRequest.genreList.firstIndex(of: genre)!].toggle()
        }) {
            GenreRowView(genre: genre, pressed: self.selected[AlamoRequest.genreList.firstIndex(of: genre)!])
        }
    }
}
