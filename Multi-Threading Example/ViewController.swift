//
//  ViewController.swift
//  Multi-Threading Example
//
//  Created by Shahzaib Mumtaz on 07/07/2022.
//

import UIKit

// Timer Thread class.

class TimerThread:Thread {
    
    var viewCon:ViewController?
    
    override func main() {
        
        while(true) {
            
            let date = Date()
            print(date)
            
            let formatter:DateFormatter = DateFormatter()
            let strformat = "dd-MM-yy    hh:mm:ss"
            formatter.dateFormat = strformat
            
            let que = DispatchQueue.main
            let closure = {
                ()->Void in
                self.viewCon!.dateLabel?.text = formatter.string(from: date)
            }
            que.async(execute: closure)
            
            Thread.sleep(forTimeInterval: 1)
            print(Thread.current)
        }
    }
}

// Image Thread class.

class ImageSliderThread:Thread {
    
    var viewCon:ViewController?
    var count = -1
    
    override func main() {
        
        while (true) {
            
            count = count+1
            
            let mainQ = DispatchQueue.main
            mainQ.async(execute: {
                
                if self.viewCon?.imageArray.count == self.count {
                    self.count = 0
                }
                
                let imageFileName = self.viewCon?.imageArray[self.count]
                self.viewCon?.imgView.image = UIImage(named: imageFileName!)
            })
            
            Thread.sleep(forTimeInterval: 1)
        }
    }
}

class ViewController: UIViewController {
    
    //************************************************//
    // MARK:- Creating Outlets.
    //************************************************//
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    //************************************************//
    // MARK: Creating properties.
    //************************************************//
    
    var imageArray:[String] = ["1.png",
                               "2.jpg",
                               "3.jpg",
                               "4.jpg",
                               "5.jpg"]
    
    //************************************************//
    // MARK:- View Life Cycle.
    //************************************************//
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //************************************************//
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Starting timer thread.
        
        let thread = TimerThread()
        thread.viewCon = self
        thread.start()
        
        // Starting image slider thread.
        
        let imageThread = ImageSliderThread{}
        imageThread.viewCon = self
        imageThread.start()
    }
    
    //************************************************//
}

