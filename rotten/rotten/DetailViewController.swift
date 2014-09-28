//
//  DetailViewController.swift
//  rotten
//
//  Created by Hing Huynh on 9/27/14.
//  Copyright (c) 2014 Hing Huynh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var networkErrorView: UIView!
    
    var movieId: String = ""
    var movie: NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var progressView = MRProgressOverlayView.showOverlayAddedTo(self.view, animated: false)
//        progressView.tintColor = UIColor.colorWithRGBHex(0xFFCC00)
        
        networkErrorView.alpha = 0
        networkErrorView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
        
        movieImageView.alpha = 0
        
//        self.detailScrollView.alpha = 0.7
//        self.detailScrollView.backgroundColor = UIColor.clearColor()
//        
        self.detailView.backgroundColor = UIColor.blackColor()
        
        var detailURL = "http://api.rottentomatoes.com/api/public/v1.0/movies/" + movieId + ".json?apikey=dagqdghwaq3e3mxyrp7kmmj5"
        
        var request = NSURLRequest(URL:NSURL(string: detailURL))
        
        var session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request,
            completionHandler: {(data: NSData!, response: NSURLResponse!, error: NSError!) in
                
                if error == nil {
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                        self.movie = object as NSDictionary
                        var posters = self.movie["posters"] as NSDictionary
                        var posterUrl = posters["original"] as String
                        
                        if posterUrl.lowercaseString.rangeOfString("tmb.jpg") != nil {
                            posterUrl = posterUrl.stringByReplacingOccurrencesOfString("tmb.jpg", withString: "ori.jpg", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        }
                        
                        self.navigationItem.title = self.movie["title"] as? String
                        self.titleLabel.text = self.movie["title"] as? String
                        self.descriptionLabel.text = self.movie["synopsis"] as? String
//                        self.description.sizeToFit()
//                        
//                        self.detailContentView.frame = CGRectMake(CGRectGetMinX(self.detailContentView.frame), CGRectGetMinY(self.detailContentView.frame), CGRectGetWidth(self.detailContentView.frame), CGRectGetMaxY(self.synopsisLabel.frame))
//                        
//                        self.detailScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.detailScrollView.frame), CGRectGetMaxY(self.synopsisLabel.frame))
                        
                        var image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(posterUrl)
                        if image != nil {
                            MRProgressOverlayView.dismissOverlayForView(self.view, animated: false)
                            println("cached in disk - detail view")
                            self.movieImageView.image = image
                            self.fadeInImage()
                        }
                        else {
                            SDWebImageDownloader.sharedDownloader().downloadImageWithURL(NSURL(string: posterUrl), options: nil, progress: nil, completed: {[weak self] (image, data, error, finished) in
                                if let wSelf = self {
                                    MRProgressOverlayView.dismissOverlayForView(wSelf.view, animated: false)
                                    if image != nil {
                                        wSelf.movieImageView.image = image
                                        wSelf.fadeInImage()
                                        SDImageCache.sharedImageCache().storeImage(image, forKey: posterUrl, toDisk: true)
                                    }
                                }
                            })
                        }
                    }
                }
                else {
                    self.showNetworkError()
                }
                
        }).resume()
        
        titleLabel.textColor = UIColor.whiteColor()
        descriptionLabel.textColor = UIColor.whiteColor()
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showNetworkError() {
        dispatch_async(dispatch_get_main_queue()) {
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: false)
            
            self.networkErrorView.alpha = 1
            let offset = 3.0
            UIView.animateWithDuration(offset, animations: {
                self.networkErrorView.alpha = 0
            })
        }
    }
    
    func fadeInImage () {
        UIView.beginAnimations("fade in", context: nil)
        UIView.setAnimationDuration(1.5)
        self.movieImageView.alpha = 1
        UIView.commitAnimations()
    }
}
