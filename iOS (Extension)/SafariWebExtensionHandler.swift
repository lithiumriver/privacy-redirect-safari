//
//  SafariWebExtensionHandler.swift
//  Privacy Redirect (iOS) Extension
//
//  Created by figbert on 10/3/21.
//

import SafariServices
import os.log

let SFExtensionMessageKey = "message"

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems[0] as! NSExtensionItem
        let message = item.userInfo?[SFExtensionMessageKey]
        os_log(.default, "Received message from browser.runtime.sendNativeMessage: %@", message as! CVarArg)

        let defaults = UserDefaults(suiteName: "group.com.lithiumriver.Privacy-Redirect-for-Safari")
        let response = NSExtensionItem()

        let messageDict = message as? [String: String]
        if messageDict?["message"] == "redirectSettings" {
            response.userInfo = [
                SFExtensionMessageKey: [
                    "nitter": !(defaults?.bool(forKey: "disableNitter") ?? false),
                    "reddit": !(defaults?.bool(forKey: "disableReddit") ?? false),
                    "invidious": !(defaults?.bool(forKey: "disableInvidious") ?? false),
                    "simplyTranslate": !(defaults?.bool(forKey: "disableSimplyTranslate") ?? false),
                    "osm": !(defaults?.bool(forKey: "disableOsm") ?? false),
                    "searchEngine": !(defaults?.bool(forKey: "disableSearchEngine") ?? false),
                    "rimgo": !(defaults?.bool(forKey: "disableRimgo") ?? false),
                    "libremdb": !(defaults?.bool(forKey: "disableLibremDB") ?? false),
                    "amazon": !(defaults?.bool(forKey: "disableAmazon") ?? false),
                ]
            ]
        } else if messageDict?["message"] == "instanceSettings" {
            let nitter = defaults?.string(forKey: "nitterInstance") ?? "xcancel.com"
            let reddit = defaults?.string(forKey: "redditInstance") ?? "redlib.catsarch.com"
            let invidious = defaults?.string(forKey: "invidiousInstance") ?? "yewtu.be"
            let simplyTranslate = defaults?.string(forKey: "simplyTranslateInstance") ?? "simplytranslate.org"
            let osm = defaults?.string(forKey: "osmInstance") ?? "openstreetmap.org"
            let searchEngine = defaults?.string(forKey: "searchEngineInstance") ?? "duckduckgo.com/"
            let rimgo = defaults?.string(forKey: "rimgoInstance") ?? "rimgo.pussthecat.org"
            let libremdb = defaults?.string(forKey: "libremDBInstance") ?? "libremdb.iket.me"
            response.userInfo = [
                SFExtensionMessageKey: [
                    "nitter": nitter,
                    "reddit": reddit,
                    "invidious": invidious,
                    "simplyTranslate": simplyTranslate,
                    "osm": osm,
                    "searchEngine": searchEngine,
                    "rimgo": rimgo,
                    "libremdb": libremdb,
                ]
            ]
        }

        context.completeRequest(returningItems: [response], completionHandler: nil)
    }

}
