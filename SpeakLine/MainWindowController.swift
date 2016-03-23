//
//  MainWindowController.swift
//  SpeakLine
//
//  Created by Sebastian on 3/23/16.
//  Copyright © 2016 Sebastian. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSSpeechSynthesizerDelegate, NSWindowDelegate {

    
    @IBOutlet weak var textfield: NSTextField!
    
    @IBOutlet weak var stopButton: NSButton!
    
    @IBOutlet weak var speakButton: NSButton!
    
    let speechSynth = NSSpeechSynthesizer()
    
    var isStarted = false {
        didSet {
            updateButtons()
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        updateButtons()
        speechSynth.delegate = self
    }
    
    override var windowNibName: String? {
        return "MainWindowController"
    }
    
    //MARK: - Action methods
    
    @IBAction func speakIt(sender: NSButton) {
        
        let string = textfield.stringValue
        
        if string.isEmpty {
            print("emprty")
        } else {
            speechSynth.startSpeakingString(string)
            isStarted = true
        }
    }
    
    @IBAction func stopIt(sender: NSButton) {
        speechSynth.stopSpeaking()
    }
    
    func updateButtons() {
        if isStarted {
            speakButton.enabled = false
            stopButton.enabled = true
        } else {
            speakButton.enabled = true
            stopButton.enabled = false
        }
    }
    
    //MARK: - NSSpeechSynthesizerDelegate
    
    func speechSynthesizer(sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        isStarted = false
    }
    
    //MARK: - NSWindowDelegate
    
    func windowShouldClose(sender: AnyObject) -> Bool {
        return !isStarted
    }
}
