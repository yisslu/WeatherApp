//
//  CommonErrors.swift
//  Weather
//
//  Created by Jesús Lugo Sáenz on 11/02/25.
//

import Foundation

enum CommonErrors: Error, LocalizedError {
    case notFound, parsingError, badRequest, unexpectedResponse, invalidUser
    case badResponse(Int)
    
    var errorDescription: String? {
        switch self {
        case .notFound: return "User not found"
        case .parsingError: return "Could not parse response"
        case .badRequest: return "The request could not be built."
        case .badResponse(let code): return "HTTP response \(code)"
        case .unexpectedResponse: return "Could not interpret response."
        case .invalidUser: return "Your user information is incomplete, please log in from our website to complete it. "
        }
    
    }
}
