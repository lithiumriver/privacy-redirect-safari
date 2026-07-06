//
//  InstancesView.swift
//  Privacy Redirect
//
//  Created by figbert on 15/7/22.
//

import SwiftUI

struct InstancesView: View {
    @AppStorage("useCustomNitterInstance") var useCustomNitterInstance = false
    @AppStorage("useCustomRedditInstance") var useCustomRedditInstance = false
    @AppStorage("useCustomInvidiousInstance") var useCustomInvidiousInstance = false
    @AppStorage("useCustomSimplyTranslateInstance") var useCustomSimplyTranslateInstance = false
    @AppStorage("useCustomOsmInstance") var useCustomOsmInstance = false
    @AppStorage("useCustomSearchEngineInstance") var useCustomSearchEngineInstance = false
    @AppStorage("useCustomRimgoInstance") var useCustomRimgoInstance = false
    @AppStorage("useCustomLibremDBInstance") var useCustomLibremDBInstance = false

    @AppStorage("nitterInstance") var nitterInstance = "xcancel.com"
    @AppStorage("redditInstance") var redditInstance = "redlib.catsarch.com"
    @AppStorage("invidiousInstance") var invidiousInstance = "yewtu.be"
    @AppStorage("simplyTranslateInstance") var simplyTranslateInstance = "simplytranslate.org"
    @AppStorage("osmInstance") var osmInstance = "openstreetmap.org"
    @AppStorage("searchEngineInstance") var searchEngineInstance = "duckduckgo.com/"
    @AppStorage("rimgoInstance") var rimgoInstance = "rimgo.pussthecat.org"
    @AppStorage("libremDBInstance") var libremDBInstance = "libremdb.iket.me"

    let instances = Instances()

    var body: some View {
        InstanceViewContainer {
            Group {
                InstanceSection(
                    name: "Twitter / X",
                    customInstance: $useCustomNitterInstance,
                    instance: $nitterInstance,
                    instances: instances.nitter)
                InstanceSection(
                    name: "Reddit",
                    customInstance: $useCustomRedditInstance,
                    instance: $redditInstance,
                    instances: instances.reddit)
                InstanceSection(
                    name: "YouTube",
                    customInstance: $useCustomInvidiousInstance,
                    instance: $invidiousInstance,
                    instances: instances.invidious)
            }
            Group {
                InstanceSection(
                    name: "Google Translate",
                    customInstance: $useCustomSimplyTranslateInstance,
                    instance: $simplyTranslateInstance,
                    instances: instances.simplyTranslate)
                InstanceSection(
                    name: "Google Maps",
                    customInstance: $useCustomOsmInstance,
                    instance: $osmInstance,
                    instances: instances.maps)
                #if os(iOS)
                VStack(alignment: .leading) {
                    Text("Search")
                        .font(.headline)
                    HStack {
                        if !useCustomSearchEngineInstance {
                            Picker(selection: $searchEngineInstance,
                                   label: Text("Instance"), content: {
                                ForEach(instances.searchEngines, id: \.id) { instance in
                                    Text("\(instance.link)").tag(instance.url)
                                }
                            })
                            .labelsHidden()
                        } else {
                            TextField("Search Engine Instance (including path)", text: $searchEngineInstance)
                        }
                        Spacer()
                        Toggle("Custom", isOn: $useCustomSearchEngineInstance)
                            .labelsHidden()
                    }
                }
                #else
                Section(header: Text("Search").bold(), content: {
                    HStack {
                        if !useCustomSearchEngineInstance {
                            Picker(selection: $searchEngineInstance,
                                   label: Text("Instance"), content: {
                                ForEach(instances.searchEngines, id: \.id) { instance in
                                    Text("\(instance.link)").tag(instance.url)
                                }
                            })
                        } else {
                            TextField("Search Engine Instance (including path)", text: $searchEngineInstance)
                        }
                        Toggle("Custom", isOn: $useCustomSearchEngineInstance)
                    }
                })
                #endif
            }
            Group {
                InstanceSection(
                    name: "Imgur",
                    customInstance: $useCustomRimgoInstance,
                    instance: $rimgoInstance,
                    instances: instances.rimgo)
                InstanceSection(
                    name: "LibremDB",
                    customInstance: $useCustomLibremDBInstance,
                    instance: $libremDBInstance,
                    instances: instances.libremdb)
            }
        }
    }
}

struct InstancesView_Previews: PreviewProvider {
    static var previews: some View {
        InstancesView()
    }
}
