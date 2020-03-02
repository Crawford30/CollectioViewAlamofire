//
//  ViewController.swift
//  CollectionViewAlamofire
//
//  Created by JOEL CRAWFORD on 2/18/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage



struct serviceID {
    
    var serviceID:        Int
    var categoryID:       Int
    var serviceTitle:     String
    var serviceImage:     String
    var serviceImageLink: String
    
}

struct categoryID {
    
    var categoryID:    Int
    var categoryTitle: String
    var categoryImage: String
    
    
    
}



class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    enum myTags: Int {
        
        case cellFavourites = 2000
        case cellShare      = 4000
        case cellBookNow    = 6000
        
    }
    
    enum iPhoneDevice: Int {
        
        case iPhone8
        case iPhone8Plus
        case iPhone11
        case iPhone11ProMax
        
    }
    
    enum myTabButtons: Int {
        
        case tabAllServices
        case tabFeatured
        case tabFavourites
        
    }
    
    //--------------------------------------------------------------------------------------------------------
    
    
    @IBOutlet weak var faketabbar:      UIButton!
    @IBOutlet weak var featuredButton:  UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    
    @IBOutlet weak var collectionView:           UICollectionView!
    @IBOutlet weak var horizontalcollectionView: UICollectionView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    
    //=======array=============================================================================================
    
    var mainArray:       [ serviceID ]  = [] //holding ids of every section in any category
    var categoriesArray: [ categoryID ] = []
    var favouritesArray: [ serviceID ]  = []
    
    
    
    
    
    //======================================MY CRAP===============
    var services: [ Any ] = [] //holding  services
    var catID: [Int] = [] //getting the categoryID to concatenate it with //======https://api.ichuzz2work.com/api/services/category
    // eg, https://api.ichuzz2work.com/api/services/category/category_id ===Loads a service with that categoryid
    //=====================================================================
    
    
    var currentCategory: Int = 0 // Just making sure they are initialized
    var currentSection:  Int = 0
    
    //=============For Categories=============================================================================
    
    let categoryLink = "https://api.ichuzz2work.com/api/services/categories"
    
    
    var categoryThumbnails: NSMutableArray = NSMutableArray()
    
    //==========For Services==================================================================================
    
    let link = "https://api.ichuzz2work.com/api/services"
    
    var serviceThumbnails: NSMutableArray = NSMutableArray()
    
    
    //==================================================================================
    
    let iPhone8PlusHeight: CGFloat = 736.0
    
    var tabButtonMode: Int = myTabButtons.tabAllServices.rawValue // Default mode
    
    var vertCVExpanded:   CGRect = CGRect()
    var vertCVCompressed: CGRect = CGRect()
    
    //==============  Constants for collectionView's  =====================================
    
    let horizontalCVCellSize:     CGSize  = CGSize( width:  88, height:  90 )
    let myCellSize:               CGSize  = CGSize( width: 150, height: 150 ) // Vertical CV cell size
    
    let myVertCVSpacing:          CGFloat = CGFloat( 8.0 )
    let myHorizCVSpacing:         CGFloat = CGFloat( 4.0 )
    
    let buttonFontSize:           CGFloat = CGFloat( 15.0 )
    let buttonEmphasizedFontSize: CGFloat = CGFloat( 18.0 )
    
    
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad() // ‼️‼️‼️‼️‼️  This should ALWAYS BE THE FIRST CODE in viewDidLoad  ‼️‼️‼️‼️‼️‼️‼️‼️‼️
        
        prepUI()
        
        //-----------------------------------------------------------------------------------------------------
        
        LoadCategories()
        
        LoadServices()
        
        //-----------------------------------------------------------------------------------------------------
        
        horizontalcollectionView.delegate   = self
        horizontalcollectionView.dataSource = self
        
        collectionView.delegate             = self
        collectionView.dataSource           = self
        
    }
    
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    
    @IBAction func menuButtonTapped(_ sender: UIBarButtonItem) {
        
        print("Menu button tapped!")
        
    }
    
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        
        print("Search button tapped!")
        
    }
    
    //🔷🔷🔷🔷🔷🔷🔷🔷  ACTIONS FOR THE TAB BAR BUTTONS  🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    
    @IBAction func AllServicesAction(_ sender: UIButton) {
        
        if tabButtonMode == myTabButtons.tabAllServices.rawValue {
            
            return // Do nothing if already in that mode
            
        }
        
        print("All ServicesAction Button tapped")
        
        tabButtonMode = myTabButtons.tabAllServices.rawValue
        
        setTabBarButtonColors()
        
        collectionView.frame = vertCVCompressed
        
        horizontalcollectionView.isHidden = false   // Show Categories collectionView
        
    }
    
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    
    @IBAction func FeaturedAction(_ sender: UIButton) {
        
        if tabButtonMode == myTabButtons.tabFeatured.rawValue {
            
            return // Do nothing if already in that mode
            
        }
        
        if !horizontalcollectionView.isHidden {     // Hide Categories collectionView if it is showing
            
            horizontalcollectionView.isHidden = true
            
            collectionView.frame = vertCVExpanded
            
        }
        
        tabButtonMode = myTabButtons.tabFeatured.rawValue
        
        setTabBarButtonColors()
        
        print("Featured Button tapped")
        
    }
    
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    
    @IBAction func vCVFaveButtonTapped(_ sender: UIButton) {
        
        let whichService: Int = sender.tag - myTags.cellFavourites.rawValue
        
        let localIndexPath    = IndexPath(row: whichService, section: 0)
        
        if isFavourite(theID: mainArray[ whichService ] ) {
            
            removeFavourite( theID: mainArray[ whichService ] )
            
        } else {
            
            favouritesArray.append( mainArray[ whichService ] )
            
        }
        
        collectionView.reloadItems( at: [localIndexPath] )
        
    }
    
    //----------------------------------------------------------------------------------------------------------
    
    func isFavourite( theID: serviceID ) -> Bool {
        
        if favouritesArray.count == 0 {
            
            return false
            
        }
        
        for localID in favouritesArray {
            
            if localID.categoryID == theID.categoryID {
                
                if localID.serviceID == theID.serviceID {
                    
                    return true
                    
                }
                
            }
            
        }
        
        return false
        
    }
    
    //----------------------------------------------------------------------------------------------------------
    
    func removeFavourite( theID: serviceID ) {
        
        if favouritesArray.count == 0 {
            
            return
            
        }
        
        var localIndex: Int = 0
        
        for localID in favouritesArray {
            
            if localID.categoryID == theID.categoryID {
                
                if localID.serviceID == theID.serviceID {
                    
                    favouritesArray.remove(at: localIndex)
                    
                    return
                    
                }
                
            }
            
            localIndex += 1
            
        }
        
    }
    
    //----------------------------------------------------------------------------------------------------------
    
    @IBAction func vCVShareButtonTapped(_ sender: UIButton) {
        
        let activityVC = UIActivityViewController(activityItems: [link], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        // Anything you want to exclude
        activityVC.excludedActivityTypes = [
            // UIActivity.ActivityType.postToWeibo,
            // UIActivity.ActivityType.print,
            // UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList
            // UIActivity.ActivityType.postToFlickr,
            // UIActivity.ActivityType.postToVimeo,
            // UIActivity.ActivityType.postToTencentWeibo
        ]
        
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    //=================  for favourite Action Button  =========================================================
    
    @IBAction func FavouriteAction(_ sender: UIButton) {
        
        if tabButtonMode == myTabButtons.tabFavourites.rawValue {
            
            return // Do nothing if already in that mode
            
        }
        
        if !horizontalcollectionView.isHidden {     // Hide Categories collectionView if it is showing
            
            horizontalcollectionView.isHidden = true
            
            collectionView.frame = vertCVExpanded
            
        }
        
        tabButtonMode = myTabButtons.tabFavourites.rawValue
        
        setTabBarButtonColors()
        
        print("favourite Button tapped")
        
    }
    
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //=======for horizonatl collection view=====
        if (collectionView == horizontalcollectionView) {
            
            return categoryThumbnails.count
            
        } else {
            
            //=======for vertical collection view=====
            return serviceThumbnails.count
            
        }
        
    }
    
    //========================added function===================
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if ( collectionView == horizontalcollectionView ) {
            
            if indexPath.item == currentCategory {
                // print(indexPath.item)
                
                return      // Do nothing if current Category is clicked
                
            } else {
                
                currentCategory = indexPath.item    // First things first
                
                // print("Category index \(String(currentCategory)) selected")
                
                // Empty array for Section images
                
                
                
                //=========want to get category id=====
                //https://api.ichuzz2work.com/api/services/category
                //https://api.ichuzz2work.com/api/services
                
                Alamofire.request("https://api.ichuzz2work.com/api/services", method: .get)
                    .validate()
                    .responseJSON { (response) in
                        
                        guard response.result.isSuccess else {
                            print("Error with response: \(String(describing: response.result.error))")
                            return
                        }
                        
                        guard let dictservice = response.result.value as? Dictionary <String,AnyObject> else {
                            print("Error with dictionary: \(String(describing: response.result.error))")
                            return
                        }
                        
                        guard let dictServiceData = dictservice["data"] as? [Dictionary <String,AnyObject>] else {
                            print("Error with dictionary data: \(String(describing: response.result.error))")
                            return
                        }
                        
                        
                        
                        for currentCategoryID in dictServiceData {
                            // print(indexPath.item)
                            // print(currentService)
                           
                            
                            //========GETTING THE CATEGORY ID=========
                            self.catID.append(currentCategoryID["category_id"] as! Int)
                            
                            
                            
                            
                            
                            //======PASSING EACH CATEGORY ID AS A SEARCH PARAMETER TO LOAD ITS SERVICE DATA====
                            
                            //let articleTwo = NSHipster?.URLByAppendingPathComponent("ios9", isDirectory: true)
                            //articleTwo now contains "http://nshipster.com/ios9/"
                            
                            
                            
                            //========THIS SHOULD GET THE category_id  and append to this link //https://api.ichuzz2work.com/api/services/category/(category_id) and loads the servic data for that link.
                            
                            let servicesAtCatID = "https://api.ichuzz2work.com/api/services/category/1"  //hardcoding, was trying to get a way of how i can get each category id from the catID array and append it to the link then make another call, seems not to get a good way of doing it.
                            
                            
                            
                            // let eachCatID  = (self.catID[indexPath.item])
                            // let serviceAtCatIDURL = servicesAtCatID.URLByAppendingPathComponent(eachCatID)
                            
                            Alamofire.request(servicesAtCatID).responseJSON { (response) in
                                
                                guard response.result.isSuccess else {
                                    print("Error with response: \(String(describing: response.result.error))")
                                    return
                                }
                                
                                guard let dictService = response.result.value as? Dictionary <String,AnyObject> else {
                                    print("Error with dictionary: \(String(describing: response.result.error))")
                                    return
                                }
                                
                                
                                
                                
                                
                                guard let dictServiceData = dictService["data"] as? [Dictionary <String,AnyObject>] else {
                                    print("Error with dictionary data: \(String(describing: response.result.error))")
                                    return
                                }
                                
                                for currentServices in dictServiceData {
                                    print(currentServices)
                                    
                                    let id = currentServices["category_id"] as! Int
                                    print(id)
                                    
                                    
                                    // self.services.append(currentServices["category_id"])
                                    
                                }
                                
                                
                            }
                            
                        }
                        
                        self.collectionView.reloadData()
                        return
                        
                }
                
                
                
                
                
                
                
                
                
                
            }
            
        }
        
    }
    
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //===========for Horizontal collection view============
        
        if ( collectionView == horizontalcollectionView ) {
            
            let horizontalcell = horizontalcollectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalCell", for: indexPath) as! horizontalCollectionViewCell
            
            horizontalcell.categoryLabel.text = self.categoriesArray[indexPath.item].categoryTitle
            
            if categoryThumbnails.object(at: indexPath.item) is UIImage {
                
                // ❌❌❌❌❌  DO NOT DOWNLOAD AND SCALE THE IMAGE IF WE ALREADY HAVE IT  ❌❌❌❌❌
                
                horizontalcell.categoryImageView.image = categoryThumbnails.object( at: indexPath.item ) as? UIImage
                
                print("Image retrieved from categoryThumbnails array") // Remove this
                
            } else {
                
                // Get Category image suffix to build URL
                let Categoryimagestring = self.categoriesArray[indexPath.item].categoryImage
                
                //======replacing a space in a the image string====
                let newCategoryimagetstring = Categoryimagestring.replacingOccurrences(of: " ", with: "%20", options: .literal)
                
                if let categoryimageurl = newCategoryimagetstring as? String {
                    
                    Alamofire.request("https://api.ichuzz2work.com/" + categoryimageurl).responseImage { (response) in
                        
                        if let categoryImage = response.result.value {
                            
                            DispatchQueue.main.async {
                                
                                let scaledCategoryImage = categoryImage.af_imageScaled(to: self.horizontalCVCellSize )
                                
                                horizontalcell.categoryImageView?.image = scaledCategoryImage
                                
                                // Replace placeholder string with actual image
                                self.categoryThumbnails.replaceObject( at: indexPath.item, with: scaledCategoryImage )
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
            
            return horizontalcell
            
        }
        
        //================  for vertical / Services collection view  ===============================================
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.servicelabel.text               = self.mainArray[ indexPath.item ].serviceTitle
        cell.servicelabel.layer.cornerRadius = 6
        cell.servicelabel.clipsToBounds      = true
        
        cell.bookNowButtonOutlet.layer.cornerRadius = 6
        cell.bookNowButtonOutlet.clipsToBounds      = true
        cell.bookNowButtonOutlet.tag                = myTags.cellBookNow.rawValue + indexPath.item
        
        if isFavourite(theID: mainArray[ indexPath.item ] ) {
            
            cell.favouriteBtn.setImage(UIImage(named:"redHeart"), for: .normal)
            
        } else {
            
            cell.favouriteBtn.setImage(UIImage(named:"whiteHeart"), for: .normal)
            
        }
        
        cell.favouriteBtn.tag = myTags.cellFavourites.rawValue + indexPath.item
        cell.shareBtn.tag     = myTags.cellShare.rawValue      + indexPath.item
        
        if serviceThumbnails.object(at: indexPath.item) is UIImage {
            
            // ❌❌❌❌❌  DO NOT DOWNLOAD AND SCALE THE IMAGE IF WE ALREADY HAVE IT  ❌❌❌❌❌
            
            cell.serviceimage.image = serviceThumbnails.object( at: indexPath.item ) as? UIImage
            
            print("Image retrieved from serviceThumbnails array") // Remove this
            
        }
            
        else {
            
            let imageString = self.mainArray[ indexPath.item ].serviceImage
            
            //======replacing a space in an image URL with %20
            let newString   = imageString.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            
            if let imageUrl = newString as? String {
                
                Alamofire.request("https://api.ichuzz2work.com/" + imageUrl).responseImage { (response) in
                    
                    if let image = response.result.value  {
                        
                        DispatchQueue.main.async {
                            
                            //scale the size disregarding the aspect ratio
                            let scaledImage = image.af_imageScaled(to: self.myCellSize)
                            
                            cell.serviceimage?.image = scaledImage
                            
                            // Replace placeholder string with actual image
                            self.serviceThumbnails.replaceObject( at: indexPath.item, with: scaledImage )
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        return cell
        
    }
    
    //🔷🔷🔷🔷🔷🔷  Load services in the vertical scroll view  🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if ( collectionView == horizontalcollectionView ) {
            
            return horizontalCVCellSize
            
        } else {
            
            return myCellSize
            
        }
        
    }
    
    //🔷🔷🔷🔷🔷  Load services in the vertical scroll view  🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    
    func LoadServices() {
        
        Alamofire.request(link, method: .get)
            
            .validate()
            
            .responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    print("Error with response: \(String(describing: response.result.error))")
                    return
                }
                
                guard let dict = response.result.value as? Dictionary <String,AnyObject> else {
                    print("Error with dictionary: \(String(describing: response.result.error))")
                    return
                }
                
                guard let dictData = dict["data"] as? [Dictionary <String,AnyObject>] else {
                    print("Error with dictionary data: \(String(describing: response.result.error))")
                    return
                }
                
                var tempID: serviceID
                
                self.mainArray = [] // Temporarily clear mainArray when loading new Sections
                
                for serviceData in dictData {
                    
                    tempID = serviceID.init(serviceID: 0, categoryID: 0, serviceTitle: "", serviceImage: "", serviceImageLink: "")
                    
                    tempID.categoryID   = self.currentCategory
                    
                    tempID.serviceID    = serviceData["id"]    as! Int
                    tempID.serviceImage = serviceData["image"] as! String
                    tempID.serviceTitle = serviceData["name"]  as! String
                    tempID.serviceImageLink = "Undetermined"
                    
                    self.mainArray.append( tempID )
                    
                    self.serviceThumbnails.add("placeholder") // Replace later with actual UIImage
                    
                }
                
                self.collectionView.reloadData()
                
                return
                
        }
        
    }
    
    //🔷🔷🔷🔷🔷🔷  Load categories in the horizonalscroll view  🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    
    func LoadCategories() {
        
        Alamofire.request(categoryLink, method: .get)
            
            .validate()
            
            .responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    print("Error with response: \(String(describing: response.result.error))")
                    return
                }
                
                guard let dict = response.result.value as? Dictionary <String,AnyObject> else {
                    print("Error with dictionary: \(String(describing: response.result.error))")
                    return
                }
                
                guard let dictData = dict["data"] as? [Dictionary <String,AnyObject>] else {
                    print("Error with dictionary data: \(String(describing: response.result.error))")
                    return
                }
                
                var tempID: categoryID
                
                for categoryData in dictData {
                    
                    tempID = categoryID.init(categoryID: 0, categoryTitle: "", categoryImage: "")
                    
                    tempID.categoryID    = categoryData["id"]    as! Int
                    tempID.categoryTitle = categoryData["name"]  as! String
                    tempID.categoryImage = categoryData["image"] as! String
                    
                    self.categoriesArray.append( tempID )
                    
                    self.categoryThumbnails.add("placeholder") // Replace later with actual UIImage
                    
                }
                
                self.horizontalcollectionView.reloadData()
                
                return
                
        }
        
        //========end of fun to Load categories============
        
    }
    
    @IBAction func bookNowTapped(_ sender: UIButton) {
        
        print("Book Now \(String(sender.tag)) pressed!")
        
    }
    
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    
    func prepUI() {
        
        var tempNavBarRect: CGRect = navBar.frame
        
        if self.view.frame.size.height <= iPhone8PlusHeight {
            
            tempNavBarRect.origin.y = 20
            
            navBar.frame = tempNavBarRect
            
            
            var tabBarRect: CGRect = faketabbar.frame
            
            tabBarRect.size.width = self.view.frame.size.width / 3
            
            let newYOrigin = self.view.frame.size.height - tabBarRect.size.height
            
            tabBarRect.origin.y = newYOrigin
            faketabbar.frame    = tabBarRect
            
            tabBarRect.origin.x += tabBarRect.size.width
            tabBarRect.origin.y  = newYOrigin
            featuredButton.frame = tabBarRect
            
            tabBarRect.origin.x  += tabBarRect.size.width
            tabBarRect.origin.y   = newYOrigin
            favouriteButton.frame = tabBarRect
            
        }
        
        navBar.topItem!.title = "ichuzz2work.com"
        
        horizontalcollectionView.backgroundColor = UIColor(named: "myGreenTint")
        
        setTabBarButtonColors()
        
        var tempHCV: CGRect = horizontalcollectionView.frame
        
        tempHCV.origin.x    = 0
        tempHCV.origin.y    = faketabbar.frame.origin.y - ( horizontalcollectionView.frame.size.height + 8 )
        tempHCV.size.width  = self.view.frame.size.width //only one item in a row, but with spaces between them
        
        horizontalcollectionView.frame = tempHCV
        
        collectionView.backgroundColor = .clear
        
        var tempRect: CGRect = collectionView.frame
        tempRect.origin.y    = tempNavBarRect.origin.y + tempNavBarRect.size.height + 8 // 8 pixels below navBar
        tempRect.size.width  = ( myCellSize.width * 2 ) + ( myVertCVSpacing * 3 )
        tempRect.size.height = ( horizontalcollectionView.frame.origin.y - tempRect.origin.y ) - 8
        tempRect.origin.x    = CGFloat( roundf( Float( ( self.view.frame.size.width - tempRect.size.width ) / 2.0) ) ) //centers the collection view horizonatlly
        
        collectionView.frame = tempRect
        
        vertCVCompressed = tempRect // Calculate expanded and compressed frames once
        
        tempRect.size.height = ( horizontalcollectionView.frame.size.height + horizontalcollectionView.frame.origin.y ) - collectionView.frame.origin.y
        
        vertCVExpanded = tempRect // Height is the only difference
        
    }
    
    //🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷
    
    func setTabBarButtonColors() {
        
        switch tabButtonMode {
            
        case myTabButtons.tabAllServices.rawValue:
            
            faketabbar.titleLabel?.font = UIFont.boldSystemFont(ofSize: buttonEmphasizedFontSize )
            faketabbar.setTitleColor( UIColor(named: "myGreenTint"), for: UIControl.State.normal )
            faketabbar.backgroundColor = .white
            
            featuredButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize )
            featuredButton.setTitleColor( .white, for: UIControl.State.normal )
            featuredButton.backgroundColor = UIColor(named: "myGreenTint")
            
            favouriteButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize )
            favouriteButton.setTitleColor( .white, for: UIControl.State.normal )
            favouriteButton.backgroundColor = UIColor(named: "myGreenTint")
            
            break
            
        case myTabButtons.tabFeatured.rawValue:
            
            faketabbar.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize )
            faketabbar.setTitleColor( .white, for: UIControl.State.normal )
            faketabbar.backgroundColor = UIColor(named: "myGreenTint")
            
            featuredButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: buttonEmphasizedFontSize )
            featuredButton.setTitleColor( UIColor(named: "myGreenTint"), for: UIControl.State.normal )
            featuredButton.backgroundColor = .white
            
            favouriteButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize )
            favouriteButton.setTitleColor( .white, for: UIControl.State.normal )
            favouriteButton.backgroundColor = UIColor(named: "myGreenTint")
            
            break
            
        case myTabButtons.tabFavourites.rawValue:
            
            faketabbar.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize )
            faketabbar.setTitleColor( .white, for: UIControl.State.normal )
            faketabbar.backgroundColor = UIColor(named: "myGreenTint")
            
            featuredButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize )
            featuredButton.setTitleColor( .white, for: UIControl.State.normal )
            featuredButton.backgroundColor = UIColor(named: "myGreenTint")
            
            favouriteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: buttonEmphasizedFontSize )
            favouriteButton.setTitleColor( UIColor(named: "myGreenTint"), for: UIControl.State.normal )
            favouriteButton.backgroundColor = .white
            
            break
            
        default:
            
            return
            
        }
        
    }
    
    
}


//❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌


//🔷🔷🔷🔷🔷  extention for UICollectionViewDelegateFlowLayout  🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷

extension ViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if ( collectionView == horizontalcollectionView ) {
            
            return UIEdgeInsets(top: myHorizCVSpacing, left: myHorizCVSpacing, bottom: myHorizCVSpacing, right: myHorizCVSpacing)
            
        } else {
            
            return UIEdgeInsets(top: myVertCVSpacing, left: myVertCVSpacing, bottom: myVertCVSpacing, right: myVertCVSpacing)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if ( collectionView == horizontalcollectionView ) {
            
            return myHorizCVSpacing
            
        } else {
            
            return myVertCVSpacing
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if ( collectionView == horizontalcollectionView ) {
            
            return myHorizCVSpacing
            
        } else {
            
            return myVertCVSpacing
            
        }
        
    }
    
}

//🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷



