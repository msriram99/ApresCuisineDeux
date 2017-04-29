//
//  MapViewController.swift
//  ApresCuisineDeux
//
//  Created by Himaja Motheram on 4/25/17.
//  Copyright © 2017 Sriram Motheram. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var foodMapView: MKMapView!
       var currentdish: Dish?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if currentdish?.Lat != nil && currentdish?.lon != nil {
            addFoodMapPointOnLoad()
        }
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotationOnLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 0.5
        self.foodMapView.addGestureRecognizer(longPressGesture)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addFoodMapPointOnLoad() {
        var pinsToRemove = [MKPointAnnotation]()
        for annotation in foodMapView.annotations {
            if annotation is MKPointAnnotation {
                pinsToRemove.append(annotation as! MKPointAnnotation)
            }
        }
        foodMapView.removeAnnotations(pinsToRemove)
        let foodMapPoint = MKPointAnnotation()
        foodMapPoint.coordinate = CLLocationCoordinate2D(latitude: (currentdish?.Lat)!, longitude: (currentdish?.lon)!)
        foodMapPoint.title = currentdish?.name
        foodMapPoint.subtitle = currentdish?.review
        foodMapView.addAnnotation(foodMapPoint)
        zoomToPin(lat: foodMapPoint.coordinate.latitude, lon: foodMapPoint.coordinate.longitude)
    }
    
    func zoomToPin(lat: Double, lon: Double) {
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let viewRegion = MKCoordinateRegionMakeWithDistance(coord, 3000.0, 3000.0)
        let adjustedRegion = foodMapView.regionThatFits(viewRegion)
        foodMapView.setRegion(adjustedRegion, animated: true)
    }
    
    func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .ended {
            let point = gesture.location(in: self.foodMapView)
            let coordinate = self.foodMapView.convert(point, toCoordinateFrom: self.foodMapView)
            print(coordinate)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = currentdish?.name
            annotation.subtitle = currentdish?.review
            self.foodMapView.addAnnotation(annotation)
            currentdish?.Lat = coordinate.latitude
            currentdish?.lon = coordinate.longitude
            currentdish?.saveInBackground { (success, error) in
                print("Object Saved")
                    }
        }
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
