//
//  PollVM.swift
//  CuriousPolls
//
//  Created by Rosa Jeon on 2023-07-18.
//

import Foundation
import FirebaseFirestore
import SwiftUI
import Observation

@Observable
class PollViewModel {
    let db = Firestore.firestore()
    let pollId: String
    
    var isLoading = false
    
    var poll: Poll? = nil
    
    init(pollId: String, poll: Poll? = nil) {
        self.pollId = pollId
        self.poll = poll
    }
    
    @MainActor
    func listenToPoll() {
        db.document("polls/\(pollId)")
            .addSnapshotListener { snapshot, error in
                guard let snapshot else { return }
                do {
                    let poll = try snapshot.data(as: Poll.self)
                    withAnimation {
                        self.poll = poll
                    }
                } catch {
                    print("Failed to fetch poll")
                }
            }
    }
    
    func incrementOption(_ option: Option ) {
        guard let index = poll?.options.firstIndex(where: {$0.id == option.id}) else { return }
        db.document("polls/\(pollId)")
            .updateData([
                "totalCount": FieldValue.increment(Int64(1)),
                "option\(index).count": FieldValue.increment(Int64(1)),
                "lastUpdatedOptionId": option.id,
                "updatedAt": FieldValue.serverTimestamp()
            ]) { error in
                print(error?.localizedDescription ?? "")
            }
    }
    
    @MainActor
    func deletePoll() async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await db.document("polls/\(pollId)").delete()
            // Optionally, you can perform any additional actions after deletion if needed.
            // For example, you could navigate back to the home screen after deleting the poll.
            // You can add this code inside the "defer" block.

        } catch {
            print("Error deleting poll: \(error.localizedDescription)")
            // Optionally, you can handle the error here or show an alert to the user.
        }
    }
}
