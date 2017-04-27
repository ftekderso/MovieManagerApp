//
//  Constants.swift
//  TheMoiveManagerApp
//
//  Created by Fikirte  Derso on 4/18/17.
//  Copyright © 2017 Fikirte  Derso. All rights reserved.
//

import UIKit

class Constants: NSObject {
    
   
    struct BaseURL {
        
        // MARK: API Key
        static let ApiKey = "eedf9a8dc2a70e70711ff5bea413114b"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "api.themoviedb.org"
        static let ApiPath = "/3"
    
        
        
    }
    
    // Methods
    struct Methods {
        
        // MARK: Search
        static let SearchMovie = "/search/movie"

    }
    
    // Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let Query = "query"
    }
    
    // JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Movies

        static let MovieTitle = "title"
        static let MoviePosterPath = "poster_path"
        static let MovieReleaseDate = "release_date"
        static let MovieOverview = "overview"
        static let MovieVoteAvg = "vote_average"
        
        static let MovieResults = "results"
        
    }
    
    /*
    // Config
    struct Configuration {
        static let ConfigBaseImageURL = "base_url"
        static let ConfigSecureBaseImageURL = "secure_base_url"
        static let ConfigImages = "images"
        static let ConfigPosterSizes = "poster_sizes"
        static let ConfigProfileSizes = "profile_sizes"

    }
    */

    
    
}
