//
//  TaggyView.swift
//  Blint
//
//  Created by Ferit Bölezek on 31/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import UIKit

class TaggyView: UIView {

    var firstRun = true
    var yCount: CGFloat = 1
    var previousRect = CGRect(x: 0, y: 0, width: 5, height: 0)
    var startingPosition = CGRect(x: 0, y: 0, width: 5, height: 0)
    var endOfLines = false
     var taggies = [String]()
     var newTaggies = [String]()
     var moreTaggies = [String]()
    var showMoreBtn: UIButton?
    var amountAdded = 0
    
    var typeOfData = UserInformationType.preferences        // default. Should be set before use.
    
    weak var delegate: TaggyViewDelegate?
    
    private var drawnLabels = [UILabel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    func addTaggies() {
        
        let amountOfTaggies = taggies.count
        if amountOfTaggies > 5 {
            if newTaggies.isEmpty {
                var searchIndex = (5*amountAdded+5)
                if searchIndex > taggies.count {
                    let difference = searchIndex - taggies.count
                    searchIndex -= difference
                    showMoreBtn?.removeFromSuperview()
                }
                
                for tag in (0+5*amountAdded)..<(searchIndex) {
                    addTaggy(withLabel: taggies[tag] as NSString)
                }
                if showMoreBtn == nil {
                addShowMore()
                } else { updateBtnPosition() }
                
            }
        } else if amountOfTaggies > 0 {
            for tag in 0...taggies.count - 1 {
                addTaggy(withLabel: taggies[tag] as NSString)
            }
        }
        amountAdded += 1
    }
    private func addShowMore() {
        showMoreBtn = UIButton()
        showMoreBtn!.frame = previousRect
        showMoreBtn!.frame.size.width = 110
        
        let estimateNextSize = CGRect(x: previousRect.minX +
            showMoreBtn!.frame.width, y: previousRect.minY, width: showMoreBtn!.frame.size.width + 10, height: showMoreBtn!.frame.size.height)
        if estimateNextSize.maxX > self.frame.width - 10 {
            showMoreBtn!.frame = startingPosition
            showMoreBtn!.frame.size.width = 110
            showMoreBtn!.frame.size.height = 32
            showMoreBtn!.center.y = previousRect.maxY + 25
            showMoreBtn!.center.x += 5
            
        } else {
        showMoreBtn!.center.x += previousRect.width + 5
        }
        
        showMoreBtn!.backgroundColor = UIColor(red: 56/255, green: 164/255, blue: 255/255, alpha: 0.8)
        showMoreBtn!.setTitle("Show more", for: .normal)
        showMoreBtn!.titleLabel?.textColor = UIColor.white
        showMoreBtn!.layer.cornerRadius = 15.0
        showMoreBtn!.isUserInteractionEnabled = true
        showMoreBtn!.addTarget(self, action: #selector(showMoreTapped), for: .touchUpInside)
        self.addSubview(showMoreBtn!)
    }
    
    func updateBtnPosition() {
        showMoreBtn!.frame = previousRect
        showMoreBtn!.frame.size.width = 110
        let estimateNextSize = CGRect(x: previousRect.minX +
            showMoreBtn!.frame.width, y: previousRect.minY, width: showMoreBtn!.frame.size.width + 10, height: showMoreBtn!.frame.size.height)
        if estimateNextSize.maxX > self.frame.width - 10 {
            showMoreBtn!.frame = startingPosition
            showMoreBtn!.frame.size.width = 110
            showMoreBtn!.frame.size.height = 32
            showMoreBtn!.center.y = previousRect.maxY + 25
            showMoreBtn!.center.x += 5
        } else {
            showMoreBtn!.center.x += previousRect.width + 10
        }
    }
    
    func showMoreTapped(sender: UIButton!) {
        addTaggies()
        delegate?.userWishesToSeeMore(informationType: typeOfData)
    }
    
    func removeEveryting() {
        removeExisting()
    }
    
    private func removeExisting() {
        if !drawnLabels.isEmpty {
        for label in drawnLabels {
            label.removeFromSuperview()
        }
        }
        taggies.removeAll()
        showMoreBtn?.removeFromSuperview()
        showMoreBtn = nil
        amountAdded = 0
        previousRect = CGRect(x: 0, y: 0, width: 5, height: 0)
        yCount = 1
    }
    
    private func addTaggy(withLabel: NSString) {

        if !endOfLines {
            let arbitrarySize = CGSize(width: 1000, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let labelRect = withLabel.boundingRect(with: arbitrarySize, options: options, attributes: [NSFontAttributeName : UIFont(name: "Avenir", size: 16)!], context: nil)
            let labelSize = labelRect.size
            
            let estimateNextSize = CGRect(x: previousRect.minX + previousRect.width + 5, y: previousRect.minY, width: labelSize.width + 20, height: labelSize.height + 10)
            
            if estimateNextSize.maxX > self.frame.width - 10 {
                previousRect = CGRect(x: 0, y: (estimateNextSize.height + 10) * yCount, width: 5, height: 0)
                yCount += 1
            }
            
            let label = UILabel(frame: CGRect(x: previousRect.minX + previousRect.width + 5, y: previousRect.minY, width: labelSize.width + 20, height: labelSize.height + 10))
            
            if label.frame.minY + labelSize.height > self.frame.height {
                increaseSizeOfParentView(increaseHeight: true, currentLabel: label)
                if endOfLines { return }
            }
            
            label.text = String(withLabel)
            label.backgroundColor = UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 0.55)
            label.layer.cornerRadius = 15.0
            label.textColor = UIColor.white
            label.layer.masksToBounds = true
            label.textAlignment = NSTextAlignment.center
            self.addSubview(label)
            drawnLabels.append(label)
            previousRect = label.frame
            firstRun = false
        }
    }
    
    /// If paramater equals true, this function will increase the size of the TaggyView to fit the next taggy. Else it will stop and not add the next taggy.
    func increaseSizeOfParentView(increaseHeight: Bool, currentLabel: UILabel) {
        
        if increaseHeight {
            self.frame.size.height += currentLabel.frame.height
        } else {
            endOfLines = true
        }
    }

}
