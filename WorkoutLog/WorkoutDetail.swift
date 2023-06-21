//
//  WorkoutDetail.swift
//  Workouts
//
//  Created by Luke Cutting on 6/17/23.
//

import SwiftUI
import SwiftUINavigation
import XCTestDynamicOverlay

class WorkoutDetailModel: ObservableObject {
    @Published var destination: Destination?
    @Published var workout: Workout
    
    var onConfirmDeletion: () -> Void =
    unimplemented("WorkoutDetailModel.onConfirmDeletion")
    
    enum Destination {
        case alert(AlertState<AlertAction>)
        case edit(EditWorkoutModel)
        case lift(Lift)
    }
    enum AlertAction{
        case confirmDeletion
    }
    
    init(
        destination: Destination? = nil,
        workout: Workout
    ){
        self.workout = workout
    }
    
    func deleteLifts(atOffsets indices: IndexSet){
        self.workout.lifts.remove(atOffsets: indices)
    }
    
    func liftTapping(_ lift: Lift){
        self.destination = .lift(lift)
    }
    
    func deleteButtonTapped(){
        self.destination = .alert(.delete)
    }
    
    func finishButtonTapped() {
        for liftIndex in self.workout.lifts.indices {
            self.workout.lifts[liftIndex].complete = false
        }
    }

    
    func alertButtonTapped(_ action: AlertAction){
        switch action {
        case .confirmDeletion:
            self.onConfirmDeletion()
        }
    }
    
    func editButtonTapped() {
        self.destination = .edit(EditWorkoutModel(workout: self.workout))
    }
    
    func cancelEditButtonTapped() {
        self.destination = nil
    }
    
    func doneEditingButtonTapped() {
        guard case let .edit(model) = self.destination
        else { return }
        
        self.workout = model.workout
        self.destination = nil
    }
    
    func completeLift(_ value: Binding<Bool>){
        value.wrappedValue.toggle()
    }
    
  
}

extension AlertState where Action == WorkoutDetailModel.AlertAction{
    static let delete = AlertState(
        title: TextState("Delete"),
        message: TextState("Are you sure you want to delete this lift?"),
        buttons: [
            .destructive(TextState("Yes"), action:
                    .send(.confirmDeletion)),
            .cancel(TextState("Cancel"))
        ]
    )
}

struct GreyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? Color.gray.opacity(0.5) : Color.clear)
    }
}

struct WorkoutDetailView: View {
    @ObservedObject var model: WorkoutDetailModel
    
    @State private var isButtonPressed = false

    var body: some View {
        List {
            if !self.model.workout.lifts.isEmpty {
            
                    Section {
                        ForEach(self.$model.workout.lifts) { $lift in
                            if !lift.complete {
                                Button {
                                    withAnimation{
                                        self.model.completeLift($lift.complete)
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "circle")
                                            .onTapGesture {
                                            withAnimation{
                                                self.model.completeLift($lift.complete)
                                            }
                                        }
                                        
                                        Text(lift.name)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        Text(lift.reps)
                                            .foregroundColor(.primary)
                                        
                                        if lift.weight.count <= 5 {
                                            Text(lift.weight)
                                                .foregroundColor(.primary)
                                                .frame(width: 70)
                                        } else {
                                            Text(lift.weight)
                                                .foregroundColor(.primary)
                                                .frame(width: 110)
                                        }
                                    }
                                    .padding(.trailing, -15.0)
                                   
                                }
                                
                            }
                        }
                        .onDelete { indices in
                            self.model.deleteLifts(atOffsets: indices)
                        }
                    } header: {
                        Text("Lifts")
                    }
                
                Section {
                    ForEach(self.$model.workout.lifts) { $lift in
                        if lift.complete{
                            Button {
                               // self.model.liftTapping(lift)
                                withAnimation{
                                    self.model.completeLift($lift.complete)
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "checkmark")
                                        .onTapGesture {
                                            self.model.completeLift($lift.complete)
                                        }
                                    Text(lift.name).foregroundColor(.primary)
                                    Spacer()
                                    Text(lift.reps).foregroundColor(.primary)
                                    //.padding(.trailing, 10.0)
                                    if lift.weight.count <= 5 {
                                        Text(lift.weight)
                                            .foregroundColor(.primary)
                                            .frame(width: 70)
                                    } else {
                                        Text(lift.weight)
                                            .foregroundColor(.primary)
                                            .frame(width: 110)
                                    }
                                }
                                .padding(.trailing, -15.0)
                         
                            }
                          
                        }
                    }
                    .onDelete { indices in
                        self.model.deleteLifts(atOffsets: indices)
                    }
                } header: {
                    Text("Completed")
                }
            }
            Section {
                Button(action: {
                    let currentDate = Date() // Get the current date
                    model.workout.date = currentDate
                    withAnimation {
                        model.finishButtonTapped()
                    }
                    isButtonPressed = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                       isButtonPressed = false
                   }
                }) {
                    Text("Finish Workout")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(isButtonPressed ? Color.gray : Color.blue)
                
            }
            
//            Section {
//                Button("Delete Workout") {
//                    self.model.deleteButtonTapped()
//                }
//                .foregroundColor(.red)
//                .frame(maxWidth: .infinity)
//            }
        }
        .navigationTitle(self.model.workout.title)
        .toolbar {
            Button("Edit") {
                self.model.editButtonTapped()
            }
        }
        .navigationDestination(
            unwrapping: self.$model.destination,
            case: /WorkoutDetailModel.Destination.lift
        ){ $lift in
            LiftView(lift: lift, workout: self.model.workout)
        }
        .alert(
            unwrapping: self.$model.destination,
            case: /WorkoutDetailModel.Destination.alert
        ) { action in
            self.model.alertButtonTapped(action)
        }
        .sheet (
            unwrapping: self.$model.destination,
            case: /WorkoutDetailModel.Destination.edit
        ) { $editModel in
            NavigationStack{
                EditWorkoutView(model: editModel)
                    .navigationTitle(self.model.workout.title)
                    .toolbar{
                        ToolbarItem(placement: .cancellationAction){
                            Button("Cancel"){
                                self.model.cancelEditButtonTapped()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction){
                            Button("Done") {
                                self.model.doneEditingButtonTapped()
                            }
                        }
                    }
            }
        }
    }
}

// Drill down next page for when a past lift is Clicked
// This is where you would edit workouts
struct LiftView: View {
  let lift: Lift
  let workout: Workout

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Divider()
          .padding(.bottom)
        Text("Name")
          .font(.headline)
          Text(self.lift.name)
        Text("Reps")
          .font(.headline)
          .padding(.top)
          Text(self.lift.reps)
        Text("Weight")
          .font(.headline)
          .padding(.top)
        Text(self.lift.weight)
      }
    }
    .navigationTitle(
      Text(self.lift.name)
    )
    .padding()
  }
}

struct WorkoutDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WorkoutDetailView(model: WorkoutDetailModel(workout: .mock))
        }
    }
}

