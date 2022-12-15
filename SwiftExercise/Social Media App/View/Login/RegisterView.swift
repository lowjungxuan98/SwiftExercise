//
//  RegisterView.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 09/12/2022.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage
import PhotosUI
import SwiftUI

struct RegisterView: View {
    @State var emailID: String=""
    @State var password: String=""
    @State var userName: String=""
    @State var userBio: String=""
    @State var userBioLink: String=""
    @State var userProfilePicData: Data?
    
    // MARK: View Properties
    
    @Environment(\.dismiss) var dismiss
    @State var showImagePicker: Bool=false
    @State var photoItem: PhotosPickerItem?
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
            Text("Lets Register\nAccount")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            Text("Hello user, have a wonderful journey")
                .font(.title3)
                .hAlign(.leading)
            
            // MARK: For Small Size Optimization
            
            ViewThatFits {
                ScrollView(.vertical, showsIndicators: false) {
                    HelperView()
                }
                HelperView()
            }
            
            // MARK: Register Button
            
            HStack {
                Text("Already have an account?")
                    .foregroundColor(.gray)
                
                Button("Login Now") {
                    dismiss()
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
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { newValue in
            
            // MARK: Register Button
            
            if let newValue {
                _Concurrency.Task {
                    do {
                        guard let imageData=try await newValue.loadTransferable(type: Data.self) else { return }
                        
                        // MARK: UI Must be Updated on Main Thread
                        
                        await MainActor.run(body: {
                            userProfilePicData=imageData
                        })
                    } catch {}
                }
            }
        }
        
        // MARK: Displaying Alert
        
        .alert(errorMessage, isPresented: $showError) {}
    }
    
    @ViewBuilder
    func HelperView() -> some View {
        VStack(spacing: 12) {
            ZStack {
                if let userProfilePicData, let image=UIImage(data: userProfilePicData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image("NullProfile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .frame(width: 85, height: 85)
            .clipShape(Circle())
            .contentShape(Circle())
            .onTapGesture {
                showImagePicker.toggle()
            }
            .padding(.top, 25)
            
            TextField("Username", text: $userName)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            TextField("Email", text: $emailID)
                .autocapitalization(.none)
                .textContentType(.emailAddress)
                .border(1, .gray.opacity(0.5))
            
            SecureField("Password", text: $password)
                .textContentType(.password)
                .border(1, .gray.opacity(0.5))
            
            TextField("About You", text: $userBio, axis: .vertical)
                .frame(minHeight: 100, alignment: .top)
                .textContentType(.none)
                .border(1, .gray.opacity(0.5))
            
            TextField("Bio Link (Optional)", text: $userBioLink)
                .autocapitalization(.none)
                .textContentType(.none)
                .border(1, .gray.opacity(0.5))
            
            Button { registerUser() } label: {
                // MARK: Register Button
                
                Text("Sign up")
                    .foregroundColor(.white)
                    .hAlign(.center)
                    .fillview(.black)
            }
            .disableWithOpacity(userName == "" || userBio == "" || emailID == "" || password == "" || userProfilePicData == nil)
            .padding(.top, 10)
        }
    }
    
    func registerUser() {
        isLoading=true
        closeKeyboard()
        _Concurrency.Task {
            do {
                // Step 1: Creating Firebase Account
                try await Auth.auth().createUser(withEmail: emailID, password: password)
                
                // Step 2: Uploading Profile Photo Into Firebase Storage
                guard let userID=Auth.auth().currentUser?.uid else { return }
                guard let imageData=userProfilePicData else { return }
                let storageRef=Storage.storage().reference().child("Profile_Images").child(userID)
                let _=try await storageRef.putDataAsync(imageData)
                
                // Step 3: Downloading Photo URL
                let downloadURL=try await storageRef.downloadURL()
                
                // Step 4: Creating a User Firestore Object
                let user=User(username: userName, userBio: userBio, userBioLink: userBioLink, userUID: userID, userEmail: emailID, userProfileURL: downloadURL)
                
                // Step 5: Saving User Doc into Firestore Database
                let _=try Firestore.firestore().collection("Users").document(userID).setData(from: user, completion: { error in
                    if error == nil {
                        // MARK: Print Saved Successfully
                        
                        print("Saved Successfully")
                        userNameStored=userName
                        self.userUID=userID
                        profileURL=downloadURL
                        logStatus=true
                    }
                })
            } catch {
                // MARK: Deleting Created Account In Case of Failure
                
                try await Auth.auth().currentUser?.delete()
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

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        SocialMediaApp()
    }
}
