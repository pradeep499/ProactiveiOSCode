//
//  DKImagePickerController.swift
//  CustomImagePicker
//
//  Created by ZhangAo on 14-10-2.
//  Copyright (c) 2014年 ZhangAo. All rights reserved.
//

import UIKit
import AssetsLibrary


// Delegate
@objc public protocol DKImagePickerControllerDelegate : NSObjectProtocol {
    /// Called when right button is clicked.
    ///
    /// :param: images Images of selected
    func imagePickerControllerDidSelectedAssets(images: [DKAsset]!)
    
    /// Called when cancel button is clicked.
    func imagePickerControllerCancelled()
}

//////////////////////////////////////////////////////////////////////////////////////////

// Cell Identifier
let GroupCellIdentifier = "GroupCellIdentifier"
let ImageCellIdentifier = "ImageCellIdentifier"

// Nofifications
let DKImageSelectedNotification = "DKImageSelectedNotification"
let DKImageUnselectedNotification = "DKImageUnselectedNotification"

// Group Model
class DKAssetGroup : NSObject {
    var groupName: String!
    var thumbnail: UIImage!
    var group: ALAssetsGroup!
}

// Asset Model
public class DKAsset: NSObject {
    public var thumbnailImage: UIImage?
    public lazy var fullScreenImage: UIImage? = {
        return UIImage(CGImage: self.originalAsset.defaultRepresentation().fullScreenImage().takeUnretainedValue())
    }()
    public lazy var fullResolutionImage: UIImage? = {
        return UIImage(CGImage: self.originalAsset.defaultRepresentation().fullResolutionImage().takeUnretainedValue())
    }()
    public var url: NSURL?
    
    private var originalAsset: ALAsset!
    
    // Compare two assets
    override public func isEqual(object: AnyObject?) -> Bool {
        let other = object as! DKAsset
        return self.url!.isEqual(other.url!)
    }
}

// Internal
extension UIViewController {
    var imagePickerController: DKImagePickerController? {
        get {
            let nav = self.navigationController
            if nav is DKImagePickerController {
                return nav as? DKImagePickerController
            } else {
                return nil
            }
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Show All Iamges In Group
//////////////////////////////////////////////////////////////////////////////////////////

class DKImageGroupViewController: UICollectionViewController {
    
    class DKImageCollectionCell: UICollectionViewCell {
        var thumbnail: UIImage! {
            didSet {
                self.imageView.image = thumbnail
            }
        }
        
        override var selected: Bool {
            didSet {
                checkView.hidden = !super.selected
            }
        }
        
        private var imageView = UIImageView()
        private var checkView = UIImageView(image: UIImage(named: "DKImagePickerController_PhotoChecked",
            inBundle: NSBundle(forClass: DKImagePickerController.self),
            compatibleWithTraitCollection: nil))
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            imageView.frame = self.bounds
            self.contentView.addSubview(imageView)
            self.contentView.addSubview(checkView)
        }
        
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            imageView.frame = self.bounds
            checkView.frame.origin = CGPoint(x: self.contentView.bounds.width - checkView.bounds.width,
                y: 0)
        }
    }
    
    var assetGroup: DKAssetGroup!
    private lazy var imageAssets: NSMutableArray = {
        return NSMutableArray()
    }()
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
     internal convenience init() {
        let layout = UICollectionViewFlowLayout()
        
        let interval: CGFloat = 3
        layout.minimumInteritemSpacing = interval
        layout.minimumLineSpacing = interval
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let itemWidth = (screenWidth - interval * 3) / 4
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)

        self.init(collectionViewLayout: layout)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(assetGroup != nil, "assetGroup is nil")

        self.title = assetGroup.groupName
        
        self.collectionView!.backgroundColor = UIColor.whiteColor()
        self.collectionView!.allowsMultipleSelection = true
        self.collectionView!.registerClass(DKImageCollectionCell.self, forCellWithReuseIdentifier: ImageCellIdentifier)
        
        assetGroup.group.enumerateAssetsUsingBlock {[unowned self](result: ALAsset!, index: Int, stop: UnsafeMutablePointer<ObjCBool>) in
            if result != nil {
                let asset = DKAsset()
                asset.thumbnailImage = UIImage(CGImage:result.thumbnail().takeUnretainedValue())
                asset.url = result.valueForProperty(ALAssetPropertyAssetURL) as? NSURL
                asset.originalAsset = result
                self.imageAssets.addObject(asset)
            } else {
                self.collectionView!.reloadData()
                dispatch_async(dispatch_get_main_queue()) {
                    self.collectionView!.scrollToItemAtIndexPath(NSIndexPath(forRow: self.imageAssets.count-1, inSection: 0),
                        atScrollPosition: UICollectionViewScrollPosition.Bottom,
                        animated: false)
                }
            }
        }
    }
    
    //Mark: - UICollectionViewDelegate, UICollectionViewDataSource methods
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageAssets.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ImageCellIdentifier, forIndexPath: indexPath) as! DKImageCollectionCell
        
        let asset = imageAssets[indexPath.row] as! DKAsset
        cell.thumbnail = asset.thumbnailImage
        
        if self.imagePickerController?.selectedAssets.count < 0{
            return cell
        }
        
        if self.imagePickerController!.selectedAssets.indexOf(asset) != nil {
            cell.selected = true
            collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.None)
        } else {
            cell.selected = false
            collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.imagePickerController!.selectedAssets.count < self.imagePickerController!.maxSelectableCount
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSNotificationCenter.defaultCenter().postNotificationName(DKImageSelectedNotification, object: imageAssets[indexPath.row])
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        NSNotificationCenter.defaultCenter().postNotificationName(DKImageUnselectedNotification, object: imageAssets[indexPath.row])
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Show All Group
//////////////////////////////////////////////////////////////////////////////////////////

class DKAssetsLibraryController: UITableViewController {
    
    lazy private var groups: NSMutableArray = {
        return NSMutableArray()
    }()
    
    lazy private var library: ALAssetsLibrary = {
        return ALAssetsLibrary()
    }()
    
    private var noAccessView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: GroupCellIdentifier)
        self.view.backgroundColor = UIColor.whiteColor()
        
        library.enumerateGroupsWithTypes(ALAssetsGroupAll, usingBlock: {(group: ALAssetsGroup! , stop: UnsafeMutablePointer<ObjCBool>) in
            if group != nil {
                if group.numberOfAssets() != 0 {
                    let groupName = group.valueForProperty(ALAssetsGroupPropertyName) as! String
                    
                    let assetGroup = DKAssetGroup()
                    assetGroup.groupName = groupName
                    assetGroup.thumbnail = UIImage(CGImage: group.posterImage().takeUnretainedValue())
                    assetGroup.group = group
                    self.groups.insertObject(assetGroup, atIndex: 0)
                }
            } else {
                self.tableView.reloadData()
            }
        }, failureBlock: {(error: NSError!) in
            self.noAccessView.frame = self.view.bounds
            self.tableView.scrollEnabled = false
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            self.view.addSubview(self.noAccessView)
        })
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
     override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 10
    }

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(GroupCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        let assetGroup = groups[indexPath.row] as! DKAssetGroup
        cell.textLabel!.text = assetGroup.groupName
        cell.imageView!.image = assetGroup.thumbnail
        cell.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let assetGroup = groups[indexPath.row] as! DKAssetGroup
        let imageGroupController = DKImageGroupViewController()
        imageGroupController.assetGroup = assetGroup
        self.navigationController?.pushViewController(imageGroupController, animated: true)
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Main Controller
//////////////////////////////////////////////////////////////////////////////////////////

public class DKImagePickerController: UINavigationController {
    
    /// The height of the bottom of the preview
    public var previewHeight: CGFloat = 80
    public var rightButtonTitle: String = "Select"
    public var maxSelectableCount = 5
    /// Displayed when denied access
    public var noAccessView: UIView = {
        let label = UILabel()
        label.text = "User has denied access"
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.lightGrayColor()
        return label
    }()
    
    public weak var pickerDelegate: DKImagePickerControllerDelegate?
    public var defaultSelectedAssets: [DKAsset]? {
        didSet {
            if let defaultSelectedAssets = self.defaultSelectedAssets {
               self.selectedAssets = defaultSelectedAssets
                //self.imagesPreviewView.replaceAssets(defaultSelectedAssets)
                self.updateSelectionStatus()
            }
        }
    }
    
    var selectedAssets = [DKAsset]()
    
    class DKPreviewView: UIScrollView {
        let interval: CGFloat = 5
        private var assets = [DKAsset]()
        private var imagesDict: [DKAsset : UIImageView] = [:]
        
        func imageFrameForIndex(index: Int) -> CGRect {
            let imageLengthOfSide = self.bounds.height - interval * 2
            
            return CGRect(x: CGFloat(index) * imageLengthOfSide + CGFloat(index + 1) * interval,
                y: (self.bounds.height - imageLengthOfSide)/2,
                width: imageLengthOfSide, height: imageLengthOfSide)
        }
        
        func insertAsset(asset: DKAsset) {
            let imageView = UIImageView(image: asset.thumbnailImage)
            imageView.frame = imageFrameForIndex(assets.count)
            
            self.addSubview(imageView)
            assets.append(asset)
            imagesDict.updateValue(imageView, forKey: asset)
            setupContent(true)
        }
        
        func removeAsset(asset: DKAsset) {
            imagesDict.removeValueForKey(asset)?.removeFromSuperview()
            let index = assets.indexOf(asset)
            if let toRemovedIndex = index {
                assets.removeAtIndex(toRemovedIndex)
                setupContent(false)
            }
        }
        
        func replaceAssets(assets: [DKAsset]) {
            self.imagesDict = [:]
            self.assets = []
            self.subviews.map {$0.removeFromSuperview()}
            
            for asset in assets {
                self.insertAsset(asset)
            }
        }
        
        private func setupContent(isInsert: Bool) {
            if isInsert == false {
                for (index,asset) in assets.enumerate() {
                    let imageView = imagesDict[asset]!
                    imageView.frame = imageFrameForIndex(index)
                }
            }
            
            self.contentSize = CGSize(width: CGRectGetMaxX((self.subviews.last! as UIView).frame) + interval,
                height: self.bounds.height)
        }
    }
    
    class DKContentWrapperViewController: UIViewController {
        var contentViewController: UIViewController
        var bottomBarHeight: CGFloat = 0
        var showBottomBar: Bool = false {
            didSet {
                if self.showBottomBar {
                    self.contentViewController.view.frame.size.height = self.view.bounds.size.height - self.bottomBarHeight
                } else {
                    self.contentViewController.view.frame.size.height = self.view.bounds.size.height
                }
            }
        }
        
        init(_ viewController: UIViewController) {
            contentViewController = viewController

            super.init(nibName: nil, bundle: nil)
            self.addChildViewController(viewController)
            
            contentViewController.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.New, context: nil)
        }
        
        deinit {
            contentViewController.removeObserver(self, forKeyPath: "title")
        }

        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
            if keyPath == "title" {
                self.title = contentViewController.title
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.view.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(contentViewController.view)
            contentViewController.view.frame = view.bounds
        }
    }
    
    lazy internal  var imagesPreviewView: DKPreviewView = {
        let preview = DKPreviewView()
        preview.hidden = true
        preview.alwaysBounceHorizontal = true
        preview.backgroundColor = UIColor.lightGrayColor()
        return preview
    }()
    lazy internal var doneButton: UIButton =  {
        //let button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        let button = UIButton(type: UIButtonType.Custom) as UIButton
        button.setTitle("", forState: UIControlState.Normal)
        button.setTitleColor(self.navigationBar.tintColor, forState: UIControlState.Normal)
        button.reversesTitleShadowWhenHighlighted = true
        button.addTarget(self, action: #selector(DKImagePickerController.onDoneClicked), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        let libraryController = DKAssetsLibraryController()
        let wrapperVC = DKContentWrapperViewController(libraryController)
        
        self.init(rootViewController: wrapperVC)
        
        libraryController.noAccessView = noAccessView
        wrapperVC.bottomBarHeight = previewHeight
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        imagesPreviewView.frame = CGRect(x: 0, y: view.bounds.height - previewHeight,
                                     width: view.bounds.width, height: previewHeight)
        imagesPreviewView.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
        
        view.addSubview(imagesPreviewView)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DKImagePickerController.selectedImage(_:)),
                                                                   name: DKImageSelectedNotification,
                                                                 object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DKImagePickerController.unselectedImage(_:)),
                                                                   name: DKImageUnselectedNotification,
                                                                 object: nil)
    }

    override public func pushViewController(viewController: UIViewController, animated: Bool) {
        let wrapperVC = DKContentWrapperViewController(viewController)
        wrapperVC.bottomBarHeight = previewHeight
        
        super.pushViewController(wrapperVC, animated: animated)

        self.topViewController!.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.doneButton)
        self.updateSelectionStatus()
        
        if self.viewControllers.count == 1 && self.topViewController?.navigationItem.leftBarButtonItem == nil {
            self.topViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel,
                target: self,
                action: #selector(DKImagePickerController.onCancelClicked))
        }
    }
    
    private func updateSelectionStatus() {
        
        print_debug("update selecttions status ")
        if self.selectedAssets.count > 0 {
            self.doneButton.setTitle(rightButtonTitle + "(\(selectedAssets.count))", forState: UIControlState.Normal)
        } else {
            self.doneButton.setTitle("", forState: UIControlState.Normal)
        }
        self.doneButton.sizeToFit()
        
        self.imagesPreviewView.hidden = self.selectedAssets.count == 0
        
        (self.viewControllers as! [DKContentWrapperViewController]).map {$0.showBottomBar = !self.imagesPreviewView.hidden}
    }
    
    // MARK: - Delegate methods
    func onCancelClicked() {
        if let delegate = self.pickerDelegate {
            delegate.imagePickerControllerCancelled()
        }
    }
    
    func onDoneClicked() {
        if let delegate = self.pickerDelegate {
            delegate.imagePickerControllerDidSelectedAssets(self.selectedAssets)
        }
    }
    
    // MARK: - Notifications
    func selectedImage(noti: NSNotification) {
        if let asset = noti.object as? DKAsset {
            selectedAssets.append(asset)
            imagesPreviewView.insertAsset(asset)
            updateSelectionStatus()
        }
    }
    
    func unselectedImage(noti: NSNotification) {
        if let asset = noti.object as? DKAsset {
            selectedAssets.removeAtIndex(selectedAssets.indexOf(asset)!)
            imagesPreviewView.removeAsset(asset)
            updateSelectionStatus()
        }
    }
}
