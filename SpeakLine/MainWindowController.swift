//
//  MainWindowController.swift
//  SpeakLine
//
//  Created by Sebastian on 3/23/16.
//  Copyright © 2016 Sebastian. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSSpeechSynthesizerDelegate, NSWindowDelegate, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var textfield: NSTextField!
    
    @IBOutlet weak var stopButton: NSButton!
    
    @IBOutlet weak var speakButton: NSButton!
    
    let speechSynth = NSSpeechSynthesizer()
    
    let voices = NSSpeechSynthesizer.availableVoices()
    
    var isStarted = false {
        didSet {
            updateButtons()
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        updateButtons()
        speechSynth.delegate = self
        
        let defaultVoice = NSSpeechSynthesizer.defaultVoice()
        
        if let defaultRow = voices.indexOf(defaultVoice) {
            
            let indices = NSIndexSet(index: defaultRow)
            tableView.selectRowIndexes(indices, byExtendingSelection: false)
            tableView.scrollRowToVisible(defaultRow)
        }
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
    
    func voiceNameForIndentifier(identifier: String) -> String? {
        
        let attributes = NSSpeechSynthesizer.attributesForVoice(identifier)
        
        return attributes[NSVoiceName] as? String
    }
    
    //MARK: - NSSpeechSynthesizerDelegate
    
    func speechSynthesizer(sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        isStarted = false
    }
    
    
    //MARK: - NSWindowDelegate
    
    func windowShouldClose(sender: AnyObject) -> Bool {
        return !isStarted
    }
    
    //MARK: - NSTableViewDataSource
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return voices.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        
        let voice = voices[row]
        let voiceName = voiceNameForIndentifier(voice)
        
        return voiceName
    }
    
    //MARK: - NSTableViewDelegate
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let row = tableView.selectedRow
        
        //back to default if user deselected all rows
        if row == -1 {
            speechSynth.setVoice(nil)
            return
        }
        
        let voice = voices[row]
        speechSynth.setVoice(voice)
    }
}
