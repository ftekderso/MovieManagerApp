//
//  Movie.swift
//  TheMoiveManagerApp
//
//  Created by Fikirte  Derso on 4/18/17.
//  Copyright © 2017 Fikirte  Derso. All rights reserved.
//

import UIKit

class Movie: NSObject {

    var title: String?
    var posterPath: String?
    var overview: String?
    var releaseDate: String?
    var voteAverage: Float?
    
    init(data:[String:Any]?) {
        
        for (key,value) in data! {
            if key == Constants.JSONResponseKeys.MovieOverview {
                self.overview = value as? String
            }
            if key == Constants.JSONResponseKeys.MoviePosterPath {
                self.posterPath = value as? String
            }
            if key == Constants.JSONResponseKeys.MovieTitle {
                self.title = value as? String
            }
            if key == Constants.JSONResponseKeys.MovieReleaseDate {
                self.releaseDate = value as? String
            }
            if key == Constants.JSONResponseKeys.MovieVoteAvg {
                self.voteAverage = value as? Float
            }
        }
    }
     
}
