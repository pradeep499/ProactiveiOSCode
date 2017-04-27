//
//  CreateMeetUpVC.swift
//  ProactiveLiving
//
//  Created by Mohd Asim on 16/08/16.
//  Copyright © 2016 appstudioz. All rights reserved.
//

import Foundation



class CreateMeetUpVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, TLTagsControlDelegate, GooglePlacesAutocompleteDelegate, UIDocumentMenuDelegate, UIDocumentPickerDelegate  {
    
    @IBOutlet weak var txtFieldFor: CustomTextField!
    @IBOutlet weak var txtFieldOn: CustomTextField!
    @IBOutlet weak var txtFieldAt: CustomTextField!
    @IBOutlet weak var txtField_eventEndTime: CustomTextField!
    @IBOutlet weak var txtFieldWhereFirst: CustomTextField!
    @IBOutlet weak var txtFieldWhereSecond: CustomTextField!
    @IBOutlet weak var txtFieldTitle: CustomTextField!
    @IBOutlet weak var imgCoverPic: UIImageView!
    @IBOutlet weak var txtViewDesc: UIPlaceHolderTextView!
    @IBOutlet weak var switchAllowInvite: UISwitch!
    @IBOutlet weak var tokenField: TLTagsControl!
    @IBOutlet weak var containerViewTF: UIView!
    @IBOutlet weak var tableAttachments: UITableView!
    @IBOutlet weak var txtDialInNum: CustomTextField!
    @IBOutlet weak var txtPin: CustomTextField!
    @IBOutlet weak var titleBar: UILabel!
    
    @IBOutlet weak var txtFieldFakeRecurrence: CustomTextField!

    @IBOutlet weak var m_footerView: UIView!
    @IBOutlet weak var lblWithWho: UILabel!
    @IBOutlet weak var lblForTo: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    //weak var pickerView: UIPickerView!
    weak var toolBar: UIToolbar!
    var tokens = [AnyObject]()
    var arrTypes = [String]()
    var activeTextField:UITextField!
    var pickerView:UIPickerView!
    var datePicker : UIDatePicker!
    var timePicker : UIDatePicker!
    var arrAttachments = [AnyObject]()
    var gpaViewController : GooglePlacesAutocomplete!
    var pushedFrom : String!
    var isForwardAllowed : Bool!
    var dataDict = [String : AnyObject]()
    var arrPACMembers = [[String : AnyObject]]()
    var strLatLong : String!
    var fromScreenFlag : String!
    var pacID : String!
    var recurrenceDict:[String:String]!

    override func viewDidLoad() {
        super.viewDidLoad()
    //"AIzaSyCwX2QTq72LeMHwJ8ymH6TGGJP8iqMoFLU"
        gpaViewController = GooglePlacesAutocomplete(
            apiKey: "AIzaSyCofV_YsTjl-9lu2m4rOCj1bMmW4PS1Td0",
            placeType: .Address
        )
        txtFieldWhereSecond.addTarget(self, action: #selector(addressTextFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingDidBegin)

        
        //Date Picker
        datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.minimumDate = NSDate()
        

        if(pushedFrom=="MEETUPS")
        {
            self.titleBar.text = "New Meet Up"
            //self.arrTypes = ["We", "Heart", "Potluck"]
            self.txtFieldWhereSecond.hidden=false
            self.txtPin.hidden=true
            self.txtDialInNum.hidden=true
            self.lblWithWho.text="With"
            self.lblForTo.text="For"
            self.lblTitle.text="Meet Up Title"
        }
        else if(pushedFrom=="WEBINVITES")
        {
            self.titleBar.text = "New Web Invite"
            self.txtFieldWhereFirst.placeholder="Web Invite Link"
            //self.arrTypes = ["Conference Call", "Podcast", "Videocast", "Webinar", "Webcast"]
            self.txtFieldWhereSecond.hidden=true
            self.txtPin.hidden=false
            self.txtDialInNum.hidden=false
            self.lblWithWho.text="Who"
            self.lblForTo.text="To"
            self.lblTitle.text="Web Invite Title"
        }
        else if(pushedFrom=="EDITMEETUPS")
        {
            self.titleBar.text = "Edit Meet Up"
            //self.arrTypes = ["We", "Heart", "Potluck"]
            self.txtFieldWhereSecond.hidden=false
            self.txtPin.hidden=true
            self.txtDialInNum.hidden=true
            self.lblWithWho.text="With"
            self.lblForTo.text="For"
            self.lblTitle.text="Meet Up Title"
            
            //self.tokens = self.dataDict["members"] as! Array
            
            for item in (self.dataDict["members"] as! NSArray) {
                var tempData = item as! [String:AnyObject]
                if ((tempData["memberId"] as! String) != ChatHelper.userDefaultForKey(_ID)){
                    var tempDict = Dictionary <String,String>()
                    tempDict["firstName"] = tempData["name"] as? String
                    tempDict["_id"] = tempData["memberId"] as? String
                    tempDict["mobilePhone"] = tempData["mobilePhone"] as? String
                    tempDict["imgUrl"] = tempData["imgUrl"] as? String
                    tempDict["forwardedBy"] = tempData["forwardedBy"] as? String
                    tempDict["status"] = tempData["status"] as? String
                    
                    self.tokens.append(tempDict)
                }
                
            }
            
            for contact in self.tokens {
                 self.tokenField.tags.addObject(contact["firstName"]!!)
                
            }
            
            self.arrAttachments = self.dataDict["links"] as! Array
            
            self.tableAttachments.reloadData()
            self.tokenField.reloadTagSubviews()

            txtFieldFor.text = self.dataDict["for"] as? String
            let on = self.dataDict["eventDate"] as? String
        
            txtFieldOn.text = convert(time: on!, fromFormat: "dd/MM/yyyy", toFormat: "MM/dd/yyyy")
            
            
            
            
            txtFieldAt.text = self.dataDict["eventStartTime"] as? String
            txtField_eventEndTime.text = self.dataDict["eventEndTime"] as? String
            txtFieldWhereFirst.text = self.dataDict["locationName"] as? String
            txtFieldWhereSecond.text = self.dataDict["address"] as? String
            txtFieldTitle.text = self.dataDict["title"] as? String
            txtViewDesc.text = self.dataDict["desc"] as? String
            switchAllowInvite.on = self.dataDict["isAllow"] as! Bool
            let imgUrl = self.dataDict["imgUrl"] as? String
            if !(imgUrl == "") {
                imgCoverPic.setImageWithURL(NSURL(string: imgUrl!))
            }
            
        }
        else if(pushedFrom=="EDITWEBINVITES")
        {
            self.titleBar.text = "Edit Web Invite"
            self.txtFieldWhereFirst.placeholder="Web Invite Link"
            //self.arrTypes = ["Conference Call", "Podcast", "Videocast", "Webinar", "Webcast"]
            self.txtFieldWhereSecond.hidden=true
            self.txtPin.hidden=false
            self.txtDialInNum.hidden=false
            self.lblWithWho.text="Who"
            self.lblForTo.text="To"
            self.lblTitle.text="Web Invite Title"

            
            for item in (self.dataDict["members"] as! NSArray) {
                var tempData = item as! [String:AnyObject]
                if ((tempData["memberId"] as! String) != ChatHelper.userDefaultForKey(_ID)){
                    var tempDict = Dictionary <String,String>()
                    tempDict["firstName"] = tempData["name"] as? String
                    tempDict["_id"] = tempData["memberId"] as? String
                    tempDict["mobilePhone"] = tempData["mobilePhone"] as? String
                    tempDict["imgUrl"] = tempData["imgUrl"] as? String
                    tempDict["forwardedBy"] = tempData["forwardedBy"] as? String
                    tempDict["status"] = tempData["status"] as? String
                    
                    self.tokens.append(tempDict)
                }
                
            }
            
            for contact in self.tokens {
                self.tokenField.tags.addObject(contact["firstName"]!!)
            }
            self.arrAttachments = self.dataDict["links"] as! Array
            
            self.tableAttachments.reloadData()
            self.tokenField.reloadTagSubviews()
            
            txtFieldFor.text = self.dataDict["for"] as? String
            let on = self.dataDict["eventDate"] as? String
            
            txtFieldOn.text = convert(time: on!, fromFormat: "dd/MM/yyyy", toFormat: "MM/dd/yyyy")

            
            txtFieldAt.text = self.dataDict["eventStartTime"] as? String
            txtField_eventEndTime.text = self.dataDict["eventEndTime"] as? String
            txtFieldWhereFirst.text = self.dataDict["webLink"] as? String
            txtDialInNum.text = self.dataDict["dialInNumber"] as? String
            txtPin.text = self.dataDict["pin"] as? String
            txtFieldTitle.text = self.dataDict["title"] as? String
            txtViewDesc.text = self.dataDict["desc"] as? String
            switchAllowInvite.on = self.dataDict["isAllow"] as! Bool
            let imgUrl = self.dataDict["imgUrl"] as? String
            if !(imgUrl == "") {
                imgCoverPic.sd_setImageWithURL(NSURL(string: imgUrl!))
            }
            
        }
        
        if(self.fromScreenFlag != nil && self.fromScreenFlag == "PAC") {
            
            for item in self.arrPACMembers {
                var tempDict = Dictionary <String,String>()
                tempDict["firstName"] = item["firstName"] as? String
                tempDict["_id"] = item["_id"] as? String
                tempDict["mobilePhone"] = item["mobilePhone"] as? String
                tempDict["imgUrl"] = item["imgUrl"] as? String
                
                self.tokens.append(tempDict)
                
            }
            
            for contact in self.tokens {
                self.tokenField.tags.addObject(contact["firstName"]!!)
            }
            
            self.tokenField.reloadTagSubviews()

        }
        
        isForwardAllowed = switchAllowInvite.on
        txtField_eventEndTime.delegate = self
        txtFieldAt.delegate = self
        txtFieldTitle.delegate=self
        self.tokenField.tagPlaceholder = "Add here";
        //self.tokenField.mode = TLTagsControlMode.Edit ;
        self.tokenField.tagsDeleteButtonColor = UIColor.lightGrayColor()
        self.tokenField.tapDelegate=self
        
        AppHelper.setBorderOnView(self.containerViewTF)
        AppHelper.setBorderOnView(self.txtViewDesc)

        pickerView = UIPickerView()
        pickerView.frame=CGRectMake(0, screenHeight-240, screenWidth, 240)
        pickerView.backgroundColor = .whiteColor()
        
        pickerView.showsSelectionIndicator = true
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        //toolBar.tintColor = UIColor(red: 76/255, green: 17/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CreateMeetUpVC.doneTypesPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        //let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "donePicker")
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
      //  pickerView.backgroundColor = UIColor.redColor()
        txtFieldFor.inputView = pickerView
        txtFieldFor.inputAccessoryView = toolBar
        
        
        

        let toolBar1 = UIToolbar()
        toolBar1.barStyle = UIBarStyle.Default
        toolBar1.translucent = true
        //toolBar1.tintColor = UIColor(red: 76/255, green: 17/255, blue: 100/255, alpha: 1)
        toolBar1.sizeToFit()
        
        let doneButton1 = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CreateMeetUpVC.doneDatePicker))
        toolBar1.setItems([spaceButton, doneButton1], animated: false)
        toolBar1.userInteractionEnabled = true
        
        txtFieldOn.inputView=datePicker
        txtFieldOn.inputAccessoryView = toolBar1
        
        //Time Picker
        timePicker = UIDatePicker()
        timePicker.datePickerMode = UIDatePickerMode.Time
        timePicker.minimumDate = NSDate()

        let toolBar2 = UIToolbar()
        toolBar2.barStyle = UIBarStyle.Default
        toolBar2.translucent = true
        //toolBar2.tintColor = UIColor(red: 76/255, green: 17/255, blue: 100/255, alpha: 1)
        toolBar2.sizeToFit()
        
        let doneButton2 = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CreateMeetUpVC.doneTimePicker))
        toolBar2.setItems([spaceButton, doneButton2], animated: false)
        toolBar2.userInteractionEnabled = true
        
        txtFieldAt.inputView=timePicker
        txtFieldAt.inputAccessoryView = toolBar2
        
        let toolBarEndTime = UIToolbar()
        toolBarEndTime.barStyle = UIBarStyle.Default
        toolBarEndTime.translucent = true
        //toolBar2.tintColor = UIColor(red: 76/255, green: 17/255, blue: 100/255, alpha: 1)
        toolBarEndTime.sizeToFit()
        
        let doneButtonEndTime = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CreateMeetUpVC.doneTimePickerEndTime))
        toolBarEndTime.setItems([spaceButton, doneButtonEndTime], animated: false)
        toolBarEndTime.userInteractionEnabled = true
        
        
        txtField_eventEndTime.inputView=timePicker
        txtField_eventEndTime.inputAccessoryView = toolBarEndTime
        

        self.txtFieldFor.rightViewMode = UITextFieldViewMode.Always
        let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView1.image = UIImage(named: "down_arrow")
        self.txtFieldFor.rightView = imageView1
        
        self.txtFieldOn.rightViewMode = UITextFieldViewMode.Always
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView2.image = UIImage(named: "create_meetup_select_date")
        self.txtFieldOn.rightView = imageView2
        
        
        txtFieldAt.rightViewMode = UITextFieldViewMode.Always
        let imageView3 = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView3.image = UIImage(named: "create_meetup_select_time")
        txtFieldAt.rightView = imageView3
        
        
        self.txtField_eventEndTime.rightViewMode = UITextFieldViewMode.Always
        let ivTime = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        ivTime.image = UIImage(named: "create_meetup_select_time")
        self.txtField_eventEndTime.rightView = ivTime
        
        self.txtFieldWhereSecond.rightViewMode = UITextFieldViewMode.Always
        let imageView4 = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView4.image = UIImage(named: "create_meetup_select_location")
        self.txtFieldWhereSecond.rightView = imageView4
        
        self.txtFieldOn.rightViewMode = UITextFieldViewMode.Always
        let imageView5 = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView5.image = UIImage(named: "create_meetup_select_date")
        self.txtFieldOn.rightView = imageView5

        IQKeyboardManager.sharedManager().enableAutoToolbar=false
        IQKeyboardManager.sharedManager().enable=false
        
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(GroupDetailVC.clickUserImage(_:)))
        recognizer.delegate = self
        imgCoverPic.addGestureRecognizer(recognizer)
        imgCoverPic.userInteractionEnabled = true
        imgCoverPic.layer.cornerRadius = imgCoverPic.frame.height/2
        imgCoverPic.clipsToBounds = true
        imgCoverPic.setImageWithURL(NSURL(string:""), placeholderImage: UIImage(named:"profile.png"))
        
        self.tableAttachments.separatorStyle = UITableViewCellSeparatorStyle.None
        self.txtViewDesc.placeholder = "Minimum 50 words"
        
        IQKeyboardManager.sharedManager().enable=true
        IQKeyboardManager.sharedManager().enableAutoToolbar=true

        self.getPickerDataFromServer()
        self.listenerCreateMeetUpOrWebInvite()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = true
        
        HelpingClass.getUserDetails()
    }
    
    func addCotact(contact : [String : AnyObject] ) -> Void {
        
        if (self.tokens as NSArray).containsObject(contact) {
            return
        }
        self.tokens.append(contact)
        //let lastNames = self.tokens.map({$0["firstName"]! as! String}) as [String]
        self.tokenField.tags.addObject(contact["firstName"]!)
        self.tokenField.reloadTagSubviews()
    }
    
    //MARK:- Btn Action
    
    func convert(time time: String, fromFormat fromFormate:String, toFormat toFormate:String) -> String
    {

        let dateFormatter = NSDateFormatter()
         dateFormatter.dateFormat = fromFormate
        let date = dateFormatter.dateFromString(time)
        
        let dateFormatterNw = NSDateFormatter()
        dateFormatterNw.dateFormat = toFormate
        let result = dateFormatterNw.stringFromDate(date!)
        
        datePicker.minimumDate = dateFormatterNw.dateFromString(result)

        return result
    }
    
    
    
    //MARK:- TLTagsControlDelegate
    func tagsControl(tagsControl: TLTagsControl!, tappedAtIndex index: Int) {
        print("Tag was tapped ", tagsControl.tags[index]);
    }
    
    func tagsControl(tagsControl: TLTagsControl!, deletedAtIndex index: Int) {
        print("Tag was deleted ", tagsControl.tags[index]);
       
        self.tokens.removeAtIndex(index)
        tagsControl.tags.removeObjectAtIndex(index)
        self.tokenField.reloadTagSubviews()
        
    }
    
    //MARK:- PICKERVIEW DELEGATE METHODS
    func pickerView(_pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrTypes.count
    }
    func numberOfComponentsInPickerView(_pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.arrTypes[row]
    }
    
    func doneTypesPicker() {
       
        self.txtFieldFor.resignFirstResponder()

        if(self.arrTypes.count>0)
        {
            let type = self.arrTypes[pickerView.selectedRowInComponent(0)]
            
            if(!(type == "Other"))
            {
                self.txtFieldFor.text = self.arrTypes[pickerView.selectedRowInComponent(0)]
            }
            else
            {
                self.showAlertForOtherType()
            }
            print("done!")
        }
    }
    
    func showAlertForOtherType() {
        
        let alertController = UIAlertController(title: "Other", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Add your choice"
        }
        
        let doneAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            
            let titleTextField = alertController.textFields![0] as UITextField
            
            if (titleTextField.text?.characters.count > 0)
            {
               self.txtFieldFor.text = titleTextField.text! as String
                
            }
            self.txtFieldFor.resignFirstResponder()
            
        })
        
        
        alertController.addAction(doneAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func toGetCurrentTime(selectedDate : NSDate){
        
        let date = NSDate()
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = "MM/dd/yyyy"
        let currenStr = dateFormatter1.stringFromDate(date)
        let selectedStr = dateFormatter1.stringFromDate(selectedDate)
        let result = dateFormatter1.dateFromString(currenStr)?.compare(dateFormatter1.dateFromString(selectedStr)!)
        
        if result == NSComparisonResult.OrderedSame{
            timePicker.minimumDate = NSDate()
        }else{
            let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let currentDate: NSDate = NSDate()
            let components: NSDateComponents = NSDateComponents()
            components.year = -18
            
            let minDate: NSDate = gregorian.dateByAddingComponents(components, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
            timePicker.minimumDate = minDate

            
        }
        
    
    }
    
    func doneDatePicker() {
        
        
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = "MM/dd/yyyy"
        let selectedDate = dateFormatter1.stringFromDate(datePicker.date)
      
        self.txtFieldOn.text = selectedDate
        toGetCurrentTime(datePicker.date)
        
        self.txtFieldAt.text = ""
        
        if !((pushedFrom=="MEETUPS") || (pushedFrom=="WEBINVITES")){
            self.txtField_eventEndTime.text = ""

        }

        
        self.txtFieldOn.resignFirstResponder()
        print("done!")
    }
    
    func doneTimePicker() {
        
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = "hh:mm a"
        let selectedDate = dateFormatter1.stringFromDate(timePicker.date)
        
        self.txtFieldAt.text = selectedDate
        self.txtFieldAt.resignFirstResponder()
        
       // self.timePicker.minimumDate = timePicker.date
        
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateByAddingUnit(.Minute, value: 59, toDate: timePicker.date, options: [])
        self.txtField_eventEndTime.text = dateFormatter1.stringFromDate(date!)
        
        
        print("done!")
    }
    
    func doneTimePickerEndTime() {
        
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = "hh:mm a"
        let selectedDateStr = dateFormatter1.stringFromDate(timePicker.date)
        let selectedDate  = dateFormatter1.dateFromString(selectedDateStr)
        let selectedDatePrevoius = dateFormatter1.dateFromString(self.txtFieldAt.text!)
        
        let compareResult = selectedDatePrevoius!.compare(selectedDate!)
        if compareResult == NSComparisonResult.OrderedAscending {
            self.txtField_eventEndTime.text = selectedDateStr
            self.txtField_eventEndTime.resignFirstResponder()
            
        }else{
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please select time greater than Start At time.", delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
        }
        
        
        
        
       
    }
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == txtField_eventEndTime{
            if (txtFieldAt.text?.characters.count == 0){
            txtField_eventEndTime.resignFirstResponder()
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please select first Start At time.", delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
        }
        print_debug(textField.description)

        activeTextField = textField
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
            if textField == self.txtFieldTitle {
                
                let maxLength = 23
                let currentString: NSString = textField.text!
                let newString: NSString =
                    currentString.stringByReplacingCharactersInRange(range, withString: string)
                return newString.length <= maxLength
            }
           
            
            
            return true
        }
    
    
    
    //mark- UITableview Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAttachments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableAttachments.dequeueReusableCellWithIdentifier("cellAttachments", forIndexPath: indexPath) as UITableViewCell
        cell.selectionStyle = .None
        let attachmentName = cell.contentView.viewWithTag(111) as! UITextView
        let closeButton = cell.contentView.viewWithTag(222) as! UIButton
        closeButton.addTarget(self, action: #selector(btnDeleteClick(_:)), forControlEvents: .TouchUpInside)
        let backView = cell.contentView.viewWithTag(333)! as UIView
        AppHelper.setBorderOnView(backView)
        attachmentName.text = self.arrAttachments[indexPath.row]["title"] as! String
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func btnDeleteClick(sender: UIButton)  {
        print(sender)
        
        let point = self.tableAttachments.convertPoint(CGPoint.zero, fromView: sender)
        guard let indexPath = self.tableAttachments.indexPathForRowAtPoint(point) else {
            fatalError("can't find point in tableView")
        }
        self.arrAttachments.removeAtIndex(indexPath.row)
        self.tableAttachments.reloadData()
    }
    
    @IBAction func btnDoneClick(sender: AnyObject) {
        
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            let button = sender as! UIButton

            if (self.tokens.count == 0) {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please select at least one contact.", delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                
            }
            else if (self.txtFieldFor.text!.characters.count == 0)
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please select type.", delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
            else if (self.txtFieldOn.text!.characters.count == 0)
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please select date.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
            else if (self.txtFieldAt.text!.characters.count == 0)
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please select time.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
            else if (self.txtFieldWhereFirst.text!.characters.count == 0)
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please enter address.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
            else if (self.txtFieldTitle.text!.characters.count == 0)
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please enter title.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
            else if (self.txtViewDesc.text!.characters.count == 0)
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please enter description.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
            else
            {
                var linksArray : NSMutableArray!
                linksArray = NSMutableArray()
                
                button.userInteractionEnabled=false
                showActivityIndicator(self.view)
                var dict = Dictionary<String,AnyObject>()
                dict["title"]=self.txtFieldTitle.text! as String
                dict["desc"]=txtViewDesc.text
                
                if(pushedFrom=="MEETUPS" || self.pushedFrom == "EDITMEETUPS") {
                    dict["type"]="meetup"
                    dict["venue"]=self.txtFieldWhereFirst.text
                    dict["address"]=self.txtFieldWhereSecond.text
                }
                else {
                    dict["type"]="webinvite"
                    dict["dialInNumber"] = txtDialInNum.text ?? ""
                    dict["pin"] = txtPin.text ?? ""
                    dict["webLink"]=self.txtFieldWhereFirst.text
                }
                
                
                if(self.fromScreenFlag != nil && self.fromScreenFlag == "PAC") {
                    dict["calendarType"]="pac"
                    dict["pacId"] = self.pacID
                }
                else {
                    dict["calendarType"]="private"
                }
                
                dict["for"]=txtFieldFor.text
                
                for link in self.arrAttachments {
                    var dicLinks = Dictionary<String,AnyObject>()
                    dicLinks["title"] = link ["title"]
                    dicLinks["url"] = link ["url"]
                    linksArray.addObject(dicLinks)
                }
                
                dict["links"]=linksArray as [AnyObject]
                dict["attachments"]="abc.png"
                dict["createdBy"]=ChatHelper.userDefaultForKey("userId") as String
                dict["eventDate"] =   HelpingClass.convertDateFormat("MM/dd/yyyy", desireFormat:"dd/MM/yyyy", dateStr: txtFieldOn.text!)
                dict["eventStartTime"]=txtFieldAt.text
                dict["eventEndTime"]=txtField_eventEndTime.text
                dict["isAllow"]=isForwardAllowed

                var userIdArray : NSMutableArray!
                userIdArray = NSMutableArray()
                
                
                for myobject : AnyObject in self.tokens
                {
                    var tempDict = Dictionary<String,AnyObject>()
                    tempDict["userId"]=myobject["_id"] as! String
               //     tempDict["mobilePhone"]=myobject["mobilePhone"] as! String
                    
                    if let firstName = myobject["firstName"] as? String {
                        tempDict["firstName"] = firstName
                    }
                    if let mobilePhone = myobject["mobilePhone"] as? String {
                        tempDict["mobilePhone"] = mobilePhone
                    }
                    if let imgUrl = myobject["imgUrl"] as? String {
                        tempDict["imgUrl"] = imgUrl
                    }
                    if let forwardedBy = myobject["forwardedBy"] as? String {
                        tempDict["forwardedBy"] = forwardedBy
                    }
                    if let status = myobject["status"] as? String {
                        tempDict["status"] = status
                    }
                    
                    userIdArray.addObject(tempDict);
                }
                
                var tempDict = Dictionary<String,AnyObject>()
                tempDict["userId"]=ChatHelper.userDefaultForKey("userId") as String
                tempDict["mobilePhone"] = AppHelper.userDefaultsForKey(cellNum)
                userIdArray.addObject(tempDict);
                
              
                if(self.pushedFrom == "EDITMEETUPS" || self.pushedFrom == "EDITWEBINVITES")
                {
                    dict["groupId"] = self.dataDict["groupId"] as! String
                    dict["typeId"] = self.dataDict["_id"] as! String
                    dict["createdDate"] = self.dataDict["createdDate"] as! String
                    
                }
                else
                {
                    //group create data
                    var groupDict = [String: AnyObject]()
                    groupDict["userid"] = AppHelper.userDefaultsForKey(_ID)
                    groupDict["groupname"] = self.txtFieldTitle.text! as String
                    
                    var groupMembers = [AnyObject]()
                    var userDict = [String: AnyObject]()
                    userDict["userid"] = ChatHelper.userDefaultForKey(_ID)
                    userDict["phoneNumber"] = AppHelper.userDefaultsForKey(cellNum)
                    userDict["user_firstName"] = AppHelper.userDefaultsForKey(userFirstName)
                    groupMembers.append(userDict)
                    groupDict["users"] = groupMembers
                    dict["groupDetail"] = groupDict

                }
                
                dict["members"] = userIdArray
                dict["latlong"] = self.strLatLong
                
                
                if (recurrenceDict != nil) {
                    dict["isrecur"] = String(true)
                    dict["recurrence"] = recurrenceDict
                }else{
                    dict["isrecur"] = String(false)
                }
                
           
                print(dict)

                if self.imgCoverPic.image != nil
                {
                    let imageData = UIImageJPEGRepresentation(self.imgCoverPic.image!, 1.0)
                    
                    let baseUrlString = ChatBaseMediaUrl+ChatMediaPath
                    let url = NSURL(string: baseUrlString)?.absoluteString
                    let manager=AFHTTPRequestOperationManager()
                    
                    manager.POST(url, parameters: nil, constructingBodyWithBlock: {
                        (formdata:AFMultipartFormData!)-> Void  in
                        
                        if(imageData != nil)
                        {
                            formdata.appendPartWithFileData(imageData, name: "files", fileName: "image.jpg" as String, mimeType: "image/jpeg")
                        }
                        
                        
                        }, success:
                        {
                            operation, response -> Void in
                            
                            //Parsing JSON
                            var parsedData = JSON(response)
                            //  println_debug(parsedData)
                            dict["imgUrl"] = parsedData["filesUrl"].string
                            
                            button.userInteractionEnabled=true
                            
                            if(self.pushedFrom == "EDITMEETUPS" || self.pushedFrom == "EDITWEBINVITES")
                            {
                                ChatListner .getChatListnerObj().socket.emit("editMeetup_Invite", dict)
                                let delay = 2.0
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                                    stopActivityIndicator(self.view)
                                    self.navigationController?.popViewControllerAnimated(true)
                                })
                            }
                            else
                            {
                                ChatListner .getChatListnerObj().socket.emit("createMeetup_Invite", dict)
                                let delay = 2.0
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {                                    stopActivityIndicator(self.view)
                                    self.navigationController?.popViewControllerAnimated(true)
                                })
                            }
                            
                            
                        }, failure:
                        {
                            operation, response -> Void in
                            // println_debug(response)
                            button.userInteractionEnabled=true
                            stopActivityIndicator(self.view)
                            
                        }
                    )
                }else
                {
                    dict["imgUrl"] = ""
                    if(self.pushedFrom == "EDITMEETUPS" || self.pushedFrom == "EDITWEBINVITES")
                    {
                        ChatListner .getChatListnerObj().socket.emit("editMeetup_Invite", dict)
                        let delay = 2.0
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                            stopActivityIndicator(self.view)
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                    }
                    else
                    {
                        ChatListner .getChatListnerObj().socket.emit("createMeetup_Invite", dict)
                        
                        let delay = 2.0
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                            stopActivityIndicator(self.view)
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                    }
                    
                    
                }
                
                
            }
            
        }else
        {
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Internet Connection not available.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
        }
    }
    
    func listenerCreateMeetUpOrWebInvite() {
        
        if ServiceClass.checkNetworkReachabilityWithoutAlert()
        {
            
            ChatListner .getChatListnerObj().socket.off("getMeetup_Invite")
            ChatListner .getChatListnerObj().socket.on("getMeetup_Invite") {data, ack in
                
                print("value error_code\(data[0]["status"] as! String))")
                
                let errorCode = (data[0]["status"] as? String) ?? "1"
                
                if errorCode == "0"
                {
                    guard let dictData = data[0] as? Dictionary<String, AnyObject> else
                    {
                        return
                    }
                    
                    guard let resultDict = dictData["result"] as? Dictionary<String, AnyObject>  else
                    {
                        return
                    }
                    print("arrayList \(resultDict)")
                    
                    //Add newly created meeup/invite to phone calender
                    if let newEvent = resultDict["isNewMeetupInvite"] as? String {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm a"
                        let startDate = dateFormatter.dateFromString((resultDict["eventDate"] as! String) + " " + (resultDict["eventStartTime"] as! String))
                        let endDate = dateFormatter.dateFromString((resultDict["eventDate"] as! String) + " " + (resultDict["eventEndTime"] as! String))
                        let title = resultDict["title"] as! String
                        let notes = resultDict["desc"] as! String
                        
                        AppHelper.addEventToPhoneCalendarWithStartDate(startDate, endDate: endDate, withTitle: title, withNotes: notes)
                    }
                }
                else
                {
                    //SharedClass.sharedInstance.showOkAlertViewController(result!["response_string"] as! String, viewController: self)
                    
                }
            }
        }
    }
    
    @IBAction func btnAddContactClick(sender: AnyObject) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let friendListObj: AllContactsVC = storyBoard.instantiateViewControllerWithIdentifier("AllContactsVC") as! AllContactsVC
        friendListObj.fromVC="MeetUp"
        self.navigationController?.pushViewController(friendListObj, animated: true)
        
    }
    
    func getPickerDataFromServer(){
        
        if AppDelegate.checkInternetConnection() {
            //show indicator on screen
            AppDelegate.showProgressHUDWithStatus("Please wait..")
            var parameters = [String: AnyObject]()
            parameters["AppKey"] = AppKey
            parameters["UserID"] = AppHelper.userDefaultsForKey(_ID)
            
            //call global web service class
            Services.serviceCallWithPath(ServiceMeetUpInviteStaticData, withParam: parameters, success: { (responseDict) in
                
                print(responseDict)
                
                AppDelegate.dismissProgressHUD()
                //dissmiss indicator
                if ((responseDict["error"] as! Int) == 0) {
                    let items = responseDict["result"] as! [AnyObject]
                    self.arrTypes = items.map({$0["type"]! as! String}) as [String]
                    self.pickerView.reloadAllComponents()
                }
                else {
                    AppHelper.showAlertWithTitle(responseDict["errorMsg"] as! String, message: "", tag: 0, delegate: nil, cancelButton: "Ok", otherButton: nil)
                }
                
                }, failure: { (error) in
                    
                    AppDelegate.dismissProgressHUD()
                    //dissmiss indicator
                    AppHelper.showAlertWithTitle("", message: serviceError, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
            })
        }
        else {
            //show internet not available
            AppHelper.showAlertWithTitle(netError, message: netErrorMessage, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
        }
        
    }
    
    
    //MARK:- Image Picker Delegates
    func imagePickerController(picker:UIImagePickerController, didFinishPickingMediaWithInfo info:[String : AnyObject])
    {
        let tempImage = info[UIImagePickerControllerEditedImage] as! UIImage
        imgCoverPic.image = tempImage
        self.dismissViewControllerAnimated(true, completion: {
            //self.updateGroupDetails()
        })
        
    }
    
    func clickUserImage(recognizer:UITapGestureRecognizer)
    {
        
        if(IS_IOS_7)
        {
            let actionSheet = UIActionSheet(title: "Add Photo Through", delegate:self, cancelButtonTitle: nil, destructiveButtonTitle:nil, otherButtonTitles: "Camera","Gallery","Cancel")
            actionSheet.showInView( UIApplication.sharedApplication().keyWindow!)
            
        }
        else
        {
            let actionSheet =  UIAlertController(title: "Add Photo Through", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler:
                {(ACTION :UIAlertAction!)in
                    
                    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
                    {
                        let imagePicker = UIImagePickerController()
                        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                        imagePicker.mediaTypes = [String(kUTTypeImage)]
                        imagePicker.allowsEditing = true
                        imagePicker.delegate = self
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
                            switch authStatus {
                            case .Authorized:
                                self.presentViewController(imagePicker, animated: true, completion: nil)
                                break
                            case .Denied:
                                AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                            case .NotDetermined:
                                AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo,
                                    completionHandler: { (granted:Bool) -> Void in
                                        if granted {
                                             self.presentViewController(imagePicker, animated: true, completion: nil)
                                        }
                                        else {
                                            AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                                        }
                                })
                            default:
                                AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                                
                            }
                        })
                        
                        
//                        self.presentViewController(imagePicker, animated: true, completion: nil)
                    }
                    
                    
            }))
            actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default, handler:
                { (ACTION :UIAlertAction!)in
                    
                    let imagePicker = UIImagePickerController()
                    imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                    imagePicker.mediaTypes = [String(kUTTypeImage)]
                    imagePicker.allowsEditing = true
                    imagePicker.delegate = self
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)//PHPhotoLibrary.authorizationStatus()
                        switch authStatus {
                        case .Authorized:
                             self.presentViewController(imagePicker, animated: true, completion: nil)
                        break // Do your stuff here i.e. allowScanning()
                        case .Denied:
                            AppHelper.showAlertWithTitle(AppName, message:gallerySetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                        case .NotDetermined:
                            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { granted in
                                if granted {
                                    dispatch_async(dispatch_get_main_queue()) {
                                         self.presentViewController(imagePicker, animated: true, completion: nil)
                                    }
                                }
                            })
                        default:
                            AppHelper.showAlertWithTitle(AppName, message:gallerySetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                        }
                    })
                    
//                    self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
    }
    
    //MARK:- UIActionSheet Delegates
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
            switch buttonIndex{
                
            case 0:
                
                //To check if camera is available
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
                {
                    let imagePicker = UIImagePickerController()
                    
                    imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                    imagePicker.mediaTypes = [String(kUTTypeImage)]
                    imagePicker.allowsEditing = true
                    imagePicker.delegate = self
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
                        switch authStatus {
                        case .Authorized:
                            self.presentViewController(imagePicker, animated: true, completion: nil)

                            break
                        case .Denied:
                            AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                        case .NotDetermined:
                            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo,
                                completionHandler: { (granted:Bool) -> Void in
                                    if granted {
                                        self.presentViewController(imagePicker, animated: true, completion: nil)
                                    }
                                    else {
                                        AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                                    }
                            })
                        default:
                            AppHelper.showAlertWithTitle(AppName, message:cameraSetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                            
                        }
                    })
                    
//                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }
                
                break;
            case 1:
                //Gallery
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.mediaTypes = [String(kUTTypeImage)]
                imagePicker.allowsEditing = true
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)//PHPhotoLibrary.authorizationStatus()
                    switch authStatus {
                    case .Authorized:
                       self.presentViewController(imagePicker, animated: true, completion: nil)
                    break // Do your stuff here i.e. allowScanning()
                    case .Denied:
                        AppHelper.showAlertWithTitle(AppName, message:gallerySetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    case .NotDetermined:
                        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { granted in
                            if granted {
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.presentViewController(imagePicker, animated: true, completion: nil)
                                }
                            }
                        })
                    default:
                        AppHelper.showAlertWithTitle(AppName, message:gallerySetting, tag: 0, delegate: nil, cancelButton: ok, otherButton: nil)
                    }
                })
                
                
                
                //self.presentViewController(imagePicker, animated: true, completion: nil)
                
                break;
            default:
                self.dismissViewControllerAnimated(false, completion: nil)
                break;
                //Some code here..
            }
    }


    @IBAction func btnAddLinkClick(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Add Link", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Add title here"
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Add link here"
        }
        
        let saveAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            
            let titleTextField = alertController.textFields![0] as UITextField

            let linkTextField = alertController.textFields![1] as UITextField
            
            var dict = Dictionary<String,AnyObject>()

            
            if (linkTextField.text!.isValidURL() == false) {
                
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please input valid url.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
                
            }
            else {
            
            if (titleTextField.text?.characters.count > 0 && linkTextField.text?.characters.count > 0)
            {
                dict["title"]=titleTextField.text! as String
                dict["url"]=linkTextField.text
                
                self.arrAttachments.append(dict)
                self.tableAttachments.reloadData()
            }
            else
            {
                ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Please input both title and url.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            }
         
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
       
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
       
    }
    
    @IBAction func btnAddAttachClick(sender: AnyObject) {
        
        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.data","public.text","public.image"], inMode: .Import)
        importMenu.delegate = self
        importMenu.title="Attach a Document"
       
        //importMenu.addOptionWithTitle("Attach from Gallery", image: nil, order: .First, handler: {
        //print("New Doc Requested") } )
        
        presentViewController(importMenu, animated: true, completion: nil)


    }
    
    // MARK:- UIDocumentMenuDelegate
    func documentMenu(documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        presentViewController(documentPicker, animated: true, completion: nil)
    }
    
    // MARK: - UIDocumentPickerDelegate Methods
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
       
        if controller.documentPickerMode == .Import {
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.arrAttachments.append(url.lastPathComponent!)
                self.tableAttachments.reloadData()
                
            }
        }

    }
    
    func documentPickerWasCancelled(controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    @IBAction func switchAllowInviteClick(mySwitch: UISwitch) {
        
        isForwardAllowed=mySwitch.on

    }
    
    @IBAction func btnBackClick(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func onClickRecurrenceBtn(sender: AnyObject) {
        if  self.txtFieldOn.text?.characters.count < 1 {
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Recurrence start date can't be blank.", delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return
        }
        if  self.txtFieldAt.text?.characters.count < 1 {
            ChatHelper.showALertWithTag(0, title: APP_NAME, message: "Recurrence start time can't be blank.", delegate: self, cancelButtonTitle: "Ok", otherButtonTitle: nil)
            return
        }
        
        let VC:RecurrenceVC = AppHelper.getStoryBoard().instantiateViewControllerWithIdentifier("RecurrenceVC") as! RecurrenceVC
        VC.startDateOfRecurrenceStr = self.txtFieldOn.text!
        VC.startDateAtOfRecurrenceStr = self.txtFieldAt.text!
        VC.parentVC = self
        self.navigationController?.pushViewController(VC, animated: true);
    }
    
    
    
    func addressTextFieldDidChange(textField: UITextField) {
        gpaViewController.placeDelegate = self
        presentViewController(gpaViewController, animated: true, completion: nil)
    }
    
    func placeSelected(place: Place) {
        print(place.description)
        self.txtFieldWhereSecond.text=place.description
        dismissViewControllerAnimated(true, completion: nil)
        place.getDetails { details in
            self.strLatLong = "\(details.latitude),\(details.longitude)"
            print(details.description)
        }
    }
    
    func placeViewClosed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
