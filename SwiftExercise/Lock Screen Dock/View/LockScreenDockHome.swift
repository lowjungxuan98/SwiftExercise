//
//  LockScreenDockHome.swift
//  SwiftExercise
//
//  Created by Low Jung Xuan on 12/12/2022.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct LockScreenDockHome: View {
    // MARK: Added Shortcuts Data

    @State var addedShortcuts: [AppLink] = []
    @State var availableAppLinks: [AppLink] = []
    var body: some View {
        List {
            Section {
                HStack(spacing: 0) {
                    ForEach(addedShortcuts) { link in
                        Image(link.name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                withAnimation {
                                    addedShortcuts.removeAll(where: { $0 == link })
                                }
                            }
                    }
                }
                .frame(height: 85)
            } header: {
                Text("Preview")
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

            Section {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(availableAppLinks.filter { !addedShortcuts.contains($0) }) { link in
                            VStack(spacing: 8) {
                                Image(link.name)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)

                                Text(link.name)
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    addedShortcuts.append(link)
                                }
                            }
                        }
                    }
                    .frame(height: 100)
                    .padding(10)
                }

                // MARK: We're only allowing max of 4 apps on the dock

                .disabled(addedShortcuts.count >= 4)
                .opacity(addedShortcuts.count >= 4 ? 0.6 : 1)
            } header: {
                Text("Tap to add shortcut")
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

            Button(action: addDocktoLockScreen) {
                HStack {
                    Text("Add Lockscreen Dock")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: "dock.rectangle")
                }
            }

            // MARK: Minimum 2 Apps needed to add dock to lockscreen

            .disabled(addedShortcuts.count < 2)
            .opacity(addedShortcuts.count < 2 ? 0.6 : 1)
        }
        .onAppear {
            // MARK: Checking Which App's are available in the User's iPhone

            // And Updating Applink Model based on that so that unavailable apps won't appear on the Home Screen
            for link in appLinks {
                if let url = URL(string: link.deepLink) {
                    if UIApplication.shared.canOpenURL(url) {
                        // Available on the iPhone
                        var updatedLink = link
                        updatedLink.appURL = url
                        availableAppLinks.append(updatedLink)
                    }
                    // Else App not found on the iPhone
                }
                // Else Invalid URL
            }
        }
    }

    func addDocktoLockScreen() {
        // MARK: Removing All Existing Activities Which Was added before

        removeExistingDock()

        // MARK: Live Activity Code Goes Here

        // Step 1: Creating Live Activity Attribute
        let activityAttribute = DockAttributes(name: "LockScreen Dock", addedLinks: addedShortcuts)

        // Step 2: Creating Content State for the Live Activity Attribute
        let initialContentState = DockAttributes.ContentState()

        // Step 3: Adding Live activity to the Lock Screen
        do {
            // Step 4: Creating Activity
            let activity = try Activity<DockAttributes>.request(attributes: activityAttribute, contentState: initialContentState)
            print("Activity Added \(activity.id)")
        } catch {
            print(error.localizedDescription)
        }
    }

    func removeExistingDock() {
        _Concurrency.Task {
            for activity in Activity<DockAttributes>.activities{
                await activity.end(dismissalPolicy: .immediate)
            }
        }
    }
}

struct LockScreenDockHome_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenDock()
    }
}
