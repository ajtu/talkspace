//
//  Services.swift
//  iOS Interview
//
//  Created by Alvin Tu on 10/18/19.
//  Copyright © 2019 Talkspace. All rights reserved.
//

import Foundation


import Foundation

class Service: NSObject {
    static let shared = Service()

    func fetchTherapists(completion: @escaping ([Therapist], Error?) -> ()) {
        if let filepath = Bundle.main.path(forResource: "therapists09", ofType: "json"){
            do
            {
                let contents = try String(contentsOfFile: filepath)
                if let dictionary = convertToDictionary(text: contents),
                    let therapistArray = dictionary["therapists"],
                    let therapistString = json(from: therapistArray),
                    let json = therapistString.data(using: .utf8){
                    
                    do {
                        let therapists = try JSONDecoder().decode([Therapist].self, from: json)
                        DispatchQueue.main.async {
                            return completion(therapists,nil)
                        }
                    } catch let jsonErr {print("Failed to decode:", jsonErr)}
                }
            }
            catch {print("Contents could not be loaded.")}
        }
    }
}

//helper functions
extension Service
{
    private func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    private func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}
