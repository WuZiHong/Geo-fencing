//
//  ViewController.swift
//  Geo-fencing
//
//  Created by 吴子鸿 on 2016/12/22.
//  Copyright © 2016年 吴子鸿. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    var num:Int = 0
    
    @IBOutlet weak var mapview: MKMapView!      //展示的地图
    //定位管理器
    let locationManager:CLLocationManager = CLLocationManager()
    
    var location: CLLocation?

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    var isfirst:Bool = true
    var circle:MKCircle!
    
    var dormregion:CLCircularRegion!        //宿舍范围
    var libraryregion:CLCircularRegion!     //图书馆范围
    var teaching1region:CLCircularRegion! //教一楼
    var teaching3region:CLCircularRegion!   //教三楼
    var gymregion:CLCircularRegion!     //体育馆
    var inforegion:CLCircularRegion!    //信息楼
    var isinteaching3 = false
    var isinlibrary = false;
    var isindorm = false;
    var isinteaching1 = false;
    var isingym = false;
    var isininfo = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.mapview.showsUserLocation = true
        //地图类型设置 - 标准地图
        self.mapview.mapType = MKMapType.standard
        
        //设置地图委托
        self.mapview.delegate = self
        //设置定位服务管理器代理
        locationManager.delegate = self
        //设置定位进度
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //更新距离
        locationManager.distanceFilter = 1   //下面表示设备至少移动1米，才通知委托更新
        ////发送授权申请
        locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled())
        {
            //允许使用定位服务的话，开启定位服务更新
            locationManager.startUpdatingLocation()
            print("定位开始")
        }
        
        //画的图书馆圈
        let libraryco = CLLocationCoordinate2D(latitude:30.5186060000 , longitude:114.3994190000 )
        libraryregion = CLCircularRegion(center: libraryco, radius: 50, identifier: "Library")
        circle = MKCircle(center: libraryco, radius: 50)
        //self.mapview.add(circle)
        libraryregion.notifyOnEntry = true
        libraryregion.notifyOnExit = true
        
        
        //画宿舍圈30.5199740000,114.3971170000
        let dormco = CLLocationCoordinate2D(latitude: 30.5199740000, longitude: 114.3971170000)
        circle = MKCircle(center: dormco, radius: 20)
        self.mapview.add(circle)
        dormregion = CLCircularRegion(center: dormco, radius: 20, identifier: "dorm")
        dormregion.notifyOnEntry = true
        dormregion.notifyOnExit = true
        
        //画教一楼圈30.5203440000,114.4007330000
        let teaching1co = CLLocationCoordinate2D(latitude: 30.5203440000, longitude: 114.4007330000)
        circle = MKCircle(center: teaching1co, radius: 40)
        self.mapview.add(circle)
        teaching1region = CLCircularRegion(center: teaching1co, radius: 40, identifier: "TeachingBuilding1")
        teaching1region.notifyOnEntry = true
        teaching1region.notifyOnExit = true
        
        //画教三楼圈30.5213510000,114.3993280000
        let teaching3co = CLLocationCoordinate2D(latitude: 30.5213510000, longitude: 114.3993280000)
        circle = MKCircle(center: teaching3co, radius: 30)
        self.mapview.add(circle)
        teaching3region = CLCircularRegion(center: teaching3co, radius: 30, identifier: "TeachingBuilding3")
        teaching3region.notifyOnEntry = true
        teaching3region.notifyOnExit = true
        
        //画体院馆圈30.5219450000,114.3984020000
        let gymco = CLLocationCoordinate2D(latitude: 30.5219450000, longitude: 114.3984020000)
        circle = MKCircle(center: gymco, radius: 40)
        self.mapview.add(circle)
        gymregion = CLCircularRegion(center: gymco, radius: 40, identifier: "gym")
        gymregion.notifyOnEntry = true
        gymregion.notifyOnExit = true
        
        //画信息楼圈30.5214340000,114.4010280000
        let infoco = CLLocationCoordinate2D(latitude: 30.5214340000, longitude: 114.4010280000)
        circle = MKCircle(center: infoco, radius: 30)
        self.mapview.add(circle)
        inforegion = CLCircularRegion(center: infoco, radius: 30, identifier: "info")
        inforegion.notifyOnEntry = true
        inforegion.notifyOnExit = true
        
        //画的图书馆、位置矩形
        let libraryco1 = CLLocationCoordinate2D(latitude:30.5182800000 , longitude:114.3991150000 )
        let libraryco2 = CLLocationCoordinate2D(latitude:30.5182800000 , longitude:114.3996890000 )
        let libraryco3 = CLLocationCoordinate2D(latitude:30.5188930000 , longitude:114.3996840000 )
        let libraryco4 = CLLocationCoordinate2D(latitude:30.5189030000 , longitude:114.3991210000 )
        let coordinatess:[CLLocationCoordinate2D] = [libraryco1,libraryco2,libraryco3,libraryco4,libraryco1]    //要画成矩形，所以要5个点
        let polyline = MKPolyline(coordinates: coordinatess, count: 5)
        self.mapview.add(polyline)   //添加到图中
        
        //locationManager.startMonitoring(for: libraryregion)        //监测区域！！
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO: Display circle over lay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("判断")
        if let circle = overlay as? MKCircle {
            print ("画圈了")
            var overlayRenderer : MKCircleRenderer = MKCircleRenderer(overlay: overlay);
            overlayRenderer.lineWidth = 1.0
            overlayRenderer.strokeColor = UIColor.red
            return overlayRenderer
        }
        else if let polyline = overlay as? MKPolyline{
            print ("画矩形了")
            var overlayRenderer : MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
            overlayRenderer.lineWidth = 1.0
            overlayRenderer.strokeColor = UIColor.green
            return overlayRenderer
        }
        return MKOverlayRenderer()
        
    }

    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("进入了")
        let alert = UIAlertController(title: "Welcome!", message: "你进入了\(region.identifier)!", preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("出去了")
        let alert = UIAlertController(title: "Goodbye!", message: "你离开了\(region.identifier)!", preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //delegate method that fires when user location is recieved
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        self.location = userLocation.location
        var region:MKCoordinateRegion
        if (isfirst)        //第一次定位，界面到用户的地方
        {
        //zoom in on user
            region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, mapview.region.span.latitudeDelta, mapview.region.span.longitudeDelta)
            isfirst = false
            mapView.setRegion(region, animated: true)
        }
        num=num+1
        print ("更新位置"+String(describing: num))
        //获取最新的坐标
        label1.text = "经度：\(self.location!.coordinate.longitude)"
        //获取纬度
        label2.text = "纬度：\(self.location!.coordinate.latitude)"
        //获取水平精度
        label4.text = "水平精度：\(self.location!.horizontalAccuracy)"
        //获取垂直精度
        label5.text = "垂直精度：\(self.location!.verticalAccuracy)"
        
        //手动判断图书馆
        if (libraryregion.contains(self.location!.coordinate) && isinlibrary == false) //进入了图书馆
        {
            isinlibrary = true
            let alert = UIAlertController(title: "Welcome!", message: "你进入了图书馆!", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if (isinlibrary && !libraryregion.contains(self.location!.coordinate))
        {
            isinlibrary = false
            let alert = UIAlertController(title: "ByeBye!", message: "你离开了图书馆!", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        //手动判断宿舍
        if (dormregion.contains(self.location!.coordinate) && isindorm == false) //进入了宿舍
        {
            isindorm = true
            let alert = UIAlertController(title: "Welcome!", message: "你进入了宿舍!", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if (isindorm && !dormregion.contains(self.location!.coordinate))
        {
            isindorm = false
            let alert = UIAlertController(title: "ByeBye!", message: "你离开了宿舍!", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        //手动判断教一楼
        if (teaching1region.contains(self.location!.coordinate) && isinteaching1 == false) //进入了教一楼
        {
            isinteaching1 = true
            let alert = UIAlertController(title: "Welcome!", message: "你进入了教一楼!", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if (isinteaching1 && !teaching1region.contains(self.location!.coordinate))
        {
            isinteaching1 = false
            let alert = UIAlertController(title: "ByeBye!", message: "你离开了教一楼!", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        //手动判断教三楼
        if (teaching3region.contains(self.location!.coordinate) && isinteaching3 == false) //进入了教三楼
        {
            isinteaching3 = true
            let alert = UIAlertController(title: "Welcome!", message: "你进入了教三楼!", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if (isinteaching3 && !teaching3region.contains(self.location!.coordinate))
        {
            isinteaching3 = false
            let alert = UIAlertController(title: "ByeBye!", message: "你离开了教三楼!", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        //手动判断体育馆
        if (gymregion.contains(self.location!.coordinate) && isingym == false) //进入了教三楼
        {
            isingym = true
            let alert = UIAlertController(title: "Welcome!", message: "你进入了体育馆!", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if (isingym && !gymregion.contains(self.location!.coordinate))
        {
            isingym = false
            let alert = UIAlertController(title: "ByeBye!", message: "你离开了体育馆!", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        //手动判断信息楼
        if (inforegion.contains(self.location!.coordinate) && isininfo == false) //进入了教三楼
        {
            isininfo = true
            let alert = UIAlertController(title: "Welcome!", message: "你进入了信息楼!", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if (isininfo && !inforegion.contains(self.location!.coordinate))
        {
            isininfo = false
            let alert = UIAlertController(title: "ByeBye!", message: "你离开了信息楼!", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
    
    

}
