//
//  ContentView.swift
//  Privacy Redirect
//
//  Created by FIGBERT on 6/21/21.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("disableNitter") var disableNitter = false
    @AppStorage("disableReddit") var disableReddit = false
    @AppStorage("disableInvidious") var disableInvidious = false
    @AppStorage("disableSimplyTranslate") var disableSimplyTranslate = false
    @AppStorage("disableOsm") var disableOsm = false
    @AppStorage("disableSearchEngine") var disableSearchEngine = false
    @AppStorage("disableRimgo") var disableRimgo = false
    @AppStorage("disableLibremDB") var disableLibremDB = false
    @AppStorage("disableAmazon") var disableAmazon = false
    @State private var viewingSettings = false

    var body: some View {
        let redirectNitter = Binding<Bool>(
            get: { !self.disableNitter },
            set: { value in self.disableNitter = !value }
        )
        let redirectReddit = Binding<Bool>(
            get: { !self.disableReddit },
            set: { value in self.disableReddit = !value }
        )
        let redirectInvidious = Binding<Bool>(
            get: { !self.disableInvidious },
            set: { value in self.disableInvidious = !value }
        )
        let redirectSimplyTranslate = Binding<Bool>(
            get: { !self.disableSimplyTranslate },
            set: { value in self.disableSimplyTranslate = !value }
        )
        let redirectOsm = Binding<Bool>(
            get: { !self.disableOsm },
            set: { value in self.disableOsm = !value }
        )
        let redirectSearchEngine = Binding<Bool>(
            get: { !self.disableSearchEngine },
            set: { value in self.disableSearchEngine = !value }
        )
        let redirectRimgo = Binding<Bool>(
            get: { !self.disableRimgo },
            set: { value in self.disableRimgo = !value }
        )
        let redirectLibremDB = Binding<Bool>(
            get: { !self.disableLibremDB },
            set: { value in self.disableLibremDB = !value }
        )
        let redirectAmazon = Binding<Bool>(
            get: { !self.disableAmazon },
            set: { value in self.disableAmazon = !value }
        )

        return ScrollView {
            VStack {
                Spacer()
                Image(uiImage: UIImage(named: "LargeIcon")!)
                    .resizable()
                    .frame(
                        width: 150,
                        height: 150,
                        alignment: .center
                    )
                Text("Privacy Redirect")
                    .font(.title)
                Text("Enable the extension in Safari Settings")
                    .font(.subheadline)
                Spacer()
                VStack {
                    Group {
                        Toggle("Twitter / X Redirects", isOn: redirectNitter)
                        Toggle("Reddit Redirects", isOn: redirectReddit)
                        Toggle("YouTube Redirects", isOn: redirectInvidious)
                    }
                    Group {
                        Toggle("Google Translate Redirects", isOn: redirectSimplyTranslate)
                        Toggle("Google Maps Redirects", isOn: redirectOsm)
                        Toggle("Search Redirects", isOn: redirectSearchEngine)
                    }
                    Group {
                        Toggle("Imgur Redirects", isOn: redirectRimgo)
                        Toggle("IMDB Redirects", isOn: redirectLibremDB)
                        Toggle("Amazon Redirects", isOn: redirectAmazon)
                    }
                }
                    .frame(maxWidth: 500)
                    .padding()
                Spacer()
                Button("Instructions and Instance Settings") {
                    self.viewingSettings = true
                }
                Spacer()
            }
            .sheet(isPresented: $viewingSettings, content: {
                SettingsView()
            })
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
