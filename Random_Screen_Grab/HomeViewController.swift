//
//  ViewController.swift
//  Random_Screen_Grab
//
//  Created by Kanaan Irwin on 10/3/18.
//  Copyright © 2018 Kanaan Irwin. All rights reserved.
//

import Cocoa
import Foundation

class HomeViewController: NSViewController {
    @IBOutlet var overallView: NSView!
    @IBOutlet weak var view1: NSTextField!
    @IBOutlet weak var randomScreenGrab: NSTextField!
    @IBOutlet weak var view2: NSStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func startBtnClicked(_ sender: Any) {
        // This calls fireScreenCap after 5 seconds
        var timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(HomeViewController.fireScreenFunc), userInfo: nil, repeats: false)
//        print("This is a test") //debug
    }
    @IBAction func stopBtnClicked(_ sender: Any) {
        // print("This is a test") //debug
        NSApplication.shared.terminate(self)
    }
    /*
    This function takes screenshots of the current displays
    Even if the user has multiple displays
    */
    @objc func fireScreenFunc() {
        
        let userName = NSUserName() // Gets current user for the file path
        let randomInterval = Double.random(in: 40 ..< 60) // Generates random number for interval of time
        print("\(randomInterval)") //debug
        
        // This calls fireScreenCap after random interval of seconds
        var timer = Timer.scheduledTimer(timeInterval: randomInterval, target: self, selector: #selector(HomeViewController.fireScreenFunc), userInfo: nil, repeats: false)
        takeScreenShot(folderName: "/Users/\(userName)/Desktop/screencap/")

    }
    @objc func takeScreenShot(folderName: String) {
        var displayCount: UInt32 = 0
        var result = CGGetActiveDisplayList(0, nil, &displayCount)
        
        if(result != CGError.success) {
            print("error: \(result)")
            return
        }
        
       // This gets the display count so it can get a screenshot of each display
        let allocated = Int(displayCount)
        let activeDisplays = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: allocated)
        result = CGGetActiveDisplayList(displayCount, activeDisplays, &displayCount)
        
        if(result != CGError.success) {
            print("error: \(result)")
            return
        }
        /*
        This creates the specified file directory if it does not already exist
        The screencaps are held here
        */
        let createFileDir = URL(fileURLWithPath: folderName, isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: createFileDir, withIntermediateDirectories: true)
        }
        catch {
            print("error: \(error)")
        }
        /*
        This creates the filename and puts it in the correct directory
        Also takes a screenshot for each display the user has
        Saves as jpeg
        */
        for i in 1...displayCount {
            let unixTimeStamp = timeStampGen()
            let fileUrl = URL(fileURLWithPath: folderName + "\(unixTimeStamp)" + "_" + "\(i)" + ".jpg", isDirectory: true)
            let screenCap: CGImage = CGDisplayCreateImage(activeDisplays[Int(i - 1)])!
            let bitmapRep = NSBitmapImageRep(cgImage: screenCap)
            let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
            
            do {
                try jpegData.write(to: fileUrl, options: .atomic)
                print("\(fileUrl)")

            }
            catch {
                print("error: \(error)")
            }
        }
    }
    /*
    This function just gets a timestamp so that there is a random filename
    */
    func timeStampGen() -> Int32 {
        return Int32(Date().timeIntervalSince1970)
    }
}
