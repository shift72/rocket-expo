//
//  RocketExpoLoggerDelegate.swift
//  Shift72RocketSDKExpo
//
//  Created by Declan ter Veer-Burke on 23/10/2025.
//

import ExpoModulesCore
import Shift72RocketSDK

class RocketExpoLoggerDelegate : Shift72RocketSDK.LoggerDelegate {
    var prefix: String = "RocketExpoLogger"
    
    private let osLogger = os.Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "Shift72RocketSDKExpo"
    )
    
    func info(area: Shift72RocketSDK.RocketPlayerLoggerArea, message: String) {
        osLogger.info("\(self.prefix): \(String(describing: area)) - \(message)")
    }
    
    func debug(area: Shift72RocketSDK.RocketPlayerLoggerArea, message: String) {
        osLogger.debug("\(self.prefix): \(String(describing: area)) - \(message)")
    }
    
    func error(error: Shift72RocketSDK.RocketPlayerError) {
        osLogger.error("\(self.prefix): \(String(describing: error.type)) - \(error.message)")
    }
    
    func info(message: String) {
        osLogger.info("\(self.prefix): \(message)")
    }
    
    func error(message: String) {
        osLogger.error("\(self.prefix): \(message)")
    }
}
