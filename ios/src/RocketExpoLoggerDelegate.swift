//
//  RocketExpoLoggerDelegate.swift
//  Shift72RocketSDKExpo
//
//  Created by Declan ter Veer-Burke on 23/10/2025.
//

import ExpoModulesCore
import Shift72RocketSDK

class RocketExpoLoggerDelegate : Shift72RocketSDK.LoggerDelegate {
    private let osLogger = os.Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "Shift72RocketSDKExpo"
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
    
    func info(message: String) {
        osLogger.info("\(message)")
    }
    
    func error(message: String) {
        osLogger.error("\(message)")
    }
}
