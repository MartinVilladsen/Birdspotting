import SwiftUI
import CoreLocation
import FirebaseCore
import MapKit
import PhotosUI

struct AddNewBirdView: View {
    @Environment(BirdController.self) private var birdController
    @Environment(\.dismiss) private var dismiss

    @State private var selectedSpecies: Bird.SPECIES = .Liverbird
    @State private var note: String = ""
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data? = UIImage(named: "birdpic")?.jpegData(compressionQuality: 0.3)
    
    @State private var camera: MapCamera?
    private var locationManager = CLLocationManager()


    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Species")) {
                    Picker("Select Species", selection: $selectedSpecies) {
                        ForEach(Bird.SPECIES.allCases, id: \.self) { species in
                            Text(species.rawValue).tag(species)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section(header: Text("Select photo")) {
                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Label("Select Photo", systemImage: "photo")
                    }
                    .onChange(of: selectedPhoto) { oldValue, newValue in
                        Task {
                            if let data = try? await newValue?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data),
                               let compressedData = uiImage.jpegData(compressionQuality: 0.3) {
                                selectedImageData = compressedData
                            }
                        }
                    }

                    if let imageData = selectedImageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                            .padding()
                    } else {
                        Text("No image selected")
                            .foregroundColor(.secondary)
                    }
                }

                Section(header: Text("Location")) {
                    if let camera = camera {
                        MapReader { mapProxy in
                            Map(position: .constant(.camera(camera)), interactionModes: .all) {
                                Marker("\(selectedSpecies)", coordinate: camera.centerCoordinate)
                                    .tint(.red)
                            }
                        }
                        .mapStyle(.hybrid())
                        .frame(height: 200)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    } else {
                        Text("Loading map...")
                            .frame(height: 200)
                    }
                }

                Section(header: Text("Note")) {
                    TextField("Attach a note", text: $note)
                }
            }
            .navigationTitle("New Spotted Bird")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        guard let centerCoordinate = camera?.centerCoordinate else {return}

                        birdController.add(
                            species: selectedSpecies,
                            date: Date(),
                            location: centerCoordinate,
                            note: note.isEmpty ? nil : note,
                            imageData: selectedImageData
                        )
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .onAppear {
                guard let location = birdController.getCurrentLocation() else { return }
                camera = MapCamera(
                    centerCoordinate: location, distance: 300, pitch: 40
                )
            }
        }
    }
}


#Preview {
    AddNewBirdView().environment(BirdController())
}
