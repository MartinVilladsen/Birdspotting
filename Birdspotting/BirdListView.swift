import SwiftUI
import FirebaseCore
import CoreLocation

struct BirdListView: View {
    @Environment(BirdController.self) private var birdController
    @State private var isShowingAddNewBird = false

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(birdController.birds, id: \ .id) { bird in
                        NavigationLink(destination: BirdView(bird: bird)) {
                            BirdRow(bird: bird)
                        }
                    }
                    .onDelete { indexSet in
                        birdController.delete(at: indexSet)
                    }

                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Birds")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isShowingAddNewBird = true
                    }) {
                        Label("Add Bird", systemImage: "plus.circle.fill")
                    }
                    .sheet(isPresented: $isShowingAddNewBird) {
                        AddNewBirdView()
                            .presentationDetents([.medium, .large])
                    }
                }
            }
        }
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }
}

#Preview {
    BirdListView().environment(BirdController())
}
