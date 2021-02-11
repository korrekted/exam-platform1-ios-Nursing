//
//  GetQotdRequest.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 08.02.2021.
//

import Alamofire

struct GetQotdRequest: APIRequestBody {
    private let userToken: String
    private let courseId: Int
    
    init(userToken: String, courseId: Int) {
        self.userToken = userToken
        self.courseId = courseId
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/tests/qotd"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
         [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "course_id": courseId
        ]
    }
}
