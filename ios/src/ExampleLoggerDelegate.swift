//
//  ExampleLoggerDelegate.swift
//  Shift72RocketSDKExample
//
//  Created by Declan ter Veer-Burke on 2/02/24.
//

import os
import Foundation
import Shift72RocketSDK

@available(iOS 14.0, *)
class ExampleLoggerDelegate : Shift72RocketSDK.LoggerDelegate {
    private let osLogger = os.Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "Shift72RocketSDKExample"
    )
    
    func info(area: Shift72RocketSDK.RocketPlayerLoggerArea, message: String) {
        osLogger.info("\(String(describing: area)) - \(message)")
    }
    
    func debug(area: Shift72RocketSDK.RocketPlayerLoggerArea, message: String) {
        osLogger.debug("\(String(describing: area)) - \(message)")
    }
    
    func error(error: Shift72RocketSDK.RocketPlayerError) {
        osLogger.error("\(String(describing: error.type)) - \(error.message)")
    }
}
