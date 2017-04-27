//
//  WebServiceManager.swift
//  TheMoiveManagerApp
//
//  Created by Fikirte  Derso on 4/19/17.
//  Copyright © 2017 Fikirte  Derso. All rights reserved.
//

import UIKit

class WebServiceManager: NSObject {
    
    // MARK: Shared Instance
    
    // Image Specification
    var baseImageURLString = "http://image.tmdb.org/t/p/"
    var secureBaseImageURLString =  "https://image.tmdb.org/t/p/"
    
    
    class func sharedInstance() -> WebServiceManager {
        struct Singleton {
            static var sharedInstance = WebServiceManager()
        }
        return Singleton.sharedInstance
    }
    
    func getMovieForURL(url:URL, completionHandler: @escaping (_ parsedData: [String:Any]?, _ error:NSError?)->Void) {
        
    
        //Create datatask with url
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
           // var jsondData:[String:AnyObject]? = nil
            
            func constructErrorDomain(errorString: String) {
                
                let userInfo = [NSLocalizedDescriptionKey : errorString]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            //check if error
            guard (error == nil) else {
                
                constructErrorDomain(errorString: "There was an error with network request")
                return
            }
            
            //check for sucess status code
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard (statusCode == 200) else {
                
                constructErrorDomain(errorString: "Response status code other than 200")
                return
            }
            
            //All good parse data
            if let rawData = data {
                
                do {
                    let jsondData = try JSONSerialization.jsonObject(with: rawData, options: .allowFragments) as? [String:Any]
                    
                     completionHandler(jsondData, nil)
                    
                }
                catch {
                    
                    constructErrorDomain(errorString: "There was an error parsing JSON data")
                }
            }

        }
        
        task.resume()
        
        
    }
    
    func getImageforURL(url:URL, completionHandler: @escaping (_ imageData: Data?, _ error:NSError?)->Void) {
        
        
        //Create datatask with url
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        
            func constructErrorDomain(errorString: String) {
                
                let userInfo = [NSLocalizedDescriptionKey : errorString]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            //check if error
            guard (error == nil) else {
                
                constructErrorDomain(errorString: "There was an error with network request")
                return
            }
            
            //check for sucess status code
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard (statusCode == 200) else {
                
                constructErrorDomain(errorString: "Response status code other than 200")
                return
            }
            
            //All good
            completionHandler(data, nil)
            
            
        }
        
        task.resume()
        
        
    }
    
    func getURLPathImage(size: String, filePath: String) -> URL {
        
        let baseURL = URL(string: secureBaseImageURLString)!
    
        let url = baseURL.appendingPathComponent(size).appendingPathComponent(filePath)
       
        return url
    
    }
    
    func getFullURL(pathExtention:String, parameter: [String:AnyObject]) -> URL {
        
        var urlComponents = URLComponents()
        
        urlComponents.scheme = Constants.BaseURL.ApiScheme
        urlComponents.host = Constants.BaseURL.ApiHost
        urlComponents.path = Constants.BaseURL.ApiPath + (pathExtention as String)
        urlComponents.queryItems = [URLQueryItem]()
        
        //query item
        for (key, value) in parameter {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            urlComponents.queryItems?.append(queryItem)
        }
        
        return urlComponents.url!
        
    }
    
    

}
