//
//  GetCoursesRequest.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import Alamofire

struct GetCourcesRequest: APIRequestBody {
    var url: String {
        GlobalDefinitions.domainUrl + "/api/courses/list"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey
        ]
    }
}
