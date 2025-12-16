import Foundation
import SwiftUI

struct AbstractCubeEntryScreen: View {
    @StateObject private var loader: AbstractCubeWebLoader

    init(loader: AbstractCubeWebLoader) {
        _loader = StateObject(wrappedValue: loader)
    }

    var body: some View {
        ZStack {
            AbstractCubeWebViewBox(loader: loader)
                .opacity(loader.state == .finished ? 1 : 0.5)
            switch loader.state {
            case .progressing(let percent):
                AbstractCubeProgressIndicator(value: percent)
            case .failure(let err):
                AbstractCubeErrorIndicator(err: err)  // err теперь String
            case .noConnection:
                AbstractCubeOfflineIndicator()
            default:
                EmptyView()
            }
        }
    }
}

private struct AbstractCubeProgressIndicator: View {
    let value: Double
    var body: some View {
        GeometryReader { geo in
            AbstractCubeLoadingOverlay(progress: value)
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.black)
        }
    }
}

private struct AbstractCubeErrorIndicator: View {
    let err: String  // было Error, стало String
    var body: some View {
        Text("Ошибка: \(err)").foregroundColor(.red)
    }
}

private struct AbstractCubeOfflineIndicator: View {
    var body: some View {
        Text("Нет соединения").foregroundColor(.gray)
    }
}
