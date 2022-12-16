//
//  ProfileView.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 15/12/2022.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage
import PhotosUI
import SwiftUI

struct ProfileView: View {
    // MARK: My Profile Data

    @State private var myProfile: User?
    @AppStorage("log_status") var logStatus: Bool = false

    // MARK: View Properties

    @State var errorMessage: String = ""
    @State var showError: Bool = false
    @State var isLoading: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                if let myProfile {
                    ReusableProfileContent(user: myProfile)
                        .refreshable {
                            // MARK: Refresh User Data

                            self.myProfile = nil
                            await fetchUserData()
                        }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("My Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        // MARK: Two Action's

                        // 1. Logout
                        Button("Logout", action: logOutUser)
                        // 2. Delete Account
                        Button("Delete Account", role: .destructive, action: deleteAccount)
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: 90))
                            .tint(.black)
                            .scaleEffect(0.8)
                    }
                }
            }
        }
        .overlay {
            LoadingView(show: $isLoading)
        }
        .alert(errorMessage, isPresented: $showError) {}
        .task {
            // This Modifier is like onAppear
            // So Fetching for the First Time only
            if myProfile != nil { return }

            // MARK: Initial Fetch

            await fetchUserData()
        }
    }

    // MARK: Fetching User Data

    func fetchUserData() async {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        guard let user = try? await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self) else { return }
        await MainActor.run(body: {
            myProfile = user
        })
    }

    // MARK: Logging User Out

    func logOutUser() {
        try? Auth.auth().signOut()
        logStatus = false
    }

    // MARK: Deleting User Entire Account

    func deleteAccount() {
        isLoading = true
        _Concurrency.Task {
            do {
                guard let userID = Auth.auth().currentUser?.uid else { return }
                // Step 1: First Delete Profile Image from Storage
                let reference = Storage.storage().reference().child("Profile_Images").child(userID)
                try await reference.delete()
                // Step 2: Delete Firestore User Document
                try await Firestore.firestore().collection("Users").document(userID).delete()
                // Final Step: Deleting Auth Account and Setting Log Status to False
                try await Auth.auth().currentUser?.delete()
                logStatus = false
            } catch {
                await setError(error)
            }
        }
    }

    // MARK: Setting Error

    func setError(_ error: Error) async {
        // MARK: UI Must be run on Main Thread

        await MainActor.run(body: {
            isLoading = false
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
