//
//  RecurrenceVC.swift
//  ProactiveLiving
//
//  Created by Affle on 09/11/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import UIKit

class RecurrenceVC: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate {
    
//    @IBOutlet weak var tf_start_appointment: CustomTextField!
//    @IBOutlet weak var txt_end_appointment: CustomTextField!
//    @IBOutlet weak var tf_duration_appointment: CustomTextField!
    @IBOutlet weak var tf_recureEvery: CustomTextField!
    
    @IBOutlet weak var tf_startDate_rangeOfRecurrence: CustomTextField!
    @IBOutlet weak var tf_startDate_at_rangeOfRecurrence: CustomTextField!
    @IBOutlet weak var tf_occurrence: CustomTextField!
    @IBOutlet weak var tf_endDateRangeofRecurrence: CustomTextField!
    
    @IBOutlet weak var btn_daily_recrrence: UIButton!
    @IBOutlet weak var btn_weekly_recrrence: UIButton!
    @IBOutlet weak var btn_monthly_recrrence: UIButton!
    @IBOutlet weak var btn_yearly_recrrence: UIButton!
    @IBOutlet weak var btn_Mon: UIButton!
    @IBOutlet weak var btn_tue: UIButton!
    @IBOutlet weak var btn_wed: UIButton!
    @IBOutlet weak var btn_thur: UIButton!
    @IBOutlet weak var btn_fri: UIButton!
    @IBOutlet weak var btn_sat: UIButton!
    @IBOutlet weak var btn_sun: UIButton!
    @IBOutlet weak var btn_noEndDate: UIButton!
    @IBOutlet weak var btn_endAfter: UIButton!
    @IBOutlet weak var btn_endBy: UIButton!
    
    @IBOutlet weak var lbl_selectedRecurrenceType: UILabel!
    
    
    
    var datePicker : UIDatePicker!
    var recurrencePatternStr:String = "Weekly"
    var startDateOfRecurrenceStr:String = ""
    var startDateAtOfRecurrenceStr:String = ""
    var endDateOfRecurrenceStr:String = ""
    var parentVC:CreateMeetUpVC!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.setRecurrencePaternBtnImg(self.btn_weekly_recrrence)
        
        //Recurrence Btn
    //    self.setUpRecurrenceBtnBorder(self.btn_Mon)
        
        self.setUpEndRecurrenceBtnImg(self.btn_endBy)
        endDateOfRecurrenceStr = "End After";
        
        self.tf_startDate_rangeOfRecurrence.text = startDateOfRecurrenceStr
        self.tf_startDate_at_rangeOfRecurrence.text = startDateAtOfRecurrenceStr
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARKS:-
    
    func setUp() -> Void {
        
        //for start text field
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        //Date Picker
        datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.Date
        
        let toolBar1 = UIToolbar()
        toolBar1.barStyle = UIBarStyle.Default
        toolBar1.translucent = true
        //toolBar1.tintColor = UIColor(red: 76/255, green: 17/255, blue: 100/255, alpha: 1)
        toolBar1.sizeToFit()
        
        let doneButton1 = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CreateMeetUpVC.doneDatePicker))
        toolBar1.setItems([spaceButton, doneButton1], animated: false)
        toolBar1.userInteractionEnabled = true
        
        self.tf_endDateRangeofRecurrence.inputView=datePicker
        self.tf_endDateRangeofRecurrence.inputAccessoryView = toolBar1
        
        
    }
    
    //MARK: Btn
    
    //MARK: Btn
    
    //Recurrence Pattern
    func setRecurrencePaternBtnImg(btn:UIButton) -> Void  {
        
        self.btn_daily_recrrence.setImage(UIImage(named: "radio"), forState: UIControlState.Normal)
        self.btn_weekly_recrrence.setImage(UIImage(named: "radio"), forState: UIControlState.Normal)
        self.btn_monthly_recrrence.setImage(UIImage(named: "radio"), forState: UIControlState.Normal)
        self.btn_yearly_recrrence.setImage(UIImage(named: "radio"), forState: UIControlState.Normal)
        
        btn.setImage(UIImage(named: "radio_selected"), forState: UIControlState.Normal)
    }
    
    
    func setUpRecurrenceBtnBorder(button:UIButton) -> Void {
        
        
        self.btn_Mon.layer.borderWidth = 1
        self.btn_Mon.layer.borderColor = UIColor.grayColor().CGColor
        self.btn_Mon.backgroundColor = UIColor.clearColor()
        self.btn_Mon.titleLabel?.textColor = UIColor.init(red: 90/255.0, green: 90/255.0, blue: 90/255.0, alpha: 1)
        
        self.btn_tue.layer.borderWidth = 1
        self.btn_tue.layer.borderColor = UIColor.grayColor().CGColor
        self.btn_tue.backgroundColor = UIColor.clearColor()
        self.btn_tue.titleLabel?.textColor = UIColor.init(red: 90/255.0, green: 90/255.0, blue: 90/255.0, alpha: 1)
        
        self.btn_wed.layer.borderWidth = 1
        self.btn_wed.layer.borderColor = UIColor.grayColor().CGColor
        self.btn_wed.backgroundColor = UIColor.clearColor()
        self.btn_wed.titleLabel?.textColor = UIColor.init(red: 90/255.0, green: 90/255.0, blue: 90/255.0, alpha: 1)
        
        self.btn_thur.layer.borderWidth = 1
        self.btn_thur.layer.borderColor = UIColor.grayColor().CGColor
        self.btn_thur.backgroundColor = UIColor.clearColor()
        self.btn_thur.titleLabel?.textColor = UIColor.init(red: 90/255.0, green: 90/255.0, blue: 90/255.0, alpha: 1)
        
        self.btn_fri.layer.borderWidth = 1
        self.btn_fri.layer.borderColor = UIColor.grayColor().CGColor
        self.btn_fri.backgroundColor = UIColor.clearColor()
        self.btn_fri.titleLabel?.textColor = UIColor.init(red: 90/255.0, green: 90/255.0, blue: 90/255.0, alpha: 1)
        
        self.btn_sat.layer.borderWidth = 1
        self.btn_sat.layer.borderColor = UIColor.grayColor().CGColor
        self.btn_sat.backgroundColor = UIColor.clearColor()
        self.btn_sat.titleLabel?.textColor = UIColor.init(red: 90/255.0, green: 90/255.0, blue: 90/255.0, alpha: 1)
        
        self.btn_sun.layer.borderWidth = 1
        self.btn_sun.layer.borderColor = UIColor.grayColor().CGColor
        self.btn_sun.backgroundColor = UIColor.clearColor()
        self.btn_sun.titleLabel?.textColor = UIColor.init(red: 90/255.0, green: 90/255.0, blue: 90/255.0, alpha: 1)
        
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.grayColor().CGColor
        button.backgroundColor = UIColor.init(red: 1/255.0, green: 174/255.0, blue: 240/255.0, alpha: 1)
        button.titleLabel?.textColor = UIColor.whiteColor()
        
        
    }
    
    func setUpEndRecurrenceBtnImg(btn:UIButton) -> Void {
        
        self.btn_noEndDate.setImage(UIImage(named: "radio"), forState: UIControlState.Normal)
        self.btn_endAfter.setImage(UIImage(named: "radio"), forState: UIControlState.Normal)
        self.btn_endBy.setImage(UIImage(named: "radio"), forState: UIControlState.Normal)
        
        btn.setImage(UIImage(named: "radio_selected"), forState: UIControlState.Normal)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: OnClick Btn
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func btnDoneClick(sender: AnyObject) {
        if  self.tf_recureEvery.text?.characters.count < 1 {
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Recurrence every cann't be blank.", delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return
        }
        var dict = [String:String]()
        dict["pattern"] = recurrencePatternStr
        dict["recurevery"] = String(self.tf_recureEvery.text!)
        
        if endDateOfRecurrenceStr == "No End Date" {
            dict["isNoEndDate"] = String(true)
        }
        else if endDateOfRecurrenceStr == "No End Date" {
            dict["occurance"] = self.tf_occurrence.text
        }
        else{
            dict["endBy"] = self.tf_endDateRangeofRecurrence.text
        }
        
        
        
        if parentVC != nil {
            parentVC.recurrenceDict = dict            
        }
        
        
        self.navigationController!.popViewControllerAnimated(true)
    
    }

    @IBAction func onClickDailyBtn(sender: AnyObject) {
        self.setRecurrencePaternBtnImg(self.btn_daily_recrrence)
        self.lbl_selectedRecurrenceType.text = "Daily(s) on"
    }
    @IBAction func onClickWeeklyBtn(sender: AnyObject) {
        self.setRecurrencePaternBtnImg(self.btn_weekly_recrrence)
        self.lbl_selectedRecurrenceType.text = "Weekly(s) on"
    }
    
    @IBAction func onClickMonthlyBtn(sender: AnyObject) {
        self.setRecurrencePaternBtnImg(self.btn_monthly_recrrence)
        self.lbl_selectedRecurrenceType.text = "Monthly(s) on"
    }
    
    @IBAction func onClickYearlyBtn(sender: AnyObject) {
        self.setRecurrencePaternBtnImg(self.btn_yearly_recrrence)
        self.lbl_selectedRecurrenceType.text = "Yearly(s) on"
    }
    
    
    @IBAction func onClickMonBtn(sender: AnyObject) {
        self.setUpRecurrenceBtnBorder(self.btn_Mon)
    }
    @IBAction func onClickTueBtn(sender: AnyObject) {
        self.setUpRecurrenceBtnBorder(self.btn_tue)
    }
    
    @IBAction func onClickWedBtn(sender: AnyObject) {
        self.setUpRecurrenceBtnBorder(self.btn_wed)
    }
    
    @IBAction func onClickThurBtn(sender: AnyObject) {
        self.setUpRecurrenceBtnBorder(self.btn_thur)
    }
    @IBAction func onClickFridayBtn(sender: AnyObject) {
        self.setUpRecurrenceBtnBorder(self.btn_fri)
    }
    
    @IBAction func onClickSatBtn(sender: AnyObject) {
        self.setUpRecurrenceBtnBorder(self.btn_sat)
    }
    @IBAction func onClickSunBtn(sender: AnyObject) {
        self.setUpRecurrenceBtnBorder(self.btn_sun)
    }
    
    
    
    @IBAction func onClickNoEndDateBtn(sender: AnyObject) {
        self.setUpEndRecurrenceBtnImg(self.btn_noEndDate)
        
        self.tf_occurrence.text = "";
        self.tf_endDateRangeofRecurrence.text = ""
        self.tf_endDateRangeofRecurrence.text = "No End Date";
    }
    
    @IBAction func onClickEndAfterBtn(sender: AnyObject) {
        self.setUpEndRecurrenceBtnImg(self.btn_endAfter)
        
        self.tf_occurrence.text = "5";
        self.tf_endDateRangeofRecurrence.text = "End After";
        
        //calculate End Recurrance Date
        self.calculateEndDateOfRecurrence()
        
    }
    @IBAction func onClickEndByBtn(sender: AnyObject) {
        self.setUpEndRecurrenceBtnImg(self.btn_endBy)
        
        self.tf_occurrence.text = "";
        self.tf_endDateRangeofRecurrence.text = ""
        self.tf_endDateRangeofRecurrence.text = "End By";
    }
    
    //MARK:
    func calculateEndDateOfRecurrence() -> Void {
        
        let df = NSDateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        
        let startDate:NSDate = df.dateFromString(self.startDateOfRecurrenceStr)!
        let daysToAdd =  Double(self.tf_occurrence.text!)
        let endDate:NSDate = startDate.dateByAddingTimeInterval(60*60*24*daysToAdd!)
        
        self.tf_endDateRangeofRecurrence.text = df.stringFromDate(endDate)
        
    }
    //MARK: TextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.tf_occurrence {
            self.calculateEndDateOfRecurrence()
        }
        
        if  self.tf_recureEvery.text?.characters.count < 1 {
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Recurrence every cann't be blank.", delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
        }
        
        return true
    }
    
    
    //MARK: Picker Btn
    
    func doneDatePicker() {
        
       
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = "dd/MM/yyyy"
        let selectedDate = dateFormatter1.stringFromDate(datePicker.date)
        
        self.tf_endDateRangeofRecurrence.text = selectedDate
        self.tf_endDateRangeofRecurrence.resignFirstResponder()
        print("done!")
    }
  
    
    
    //MARK: Picker Delegate
    
    //MARK:- PICKERVIEW DELEGATE METHODS
    func pickerView(_pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       // return self.arrTypes.count
        return 5
        
    }
    func numberOfComponentsInPickerView(_pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      //  return self.arrTypes[row]
        return "Row"
    }
    
}
