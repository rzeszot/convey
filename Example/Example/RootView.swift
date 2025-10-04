import Convey
import SwiftUI

enum Target: String, CaseIterable {
    case root
    case back
}

enum Local {
    case increment
}

enum Transform {
    case bump
}

enum Other {
    case unknown
}

enum Screen: String {
    case red
    case green
    case yellow

    var color: Color {
        switch self {
        case .red: .red
        case .yellow: .yellow
        case .green: .green
        }
    }
}

struct Wrapper: View {
    let current: Screen
    let next: Screen

    @State var number = 0

    var body: some View {
        ZStack {
            current.color
                .ignoresSafeArea()
            ConveyReader { convey in
                VStack {
                    Button("go to \(next.rawValue)") {
                        convey(next)
                    }
                    Divider()
                    ForEach(Target.allCases, id: \.self) { item in
                        Button("go to \(item.rawValue)") {
                            convey(item)
                        }
                    }
                    Divider()
                    Button("unknown") {
                        convey(Other.unknown)
                    }
                    Divider()
                    Text("\(number)")
                    Button("increment") {
                        convey(Local.increment)
                    }
                    Button("bump (transform increment)") {
                        convey(Transform.bump)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(current.rawValue)
        .convey(transform: Transform.self) { value in
            switch value {
            case .bump: Local.increment
            }
        }
        .convey(of: Local.self) { local in
            switch local {
            case .increment:
                number += 1
            }
        }
    }
}

struct RedView: View {
    var body: some View {
        Wrapper(
            current: .red,
            next: .green
        )
    }
}

struct GreenView: View {
    var body: some View {
        Wrapper(
            current: .green,
            next: .yellow
        )
    }
}

struct YellowView: View {
    var body: some View {
        Wrapper(
            current: .yellow,
            next: .red
        )
    }
}

struct RootView: View {
    @State var path: [Screen] = []

    var body: some View {
        NavigationStack(path: $path) {
            GreenView()
                .navigationDestination(for: Screen.self) { screen in
                    switch screen {
                    case .red:
                        RedView()
                    case .green:
                        GreenView()
                    case .yellow:
                        YellowView()
                    }
                }
        }
        .buttonStyle(.borderedProminent)
        .convey(of: Screen.self, append: $path)
        .convey(of: Target.self) { target in
            switch target {
            case .back:
                if !path.isEmpty {
                    path.removeLast()
                }
            case .root:
                path = []
            }
        }
    }
}
