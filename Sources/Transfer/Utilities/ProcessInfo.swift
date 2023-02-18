//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 18.02.2023.
//

import Foundation

extension ProcessInfo {
    static var isRunningUnitTests: Bool {
        Self.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}
