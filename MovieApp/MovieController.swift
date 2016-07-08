//
//  MovieController.swift
//  MovieApp
//
//  Created by Khang Le on 7/5/16.
//  Copyright © 2016 Khang Le. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MovieController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var movieTableView: UITableView!
    
    var posterBaseUrl = "http://image.tmdb.org/t/p/w500"
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    
    var movies = [NSDictionary]()
    
    func getResultFromURL(url:String){
        
        let url = NSURL(string: url)
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data, options:[]) as? NSDictionary {
                    self.movies = responseDictionary["results"] as! [NSDictionary]
                    self.movieTableView.reloadData()
                    // Hide HUD once the network request comes back (must be done on main UI thread)
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            }
        })
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        movieTableView.dataSource = self
        movieTableView.delegate = self
        getResultFromURL("https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return movies.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = movieTableView.dequeueReusableCellWithIdentifier("movieCell") as! MovieTableViewCell
        //cell!.textLabel?.text = movies[indexPath.row]["title"] as! String
        cell.titleLabel.text = movies[indexPath.row]["title"] as? String
        cell.overViewLabel.text = movies[indexPath.row]["overview"] as? String
        
        if let posterPath = movies[indexPath.row]["poster_path"] as? String {
            let posterUrl = NSURL(string: posterBaseUrl + posterPath)
            
            cell.movieImage.setImageWithURL(posterUrl!)
        }
        else {
            // No poster image. Can either set to nil (no image) or a default movie poster image
            // that you include as an asset
            cell.movieImage.image = nil
        }
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        let nextVC = segue.destinationViewController as! DetailViewController
        let ip = movieTableView.indexPathForSelectedRow
        nextVC.overview = movies[(ip?.row)!]["overview"] as! String
        
        nextVC.posterUrlString = posterBaseUrl + (movies[(ip?.row)!]["poster_path"] as! String)
    }
 
    
}
