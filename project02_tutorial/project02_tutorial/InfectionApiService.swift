//
//  InfectionApiService.swift
//  project02_infection
//
//  Created by Shinnosuke Kajiwara on 6/8/20.
//  Copyright © 2020 Shinnosuke Kajiwara. All rights reserved.
//

import Foundation
import Combine      // to use URLComponents and Fetch

// MARK: 以下のURLより感染者の数をフェッチするための物を集めたクラスです。

final class InfectionApiService {
    
    // MARK: APIサーバーのURLを作ります。
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
    
    // MARK: データをフェッチします
    func fetchInfections() -> AnyPublisher<InfectionDataContainer, Error> {
        return URLSession.shared.dataTaskPublisher(for: components.url!)
            .map { $0.data }
            .decode(type: InfectionDataContainer.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// MARK: 以下はAPIから来るデータのフォーマットです。
struct InfectionDataContainer: Decodable {
    let infected: Int
    let deceased: Int
    let infectedByRegion: [Infection]
}

struct Infection: Decodable, Hashable {
    let region: String
    let infectedCount: Int
    var isFavorite = false
}

