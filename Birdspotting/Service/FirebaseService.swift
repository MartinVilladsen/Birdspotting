import Foundation
import FirebaseFirestore

struct FirebaseService {
    private let dbCollection = Firestore.firestore().collection("birds")
    private var listener: ListenerRegistration?
    
    mutating func setUpListener(callback: @escaping ([Bird])->Void) {
        listener = dbCollection.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
            return
        }
            let birds = documents.compactMap { queryDocumentSnapshot -> Bird? in
                return try? queryDocumentSnapshot.data(as: Bird.self)
            }
            callback(birds.sorted{$0.date.dateValue() < $1.date.dateValue()})
        }
    }
    
    mutating func tearDownListener() {
        listener?.remove()
        listener = nil
    }
    
    func addBird(bird: Bird) {
        do {
            let _ = try dbCollection.addDocument(from: bird)
        } catch {
            print(error)
        }
    }
        
    func deleteBird(bird: Bird) {
        guard let documentId = bird.id else {return}
        dbCollection.document(documentId).delete() { error in
            if let error {
                print(error)
            }
        }
    }
}
