//
//  ImageViewController.swift
//  twitterHash
//
//  Created by Zackery leman on 3/18/15.
//  Copyright (c) 2015 Zleman. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate
{
    
    var imageData: NSData? {
        didSet {
            if imageData != nil {
                self.image = UIImage(data: imageData!)
            } else {
                self.image = nil
            }
        }
    }
    
//Create scrollView and set properties
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize  = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 5.0
        }
    }
    
    private var imageView = UIImageView()
    
    
    private var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize  = imageView.frame.size
            scrollViewDidScrollOrZoom = false
            autoScale()
        }
    }
    
    private var scrollViewDidScrollOrZoom = false
    
    private func autoScale() {
        if scrollViewDidScrollOrZoom {
            return
        }
        if let sv = scrollView {
            if image != nil {
                
                //sv.zoomScale = max(sv.bounds.size.height / image!.size.height, sv.bounds.size.width / image!.size.width)
                
                sv.contentOffset = CGPoint(x: (imageView.frame.size.width - sv.frame.size.width) / 2, y: (imageView.frame.size.height - sv.frame.size.height) / 2)
                
                scrollViewDidScrollOrZoom = false
            }
        }
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollViewDidScrollOrZoom = true
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        scrollViewDidScrollOrZoom = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        autoScale()
    }
    
}