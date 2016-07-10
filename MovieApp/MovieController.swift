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
import ReachabilitySwift

class MovieController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var movieTableView: UITableView!
    
    //var searchResults =[String]()
    
    var posterBaseUrl = "http://image.tmdb.org/t/p/w500"
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    
    var movies = [NSDictionary]()
    var moviesSearch = [NSDictionary]()
    // search in progress or not
    var isSearching : Bool = false
    var endPoint:String!
    
    func getResultFromURL(url:String){
        if Reachability.isConnectedToNetwork() == true {
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
        } else {
            print("noconnec")
            self.movies = [NSDictionary]()
            self.movieTableView.reloadData()
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }

    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        if Reachability.isConnectedToNetwork() == true {
            let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")
            let request = NSURLRequest(
                URL: url!,
                cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
                timeoutInterval: 10)
            
            let session = NSURLSession(
                configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                delegate: nil,
                delegateQueue: NSOperationQueue.mainQueue()
            )
            
            let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                        self.movies = responseDictionary["results"] as! [NSDictionary]
                        self.movieTableView.reloadData()
                        // Hide HUD once the network request comes back (must be done on main UI thread)
                        refreshControl.endRefreshing()
                    }
                }
            })
            task.resume()
            
        } else {
            print("noconnec")
            refreshControl.endRefreshing()
            self.movies = [NSDictionary]()
            self.movieTableView.reloadData()
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        
        // Do any additional setup after loading the view.
        movieTableView.dataSource = self
        movieTableView.delegate = self
        self.searchBar.delegate = self
        getResultFromURL("https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        movieTableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if self.isSearching == true {
            return self.moviesSearch.count
        }else {
            return self.movies.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var moviesResult = [NSDictionary]()
        if self.isSearching == true {
            moviesResult = moviesSearch
        }else{
            moviesResult = movies
        }
        
        let cell = movieTableView.dequeueReusableCellWithIdentifier("movieCell") as! MovieTableViewCell
        cell.titleLabel.text = moviesResult[indexPath.row]["title"] as? String
        cell.overViewLabel.text = moviesResult[indexPath.row]["overview"] as? String
        
        if let posterPath = moviesResult[indexPath.row]["poster_path"] as? String {
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
        /*
        print(segue.identifier)
        let tabBarController = segue.destinationViewController as! UITabBarController
        let nav = tabBarController.viewControllers![2] as! UINavigationController
        let destinationViewController = nav.topViewController as! DetailViewController
        let ip = movieTableView.indexPathForSelectedRow
        destinationViewController.overview = movies[(ip?.row)!]["overview"] as! String
        destinationViewController.posterUrlString = posterBaseUrl + (movies[(ip?.row)!]["poster_path"] as! String)
*/
        
        let nextVC = segue.destinationViewController as! DetailViewController
        let ip = movieTableView.indexPathForSelectedRow
        nextVC.overview = movies[(ip?.row)!]["overview"] as! String
        nextVC.posterUrlString = posterBaseUrl + (movies[(ip?.row)!]["poster_path"] as! String)
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if self.searchBar.text!.isEmpty {
            print("Empty")
            // set searching false
            self.isSearching = false
            
            // reload table view
            self.movieTableView.reloadData()
            
        }else{
            
            // set searghing true
            self.isSearching = true
            
            // empty searching array
            self.moviesSearch.removeAll(keepCapacity: false)
            
            // find matching item and add it to the searcing array
            for i in 0..<self.movies.count {
                //let listItem : String = self.fruitList[i]
                if movies[i]["overview"]!.lowercaseString.rangeOfString(self.searchBar.text!.lowercaseString) != nil
                || movies[i]["title"]!.lowercaseString.rangeOfString(self.searchBar.text!.lowercaseString) != nil{
                    self.moviesSearch.append(movies[i])
                }
            }
            
            self.movieTableView.reloadData()        }
        
    }
 
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        self.movieTableView.reloadData()
    }}
