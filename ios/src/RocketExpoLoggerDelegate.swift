//
//  RocketExpoLoggerDelegate.swift
//  Pods
//
//  Created by Declan ter Veer-Burke on 23/10/2025.
//

import ExpoModulesCore
import Shift72RocketSDK

class RocketExpoLoggerDelegate : Shift72RocketSDK.LoggerDelegate {
    private let appContext: AppContext
    private let prefix: String?

    private var prefixFull: String {
        if let prefix {"\(prefix)\\"} else {""}
    }

    init(appContext: AppContext, prefix: String? = nil) {
        self.appContext = appContext
        self.prefix = prefix
    }

    func info(area: Shift72RocketSDK.RocketPlayerLoggerArea, message: String) {
        //appContext.jsLogger.info("\(prefixFull)\(String(describing: area)) - \(message)")
    }

    func debug(area: Shift72RocketSDK.RocketPlayerLoggerArea, message: String) {
        //appContext.jsLogger.debug("\(prefixFull)\(String(describing: area)) - \(message)")
    }

    func error(error: Shift72RocketSDK.RocketPlayerError) {
        //appContext.jsLogger.error("\(prefixFull)\(String(describing: error.type)) - \(error.message)")
    }
}
