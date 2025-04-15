import SwiftUI
import CoreLocation
import MapKit
import FirebaseCore

struct BirdView: View {
    @Environment(BirdController.self) private var birdController
    @State private var cameraPosition: MapCameraPosition?
    let bird: Bird
    
    var image: Image? {
        if let data = bird.image, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(bird.species.rawValue)
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Text(bird.date.dateValue().formatted(date: .numeric, time: .shortened))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                image?
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
                
                
                Divider()
                
                if let cameraPosition = cameraPosition {
                    MapReader { mapProxy in
                        Map(position: .constant(cameraPosition), interactionModes: .all) {
                            Marker("\(bird.species.rawValue)", coordinate: bird.location.coordinate)
                                .tint(.red)
                        }
                    }
                    .mapStyle(.hybrid)
                    .frame(height: 200)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                } else {
                    Text("Loading map...")
                        .frame(height: 200)
                }
                
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.blue)
                    Text("\(bird.location.latitude, specifier: "%.5f"), \(bird.location.longitude, specifier: "%.5f")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let note = bird.note, !note.isEmpty {
                    Divider()
                    Text("Note")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    Text(note)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding(8)
                        .cornerRadius(8)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(nil)
                    
                }
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            .onAppear {
                cameraPosition = .camera(MapCamera(
                    centerCoordinate: bird.location.coordinate, distance: 300, pitch: 40
                ))
            }
        }
    }
}

#Preview {
    BirdView(bird: Bird(
        id: "123",
        species: .Liverbird,
        date: Timestamp(date: Date()),
        location: Bird.Location(coordinate: CLLocationCoordinate2D(latitude: 55.6761, longitude: 12.5683)),
        note: "Life is a mystery Everyone must stand alone I hear you call my name And it feels like home When you call my name, it's like a little prayer I'm down on my knees, I wanna take you there In the midnight hour, I can feel your power Just like a prayer, you know I'll take you there I hear your voice It's like an angel sighin' I have no choice I hear your voice Feels like flying I close my eyes Oh God I think I'm fallin' Out of the sky I close my eyes Heaven help me When you call my name, it's like a little prayer I'm down on my knees, I wanna take you there In the midnight hour, I can feel your power Just like a prayer, you know I'll take you there Like a child You whisper softly to me You're in control Just like a child Now I'm dancing It's like a dream No end and no beginning You're here with me It's like a dream Let the choir sing When you call my name, it's like a little prayer I'm down on my knees, I wanna take you there In the midnight hour, I can feel your power Just like a prayer, you know I'll take you there When you call my name, it's like a little prayer I'm down on my knees, I wanna take you there In the midnight hour, I can feel a power Just like a prayer, you know I'll take you there Life is a mystery Everyone must stand alone I hear you call my name And it feels like home Just like a prayer (oh-oh), your voice can take me there (oh-oh) Just like a muse to me (oh-oh), you are a mystery (oh-oh) Just like a dream (oh-oh), you are not what you seem Just like a prayer, no choice your voice can take me there mmm mm (Just like a prayer, I'll take you there) I'll take you there (It's like a dream to me) whoa oh-oh-oh (Just like a prayer, I'll take you there) I'll take you there (It's like a dream to me) oh yeah, oh yeah yeah yeah yeah (Just like a prayer, I'll take you there) oh yeah yeah yee (It's like a dream to me) whoa oh-oh Just like a prayer, your voice can take me there (just like a prayer) Just like a muse to me, you are a mystery (your voice can take me there) Just like a dream, you are not what you seem (just like a prayer) Just like a prayer, no choice your voice can take me there Just like a prayer, your voice can take me there (just like a prayer) Just like a muse to me, you are a mystery (your voice can take me there) Just like a dream, you are not what you seem (just like a prayer) Just like a prayer, no choice your voice can take me there your voice can take me there (Your voice can take me there) just like a prayer (Just like a prayer) (Just like a prayer) (Your voice can take me there) (Just like a prayer) (Just like a prayer) (Your voice can take me there) (Just like a prayer)",
        image: nil
    )).environment(BirdController())
}
