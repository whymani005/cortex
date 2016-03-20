//
//  TrendsViewController.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 10/8/15.
//  Copyright © 2015 Manisha Yeramareddy. All rights reserved.
//

import UIKit
import Charts

class TrendsViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var days : [String] = []
    var mood : [Int] = []
    var noMoodIndexes : [Int] = []
    
    var currentViewingChartType : Int = -1
    
    var chartNameLabel : [String] = ["Mood Chart", "Top Categories", "Number of Thoughts"]
    //var graphViews : [AnyObject] = [pieChartView]
 
    let trendsRepo = TrendsRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lineChartView.delegate = self
        lineChartView.descriptionText = ""
        lineChartView.noDataText = "No data available yet"
        self.lineChartView.leftAxis.valueFormatter = NSNumberFormatter()
        self.lineChartView.leftAxis.valueFormatter?.minimumFractionDigits = 0
        
        pieChartView.delegate = self
        pieChartView.descriptionText = ""
        pieChartView.noDataText = "No data available yet"
        pieChartView.backgroundColor = UIColor.whiteColor()
        self.pieChartView.valueFormatter = NSNumberFormatter()
        self.pieChartView.valueFormatter?.minimumFractionDigits = 0
        
        // Do any additional setup after loading the view.
        currentViewingChartType = Int(0)
    }
    
    override func viewWillAppear(animated: Bool) {
        setUpCurrentViewingChart()
    }
    
    func setUpCurrentViewingChart() {
        if(currentViewingChartType == 0) {
            titleLabel.text = chartNameLabel[currentViewingChartType]
            segmentedControl.hidden = false
            segmentedControl.selectedSegmentIndex = 0
            lineChartView.hidden = false
            pieChartView.hidden = true
            rightButton.enabled = true
            leftButton.enabled = false
            setUpMoodLineChartFor7Days()
        } else if(currentViewingChartType == 1) {
            titleLabel.text = chartNameLabel[currentViewingChartType]
            segmentedControl.hidden = false
            segmentedControl.selectedSegmentIndex = 0
            lineChartView.hidden = true
            pieChartView.hidden = false
            rightButton.enabled = false
            leftButton.enabled = true
            setUpCategoryPieChartFor7Days()
        }
    }
    
    @IBAction func rightButtonPressed(sender: AnyObject) {
        currentViewingChartType = currentViewingChartType + Int(1)
        setUpCurrentViewingChart()
    }
    
    @IBAction func leftButtonPressed(sender: AnyObject) {
        currentViewingChartType = currentViewingChartType - Int(1)
        setUpCurrentViewingChart()
    }
    
    @IBAction func segmentedControlPressed(sender: AnyObject) {
        noMoodIndexes.removeAll(keepCapacity: false)
        if(segmentedControl.selectedSegmentIndex == 0) {
            if(currentViewingChartType == 0) {
                setUpMoodLineChartFor7Days()
            } else if(currentViewingChartType == 1) {
                setUpCategoryPieChartFor7Days()
            }
            
        } else if(segmentedControl.selectedSegmentIndex == 1) {
            if(currentViewingChartType == 0) {
                setUpMoodLineChartFor30Days()
            } else if(currentViewingChartType == 1) {
                setUpCategoryPieChartFor30Days()
            }
            
        } else if(segmentedControl.selectedSegmentIndex == 2) {
            if(currentViewingChartType == 0) {
                setUpMoodLineChartFor90Days()
            } else if(currentViewingChartType == 1) {
                setUpCategoryPieChartFor90Days()
            }
        }
    }
    
    func setUpMoodLineChartFor7Days() {
        let dateStr = trendsRepo.getDateStringArrayForLastNDaysFromGivenDate(NSDate(), numOfDays: 7)
        let moodavg  = trendsRepo.getMoodAvgArrayForLastNDaysFromGivenDate(NSDate(), numOfDays: 7)
        setMoodLineChart(dateStr, values: moodavg)
    }
    
    func setUpMoodLineChartFor30Days() {
        let dateStr = trendsRepo.getDateStringArrayForLastNDaysFromGivenDate(NSDate(), numOfDays: 30)
        let moodavg  = trendsRepo.getMoodAvgArrayForLastNDaysFromGivenDate(NSDate(), numOfDays: 30)
        setMoodLineChart(dateStr, values: moodavg)
    }
    
    func setUpMoodLineChartFor90Days() {
        let dateStr = trendsRepo.getDateStringArrayForLastNDaysFromGivenDate(NSDate(), numOfDays: 90)
        let moodavg  = trendsRepo.getMoodAvgArrayForLastNDaysFromGivenDate(NSDate(), numOfDays: 90)
        setMoodLineChart(dateStr, values: moodavg)
    }
    
    func setMoodLineChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            /*if(values[i] == Double(99.0)) {
                let dataEntry = ChartDataEntry(value: 4.0, xIndex: i)
                noMoodIndexes.append(i)
                dataEntries.append(dataEntry)
            } else {
                let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
                dataEntries.append(dataEntry)
            }*/
            if(values[i] != Double(99.0)) {
                let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
                dataEntries.append(dataEntry)
            }
        }

        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "My Mood")
        lineChartDataSet.circleRadius = CGFloat(6.0)
   
        lineChartDataSet.setMainCircleColor(UIColor(rgba: "#F6A242"))
        /*for i in 0..<noMoodIndexes.count {
            let indexValue : Int = noMoodIndexes[i]
            lineChartDataSet.setCircleColorAtIndex(UIColor.lightGrayColor(), index: indexValue)
        }*/
        
        //lineChartDataSet.drawCircleHoleEnabled = false
        lineChartDataSet.setColor(UIColor(rgba: "#F6A242"))
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
       
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false

        lineChartView.leftAxis.customAxisMax = Double(6.5)
        lineChartView.leftAxis.customAxisMin = Double(0.5)

        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.legend.form = ChartLegend.ChartLegendForm.Line
        lineChartView.backgroundColor = UIColor.whiteColor()
        //lineChartView.animate(xAxisDuration: 2.0)
        
        lineChartView.data = lineChartData
        print("DONE setMoodLineChart")
    }
    
    func setUpCategoryPieChartFor7Days() {
        let data : [NSDictionary] = trendsRepo.getCategoryCountForDateRange(DateUtils.plusDays(NSDate(), daysToAdd: -7), end: NSDate())
        if(data.count > 0) {
            setUpCategoryPieChartData(data)
        }
    }
    
    func setUpCategoryPieChartFor30Days() {
        let data : [NSDictionary] = trendsRepo.getCategoryCountForDateRange(DateUtils.plusDays(NSDate(), daysToAdd: -30), end: NSDate())
        if(data.count > 0) {
            setUpCategoryPieChartData(data)
        }
    }
    
    func setUpCategoryPieChartFor90Days() {
        let data : [NSDictionary] = trendsRepo.getCategoryCountForDateRange(DateUtils.plusDays(NSDate(), daysToAdd: -90), end: NSDate())
        if(data.count > 0) {
            setUpCategoryPieChartData(data)
        }
    }

    func setUpCategoryPieChartData(data: [NSDictionary]) {
        var categories = [String]()
        var categoryCount = [Double]()
        
        for one in data {
            categories.append(one[EntityInfo.Thought.categoryString] as! String)
            categoryCount.append(one["categoryCount"] as! Double)
        }
        setCategoryPieChartView(categories, values: categoryCount)
    }
    
    func setCategoryPieChartView(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        
        let numFormatter = NSNumberFormatter()
        numFormatter.numberStyle = NSNumberFormatterStyle.PercentStyle
        numFormatter.maximumFractionDigits = 1
        numFormatter.multiplier = 1.0
        numFormatter.percentSymbol = " %"
        pieChartData.setValueFormatter(numFormatter)
        
        pieChartDataSet.sliceSpace = 2.0;
        pieChartView.usePercentValuesEnabled = true;
        pieChartView.holeTransparent = true;
        pieChartView.holeRadiusPercent = 0.40 //0.58
        pieChartView.transparentCircleRadiusPercent = 0.43 //0.61
        pieChartView.drawHoleEnabled = true;
        pieChartView.rotationAngle = 0.0;
        pieChartView.rotationEnabled = true;
        
        pieChartView.legend.position = ChartLegend.ChartLegendPosition.RightOfChart
        pieChartView.legend.xEntrySpace = 7.0
        pieChartView.legend.yEntrySpace = 0.0
        pieChartView.legend.yOffset = 0.0
        pieChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: ChartEasingOption.EaseOutBack)
        
        var colors: [UIColor] = []
        //colors.append(UIColor.blueColor())
        //colors.append(UIColor.grayColor())
        colors.appendContentsOf(ChartColorTemplates.colorful())
        pieChartDataSet.colors = colors
        
        pieChartView.data = pieChartData
    }
    
    @IBAction func saveChartToCameraRoll(sender: AnyObject) {
        //figure out which chart they are looking at first
        if(currentViewingChartType == 0) {
            lineChartView.saveToCameraRoll()
        } else if(currentViewingChartType == 1) {
            pieChartView.saveToCameraRoll()
        }
        let alert = UIAlertController(title: "Success", message: "This trends chart has been saved to you camera roll.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: {})
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
