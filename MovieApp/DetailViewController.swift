//
//  DetailViewController.swift
//  MovieApp
//
//  Created by Khang Le on 7/8/16.
//  Copyright © 2016 Khang Le. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    var posterUrlString:String = ""
    var overview:String = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let smallImageRequest = NSURLRequest(URL: NSURL(string: "https://image.tmdb.org/t/p/w45" + posterUrlString)!)
        let largeImageRequest = NSURLRequest(URL: NSURL(string: "https://image.tmdb.org/t/p/original" + posterUrlString)!)
        
        self.posterImage.setImageWithURLRequest(
            smallImageRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                
                // smallImageResponse will be nil if the smallImage is already available
                // in cache (might want to do something smarter in that case).
                self.posterImage.alpha = 0.0
                self.posterImage.image = smallImage;
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    
                    self.posterImage.alpha = 1.0
                    
                    }, completion: { (sucess) -> Void in
                        
                        // The AFNetworking ImageView Category only allows one request to be sent at a time
                        // per ImageView. This code must be in the completion block.
                        self.posterImage.setImageWithURLRequest(
                            largeImageRequest,
                            placeholderImage: smallImage,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                
                                self.posterImage.image = largeImage;
                                
                            },
                            failure: { (request, response, error) -> Void in
                                self.posterImage.image = smallImage;

                        })
                })
            },
            failure: { (request, response, error) -> Void in
                var alert = UIAlertView(title: "Cannot get the images", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
        })
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
