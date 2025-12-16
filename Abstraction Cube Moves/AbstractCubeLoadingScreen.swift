import SwiftUI

// MARK: - Протоколы для улучшения расширяемости

protocol ProgressDisplayable {
    var progressPercentage: Int { get }
}

protocol BackgroundProviding {
    associatedtype BackgroundContent: View
    func makeBackground() -> BackgroundContent
}

// MARK: - Расширенная структура загрузки

struct AbstractCubeLoadingOverlay: View, ProgressDisplayable {
    let progress: Double
    @State private var angle: Double = 0
    @State private var glow: Bool = false
    var progressPercentage: Int { Int(progress * 100) }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Animated gradient background (no images)
                ZStack {
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "#0A0A1F"),
                            Color(hex: "#1B0A2F"),
                            Color(hex: "#041A3B")
                        ]),
                        center: .center,
                        startRadius: 10,
                        endRadius: max(geo.size.width, geo.size.height)
                    )

                    AngularGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "#27187E"),
                            Color(hex: "#00BBF9"),
                            Color(hex: "#F15BB5"),
                            Color(hex: "#FEE440"),
                            Color(hex: "#27187E"),
                        ]),
                        center: .center,
                        angle: .degrees(angle)
                    )
                    .blendMode(.plusLighter)
                    .animation(.linear(duration: 6).repeatForever(autoreverses: false), value: angle)
                    .onAppear { angle = 360 }
                }
                .ignoresSafeArea()

                VStack(spacing: 28) {
                    // Circular spinner
                    AbstractCubeCircularSpinner(progress: progress)
                        .frame(width: min(geo.size.width, geo.size.height) * 0.32,
                               height: min(geo.size.width, geo.size.height) * 0.32)
                        .shadow(color: Color.white.opacity(glow ? 0.35 : 0.1), radius: glow ? 24 : 8)
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: glow)
                        .onAppear { glow = true }

                    // English text only
                    VStack(spacing: 8) {
                        Text("Loading...")
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "#FEE440"), Color(hex: "#00BBF9")]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color(hex: "#00BBF9").opacity(0.4), radius: 6, x: 0, y: 2)

                        Text("\(progressPercentage)%")
                            .font(.system(size: 20, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.9))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.08),
                                Color.white.opacity(0.02)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(hex: "#00BBF9").opacity(0.7),
                                    Color(hex: "#F15BB5").opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ), lineWidth: 1)
                    )
                    .cornerRadius(14)
                }
            }
        }
    }
}

// MARK: - Фоновые представления

struct AbstractCubeBackground: View, BackgroundProviding {
    func makeBackground() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "#0B0F1A"),
                Color(hex: "#0F172A"),
                Color(hex: "#111827"),
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ).ignoresSafeArea()
    }

    var body: some View {
        makeBackground()
    }
}

// MARK: - Circular Spinner

private struct AbstractCubeCircularSpinner: View {
    let progress: Double
    @State private var rotation: Double = 0
    @State private var pulse: Bool = false

    var body: some View {
        ZStack {
            // Background track
            Circle()
                .stroke(Color.white.opacity(0.06), lineWidth: 12)

            // Progress ring
            Circle()
                .trim(from: 0, to: max(0.02, min(1.0, progress)))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "#00F5D4"), // neon cyan
                            Color(hex: "#00BBF9"), // neon blue
                            Color(hex: "#F15BB5"), // neon magenta
                            Color(hex: "#FEE440"), // neon yellow
                            Color(hex: "#00F5D4"), // loop back
                        ]),
                        center: .center,
                        angle: .degrees(rotation)
                    ),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: Color(hex: "#00BBF9").opacity(0.45), radius: 10)
                .animation(.easeInOut(duration: 0.25), value: progress)

            // Rotating highlight arc
            Circle()
                .trim(from: 0.0, to: 0.12)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.9), Color.clear]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(.degrees(rotation))
                .rotationEffect(.degrees(-90))
                .blendMode(.screen)

            // Dashed orbit ring
            Circle()
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "#00BBF9"),
                            Color(hex: "#F15BB5"),
                            Color(hex: "#00BBF9")
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [2, 10])
                )
                .rotationEffect(.degrees(-rotation))
                .opacity(0.9)
                .blendMode(.plusLighter)

            // Inner pulsing core
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "#FEE440"),
                            Color(hex: "#F15BB5").opacity(0.6),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 2,
                        endRadius: 60
                    )
                )
                .scaleEffect(pulse ? 1.05 : 0.9)
                .opacity(0.9)
        }
        .onAppear {
            withAnimation(.linear(duration: 1.8).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                pulse.toggle()
            }
        }
    }
}

// MARK: - Previews

#if canImport(SwiftUI)
import SwiftUI
#endif

// Use availability to keep using the modern #Preview API on iOS 17+ and provide a fallback for older versions
@available(iOS 17.0, *)
#Preview("Vertical") {
    AbstractCubeLoadingOverlay(progress: 0.2)
}

@available(iOS 17.0, *)
#Preview("Horizontal", traits: .landscapeRight) {
    AbstractCubeLoadingOverlay(progress: 0.2)
}

// Fallback previews for iOS < 17
struct AbstractCubeLoadingOverlay_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AbstractCubeLoadingOverlay(progress: 0.2)
                .previewDisplayName("Vertical (Legacy)")

            AbstractCubeLoadingOverlay(progress: 0.2)
                .previewDisplayName("Horizontal (Legacy)")
                .previewLayout(.fixed(width: 812, height: 375)) // Simulate landscape on older previews
        }
    }
}
