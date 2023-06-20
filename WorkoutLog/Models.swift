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
  let id: Tagged<Self, UUID>
  var name: String
  var reps: String
  var weight: String
  var complete: Bool
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
      Lift(id: Lift.ID(UUID()), name: "Push-Ups", reps: "3x12", weight: "", complete: false),
      Lift(id: Lift.ID(UUID()), name: "Chest Press", reps: "3x(10x9x9)", weight: "80", complete: false),
      Lift(id: Lift.ID(UUID()), name: "Bench", reps: "3x(10x10x6)", weight: "180x192x204", complete: false),
      Lift(id: Lift.ID(UUID()), name: "Alt Bicep Curls", reps: "3x10", weight: "40", complete: false),
      Lift(id: Lift.ID(UUID()), name: "Shoulder Press", reps: "3x10", weight: "50", complete: false),
      Lift(id: Lift.ID(UUID()), name: "Chest Fly", reps: "3x10", weight: "150", complete: false),
      Lift(id: Lift.ID(UUID()), name: "Hammer Curls", reps: "3x(10x10x6)", weight: "40", complete: false),
      Lift(id: Lift.ID(UUID()), name: "Lateral Raises", reps: "3x10", weight: "25", complete: false),
      Lift(id: Lift.ID(UUID()), name: "Tri-extension single arm", reps: "3x10", weight: "25", complete: false),
      Lift(id: Lift.ID(UUID()), name: "Tri Push Down Bar", reps: "3x10", weight: "72.5", complete: false),
      Lift(id: Lift.ID(UUID()), name: "One Hand Tricep", reps: "3x10", weight: "25", complete: false),
      Lift(id: Lift.ID(UUID()), name: "Crunch Rope", reps: "3x10", weight: "52.5", complete: false)
    ],
    theme: .blue,
    title: "All Upper Body",
    date: Date()
  )
    
}
