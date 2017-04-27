//
//  MovieListsViewController.swift
//  TheMoiveManagerApp
//
//  Created by Fikirte  Derso on 4/18/17.
//  Copyright © 2017 Fikirte  Derso. All rights reserved.
//

import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

class MovieListsViewController: UIViewController {
    
    //Image Size specification
    var posterSizes = ["w92", "w154", "w185", "w342", "w500", "w780", "original"]
    var profileSizes = ["w45", "w185", "h632", "original"]
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var resultArray:[Movie] = Array()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension MovieListsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    // MARK: UICollectionViewDataSource
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return resultArray.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCollectionViewCell
        
        let movieObject = resultArray[indexPath.row]
        cell.titleLbl.text = movieObject.title
        cell.activityIndicator.startAnimating()
        cell.activityIndicator.isHidden = false
        
        let posterPath = movieObject.posterPath
        let size = profileSizes[1]
        print("Image: \(posterPath)")
     
        let cachedImage = imageCache.object(forKey:posterPath as AnyObject)
        
        if cachedImage != nil {
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.isHidden = true
            cell.imageView.image = cachedImage as! UIImage?
        }
        else {
        
            if posterPath == nil {
                cell.activityIndicator.stopAnimating()
                cell.activityIndicator.isHidden = true
                cell.imageView.image = UIImage(named: "Movie_Splash_Image.png")
            }
            else{
            //construct url
            let url = WebServiceManager.sharedInstance().getURLPathImage(size: size, filePath: posterPath!)
            
            
            WebServiceManager.sharedInstance().getImageforURL(url: url) { (imageData, error) in
                
                if error == nil {
                    
                    if let image = UIImage(data: imageData!) {
                       
                        DispatchQueue.main.async {
                            cell.activityIndicator.stopAnimating()
                            cell.activityIndicator.isHidden = true
                            imageCache.setObject(image, forKey: (posterPath as AnyObject) as! NSString)
                            cell.imageView.image = image
                        }
                    }
                
                }
                else {
                    
                    print("Error: \(error?.description)")
                }
            }
        }
        }
        
        return cell
    }
    
    
    
    // MARK: UICollectionViewDelegate


      func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        let cell:MovieCollectionViewCell  = collectionView.cellForItem(at: indexPath) as! MovieCollectionViewCell
        
        let movieObject = resultArray[indexPath.row]
        detailViewController.smallImage = cell.imageView.image
        detailViewController.movieTitle = cell.titleLbl.text
        detailViewController.overviewText = movieObject.overview
        detailViewController.releaseDate = movieObject.releaseDate
        detailViewController.vote = String(describing: movieObject.voteAverage!)
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
        return true
     }
    
}

// Mark: - UISearchBar Delegate Method

extension MovieListsViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        
        searchBar.resignFirstResponder()
        self.resultArray.removeAll()
        if var queryString = searchBar.text {
            
            queryString = queryString.replacingOccurrences(of: " ", with: "+")
            
            let parameterDict = [Constants.ParameterKeys.ApiKey : Constants.BaseURL.ApiKey,
                                 Constants.ParameterKeys.Query : queryString]
            
            //construct url
            let url = WebServiceManager.sharedInstance().getFullURL(pathExtention: Constants.Methods.SearchMovie, parameter: parameterDict as [String : AnyObject])
            
            //make service call
            WebServiceManager.sharedInstance().getMovieForURL(url: url, completionHandler: { (parsedData, error) in
                
                
                if (error == nil && parsedData != nil) {
                    
                    let results = (parsedData![Constants.JSONResponseKeys.MovieResults] as! NSArray) as Array
                    
                    for  item in results {
                        
                        print("item: \(item["title"]!!)")
                        
                        let movieObject = Movie(data: item as? [String : Any])
                        self.resultArray.append(movieObject)
                        
                    }
                    
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            })
            
            
        }
        else {
            print("Please enter a search text")
        }
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        searchBar.text = ""
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool{
        
       // searchBar.becomeFirstResponder()
        return true
        
    }

}


