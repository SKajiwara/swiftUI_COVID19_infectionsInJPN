//
//  InfectionApiService.swift
//  project02_tutorial
//
//  Created by Shinnosuke Kajiwara on 6/8/20.
//  Copyright © 2020 Shinnosuke Kajiwara. All rights reserved.
//

import Foundation
import Combine // to fetch from api


final class InfectionApiService {
    // https://api.apify.com/v2/key-value-stores/YbboJrL3cgVfkV1am/records/LATEST?disableRedirect=true
    // https://api.apify.com/v2/key-value-stores/YbboJrL3cgVfkV1am/records?disableRedirect=true
    var components: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.apify.com"
        components.path = "/v2/key-value-stores/YbboJrL3cgVfkV1am/records/LATEST"
        components.queryItems = [URLQueryItem(name: "disableRedirect", value: "true")]
        // MARK: print(components) // debugger
        print(components.url!)
        return components
    }
    
    func fetchTutorials() -> AnyPublisher<TutorialDataContainer, Error> {
        return URLSession.shared.dataTaskPublisher(for: components.url!)
            .map { $0.data }
            .decode(type: TutorialDataContainer.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct TutorialDataContainer: Decodable {
    let infected: Int
    let deceased: Int
    let infectedByRegion: [Tutorial]
}

struct Tutorial: Decodable, Hashable {
    let region: String
    let infectedCount: Int
}

