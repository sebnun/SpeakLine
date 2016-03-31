//
//  PreferenceManager.swift
//  SpeakLine
//
//  Created by Sebastian on 3/31/16.
//  Copyright © 2016 Sebastian. All rights reserved.
//

import Cocoa

private let activeVoiceKey = "activeVoice"
private let activeTextKey = "activeText"

class PreferenceManager {
    private let userDefaults = NSUserDefaults
    .standardUserDefaults()
    
    var activeVoice: String? {
        set (newActiveVoice) {
            userDefaults.setObject(newActiveVoice, forKey: activeVoiceKey)
        }
        get {
            return userDefaults.objectForKey(activeVoiceKey) as? String
        }
    }
    
    var activeText: String? {
        set (newActiveText) {
            userDefaults.setObject(newActiveText, forKey: activeTextKey)
        }
        get {
            return userDefaults.objectForKey(activeTextKey) as? String
        }
    }
    
    func  registerDefaultsPreferences() {
        let defaults = [activeVoiceKey: NSSpeechSynthesizer.defaultVoice(), activeTextKey: "Able was I ere I saw Elba."]
        
        userDefaults.registerDefaults(defaults)
    }
    
    init() {
        registerDefaultsPreferences()
    }
}
