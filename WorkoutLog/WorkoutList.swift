import SwiftUI
import Tagged
import SwiftUINavigation
import Combine
import IdentifiedCollections

final class WorkoutsListModel: ObservableObject {
    
    @Published var workouts: IdentifiedArrayOf<Workout>
    
    @Published var destination: Destination?{
        didSet { self.bind() }
    }
    @Published var alertItem: AlertItem?
    
    private var destinationCancellable: AnyCancellable?
    private var cancellables: Set<AnyCancellable> = []
    
    // switch allowing to go to different pages
    enum Destination {
        case add(EditWorkoutModel)
        case detail(WorkoutDetailModel)
        case confirmation(Alert)
    }

    // Initializer
      init(
        destination: Destination? = nil
//        workouts: IdentifiedArrayOf<Workout> = []
        //changes on video #218 19:20
      ) {
        self.destination = destination
        self.workouts = []
          
  // Check if the data file exists
         if !checkDataFileExists() {
             // File doesn't exist, populate with initial data
             populateInitialData()
         }
                 
//          // Load Workouts from disk
//          do {
//              self.workouts = try JSONDecoder().decode(
//                IdentifiedArray.self,
//                from: Data(contentsOf: .workouts))
//          }catch{
//              // TODO: alert
//          }
          
          
          
          
          
          // Load Workouts from disk
                  do {
                      self.workouts = try loadWorkoutsFromDisk()
                  } catch {
                      // TODO: Handle error
                  }
                  
          
    
          self.$workouts
              .dropFirst()
              .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
              .sink { workouts in
                  do {
                      try JSONEncoder().encode(workouts).write(to: .workouts)
                  } catch {
                      // TODO: alert
                  }
              }
              .store(in: &self.cancellables)
          
        self.bind()
      }
    
    
    
    
    
    
    
    
    
    
    // Check if the data file exists
       private func checkDataFileExists() -> Bool {
           let fileManager = FileManager.default
           return fileManager.fileExists(atPath: URL.workouts.path)
       }
       
       // Populate initial data in the data file
       private func populateInitialData() {
           print("Populating Data")
           // Create initial data
           let initialWorkouts: [Workout] = [
            Workout( id: Workout.ID(UUID()),
                     lifts: [
                        Lift(id: Lift.ID(UUID()), name: "Squats", reps: "3x10", weight: "205", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Calve Raise", reps: "315", weight: "225", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Weighted Lunges", reps: "3x10", weight: "60", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Hip Thrusts", reps: "3x10", weight: "80", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Elevated Heel Squat", reps: "3x10", weight: "65", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Leg Raises", reps: "3x10", weight: "204", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Leg Press", reps: "3x10", weight: "180", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Sumo Squats", reps: "3x10", weight: "70", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Deficit Reverse Lunges", reps: "3x10", weight: "40", complete: false)
                     ],
                     theme: .red,
                     title: "Legs",
                     date: Date()),
            
            Workout( id: Workout.ID(UUID()),
                     lifts: [
                       Lift(id: Lift.ID(UUID()), name: "Push-Ups", reps: "3x12", weight: "", complete: false),
                       Lift(id: Lift.ID(UUID()), name: "Chest Press", reps: "3x(10x9x9)", weight: "80", complete: false),
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
                     theme: .orange,
                     title: "All Upper Body",
                     date: Date()),
            
            Workout( id: Workout.ID(UUID()),
                     lifts: [
                        Lift(id: Lift.ID(UUID()), name: "Push-Ups", reps: "3x12", weight: "", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Bench", reps: "3x(10x10x6)", weight: "180x192x204", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Shoulder Press", reps: "3x10", weight: "50", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Suitcases", reps: "3x10", weight: "50", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Incline Bench Press", reps: "3x10", weight: "156", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Lateral Raises", reps: "3x10", weight: "25", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Tricep Skull Crushers", reps: "3x10", weight: "50", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Chest Fly", reps: "3x10", weight: "155", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Tricep Cable Pulls", reps: "3x15", weight: "52.5", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "One Hand Tricep", reps: "3x10", weight: "25", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Crunch Rope", reps: "3x10", weight: "52.5", complete: false)
                     ],
                     theme: .teal,
                     title: "Shoulders, Chest, Tris",
                     date: Date()),
            
            Workout( id: Workout.ID(UUID()),
                     lifts: [
                        Lift(id: Lift.ID(UUID()), name: "Pull-Ups", reps: "3x8", weight: "", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Hammer Curls", reps: "3x10", weight: "40", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Lat Pull Downs", reps: "3x10", weight: "132", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Rows", reps: "3x10", weight: "120", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Alt Bicep Curls", reps: "3x10", weight: "40", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Bent Over Rows", reps: "3x10", weight: "65", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Wide Bicep Curls", reps: "3x10", weight: "30", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Dumbbell Shrug", reps: "3x10", weight: "50", complete: false),
                        Lift(id: Lift.ID(UUID()), name: "Rear Back Cable Pulls", reps: "3x20", weight: "12.5", complete: false)
                     ],
                     theme: .blue,
                     title: "Back and Bis",
                     date: Date()),
            
            
           ]
           
           // Save initial data to the data file
           do {
               let jsonData = try JSONEncoder().encode(initialWorkouts)
               try jsonData.write(to: URL.workouts)
           } catch {
               // TODO: Handle error
           }
       }
       
       // Load workouts from the data file
       private func loadWorkoutsFromDisk() throws -> IdentifiedArrayOf<Workout> {
           let jsonData = try Data(contentsOf: URL.workouts)
           let workouts = try JSONDecoder().decode(IdentifiedArrayOf<Workout>.self, from: jsonData)
           return workouts
       }
    
    
    
    
    
    
    
    
    
    
    
    
    // Navigate to the add screen
    func addWorkoutButtonTapped() {
        self.destination = .add(EditWorkoutModel(workout: Workout(id: Workout.ID(UUID()), date: Date())))
    }
    
    // Dismiss the add screen
    func dismissAddWorkoutButtonTapped() {
        self.destination = nil
    }
    
    // Add the new workout
    func confirmAddWorkoutButtonTapped(){
        defer { self.destination = nil }
        
        guard case let .add(editWorkoutModel) = self.destination
        else { return }
        var workout = editWorkoutModel.workout
        
        workout.lifts.removeAll { lift in
            lift.name.allSatisfy(\.isWhitespace)
        }
        if workout.lifts.isEmpty{
            workout.lifts.append(Lift(id:
               Lift.ID(UUID()), name: "", reps: "", weight: "", complete: false))
        }
        self.workouts.append(workout)
    }
    
    func workoutTapped(workout: Workout){
        self.destination = .detail(WorkoutDetailModel(workout: workout))
    }
    
    func deleteWorkout(workout: Workout) {
            let confirmDelete = AlertItem(
                title: "Delete Workout",
                message: "Are you sure you want to delete this workout?",
                primaryButtonTitle: "Delete",
                secondaryButtonTitle: "Cancel"
            ) {
                withAnimation {
                    self.workouts.remove(id: workout.id)
                    self.destination = nil
                }
            }
            
            // Show the confirmation alert
            self.alertItem = confirmDelete
        }

    
    private func bind() {
        switch self.destination{
        case let .detail(workoutDetailModel):
            workoutDetailModel.onConfirmDeletion = { [weak self, id = workoutDetailModel.workout.id] in
                guard let self else {return}
                
                withAnimation {
                    self.workouts.remove(id: id)
                    self.destination = nil
                }
            }
            
            self.destinationCancellable = workoutDetailModel.$workout
                .sink { [weak self] workout in
                    guard let self else { return }
                    self.workouts[id: workout.id] = workout
                }
            
        case .add, .confirmation, .none:
            break
        }
    }
}




struct WorkoutsList: View {
  @ObservedObject var model: WorkoutsListModel
    
    @State private var showAlert = false

    var sortedWorkouts: [Workout] {
         self.model.workouts.sorted { $0.date < $1.date }
     }
    
  var body: some View {
    NavigationStack {
      List {
        ForEach(sortedWorkouts) { workout in
            Button{
                self.model.workoutTapped(workout: workout)
            } label: {
                CardView(workout: workout)
            }
            .listRowBackground(workout.theme.mainColor)

        }.onDelete { indices in
            for index in indices {
                let workout = self.sortedWorkouts[index]
                self.model.deleteWorkout(workout: workout)
            }
        }
      }
      .toolbar{
          Button {
              self.model.addWorkoutButtonTapped()
          } label: {
              Image(systemName: "plus")
          }
      }
      .navigationTitle("Workouts")
      .sheet(
        unwrapping: self.$model.destination,
        case: CasePath(WorkoutsListModel.Destination.add)
      ){ $model in
          NavigationStack{
              EditWorkoutView(model: model)
                  .navigationTitle("New Workout")
                  .toolbar{
                      ToolbarItem(placement: .cancellationAction){
                          Button("Dismiss"){
                              self.model.dismissAddWorkoutButtonTapped()
                          }
                      }
                      ToolbarItem(placement: .confirmationAction){
                          Button("Add"){
                              self.model.confirmAddWorkoutButtonTapped()
                          }
                      }
                  }
          }
      }
      .alert(item: self.$model.alertItem) { alertItem in
                  Alert(
                      title: Text(alertItem.title),
                      message: Text(alertItem.message),
                      primaryButton: .destructive(Text(alertItem.primaryButtonTitle), action: alertItem.action),
                      secondaryButton: .cancel(Text(alertItem.secondaryButtonTitle))
                  )
              }
      .navigationDestination(
            unwrapping: self.$model.destination,
            case: /WorkoutsListModel.Destination.detail
            ){ $detailModel in
              WorkoutDetailView(model: detailModel)
            }
    }
  }
}

struct CardView: View {
  let workout: Workout

  var body: some View {
    VStack(alignment: .leading) {
      Text(self.workout.title)
        .font(.headline)
      Spacer()
      HStack {
          Image(systemName: "calendar")
          Text(self.workout.date, style: .date)
        Spacer()
      }
      .font(.caption)
    }
    .padding()
    .foregroundColor(self.workout.theme.accentColor)
  }
}

struct TrailingIconLabelStyle: LabelStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.title
      configuration.icon
    }
  }
}

extension LabelStyle where Self == TrailingIconLabelStyle {
  static var trailingIcon: Self { Self() }
}

// helps save data?
extension URL {
    static let workouts = Self.documentsDirectory
        .appending(component: "workouts.json")
}

struct WorkoutsList_Previews: PreviewProvider {
  static var previews: some View {
      WorkoutsList(model: WorkoutsListModel())
  }
}

