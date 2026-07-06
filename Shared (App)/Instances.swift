//
//  Instances.swift
//  Privacy Redirect
//
//  Created by figbert on 3/4/22.
//

import Foundation


struct Instances {
    public let nitter = [
        "xcancel.com",
        "nitter.net",
        "nitter.poast.org",
        "lightbrd.com",
    ]
    public let reddit = [
        "redlib.catsarch.com",
        "safereddit.com",
        "redlib.perennialte.ch",
    ]
    public let invidious = [
        "yewtu.be",
        "inv.nadeko.net",
        "invidious.nerdvpn.de",
    ]
    public let simplyTranslate = [
        "simplytranslate.org",
        "translate.projectsegfau.lt",
        "translate.plausibility.cloud",
    ]
    public let maps = [
         "openstreetmap.org",
    ]
    public let searchEngines = [
        SearchEngineInstance("duckduckgo.com"),
        SearchEngineInstance("startpage.com", path: "/sp/search"),
        SearchEngineInstance("priv.au", path: "/search"),
        SearchEngineInstance("www.ecosia.org", path: "/search"),
        SearchEngineInstance("searx.be", path: "/search"),
    ]
    public let rimgo = [
        "rimgo.pussthecat.org",
        "rimgo.catsarch.com",
        "rimgo.projectsegfau.lt",
        "rimgo.privacyredirect.com",
    ]
    public let libremdb = [
        "libremdb.iket.me",
        "libremdb.pussthecat.org",
        "ld.vern.cc",
    ]
}

struct SearchEngineInstance {
    public let link: String
    public let path: String
    public let url: String
    public let id = UUID()

    init(_ link: String, path: String = "/") {
        self.link = link
        self.path = path
        self.url = link + path
    }
}
