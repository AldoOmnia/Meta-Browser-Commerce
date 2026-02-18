//
//  PlatformConnectionStore.swift
//  Meta Browser Commerce
//
//  Persists which platforms user has logged into
//

import Foundation

enum PlatformConnectionStore {
    private static let key = "MetaBrowserCommerce.ConnectedPlatforms"

    static func isConnected(platformId: String) -> Bool {
        connectedPlatforms.contains(platformId)
    }

    static func setConnected(platformId: String, connected: Bool) {
        var set = Set(connectedPlatforms)
        if connected {
            set.insert(platformId)
        } else {
            set.remove(platformId)
        }
        UserDefaults.standard.set(Array(set), forKey: key)
    }

    static var connectedPlatforms: [String] {
        UserDefaults.standard.stringArray(forKey: key) ?? []
    }
}
