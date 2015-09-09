//
//  ViewController.swift
//  Animation
//
//  Created by Pankti Patel on 17/07/15.
//  Copyright (c) 2015 Pankti Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {

    
    let  kBarHeight:CGFloat = 50.0
    let  kBlurFadeInFactor:CGFloat = 0.004
    let  kBackgroundParallexFactor:CGFloat = 0.5
    let header_height:CGFloat  = 320.0
    var tableViewHeight:CGFloat?
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        mainScrollView!.delegate = self;
        mainScrollView!.bounces = true;
        mainScrollView!.alwaysBounceVertical = true;
        mainScrollView!.contentSize = CGSizeZero;
        mainScrollView!.showsVerticalScrollIndicator = true;
        mainScrollView!.scrollIndicatorInsets = UIEdgeInsetsMake(kBarHeight, 0, 0, 0);
//        self.view = mainScrollView;
        
        backgroundScrollView!.scrollEnabled = false;
        backgroundScrollView!.contentSize = CGSizeMake(header_height, 1000);
        
        
        imageView.image = UIImage(named: "example")
        imageView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        imageView.backgroundColor = UIColor.clearColor()
        
        UIGraphicsBeginImageContextWithOptions(backgroundScrollView!.bounds.size, backgroundScrollView!.opaque, 0.0)
        backgroundScrollView!.layer.renderInContext(UIGraphicsGetCurrentContext())
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        mainImageView!.contentMode = UIViewContentMode.ScaleAspectFill
        mainImageView!.image = img.applyBlurWithRadius(12, tintColor: UIColor(white: 0.8, alpha: 0.4), saturationDeltaFactor: 1.8, maskImage: nil)
        mainImageView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        mainImageView!.alpha = 0
        mainImageView!.backgroundColor = UIColor.clearColor()
        
        
        tableView?.scrollEnabled = false
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.tableFooterView = UIView(frame: CGRectZero)
        tableView?.separatorColor = UIColor.clearColor()
        tableView?.backgroundColor = UIColor.clearColor()
        tableViewHeight = tableView.frame.size.height
        
    }
    
    override func viewDidAppear(animated: Bool) {
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView == mainScrollView{
            var delta:CGFloat = 0.0
            var rect:CGRect = CGRectMake(0, 0, self.view.frame.size.width, header_height)
            
            if (scrollView.contentOffset.y < 0.0) {
                
                delta = fabs(min(0.0, mainScrollView!.contentOffset.y))
                backgroundScrollView!.frame = CGRectMake(CGRectGetMinX(rect) - delta / 2.0, CGRectGetMinY(rect) - delta, CGRectGetWidth(rect) + delta, CGRectGetHeight(rect) + delta)
                tableView!.setContentOffset(CGPointZero, animated: false)
                tableView.scrollEnabled = false
                
            } else {
                delta = mainScrollView!.contentOffset.y
                
//                            println(delta)
                if delta > 0 {
                    
                    mainImageView!.alpha = min(1 , delta * kBlurFadeInFactor);
                }
                
                
                var backgroundScrollViewLimit:CGFloat = backgroundScrollView!.frame.size.height - kBarHeight;
                
                if (ceil(delta) > ceil(backgroundScrollViewLimit)) {
                    
                    backgroundScrollView!.frame = CGRectMake(0, delta - backgroundScrollView!.frame.size.height + kBarHeight, self.view.frame.size.width, header_height)
                    
//                    tableView!.contentOffset = CGPointMake (0, delta - backgroundScrollViewLimit);
                    var height:CGFloat = tableView.contentSize.height
                    var maxHeight:CGFloat = tableViewHeight! + delta
                    
                    if (maxHeight > height){
                        
                        maxHeight = height;
                    }
                    
                    tableView!.frame =  CGRectMake(0, CGRectGetMinY(backgroundScrollView!.frame) + CGRectGetHeight(backgroundScrollView!.frame), tableView!.frame.size.width, tableView!.frame.size.height)
                    tableView.scrollEnabled = true
//                    println("in if")
                    var contentOffsetY:CGFloat = -backgroundScrollViewLimit * kBackgroundParallexFactor
                    backgroundScrollView?.setContentOffset(CGPointMake(0, contentOffsetY), animated: false)
                }
                else {
                    
                    
                    if ceil(delta) < ceil(backgroundScrollViewLimit){
                        
                        tableView.scrollEnabled = false

//                        println("in condition")
//                        println(delta) 
                    }
//                    println("in else")

                    backgroundScrollView!.frame = rect
                    var height:CGFloat = tableView.contentSize.height
                    var maxHeight:CGFloat = tableViewHeight!+delta
                    
                    if (maxHeight > height){
                        
                        maxHeight = height;
                    }
                    
//                    tableView!.contentOffset = CGPointMake (0, 0);

                    tableView!.frame =  CGRectMake(0, CGRectGetMinY(backgroundScrollView!.frame) + CGRectGetHeight(backgroundScrollView!.frame), tableView!.frame.size.width, maxHeight)
                    
                    mainScrollView!.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), tableView!.frame.size.height + CGRectGetHeight(backgroundScrollView!.frame));
                    
                    backgroundScrollView?.setContentOffset(CGPointMake(0, -delta * kBackgroundParallexFactor), animated: false)
                    
                }
            }
            
        }
    }
    
   
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        }
        
        //println(indexPath.row)
        cell?.backgroundColor = UIColor.clearColor()
        cell!.textLabel?.text = "Row \(indexPath.row)"
        return cell!
    }

}

