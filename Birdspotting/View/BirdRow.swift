import SwiftUI
import FirebaseCore
import CoreLocation

struct BirdRow: View {
    let bird: Bird

    var body: some View {
        HStack(spacing: 12) {
            if let imageData = bird.image, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .prettyPicture()
            } else {
                Image("birdpic")
                    .resizable()
                    .prettyPicture()
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(bird.species.rawValue)
                    .font(.headline)
                Text("Seen: \(bird.date.dateValue().formatted(date: .numeric, time: .shortened))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}


struct PrettyPictureModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scaledToFill()
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .shadow(radius: 3)
    }
}

extension View {
    func prettyPicture() -> some View {
        self.modifier(PrettyPictureModifier())
    }
}

#Preview {
    BirdRow(bird: Bird(
        id: "123",
        species: .Liverbird,
        date: Timestamp(date: Date()),
        location: Bird.Location(coordinate: CLLocationCoordinate2D(latitude: 55.6761, longitude: 12.5683)),
        note: "HEHE",
        image: nil
    ))
}
