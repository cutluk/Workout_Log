import SwiftUI
import Tagged
import IdentifiedCollections

struct Workout: Equatable, Identifiable, Codable {
  let id: Tagged<Self, UUID>
  var lifts: IdentifiedArrayOf<Lift> = []
  var theme: Theme = .blue
  var title = ""
  var date: Date
}

struct Lift: Equatable, Identifiable, Codable {
  let id: UUID
  var name: String
  var reps: String
  var weight: String
  var complete: Bool

    init(
        id: UUID = UUID(),
        name: String,
        reps: String,
        weight: String,
        complete: Bool = false
    ) {
        self.id = id
        self.name = name
        self.reps = reps
        self.weight = weight
        self.complete = complete
    }
    static func new() -> Lift {}
}

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let primaryButtonTitle: String
    let secondaryButtonTitle: String
    let action: () -> Void
}

enum Theme: String, CaseIterable, Equatable, Hashable, Identifiable, Codable {
    case red
    case orange
    case yellow
    case mint
    case green
    case teal
    case blue
    case cyan
    case indigo
    case purple
    case pink
    case brown
    case black

  var id: Self { self }

  var accentColor: Color {
    switch self {
    case .red, .orange, .yellow, .mint, .green, .teal, .blue, .cyan, .pink, .brown, .purple:
        return .black
    case .black, .indigo:
      return .white
    }
  }

  var mainColor: Color { Color(self.rawValue) }

  var name: String { self.rawValue.capitalized }
}


extension Workout {
  static let mock = Self(
    id: Workout.ID(UUID()),
    lifts: [
      Lift(name: "Push-Ups", reps: "3x12", weight: "", complete: false),
      Lift(name: "Chest Press", reps: "3x(10x9x9)", weight: "80", complete: false),
      Lift(name: "Bench", reps: "3x(10x10x6)", weight: "180x192x204", complete: false),
      Lift(name: "Alt Bicep Curls", reps: "3x10", weight: "40", complete: false),
      Lift(name: "Shoulder Press", reps: "3x10", weight: "50", complete: false),
      Lift(name: "Chest Fly", reps: "3x10", weight: "150", complete: false),
      Lift(name: "Hammer Curls", reps: "3x(10x10x6)", weight: "40", complete: false),
      Lift(name: "Lateral Raises", reps: "3x10", weight: "25", complete: false),
      Lift(name: "Tri-extension single arm", reps: "3x10", weight: "25", complete: false),
      Lift(name: "Tri Push Down Bar", reps: "3x10", weight: "72.5", complete: false),
      Lift(name: "One Hand Tricep", reps: "3x10", weight: "25", complete: false),
      Lift(name: "Crunch Rope", reps: "3x10", weight: "52.5", complete: false)
    ],
    theme: .blue,
    title: "All Upper Body",
    date: Date()
  )
    
}
