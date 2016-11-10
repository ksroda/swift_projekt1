//
//  ViewController.swift
//  Lab2
//
//  Created by Użytkownik Gość on 12.10.2016.
//  Copyright © 2016 Użytkownik Gość. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    var i = 0;
    //let plistCatPath = NSBundle.mainBundle().pathForResource("albums", ofType: "plist");
    
    var albums: NSMutableArray?
    
    var albumsDocPath : String = ""
    
    @IBOutlet weak var ArtistField: UITextField!
    @IBOutlet weak var TitleField: UITextField!
    @IBOutlet weak var GenreField: UITextField!
    @IBOutlet weak var YearField: UITextField!
    @IBOutlet weak var RateField: UILabel!
    
    @IBOutlet weak var RatingButton: UIStepper!
    @IBOutlet weak var PrevButton: UIButton!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var DeleteButton: UIButton!
    @IBOutlet weak var NewButton: UIButton!
    

    @IBOutlet weak var RecordFromLabel: UILabel!
    
    @IBOutlet weak var RecordToLabel: UILabel!
    
    //------------BUTTONS------------------------------------
    
    @IBAction func NextButtonPressed(sender: AnyObject) {
        i = i + 1;
        if ( i < (albums?.count)!) {
            changeValues()
        } else {
            addNewAlbum()
        }
    }
    
    @IBAction func SaveButtonPressed(sender: AnyObject) {
        
        var newAlbum : NSDictionary = [
            "artist" : ArtistField.text!,
            "title" : TitleField.text!,
            "genre" : GenreField.text!,
            "date" : Int(YearField.text!)!,
            "rating" : Int(RateField.text!)!
        ]
    
        if ( i == (albums?.count)! ) {
           albums!.addObject(newAlbum)
            i = 0
            changeValues()
        } else {
           edit(i, newAlbum: newAlbum)
        }
        //albums?.writeToFile("/albums.plist", atomically: <#T##Bool#>)
        save()
        
        DeleteButton.enabled = true
        NewButton.enabled = true
        NextButton.enabled = true
    }
    
    @IBAction func PrevButtonPressed(sender: AnyObject) {
        i = i - 1;
        if ( i >= 0 ) {
            changeValues()
        }
    }
    
    @IBAction func RateButtonPressed(sender: UIStepper) {
        RateField.text = Int(sender.value).description
    }

    
    @IBAction func DeleteButtonPressed(sender: AnyObject) {
        print("nnn \(i) albums.count \(albums?.count)!")
        
            if ((albums?.count)! == 1){
                albums!.removeObjectAtIndex(i)
                emptyArray()
            } else {
                albums!.removeObjectAtIndex(i)
                i = 0
                changeValues()
            }
        save()
    }
    
    //------- NEW BUTTON -----------------------------------
    @IBAction func NewButtonPressed(sender: AnyObject) {
        i = (albums?.count)!
        addNewAlbum()
    }
    
    func edit(index : Int, newAlbum : NSDictionary){
        albums!.replaceObjectAtIndex(index, withObject: newAlbum)
    }
    
    func addNewAlbum(){
        ArtistField.text = ""
        TitleField.text = ""
        GenreField.text = ""
        YearField.text = ""
        RateField.text = ""
        DeleteButton.enabled = false
        NewButton.enabled = false
        NextButton.enabled = false
        
        if( (albums?.count)! > 0 ) {
            PrevButton.enabled = true
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        PrevButton.enabled = false
        
        RatingButton.wraps = true
        RatingButton.autorepeat = true
        RatingButton.maximumValue = 10

        let plistPath = NSBundle.mainBundle().pathForResource("albums", ofType: "plist")!
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        albumsDocPath = documentsPath.stringByAppendingString("/albums.plist")
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(albumsDocPath) {
            try? fileManager.copyItemAtPath(plistPath, toPath: albumsDocPath)
        }
        
        //ns dictionary w srodku
        albums = NSMutableArray(contentsOfFile:albumsDocPath);
        
        ArtistField.addTarget(self, action: "changes:", forControlEvents: UIControlEvents.EditingChanged)
        TitleField.addTarget(self, action: "changes:", forControlEvents: UIControlEvents.EditingChanged)
        GenreField.addTarget(self, action: "changes:", forControlEvents: UIControlEvents.EditingChanged)
        YearField.addTarget(self, action: "changes:", forControlEvents: UIControlEvents.EditingChanged)
        RatingButton.addTarget(self, action: "changes:", forControlEvents: UIControlEvents.ValueChanged)
        
        changeValues()
        
    }

    func changes(textField: UITextField) {
            SaveButton.enabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func emptyArray(){
        print("empty array")
        
        ArtistField.text = ""
        TitleField.text = ""
        GenreField.text = ""
        YearField.text = ""
        RateField.text = ""
        DeleteButton.enabled = false
        NewButton.enabled = false
        PrevButton.enabled = false
        NextButton.enabled = false
        i = 0
    }
    
    func changeValues(){
        if (i > 0){
            PrevButton.enabled = true
        } else {
            PrevButton.enabled = false
        }
        
        if (i < (albums?.count)!){
            NextButton.enabled = true
        } else {
            PrevButton.enabled = false
        }
        
            ArtistField.text = albums![i].valueForKey("artist") as! String
            TitleField.text = albums![i].valueForKey("title") as! String
            GenreField.text = albums![i].valueForKey("genre") as! String
            YearField.text = albums![i].valueForKey("date")?.stringValue
            RateField.text = albums![i].valueForKey("rating")?.stringValue

        DeleteButton.enabled = true
        NewButton.enabled = true
        NextButton.enabled = true
        
        RecordFromLabel.text = String(i + 1)
        RecordToLabel.text = String((albums?.count)!)
            
        SaveButton.enabled = false
    }
    
    
    func save(){
            albums!.writeToFile(albumsDocPath,atomically: true)
    }

    
    
}

