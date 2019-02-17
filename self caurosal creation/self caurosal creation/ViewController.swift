//
//  ViewController.swift
//  AutoscrollCollectionV
//
//  Created by boppo on 2/12/19.
//  Copyright © 2019 boppo. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var imgCollectionView: UICollectionView!
    
    @IBOutlet weak var lolColle: UICollectionView!
    var isPaused = true
    var scrollingTimer = Timer()
    var visibleIndex = 1
    let imgArray : [UIImage] = [#imageLiteral(resourceName: "5"),#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "2"),#imageLiteral(resourceName: "3"),#imageLiteral(resourceName: "4"),#imageLiteral(resourceName: "5"),#imageLiteral(resourceName: "1")]
    
    //let imgArray : [UIImage] = [#imageLiteral(resourceName: "3"),#imageLiteral(resourceName: "1"),#imageLiteral(resourceName: "2"),#imageLiteral(resourceName: "3"),#imageLiteral(resourceName: "1")]
    
    // let imgArray : [UIImage] = [#imageLiteral(resourceName: "download"),#imageLiteral(resourceName: "maxresdefault (1)"),#imageLiteral(resourceName: "maxresdefault"),#imageLiteral(resourceName: "qhhsglnzmt0"),#imageLiteral(resourceName: "download"),#imageLiteral(resourceName: "maxresdefault (1)")]
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.imgCollectionView.scrollToItem(at: IndexPath(row : 1,section : 0 ), at: .left, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imgCollectionView.delegate = self
        imgCollectionView.dataSource = self
        
        lolColle.delegate = self
        lolColle.dataSource = self
        
        //  imgCollectionView!.decelerationRate = UIScrollView.DecelerationRate.fast
        
        //        imgCollectionView.collectionViewLayout = SnapFlowLayout()
        imgCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        scrollingTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ViewController.startTimer(theTimer:)), userInfo: nil, repeats: true)
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if isPaused == false{
            scrollingTimer.invalidate()
            isPaused=true
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isPaused{
            
            
            
            if scrollView == imgCollectionView{
                var X = scrollView.contentOffset.x
                //  print(X)
                
                // its imgArray.count-2 because to put the x coordinate before 2nd last element
                let maxSize = imgArray.count-2
                
                // X > last element greater
                if X >= (scrollView.contentSize.width - scrollView.bounds.width){
                    self.imgCollectionView.contentOffset = CGPoint(x: 0 , y: 0)
                    
                    // X = size of cell + cell spacing
                    X = 0
                }
                    
                    // 210 < first element is at 210 so
                else if X < (0){
                    //    let maxSize = imgArray.count-2
                    //(10*(maxSize-1)) to make scroll from first element to last element possible as (10*maxSize) is used to make scroll from last to first
                    self.imgCollectionView.contentOffset = CGPoint(x:(scrollView.contentSize.width - scrollView.bounds.width - 10),y:0)
                    
                    // X = last element cgfloat - 10
                    X = (scrollView.contentSize.width - scrollView.bounds.width - 10)
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == imgCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
            cell.imageV.image = imgArray[indexPath.row]
            
            
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath)
            return cell
        }
    }
    
    
    
    //
    @objc func startTimer(theTimer : Timer){
        isPaused = false
        self.visibleIndex += 1
        if self.visibleIndex == (imgArray.count - 1 ){
            self.imgCollectionView.contentOffset = CGPoint(x: 0, y: 0)
            self.visibleIndex = 1
        }
        print(self.visibleIndex)
        
        self.imgCollectionView.scrollToItem(at: IndexPath(row : self.visibleIndex,section : 0 ), at: .left, animated: true)
        
    }
    
    @IBAction func btnTapped(_ sender: UIButton) {
        //        let maxSize = imgArray.count-2
        //        self.imgCollectionView.contentOffset = CGPoint(x: 1000, y: 0)
        //    print("imgCollectionView.indexPathsForVisibleItems  \(imgCollectionView.indexPathsForVisibleItems)")
        let visibleRect = CGRect(origin: imgCollectionView.contentOffset, size: imgCollectionView.bounds.size)
        //        print("\(visibleRect.maxX) and \(visibleRect.minX)" )
        let visiblePoint = CGPoint(x: visibleRect.minX + 100 , y: visibleRect.midY)
        let visibleIndexPath = imgCollectionView.indexPathForItem(at: visiblePoint)
        //  print("visibleIndexPath \(visibleIndexPath)")
        //
    }
    // Velocity is measured in points per millisecond.
    private var snapToMostVisibleColumnVelocityThreshold: CGFloat { return 0.3}
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(scrollView.panGestureRecognizer.translation(in: scrollView.superview).x)
        if abs(scrollView.panGestureRecognizer.translation(in: scrollView.superview).x) < 30{
            imgCollectionView.scrollToItem(at: [0,visibleIndex], at: .left, animated: true)
        }
        else{
            //    snapToNearestCell(imgCollectionView)
            let direction = scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0 ? "left" : "right"
            if direction == "right"{
                visibleIndex+=1
                print("visibleIndex \(visibleIndex)")
                if (visibleIndex>imgArray.count-2){
                    self.imgCollectionView.contentOffset = CGPoint(x: 0, y: 0)
                    visibleIndex=1
                    imgCollectionView.scrollToItem(at: [0,visibleIndex], at: .left, animated: false)
                }
                else{
                    imgCollectionView.scrollToItem(at: [0,visibleIndex], at: .left, animated: true)
                }
            }
            else{
                visibleIndex-=1
                print("visibleIndex \(visibleIndex)")
                if (visibleIndex < 1){
                    self.imgCollectionView.contentOffset = CGPoint(x: scrollView.contentSize.width - scrollView.bounds.width, y: 0)
                    visibleIndex = imgArray.count-2
                    imgCollectionView.scrollToItem(at: [0,visibleIndex], at: .left, animated: false)
                }
                else{
                    imgCollectionView.scrollToItem(at: [0,visibleIndex], at: .left, animated: true)
                }
            }
        }
    }
    
    
    
}


