//
//  MapVC.swift
//  LiveBait
//
//  Created by maninder on 2/12/18.
//  Copyright © 2018 Maninderjit Singh. All rights reserved.
//

import UIKit
import MapKit

enum MapType
{
    case ShareNewLocation
    case SharedLocation
    case SharedLocationOnCall
    
}

class MapVC: UIViewController,MKMapViewDelegate,MSAlertProtocol{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnShareLocation: UIButton!
    
    var userReceiver : User = User()
  //  var selectedLatitude : Double = 0.0
 //   var selectedLongitude : Double = 0.0
    //var lcoationName : String = ""
    
    var mapType : MapType = .ShareNewLocation
    var locationToShare : Location!
    var locationSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.hidesBackButton = true

        mapView.showsUserLocation = true
        mapView.delegate = self
        
        
       
        
        
        if mapType == .SharedLocation || mapType == .SharedLocationOnCall
        {
            btnShareLocation.isHidden = true
            if locationToShare != nil
            {
                let center = CLLocationCoordinate2D(latitude: locationToShare.latitude!, longitude: locationToShare.longitude!)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                mapView.setRegion(region, animated: true)
                let newPin = MKPointAnnotation()
                newPin.coordinate = center
                mapView.addAnnotation(newPin)
            }
           
        }else{
            if appDelegate().locationManager != nil
            {
                let center = CLLocationCoordinate2D(latitude: (appDelegate().currentLocation?.coordinate.latitude)!, longitude: (appDelegate().currentLocation?.coordinate.longitude)!)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                mapView.setRegion(region, animated: true)
                locationToShare = Location(latitude: (appDelegate().currentLocation?.coordinate.latitude)!, longitude: (appDelegate().currentLocation?.coordinate.longitude)!, locationName: appDelegate().myLocationName)
            }
            
        }
        
        btnShareLocation.cornerRadius(value: 25)
        let longPress = UITapGestureRecognizer(target: self, action: #selector(MapVC.mapLongPress(_:))) // colon needs to pass through info
        mapView.addGestureRecognizer(longPress)
       
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    @IBAction func actionBtnBackPressed(_ sender: Any) {
        if mapType == .ShareNewLocation || mapType == .SharedLocationOnCall
        {
           self.dismiss(animated: true, completion: nil)
           // appDelegate().showCallingView()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
       
    }
    
    
    @IBAction func actionBtnShareLocationPressed(_ sender: UIButton) {
        
        if  self.locationSelected == true
        {
        
        LoginManager.sharedInstance.shareLocation(address: locationToShare, user: userReceiver) { ( success, response, strError) in
            if success{
                let alertVC = mainStoryBoard.instantiateViewController(withIdentifier: "CommonPopUpVC") as! CommonPopUpVC
                alertVC.view.alpha = 0
                alertVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                alertVC.strMessage = "Location has been shared with \(self.userReceiver.fullName)."
                alertVC.delegate = self
                alertVC.modalPresentationStyle = .overCurrentContext
                self.present(alertVC, animated: false, completion: nil)
            }else{
                showCustomAlert(message: strError!, controller: self)
            }
        }
        }else{
            showCustomAlert(message: "Please select location to share first." , controller: self)
        }
    }
    
    //MARK:- MapView Delegates
    //MARK:-
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
        
    }
    
  
    
    @objc func mapLongPress(_ recognizer: UIGestureRecognizer) {
        
        
        
        if  mapType == .SharedLocation
        {
            return
        }
 

        
        let arrAnotations    =  self.mapView.annotations
        
        for item in arrAnotations
        {
            self.mapView.removeAnnotation(item)
        }
        let touchedAt = recognizer.location(in: mapView) // adds the location on the view it was pressed
        let touchedAtCoordinate : CLLocationCoordinate2D =  mapView.convert(touchedAt, toCoordinateFrom: self.mapView) // will get coordinates
        
        locationToShare = Location(latitude:touchedAtCoordinate.latitude , longitude: touchedAtCoordinate.longitude, locationName: "")
        
        
        
        let newPin = MKPointAnnotation()
        newPin.coordinate = touchedAtCoordinate
        mapView.addAnnotation(newPin)
        self.locationSelected = true
        self.getLocationName()
    }
    
    
    func getLocationName()
    {
        let locationNew = CLLocation(latitude: locationToShare.latitude, longitude: locationToShare.longitude)
        
        var locationName : String = ""
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(locationNew, completionHandler: { placemarks, error in
            //SwiftLoader.hide()
            guard let addressDict = placemarks?[0].addressDictionary else
            {
                return
            }
            if let street = addressDict["Street"] as? String {
               locationName = street
            }
            
            if let cityName = addressDict["City"] as? String
            {
                locationName =   locationName + ", " + cityName
            }
            
            if let stateCode = addressDict["State"] as? String
            {
                locationName = locationName + ", " + stateCode
            }
            
            self.locationToShare.locationName = locationName
        })
        
    }
    
    //MARK:-  MSAlertProtocol Pop Up CallBacks
    //MARK:-
    
    
    
    func popupDonePressed(type: Any) {
        
        self.dismiss(animated: true, completion: nil)
        //appDelegate().showCallingView()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
