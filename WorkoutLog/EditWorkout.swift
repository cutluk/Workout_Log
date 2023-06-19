//
//  EditWorkout.swift
//  Workouts
//
//  Created by Luke Cutting on 6/16/23.
//

import SwiftUI
import SwiftUINavigation
import XCTestDynamicOverlay

class EditWorkoutModel: ObservableObject {
    @Published var focus: EditWorkoutView.Field?
    @Published var workout: Workout
    
    init(
        focus: EditWorkoutView.Field? = .title,
        workout: Workout
    ) {
        self.focus = .title
        self.workout = workout
        if self.workout.lifts.isEmpty {
          self.workout.lifts.append(
            Lift(id: Lift.ID(UUID()), name: "", reps: "", weight: "", complete: false)
          )
        }
    }
    
    func deleteLifts(atOffsets indices: IndexSet){
        self.workout.lifts.remove(
          atOffsets: indices
        )
        if self.workout.lifts.isEmpty {
          self.workout.lifts.append(
            Lift(id: Lift.ID(UUID()), name: "", reps: "", weight: "", complete: false))
        }
        let index = min(indices.first!,
                        self.workout.lifts.count - 1)
          self.focus = .lift(self.workout.lifts[index].id)
      }
    
    func addLiftButtonTapped() {
        let lift = Lift(id: Lift.ID(UUID()),name: "", reps: "", weight: "", complete: false)
        self.workout.lifts.append(lift)
        self.focus = .lift(lift.id)
    }
    
    func deleteButtonTapped(){
        
    }
    
    
    }


struct EditWorkoutView: View {
    enum Field: Hashable {
        case lift(Lift.ID)
        case title
    }
    
  @FocusState var focus: Field?
//  @Binding var workout: Workout
  @ObservedObject var model: EditWorkoutModel
//    @ObservedObject var detailModel: WorkoutDetailModel
    
  var body: some View {
    Form {
      Section {
        TextField("Title", text:
            self.$model.workout.title)
          // Allows for cursor to automatically go where it needs to
          //  .focused(self.$focus, equals: .title)
          ThemePicker(selection: self.$model.workout.theme)
      } header: {
        Text("Workout Info")
      }
      Section {
          ForEach(self.$model.workout.lifts) { $lift in
              HStack {
                  TextField("Name", text: $lift.name)
                      .frame(width: 170.0)
                      
                  TextField("Reps", text: $lift.reps)
                      .frame(width: 80.0)
                    
                  TextField("Weight", text: $lift.weight)
                      
              }
          }

        .onDelete { indices in
            self.model
                .deleteLifts(atOffsets: indices)
        }

        Button("New lift") {
            self.model.addLiftButtonTapped()
        }
      } header: {
        Text("Lifts")
      }
    }
      // bind the two sources of truth together
    .bind(self.$model.focus, to: self.$focus)
  }
}



struct ThemePicker: View {
  @Binding var selection: Theme

  var body: some View {
    Picker("Theme", selection: $selection) {
      ForEach(Theme.allCases) { theme in
        ZStack {
          RoundedRectangle(cornerRadius: 4)
            .fill(theme.mainColor)
          Label(theme.name, systemImage: "paintpalette")
            .padding(4)
        }
        .foregroundColor(theme.accentColor)
        .fixedSize(horizontal: false, vertical: true)
        .tag(theme)
      }
    }
  }
}


struct EditWorkout_Previews: PreviewProvider {
  static var previews: some View {
      NavigationStack{
          EditWorkoutView(model: EditWorkoutModel(workout: .mock))
      }
  }
}

