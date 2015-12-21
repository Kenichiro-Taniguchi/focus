//
//  mapViewController.swift
//  superConcentration
//
//  Created by 谷口健一郎 on 2015/12/06.
//  Copyright © 2015年 谷口健一郎. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class mapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var selflatitude:CLLocationDegrees?
    var selflongitude:CLLocationDegrees?

    var locationManager: CLLocationManager!
    
    var destLocation: CLLocationCoordinate2D!

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //AppDelegateのインスタンスを取得
        selflatitude = appDelegate.latitude
        selflongitude = appDelegate.longtude
        
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        mapView.delegate = self
        
        //位置情報の精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //位置情報取得間隔(m)
        mapView.setCenterCoordinate(mapView.userLocation.coordinate, animated: true)
        mapView.userTrackingMode = MKUserTrackingMode.Follow
        locationManager.distanceFilter = 300
        
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 位置情報取得に成功したときに呼び出されるデリゲート.
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
                // 表示する領域を設定する
                
                // 現在地から目的地家の経路を検索
        
        destLocation = CLLocationCoordinate2DMake(latitude!,longitude!)
        let destLocAnnotation: MKPointAnnotation = MKPointAnnotation()
        destLocAnnotation.coordinate = destLocation
        destLocAnnotation.title = "目的地"
        mapView.addAnnotation(destLocAnnotation)
        getRoute()
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("失敗")
    }
    
    func getRoute(){
        // MKMapItem をセットして MKDirectionsRequest を生成
        let request = MKDirectionsRequest()
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: selflatitude!, longitude: selflongitude!), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), addressDictionary: nil))
        request.requestsAlternateRoutes = false // 単独の経路を検索
        request.transportType = MKDirectionsTransportType.Any
        
        let directions = MKDirections(request:request)
        
        directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
            
            
        }

    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 5.0
        return renderer
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
