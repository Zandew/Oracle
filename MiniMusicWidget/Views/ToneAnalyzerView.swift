//
//  ToneAnalyzerView.swift
//  MiniMusicWidget
//
//  Created by Andrew Xue on 2020-07-18.
//  Copyright © 2020 Andrew Xue. All rights reserved.
//

import SwiftUI

struct ToneAnalyzerView: View {
    
    let pub = NotificationCenter.default.publisher(for: NSNotification.Name("updateMoods"))
    
    @State var text: String = ""
    @State var moodDict: [String : Double] = [:]
    
    var body: some View {
        HStack {
            VStack {
                TextView(text: $text)
                    .frame(width: 300, height: 150)
                    .lineLimit(5)
                Button(action: {
                    AlamoRequest.getMoods(text: self.text)
                }) {
                    Text("Submit")
                }
                MoodView(mood: "anger", level: moodDict["anger"] ?? 0)
                MoodView(mood: "sad", level: moodDict["sad"] ?? 0)
            }
            List {
                Text("SONG")
            }
        }.onReceive(pub) { _ in
            self.moodDict = AlamoRequest.moodList
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
