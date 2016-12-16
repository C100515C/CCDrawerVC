//
//  ViewController.swift
//  CCDrawerVC
//
//  Created by CC on 16/12/16.
//  Copyright © 2016年 cc. All rights reserved.
//

import UIKit

class CCDrawerVC: UIViewController {

    //单例
    static let shareVC:CCDrawerVC = CCDrawerVC();
    
    var leftVC:CCLeftVC?
    var mainVC:CCMainVC?
    
    var moveWidth:CGFloat?
    
    var coverBtn:UIButton?
    var leftPan:UIScreenEdgePanGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white;
        
        self.leftVC?.view.transform = CGAffineTransform.init(translationX: -self.moveWidth!, y: 0);
//        self.leftVC?.view.transform = self.leftVC!.view.transform.scaledBy(x: 0.7, y: 0.7);
        
//        setCoverButton();
        addScreenEdgePanGestureRecognizer(view: self.view);
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// 添加屏幕左边滑动手势
    ///
    /// - Parameter view: 添加手势view
    func addScreenEdgePanGestureRecognizer(view:UIView) -> Void {
        let pan = UIScreenEdgePanGestureRecognizer.init(target: self, action:#selector(CCDrawerVC.leftEdgePanAction(pan:)));
        view.addGestureRecognizer(pan);
        pan.edges = UIRectEdge.left;
        self.leftPan = pan;
    }
    
    
    /// 左边滑动执行方法
    ///
    /// - Parameter pan: 手势
    func leftEdgePanAction(pan:UIScreenEdgePanGestureRecognizer) -> Void {
        
        
        let offsetX = pan.translation(in: pan.view).x;
//        print("左滑");
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
        
            //手势 滑动改变
            if pan.state == UIGestureRecognizerState.changed && offsetX < self.moveWidth! {
                
                self.mainVC?.view.transform = CGAffineTransform.init(translationX: offsetX, y: 0);
                self.leftVC?.view.transform = CGAffineTransform.init(translationX: -self.moveWidth!+offsetX, y: 0);
                
//                let scale = (offsetX+self.moveWidth!*0.5)/self.moveWidth!;
                
//                if scale < 0.7 {
//                    scale = 0.7;
//                }else if scale >= 1.0{
//                    scale = 1.0;
//                }
//                print(scale);
//               self.leftVC?.view.transform = self.leftVC!.view.transform.scaledBy(x: scale, y: scale);
//                self.mainVC?.view.transform = self.mainVC!.view.transform.scaledBy(x:1-scale+0.7, y: 1-scale+0.7);
                
//                print("滑动");
            }else if pan.state == .cancelled || pan.state == .ended || pan.state == .failed{
                //滑动停止 取消 失败
                if offsetX >= UIScreen.main.bounds.size.width*0.5 {
                    self.openDrawer();
                    
                }else{
                    self.closeDrawer();

                }
                
            }
            
        }, completion: {(Bool)in
//            print("左滑动画结束");
        });
        
    }
    
    
    /// 打开 抽屉
    func openDrawer() -> Void {
//        print("打开");
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            
            self.mainVC?.view.transform = CGAffineTransform.init(translationX: self.moveWidth!, y: 0);
            self.leftVC?.view.transform = CGAffineTransform.init(translationX: 0, y: 0);
//            self.leftVC?.view.transform = self.leftVC!.view.transform.scaledBy(x: 1, y: 1);
//            self.mainVC?.view.transform = self.mainVC!.view.transform.scaledBy(x:0.7, y: 0.7);
        }, completion: {(Bool) in
            self.setCoverButton();
            
            self.mainVC?.view.addSubview(self.coverBtn!);
            self.leftPan!.isEnabled = false;

        });
    }
    
    
    /// 关上 抽屉
    func closeDrawer()-> Void{
//        print("关上");

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            
            self.mainVC?.view.transform = CGAffineTransform.init(translationX: 0, y: 0);
            self.leftVC?.view.transform = CGAffineTransform.init(translationX: -self.moveWidth!, y: 0);
//            self.leftVC?.view.transform = self.leftVC!.view.transform.scaledBy(x: 0.7, y: 0.7);
//            self.mainVC?.view.transform = self.mainVC!.view.transform.scaledBy(x:1, y: 1);
        }, completion: {(Bool) in
            self.coverBtn?.removeFromSuperview();
            self.coverBtn = nil;
            self.leftPan!.isEnabled = true;

        });
    }
    
    /// 创建遮罩按钮 遮罩在主视图上
    func setCoverButton() {
        
        guard self.coverBtn != nil else {
            //  创建遮罩按钮
            let coverButton = UIButton.init()
            self.coverBtn = coverButton
            coverButton.backgroundColor = UIColor.clear;
            coverButton.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            coverButton.addTarget(self, action: (#selector(CCDrawerVC.closeDrawer)), for: .touchUpInside);//点击主视图 关闭 抽屉
            addPanGestureRecognizerToCoverBtn(view: coverButton)
            return
        }
    }
    
    /// 给遮罩按钮添加拖拽手势 拖拽关闭抽屉
    ///
    /// - parameter view: 遮罩按钮
    func addPanGestureRecognizerToCoverBtn(view: UIView) {
        let pan = UIPanGestureRecognizer.init(target: self, action: (#selector(CCDrawerVC.panOnCoverBtnAction(pan:))))
        view.addGestureRecognizer(pan)
    }
    
    func panOnCoverBtnAction(pan:UIPanGestureRecognizer) -> Void {
        let offsetX = pan.translation(in: pan.view).x;

        if pan.state == UIGestureRecognizerState.changed && offsetX < 0 && offsetX > -self.moveWidth!{
            
            self.mainVC?.view.transform = CGAffineTransform.init(translationX: self.moveWidth!+offsetX, y: 0);
            self.leftVC?.view.transform = CGAffineTransform.init(translationX: offsetX, y: 0);
            
            
//            let scale = offsetX/self.moveWidth!;
            
//            if scale < 0.7 {
//                scale = 0.7;
//            }else if scale >= 1.0{
//                scale = 1.0;
            
//            }
            
//            self.leftVC?.view.transform = self.leftVC!.view.transform.scaledBy(x: scale, y: scale);
//            self.mainVC?.view.transform = self.mainVC!.view.transform.scaledBy(x:1-scale+0.7, y: 1-scale+0.7);
            
        }else if pan.state == .cancelled || pan.state == .ended || pan.state == .failed{
            
            if offsetX < 0 , UIScreen.main.bounds.width - self.moveWidth! + abs(offsetX) > UIScreen.main.bounds.width * 0.5 {
                self.closeDrawer();
                
            }else{
                self.openDrawer();
                
            }
            
        }
        
    }
    
    class func addDrawerVC(left:CCLeftVC,main:CCMainVC,move:CGFloat) -> CCDrawerVC {
        
        let drawer:CCDrawerVC = CCDrawerVC.shareVC;
        
        drawer.leftVC = left;
        drawer.mainVC = main;
        drawer.moveWidth = move;
        
        drawer.addChildViewController(left);
        drawer.addChildViewController(main);
        drawer.view.addSubview(left.view);
        drawer.view.addSubview(main.view);
        
        return drawer;
    }
    

}

