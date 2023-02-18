//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 18.02.2023.
//

import Foundation

extension URL {
    func valueOfQueryParameter(_ query: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == query })?.value
    }
}
