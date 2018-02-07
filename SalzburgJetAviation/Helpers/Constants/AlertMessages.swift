//
//  AlertMessages.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import Foundation

enum AlertMessages: String {
    case defaultTitle = "Sorry"
    case defaultButtontitle = "Retry"
    
    case invalidEmailTitle = "Invalid Email"
    case invalidEmailSubTitle = "That email is invalid"
    
    case invalidPasswordSubtitle = "That password is wrong"
    
    case weakPasswordTitle = "Password too weak"
    case weakPasswordSubtitle = "Please make sure that the password is not too easy to guess"
    
    case passwordTooShortSubtitle = "This password is too short"
    case passwordTooLongSubtitle = "This password is too long"
    
    case mismatchPasswordTitle = "Password's Don't Match"
    case mismatchPasswordSubtitle = "The passwords you have set are not the same"
    
    case invalidNameTitle = "Please make sure to type a name longer than 2 characters"
    
    case unknownErrorTitle = "An Unknown Error Occured"
    case unknownErrorSubtitle = "Please try again later"
    
    case userAlreadyExistsTitle = "Error"
    case userAlreadyExistsSubtitle = "That email address is already in use"
    
    case userNotFoundTitle = "User Not Found"
    case userNotFoundSubtitle = "This account does not exist"
    
    case networkIssueTitle = "Network Error"
    case networkIssueSubtitle = "Unable to connect to the internet"
    
    case failedSocialLoginSubtitle = "Something went wrong with Google login. Please try again later"
    
    case failedAuthTitle = "Authentication Error"
    case failedAuthSubTitle = "Oops, something went wrong with the authentication. Please try again later"
    
    case emailSentTitle = "Email Sent"
    case emailSentSubtitle = "An email with further instructions has been sent"
    case emailSentButtonTitle = "OK"
    
    case locationPermissionResetTitle = "Sorry, but you need to allow us to access your location to use this feature."
    case locationPermissionResetSubTitle = "Go to settings to fix this!"
    case okayButtonTitle = "Okay"
    
    case failedToPostToServerTitle = "Oops, looks like something is going on with our servers"
    case failedToPostToServerSubTitle = "There might be many people trying to access our servers right now, this issue may be fixed momentarily"
    
    case failedInternetTitle = "Oops, looks like something is wrong with your Internet"
    case failedToPostInternetSubtitle = "There might be something wrong with your Internet connection or our servers"
    
    case failedToSignOutTitle = "Oops, there was an issue signing out"
    case failedToSignOutSubTitle = "Would you like to try again"
    
    
}
