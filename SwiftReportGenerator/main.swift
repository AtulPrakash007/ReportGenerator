//
//  main.swift
//  SwiftReportGenerator
//
//  Created by Mohammed Hussain V on 05/11/2019.
//  Copyright © 2019 Mohammed Hussain V. All rights reserved.
//

import Foundation

var filePath = "/Users/mo20010958/Desktop/SwiftReportGenerator/SwiftReportGenerator/result.json"
var htmlFilePath = "/Users/mo20010958/Desktop/SwiftReportGenerator/SwiftReportGenerator/Result.html"
var cssFilePath = "/Users/mo20010958/Desktop/SwiftReportGenerator/SwiftReportGenerator/all.css"
var reportName = "Test"
var isFilePath = false
var ishtmlFilePath = false
var iscssFilePath = false
var isReportNameAvailable = false


for argument in CommandLine.arguments
{
    if isFilePath {
        filePath = argument
    }
    else if ishtmlFilePath {
        htmlFilePath = argument
    }
    else if isReportNameAvailable
    {
        reportName = argument
    }
    else if iscssFilePath
    {
        cssFilePath = argument
    }
    
    ishtmlFilePath = false
    isFilePath = false
    iscssFilePath = false
    isReportNameAvailable = false
    switch argument {
    case "filePath":
        isFilePath = true
    case "htmlFilePath":
        ishtmlFilePath = true
    case "cssFilePath":
        iscssFilePath = true
    case "reportName":
        isReportNameAvailable = true
    default:
        ishtmlFilePath = false
        isFilePath = false
        iscssFilePath = false
        isReportNameAvailable = false
    }
}

var objRG = ReportGenerator()
objRG.createHTMLReport(filePath: filePath, htmlFilePath: htmlFilePath, cssFilePath: cssFilePath, reportName: reportName)
