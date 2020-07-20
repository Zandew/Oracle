import SwiftUI

struct MoodView: View {
    
    var mood: String
    var level: Double
    var space: CGFloat
    
    var body: some View {
        HStack{
            Text(mood)
                .frame(width: space, height: 20, alignment: .leading)
            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 12))
                    path.addLine(to: CGPoint(x: 50, y: 12))
                }.stroke(Color.gray, lineWidth: 5)
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 11.5))
                    path.addLine(to: CGPoint(x: 50*level, y: 11.5))
                }.stroke(lineWidth: 5)
                .fill(LinearGradient(
                    gradient: .init(colors: [.red, .yellow, .green]),
                    startPoint: .init(x: 0, y: 0.5),
                    endPoint: .init(x: 1, y: 0.5)
                ))
            }
        }
        .frame(width: 100, height: 20, alignment: .top)
    }
}

