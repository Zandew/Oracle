//
//  ToneAnalyzerView.swift
//  MiniMusicWidget
//
//  Created by Andrew Xue on 2020-07-18.
//  Copyright © 2020 Andrew Xue. All rights reserved.
//

import SwiftUI

struct ToneAnalyzerView: View {
    
    let pub1 = NotificationCenter.default.publisher(for: NSNotification.Name("updateMoods"))
    let pub2 = NotificationCenter.default.publisher(for: NSNotification.Name("showRecommendations"))
    
    @State var text: String = ""
    @State var moodDict: [String : Double] = [:]
    @State var recommendations: [Song] = []
    @State var showGenres: Bool = false
    
    var body: some View {
        HStack {
            VStack {
                TextView(text: $text)
                    .frame(width: 300, height: 150)
                    .lineLimit(10)
                HStack {
                    Button(action: {
                        AlamoRequest.getMoods(text: self.text)
                    }) {
                        Text("Submit")
                    }
                    Button(action: {
                        self.showGenres.toggle()
                    }) {
                        Text("Genres")
                    }.sheet(isPresented: $showGenres) {
                        GenreListView()
                            .frame(width: 500, height: 300)
                    }
                }
                HStack{
                    VStack {
                        MoodView(mood: "anger", level: moodDict["anger"] ?? 0, space: 35)
                        MoodView(mood: "joy", level: moodDict["joy"] ?? 0, space: 35)
                        MoodView(mood: "fear", level: moodDict["fear"] ?? 0, space: 35)
                    }
                    Spacer()
                        .frame(width: 40)
                    VStack {
                        MoodView(mood: "sadness", level: moodDict["sadness"] ?? 0, space: 60)
                        MoodView(mood: "confident", level: moodDict["confident"] ?? 0, space: 60)
                        MoodView(mood: "tentative", level: moodDict["tentative"] ?? 0, space: 60)
                    }
                }
            }
            List {
                ForEach(self.recommendations) { song in
                    SongRecommendView(song: song)
                }
            }
        }.onReceive(pub1) { _ in
            self.moodDict = AlamoRequest.moodList
            AlamoRequest.getRecommendations()
        }.onReceive(pub2) { _ in
            self.recommendations = AlamoRequest.recommendationList
            print(self.recommendations)
        }
    }
}

public struct TextView: View {
    private typealias _PlatformView = _AppKitTextView
    private let platform: _PlatformView

    public init(text: Binding<String>) {
        self.platform = _PlatformView(text: text)
    }

    public var body: some View { platform }
}

fileprivate struct _AppKitTextView: NSViewRepresentable {
    @Binding var text: String

    func makeNSView(context: Context) -> NSTextView {
        let view = NSTextView()
        view.delegate = context.coordinator
        view.textColor = .controlTextColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoresizingMask = [.width, .height]
        view.isEditable = true
        return view
    }

    func updateNSView(_ view: NSTextView, context: Context) {
        view.string = text

        if let lineLimit = context.environment.lineLimit {
            view.textContainer?.maximumNumberOfLines = lineLimit
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: _AppKitTextView

        init(_ parent: _AppKitTextView) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let text = notification.object as? NSText else { return }
            self.parent.text = text.string
        }
    }
}
