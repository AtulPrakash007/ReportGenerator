//: Playground - noun: a place where people can play

import Cocoa
import Foundation

class ReportGenerator
{
    var filePath = ""
    var htmlFilePath = ""
    var userInput = 1
    var noOfClasses = 1
    
    func createHTMLReport(filePath: String, htmlFilePath: String, cssFilePath: String, reportName: String)
    {
        let filepathArr = filePath.components(separatedBy: "#")
        let cssString = readcssFile(path: cssFilePath)
        var htmlFileBody: String = "<html><head><style type=\"text/css\">\(cssString)</style></head><body>"
        htmlFileBody.append("<br/><h1>\(reportName)</h1><br/>")
        var intTCCount: Int = 0
        var intPassCount: Int = 0
        var intFailCount: Int = 0
        var intDuration: Int = 0
        var coverageRate: Int = 0
        var bodyTestRuns = ""
        bodyTestRuns += "<table border=\"1\" bordercolor=\"#FFFFFF\" class=\"testruns\">"
        var index = 0
        for newfilepath in filepathArr {

            let jsonData = try! Data(contentsOf: URL(fileURLWithPath: newfilepath), options: .mappedIfSafe)
            let myDict = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) as! NSDictionary

            let objTestSummaries: NSDictionary = (myDict.value(forKey: "issues") as! NSDictionary)
//            let objTests: NSDictionary = (objTestSummaries.value(forKey: "testFailureSummaries") as! NSDictionary)
//            let objSubTest: [NSDictionary] = (objTests.value(forKey:"_values") as! [NSDictionary])
            
            let actions: NSDictionary = (myDict.value(forKey: "actions") as! NSDictionary)
            let actionsSubTest: [NSDictionary] = (actions.value(forKey:"_values") as! [NSDictionary])
            let sratedTimeDictionary = actionsSubTest[0].value(forKey: "startedTime") as! NSDictionary
            let sratedTime =  sratedTimeDictionary.value(forKey: "_value") as! String
            let endedDictionary = actions.value(at: 0, inPropertyWithKey: "_values") as! NSDictionary
            let endedDictionarySub = endedDictionary.value(at: 0, inPropertyWithKey: "endedTime") as! NSDictionary
            let endedTime = endedDictionarySub.value(forKey: "_value") as! String
            
            let metrics = (myDict.value(forKey: "metrics") as! NSDictionary)
            let totalTestCountDictionary = (metrics.value(forKey: "testsCount") as! NSDictionary)
            var testsFailedCounttDictionary: String? = "0"
            if let value = metrics.value(forKey: "testsFailedCount") as? String {
                testsFailedCounttDictionary = value
            }

//            let targets: NSArray? = (myDict.value(forKey: "targets") as! NSArray)
//            let appCoverage = getCodeCoverage(tempArray: targets!)
//            let appCoverage = getCodeCoverage2(tempDict: myDict!)
//            let appCoverage = getOverallCoverage(tempArray: targets!)
//            let appCoverage = getOverallCoverage2(tempArray: targets!)

//            let failCount = testsFailedCounttDictionary.value(forKey: "_value") as! String
            let failCount = testsFailedCounttDictionary
            let duration = timeDurationBetweenTwoDate(sratedTime: sratedTime, endedTime: endedTime)
            let tcCount =  totalTestCountDictionary.value(forKey: "_value") as! String
            let passCount = Int(tcCount)! - Int(failCount!)!
            
            intTCCount = intTCCount + Int(tcCount)!
            intPassCount = intPassCount + passCount
            intFailCount = intFailCount + Int(failCount!)!
 
            intDuration = intDuration + duration
//            coverageRate = coverageRate + appCoverage

            if(index == 0) {
//                bodyTestRuns += createRowHeaders(tempArray: objSubTest)
            }
//            bodyTestRuns += createRowData(tempArray: objSubTest)
//            bodyTestRuns += createTestHeader(tempArray: objSubTest, tcCount: tcCount, passCount: passCount, failCount: failCount)
//            bodyTestRuns += createTestHeader3(tempArray: targets!)
//            bodyTestRuns += createTestHeader5(tempArray: targets!)

//            bodyTestRuns += createTestHeader2(tempDict: myDict!)
            
            index = index + 1
        }
        
        bodyTestRuns += "</table><br/><br/></body></html>"
        htmlFileBody.append("<table class=\"testruns\"><tr><td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\"><div><span style=\"opacity: 0;\"></span><b>Total Test Cases : </b></div></td><td header=\"Status\" key=\"status\"><b>\(intTCCount)</b></td></tr>")
        htmlFileBody.append("<tr><td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\"><div><span style=\"opacity: 0;\"></span><b>Passed Count : </b></div></td><td class=\"passed\" header=\"Status\" key=\"status\"><b>\(intPassCount)</b></td></tr>")
        htmlFileBody.append("<tr><td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\"><div><span style=\"opacity: 0;\"></span><b> Failed Count : </b></div></td><td class=\"failed\" header=\"Status\" key=\"status\"><b>\(intFailCount)</b></td></tr>")
        let intPassRate: Int = Int(floor((Double(intPassCount) / Double(intTCCount)) * 100))
        htmlFileBody.append("<tr><td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\"><div><span style=\"opacity: 0;\"></span><b>Pass Percentage : </b></div></td><td header=\"Status\" key=\"status\"><b> \(intPassCount)/\(intTCCount) (\(intPassRate)%)</b></td></tr>")
        let hours = intDuration / 3600
        let minutes = (intDuration / 60) % 60
        let seconds = intDuration % 60
        let convertHours = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        
        htmlFileBody.append("<tr><td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\"><div><span style=\"opacity: 0;\"></span><b> Test Case Duration (Hrs) : </b></div></td><td header=\"Status\" key=\"status\"><b>\(convertHours)</b></td></tr>")
        let parallelMode = intDuration/Int(userInput)
        let hr = parallelMode / 3600
        let min = (parallelMode / 60) % 60
        let sec = parallelMode % 60
        let parallelModeHours = String(format: "%02i:%02i:%02i", hr, min, sec)
        
        htmlFileBody.append("<tr><td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\"><div><span style=\"opacity: 0;\"></span><b> Total Execution Time (Hrs) : </b></div></td><td header=\"Status\" key=\"status\"><b>\(parallelModeHours)</b></td></tr>")
        let appCoverageRate: Int = Int((coverageRate/Int(noOfClasses)))
        
//        htmlFileBody.append("<tr><td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\"><div><span style=\"opacity: 0;\"></span><b> Overall Code Coverage (RadarX, RadarKit, RadarFoundation) </b></div></td><td header=\"Status\" key=\"status\"><b>\(appCoverageRate)%</b></td></tr>")
        htmlFileBody.append("<tr><td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\"><div><span style=\"opacity: 0;\"></span><b> Overall Code Coverage </b></div></td><td header=\"Status\" key=\"status\"><b>\(appCoverageRate)%</b></td></tr>")
        htmlFileBody.append("</table><br/><br/>")
        htmlFileBody.append(bodyTestRuns)
        do {
            try htmlFileBody.write(toFile: htmlFilePath, atomically: false, encoding: String.Encoding.utf8)
        } catch {
            print("Exception thrown..... please check")
        }
    }
    
    func createTestHeader(tempArray: NSArray?, tcCount: Int, passCount: Int, failCount: Int) -> String {
        let tempObj = ((tempArray?.object(at: 0) as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSArray
        var tempHTMLBody: String = "<thead>"
        tempHTMLBody.append("<tr>")
        var testNames = ""
        var totalDuration:Double = 0
        var index = 0
        for item in tempObj {
            let obj = (item as! NSDictionary).object(forKey: "TestName")
            let testName = obj.unsafelyUnwrapped as! String
            let obj2 = (item as! NSDictionary).object(forKey: "Duration")
            totalDuration = obj2.unsafelyUnwrapped as! Double
            print("Duration is: \(totalDuration)")
            testNames.append(testName)
            if(index <= tempArray!.count - 1)
            {
                testNames.append("   ")
            }
            index = index + 1
        }
        
        let durationInMins = Int(round(totalDuration/60))
        let intPassRate: Int = Int(floor((Double(passCount) / Double(tcCount)) * 100))
        tempHTMLBody.append("<td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\" ><div><span style=\"opacity: 0;\"></span><b> Test Suite Name: \(testNames) </b></div></td><td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\" ><div><span style=\"opacity: 0;\"></span><b> Total Duration(Mins): \(durationInMins) </b></div></td><td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\" ><div><span style=\"opacity: 0;\"></span><b>\(passCount)/\(tcCount) (\(intPassRate)%)</b></div></td>")
        tempHTMLBody.append("</tr>")
        tempHTMLBody.append("</thead>")
        return tempHTMLBody
    }
    
    func timeDurationBetweenTwoDate(sratedTime:String,endedTime:String) -> Int{
        let Dateformatter = DateFormatter()
        Dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let date1 = Dateformatter.date(from: sratedTime)
        let date2 = Dateformatter.date(from: endedTime)

        let distanceBetweenDates: TimeInterval? = date2?.timeIntervalSince(date1!)
        return Int(round(distanceBetweenDates!))
    }
    
    func getDuration(tempArray: NSArray?) -> Int {
        let tempObj = ((tempArray?.object(at: 0) as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSArray
        var totalDuration:Double = 0
        for item in tempObj {
            let obj = (item as! NSDictionary).object(forKey: "Duration")
            totalDuration = obj.unsafelyUnwrapped as! Double
            print("Duration is: \(totalDuration)")
        }
        let durationInMins = Int(round(totalDuration))
        return durationInMins
    }
    
    func createRowHeaders(tempArray: [NSDictionary]) -> String {
        var tempHTMLBody: String = "<thead>"
        tempHTMLBody.append("<tr>")
        let tempTD = "<th header=\"Name\" key=\"name\"><span title=\"name\">" + "Test Case Name" + "</span></th>"
        let status = "<th header=\"Name\" key=\"name\"><span title=\"status\">" + "Status" + "</span></th>"
        tempHTMLBody.append(tempTD)
        tempHTMLBody.append(status)
        tempHTMLBody.append("</tr>")
        tempHTMLBody.append("</thead>")
        return tempHTMLBody
    }
    
    func createRowData(tempArray: [NSDictionary]) -> String {
        var tempHTMLBody: String = "<tbody>"
        
        for temp in tempArray{
             tempHTMLBody.append("<tr >")
            let testCaseNameDictionar = temp.value(forKey: "testCaseName") as! NSDictionary
            let testCaseStatusDictionar = temp.value(forKey: "message") as! NSDictionary
            let testName = testCaseNameDictionar.value(forKey: "_value") as! String
            let status = testCaseStatusDictionar.value(forKey: "_value") as! String
            tempHTMLBody.append("<td class=\"failed\" header=\"Name\" key=\"name\" style=\"padding-left: 4px;\"><div><span style=\"opacity: 0;\"></span>\(testName)</div></td>")
            tempHTMLBody.append("<td class=\"failed\" header=\"Status\" key=\"status\"style=\"padding-left: 4px;\"><div><span style=\"opacity: 0;\"></span>\(status)</div></td>")
            tempHTMLBody.append("</tr>")

        }

//                    if (String(status) == "Success")
//                    {
//                        tempHTMLBody.append("<td class=\"passed\" header=\"Name\" key=\"name\" style=\"padding-left: 4px;\"><div><span style=\"opacity: 0;\"></span>\(testName)</div></td>")
//                        tempHTMLBody.append("<td class=\"passed\" header=\"Name\" key=\"name\" style=\"padding-left: 4px;\"><div><span style=\"opacity: 0;\"></span>\(duration)</div></td>")
//                        tempHTMLBody.append("<td class=\"passed\" header=\"Status\" key=\"status\">" + "\(status)" + "</td>")
//                    }
//                    else
//                    {
//                        tempHTMLBody.append("<td class=\"failed\" header=\"Name\" key=\"name\" style=\"padding-left: 4px;\"><div><span style=\"opacity: 0;\"></span>\(testName)</div></td>")
//                        tempHTMLBody.append("<td class=\"failed\" header=\"Name\" key=\"name\" style=\"padding-left: 4px;\"><div><span style=\"opacity: 0;\"></span>\(duration)</div></td>")
//                        tempHTMLBody.append("<td class=\"failed\" header=\"Status\" key=\"status\"style=\"padding-left: 4px;\"><div><span style=\"opacity: 0;\"></span>\(status)</div></td>")
//
//                    }
//                    tempHTMLBody.append("</tr>")
//                }
//                i = i + 1
//            }
//        }
        tempHTMLBody.append("</tbody>")
        return tempHTMLBody
    }
    
    func getTCCount(tempArray: NSArray?) -> Int {
        var testCaseCount: Int = 0
        for _ in tempArray! {
            let tempObj: Any = ((tempArray?.object(at: 0) as! NSArray).object(at: 0) as! NSArray).object(at: 0) as Any
            let traverseObjects: NSEnumerator = (tempObj as! NSArray).objectEnumerator()
            var i: Int = 0
            while (traverseObjects.nextObject() != nil) {
                let objTestCases: NSArray = (tempObj as AnyObject).object(at: i) as! NSArray
                for _ in objTestCases {
                    testCaseCount = testCaseCount + 1
                }
                i = i + 1
            }
        }
        return testCaseCount
    }
    
    func getPassTCCount(tempArray: NSArray?) -> Int {
        var testPassCount: Int = 0
        for _ in tempArray! {
            let tempObj: Any = ((tempArray?.object(at: 0) as! NSArray).object(at: 0) as! NSArray).object(at: 0) as Any
            let traverseObjects: NSEnumerator = (tempObj as! NSArray).objectEnumerator()
            var i: Int = 0
            while (traverseObjects.nextObject() != nil) {
                let objTestCases: NSArray = (tempObj as AnyObject).object(at: i) as! NSArray
                for objTC in objTestCases {
                    let objTCKeys: NSArray = (objTC as! NSDictionary).allKeys as NSArray
                    for tempKey in objTCKeys {
                        if (tempKey as! NSString) == "TestStatus" {
                            let tempValue = (objTC as! NSDictionary).object(forKey: tempKey)
                            if(tempValue as! NSString) == "Success" {
                                testPassCount = testPassCount + 1
                            }
                        }
                    }
                    
                }
                i = i + 1
            }
        }
        return testPassCount
    }
    
    func getFailTCCount(tempArray: NSArray) -> Int {
        var testFailCount: Int = 0
        for _ in tempArray {
            let tempObj: Any = ((tempArray.object(at: 0) as! NSArray).object(at: 0) as! NSArray).object(at: 0) as Any
            let traverseObjects: NSEnumerator = (tempObj as! NSArray).objectEnumerator()
            var i: Int = 0
            while (traverseObjects.nextObject() != nil) {
                let objTestCases: NSArray = (tempObj as AnyObject).object(at: i) as! NSArray
                for objTC in objTestCases {
                    let objTCKeys: NSArray = (objTC as! NSDictionary).allKeys as NSArray
                    for tempKey in objTCKeys {
                        if (tempKey as! NSString) == "TestStatus" {
                            let tempValue = (objTC as! NSDictionary).object(forKey: tempKey)
                            if(tempValue as! NSString) == "Failure" {
                                testFailCount = testFailCount + 1
                            }
                        }
                    }
                    
                }
                i = i + 1
            }
        }
        return testFailCount
    }
    
    func createTestHeader2(tempDict: NSDictionary?) -> String {
        var tempHTMLBody: String = "<thead>"
        tempHTMLBody.append("<tr>")
        var coveredLines: Double = 0
        var executableLines: Double = 0
        let tempObj1 = tempDict?.value(forKey: "coveredLines") as! Double
        let tempObj2 = tempDict?.value(forKey: "executableLines") as! Double
        
        coveredLines = tempObj1
        executableLines = tempObj2
        
        let intCoverageRate: Int = Int(ceil((coveredLines / executableLines) * 100))
        
        tempHTMLBody.append("<td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\" colspan=\"2\"><div><span style=\"opacity: 0;\"></span><b>Code Coverage </b></div></td><td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\" ><div><span style=\"opacity: 0;\"></span><b> \(intCoverageRate)% </b></div></td>")
        tempHTMLBody.append("</tr>")
        tempHTMLBody.append("</thead>")
        return tempHTMLBody
    }
    
    func createTestHeader3(tempArray: NSArray?) -> String {
        var tempHTMLBody: String = "<thead>"
        tempHTMLBody.append("<tr>")
        var coveredLines: Double = 0
        var executableLines: Double = 0
        var targetName: String = ""
        var count: Int = 0
        while(count < 5) {
            let tempObj: NSDictionary = tempArray?.object(at: count) as! NSDictionary
            for _ in tempArray! {
                let tempObj1 = tempObj.value(forKey: "coveredLines") as! Double
                coveredLines = tempObj1
                let tempObj2 = tempObj.value(forKey: "executableLines") as! Double
                executableLines = tempObj2
                let tempObj3 = tempObj.value(forKey: "name") as! String
                targetName = tempObj3
            }
            let intCoverageRate: Int = Int(ceil((coveredLines / executableLines) * 100))

            tempHTMLBody.append("<td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\" ><div><span style=\"opacity: 0;\"></span><b> Code Coverage </b></div></td><td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\" ><div><span style=\"opacity: 0;\"></span><b> \(targetName) </b></div></td><td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\" ><div><span style=\"opacity: 0;\"></span><b>\(intCoverageRate)%</b></div></td>")
            tempHTMLBody.append("</tr>")
            count = count + 1
        }
        tempHTMLBody.append("</thead>")
        return tempHTMLBody
    }
    
    func createTestHeader4(tempArray: NSArray?) -> String {
        var tempHTMLBody: String = "<thead>"
        tempHTMLBody.append("<tr>")
        var coveredLines: Double = 0
        var executableLines: Double = 0
        var targetName: String = ""
        var count: Int = 0
        for _ in tempArray! {
            let tempObj: NSDictionary = tempArray?.object(at: count) as! NSDictionary
            let tempObj3 = tempObj.value(forKey: "name") as! String
            targetName = tempObj3
            if targetName == "RadarX.app" {
                let tempObj1 = tempObj.value(forKey: "coveredLines") as! Double
                coveredLines = tempObj1
                let tempObj2 = tempObj.value(forKey: "executableLines") as! Double
                executableLines = tempObj2
                break
            } else {
                count = count + 1
            }
        }
        let intCoverageRate: Int = Int(ceil((coveredLines / executableLines) * 100))
            
        tempHTMLBody.append("<td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\" ><div><span style=\"opacity: 0;\"></span><b> Code Coverage </b></div></td><td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\" ><div><span style=\"opacity: 0;\"></span><b> \(targetName) </b></div></td><td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\" ><div><span style=\"opacity: 0;\"></span><b>\(intCoverageRate)%</b></div></td>")
        tempHTMLBody.append("</tr>")
        tempHTMLBody.append("</thead>")
        return tempHTMLBody
    }
    
    func createTestHeader5(tempArray: NSArray?) -> String {
        var tempHTMLBody: String = "<thead>"
        tempHTMLBody.append("<tr>")
        var coveredLines: Double = 0
        var executableLines: Double = 0
        var targetName: String = ""
        var count: Int = 0
        for _ in tempArray! {
            let tempObj: NSDictionary = tempArray?.object(at: count) as! NSDictionary
            let tempObj3 = tempObj.value(forKey: "name") as! String
            targetName = tempObj3
            if targetName == "RadarXElements.framework" || targetName == "RDARKit.framework" || targetName == "RadarX.app" {
                let tempObj1 = tempObj.value(forKey: "coveredLines") as! Double
                coveredLines = tempObj1
                let tempObj2 = tempObj.value(forKey: "executableLines") as! Double
                executableLines = tempObj2
                let intCoverageRate: Int = Int(ceil((coveredLines / executableLines) * 100))
                
                tempHTMLBody.append("<td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\" ><div><span style=\"opacity: 0;\"></span><b> Code Coverage </b></div></td><td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\" ><div><span style=\"opacity: 0;\"></span><b> \(targetName) </b></div></td><td header=\"Name\" key=\"name\" style=\"padding-left: 4px;\" ><div><span style=\"opacity: 0;\"></span><b>\(intCoverageRate)%</b></div></td>")
                tempHTMLBody.append("</tr>")
                count = count + 1
            } else {
                count = count + 1
            }
        }
        tempHTMLBody.append("</thead>")
        return tempHTMLBody
    }
    
    func getOverallCoverage(tempArray: NSArray?) -> Int {
        var tempHTMLBody: String = "<thead>"
        tempHTMLBody.append("<tr>")
        var coveredLines: Double = 0
        var executableLines: Double = 0
        var targetName: String = ""
        var count: Int = 0
        var overallCoverageRate: Int = 0
        for _ in tempArray! {
            let tempObj: NSDictionary = tempArray?.object(at: count) as! NSDictionary
            let tempObj3 = tempObj.value(forKey: "name") as! String
            targetName = tempObj3
            if targetName == "RadarXElements.framework" || targetName == "RDARKit.framework" || targetName == "RadarX.app" {
                let tempObj1 = tempObj.value(forKey: "coveredLines") as! Double
                coveredLines = tempObj1
                let tempObj2 = tempObj.value(forKey: "executableLines") as! Double
                executableLines = tempObj2
                let intCoverageRate: Int = Int(ceil((coveredLines / executableLines) * 100))
                overallCoverageRate = overallCoverageRate + intCoverageRate
                count = count + 1
            } else {
                count = count + 1
            }
        }
        return overallCoverageRate
    }
    
    func getOverallCoverage2(tempArray: NSArray?) -> Int {
        var tempHTMLBody: String = "<thead>"
        tempHTMLBody.append("<tr>")
        var coveredLines: Double = 0
        var executableLines: Double = 0
        var targetName: String = ""
        var count: Int = 0
        var allcoveredLines: Double = 0
        var allexecutableLines: Double = 0
        
        for _ in tempArray! {
            let tempObj: NSDictionary = tempArray?.object(at: count) as! NSDictionary
            let tempObj3 = tempObj.value(forKey: "name") as! String
            targetName = tempObj3
            if targetName == "RadarXElements.framework" || targetName == "RDARKit.framework" || targetName == "RadarX.app" {
                let tempObj1 = tempObj.value(forKey: "coveredLines") as! Double
                coveredLines = tempObj1
                let tempObj2 = tempObj.value(forKey: "executableLines") as! Double
                executableLines = tempObj2
                allcoveredLines = allcoveredLines + coveredLines
                allexecutableLines = allexecutableLines + executableLines
                print("all covered lines \(allcoveredLines)")
                print("all executable lines \(allexecutableLines)")
                count = count + 1
            } else {
                count = count + 1
            }
        }
        let intCoverageRate: Int = Int(ceil((allcoveredLines / allexecutableLines) * 100))
        return intCoverageRate
    }
    
    func getCodeCoverage2(tempDict: NSDictionary?) -> Int {
        var tempHTMLBody: String = "<thead>"
        tempHTMLBody.append("<tr>")
        var coveredLines: Double = 0
        var executableLines: Double = 0
        let tempObj1 = tempDict?.value(forKey: "coveredLines") as! Double
        let tempObj2 = tempDict?.value(forKey: "executableLines") as! Double
        
        coveredLines = tempObj1
        executableLines = tempObj2
        
        let intCoverageRate: Int = Int(ceil((coveredLines / executableLines) * 100))
        return intCoverageRate
    }
    
    func getCodeCoverage(tempArray: NSArray?) -> Int {
        var coveredLines: Double = 0
        var executableLines: Double = 0
        var targetName: String = ""
        var count: Int = 0
        for _ in tempArray! {
            let tempObj: NSDictionary = tempArray?.object(at: count) as! NSDictionary
            let tempObj3 = tempObj.value(forKey: "name") as! String
            targetName = tempObj3
            if targetName == "RadarX.app" {
                let tempObj1 = tempObj.value(forKey: "coveredLines") as! Double
                coveredLines = tempObj1
                let tempObj2 = tempObj.value(forKey: "executableLines") as! Double
                executableLines = tempObj2
                break
            } else {
                count = count + 1
            }
        }
        let intCoverageRate: Int = Int(ceil((coveredLines / executableLines) * 100))
        return intCoverageRate
    }
    
    func readcssFile(path: String) -> String {
        
        do {
            let contents = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            return contents
        } catch {
            print("Unable to read file: \(path)")
            return ""
        }
    }
}

