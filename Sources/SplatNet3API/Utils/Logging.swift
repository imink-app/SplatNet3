import Logging
import SplatNet3
import InkMoya

public typealias LogLevel = Logger.Level

private var _logger = Logger(label: "app.imink.coral")

var logger: Logger {
    _logger.logLevel = SplatNet3.logLevel
    return _logger
}

extension SplatNet3 {
    static var logLevel: LogLevel = LogLevel.error

    public static func setLogLevel(_ logLevel: LogLevel) {
        SplatNet3.logLevel = logLevel
        InkMoya.setLogLevel(logLevel)
    }
}
