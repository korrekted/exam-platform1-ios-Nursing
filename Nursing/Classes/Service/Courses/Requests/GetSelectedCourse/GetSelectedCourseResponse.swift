//
//  GetSelectedCourseResponse.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 18.11.2021.
//

final class GetSelectedCourseResponse {
    static func map(from response: Any) -> Int? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any]
        else {
            return nil
        }
        
        return data["current_application_course_id"] as? Int
    }
}
