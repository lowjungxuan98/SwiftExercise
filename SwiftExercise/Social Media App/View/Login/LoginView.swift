//
//  LoginView.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 08/12/2022.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

struct LoginView: View {
    @State var emailID: String=""
    @State var password: String=""

    // MARK: View Properties

    @State var createAccount: Bool=false
    @State var showError: Bool=false
    @State var errorMessage: String=""
    @State var isLoading: Bool=false

    // MARK: User Defaults

    @AppStorage("log_status") var logStatus: Bool=false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String=""
    @AppStorage("user_UID") var userUID: String=""

    var body: some View {
        VStack(spacing: 10) {
            Text("Lets Sign you in")
                .font(.largeTitle.bold())
                .hAlign(.leading)

            Text("Welcome Back,\nYou have been missed")
                .font(.title3)
                .hAlign(.leading)

            VStack(spacing: 12) {
                TextField("Email", text: $emailID)
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    .padding(.top, 25)

                SecureField("Password", text: $password)
                    .textContentType(.password)
                    .border(1, .gray.opacity(0.5))

                Button("Reset Password") { resetPassword() }
                    .font(.callout)
                    .fontWeight(.medium)
                    .tint(.black)
                    .hAlign(.trailing)

                Button { loginUser() } label: {
                    // MARK: Login Button

                    Text("Sign in")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillview(.black)
                }
                .padding(.top, 10)
            }

            // MARK: Register Button

            HStack {
                Text("Don't have an account?")
                    .foregroundColor(.gray)

                Button("Register Now") {
                    createAccount.toggle()
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .vAlign(.top)
        .padding(15)
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        .fullScreenCover(isPresented: $createAccount) {
            RegisterView()
        }

        // MARK: Displaying Alert

        .alert(errorMessage, isPresented: $showError) {}
    }

    func loginUser() {
        self.isLoading=true
        closeKeyboard()
        _Concurrency.Task {
            do {
                // With the help of Swift Concurrency Auth can be done with Single Line
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                try await fetchUser()
            } catch {
                await setError(error)
            }
        }
    }

    // MARK: If User if Found then Fetching User Data From Firebase

    func fetchUser() async throws {
        guard let userID=Auth.auth().currentUser?.uid else { return }
        let user=try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)

        // MARK: UI Updating Must be Run On Main Thread

        await MainActor.run(body: {
            // Setting UserDefault data and Changing App's Auth Status
            userUID=userID
            userNameStored=user.username
            profileURL=user.userProfileURL
            logStatus=true
        })
    }

    func resetPassword() {
        _Concurrency.Task {
            do {
                // With the help of Swift Concurrency Auth can be done with Single Line
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
            } catch {
                await setError(error)
            }
        }
    }

    // MARK: Displaying Error VIA Alert

    func setError(_ error: Error) async {
        // MARK: UI Must be Updated on Main Thread

        await MainActor.run(body: {
            errorMessage=error.localizedDescription
            showError.toggle()
            isLoading=false
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
