import SwiftUI

struct FilteredBirdsView: View {
    @Environment(BirdController.self) private var birdController
    @State private var selectedSpecies: Bird.SPECIES? = nil
    @State private var isGroupedBySpecies: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                Toggle("Group by Species", isOn: $isGroupedBySpecies)
                    .padding()

                HStack {
                    if !isGroupedBySpecies {
                        Text("Filter by species")
                        Picker("", selection: $selectedSpecies) {
                            Text("All").tag(Bird.SPECIES?.none)
                            ForEach(Bird.SPECIES.allCases, id: \.self) { species in
                                Text(species.rawValue).tag(species as Bird.SPECIES?)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(1)
                    }
                }

                List {
                    if isGroupedBySpecies {
                        ForEach(Bird.SPECIES.allCases, id: \.self) { species in
                            Section(header: Text(species.rawValue)) {
                                ForEach(birdController.birds.filter { $0.species == species }, id: \.id) { bird in
                                    NavigationLink(destination: BirdView(bird: bird)) {
                                        BirdRow(bird: bird)
                                    }
                                }
                            }
                        }
                    } else {
                        ForEach(birdController.filteredBirds(for: selectedSpecies), id: \.id) { bird in
                            NavigationLink(destination: BirdView(bird: bird)) {
                                BirdRow(bird: bird)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filter Birds")
        }
    }
}

#Preview {
    FilteredBirdsView().environment(BirdController())
}
