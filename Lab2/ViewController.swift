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
    let plistCatPath = NSBundle.mainBundle().pathForResource("albums", ofType: "plist");
    
    var albums: NSMutableArray?
    
    
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
    
    @IBAction func NextButtonPressed(sender: AnyObject) {
        i = i + 1;
        if ( i < ((albums?.count)! - 1)) {
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
            "year" : Int(YearField.text!)!,
            "rating" : Int(RateField.text!)!
        ]
        
        if ( i == ((albums?.count)! - 1)) {
           albums!.addObject(newAlbum)
        } else {
           edit(i, newAlbum: newAlbum)
        }
        //albums?.writeToFile("/albums.plist", atomically: <#T##Bool#>)
        
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
        albums!.removeObjectAtIndex(i)
        changeValues()
    }
    
    @IBAction func NewButtonPressed(sender: AnyObject) {
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

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        PrevButton.enabled = false
        
        RatingButton.wraps = true
        RatingButton.autorepeat = true
        RatingButton.maximumValue = 10
        
        //ns dictionary w srodku
        albums = NSMutableArray(contentsOfFile:plistCatPath!); //zmiana na mutable!!!!!
        changeValues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func changeValues(){
        if (i > 0){
            PrevButton.enabled = true
        } else {
            PrevButton.enabled = false
        }
        
        if (i < ((albums?.count)! - 1)){
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
    }

}
