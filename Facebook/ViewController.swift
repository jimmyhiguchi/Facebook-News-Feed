//
//  ViewController.swift
//  Facebook
//
//  Created by Jimmy Higuchi on 9/21/17.
//  Copyright © 2017 Jimmy Higuchi. All rights reserved.
//

import UIKit

class Post {
    var name: String?
    var statusText: String?
    var profileImageName: String?
    var statusImageName: String?
    var numberOfLikes: Int?
    var numberOfComments: Int?
}

// create array of Post
var posts = [Post]()

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create new posts
        let markPost = Post()
        markPost.name = "Mark Zuckerberg"
        markPost.statusText = "Meanwhile, Beast turned to the dark side."
        markPost.profileImageName = "zuckprofile"
        markPost.statusImageName = "zuckdog"
        markPost.numberOfLikes = 400
        markPost.numberOfComments = 123
        
        let stevePost = Post()
        stevePost.name = "Steve Jobs"
        stevePost.statusText = "Design is not just what it looks like and feels like. Design is how it works.\n\n" +
            "Being the richest man in the cemetery doesn't matter to me. Going to bed at night saying we've done something wonderful, that's what matters to me.\n\n" +
            "Sometimes when you innovate you make mistakes. It is best to admit them quickly, and get on with improving your other innovations."
        stevePost.profileImageName = "steve_profile"
        stevePost.statusImageName = "steve_status"
        stevePost.numberOfLikes = 1000
        stevePost.numberOfComments = 55
        
        let ghandhiPost = Post()
        ghandhiPost.name = "Mahatma Gandhi"
        ghandhiPost.statusText = "You must be the change you wish to see in the world.\n\n" +
        "First they ignore you, then they laugh at you, then they fight you, then you win.\n\n" +
        "Live as if you were to die tomorrow; learn as if you were to live forever."
        ghandhiPost.profileImageName = "gandhi"
        ghandhiPost.statusImageName = "gandhi_status"
        ghandhiPost.numberOfLikes = 333
        ghandhiPost.numberOfComments = 22
        
        posts.append(markPost)
        posts.append(stevePost)
        posts.append(ghandhiPost)
        
        // allows pulling to bounce the cells
        collectionView?.alwaysBounceVertical = true
        
        // change background color of collection to off white
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        navigationItem.title = "Fakebook"
       
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
 
    // number of items in section
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    // load cell content
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellFeed = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        
        cellFeed.post = posts[indexPath.item]
        
        return cellFeed
    }
    
    // size of cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //estimate height of statusText
        if let statusText = posts[indexPath.item].statusText {
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], context: nil)
            
            // knownHeight is the sum of all Vertical heights in constraint
            let knownHeight = CGFloat(8 + 44 + 4 + 4 + 200 + 8 + 24 + 8 + 44)
            
            return CGSize(width: view.frame.width, height: rect.height + knownHeight + 24)
        }
        
        return CGSize(width: view.frame.width, height: 500)

    }

    // adjust cells based on screen orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
        
    }
}

class FeedCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            
            if let name = post?.name {
                
                // first line of text
                let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 155, green: 161, blue: 171)])
                
                // second line of text
                attributedText.append(NSAttributedString(string: "\nDecember 18   •   San Francisco  •  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.gray]))
                
                // append globe (adding image to text field)
                let attachment = NSTextAttachment()
                attachment.image = #imageLiteral(resourceName: "globe_icon")
                attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
                attributedText.append(NSAttributedString(attachment: attachment))
                
                // increase line spacing
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
                
                
                nameLabel.attributedText = attributedText
                
            }
        
            if let statusText = post?.statusText {
                statusTextView.text = statusText
            }
            
            if let profileImageName = post?.profileImageName {
                profileImageView.image = UIImage(named: profileImageName)
            }
            
            if let statusImage = post?.statusImageName {
                statusImageView.image = UIImage(named: statusImage)
            }
            
            if let likes = post?.numberOfLikes {
                if let comments = post?.numberOfComments {
                    likesCommentsLabel.text = "\(likes) Likes        \(comments) Comments"
                }
            }
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // research {}()
    // loads nameLabel
    let nameLabel: UILabel = {
        let label = UILabel()
        
        // two lines of text per cell
        label.numberOfLines = 2
        
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    
    }()
    // loads profile image
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = #imageLiteral(resourceName: "zuckprofile")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // status text
    let statusTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        // turning off scrolling
        textView.isScrollEnabled = false
        return textView
    }()
    
    // status image
    let statusImageView: UIImageView = {
        let statusImage = UIImageView()
        statusImage.contentMode = .scaleAspectFill
        statusImage.translatesAutoresizingMaskIntoConstraints = false
        statusImage.layer.masksToBounds = true
        return statusImage
    }()
    
    // adding likes and comments
    let likesCommentsLabel: UILabel = {
        let likesComments = UILabel()
//        likesComments.text = "\(.numberOfLikes) Likes        10.7k Comments"
        likesComments.font = UIFont.systemFont(ofSize: 12)
        likesComments.textColor = UIColor.rgb(red: 155, green: 161, blue: 171)
        return likesComments
    }()
    
    // adding divider line view
    let dividerLineView: UIView = {
        let dividerLine = UIView()
        dividerLine.backgroundColor = UIColor.rgb(red: 226, green: 228, blue: 232)
        return dividerLine
    }()
    
    // Buttons
    let likeButton =  buttonForTitle(title: " Like", imageName: #imageLiteral(resourceName: "like"))
    let commentButton = buttonForTitle(title: " Comment", imageName: #imageLiteral(resourceName: "comment"))
    let shareButton = buttonForTitle(title: " Share", imageName: #imageLiteral(resourceName: "share"))

    
    // Function to create all buttons
    static func buttonForTitle(title: String, imageName: UIImage) -> UIButton {

            let button = UIButton()
            button.setImage(imageName, for: .normal)
            button.setTitleColor(UIColor.rgb(red: 143, green: 150, blue: 163), for: .normal)
            button.setTitle(" \(title)", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)

            return button

    }
    
    
        func setupViews() {
            
            backgroundColor = UIColor.white
            
            // cell label formatting
            addSubview(nameLabel)
            addSubview(profileImageView)
            addSubview(statusTextView)
            addSubview(statusImageView)
            addSubview(likesCommentsLabel)
            addSubview(dividerLineView)
            addSubview(likeButton)
            addSubview(commentButton)
            addSubview(shareButton)
            
            
            // CONSTRAINTS: Horizontal
            addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
            addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: statusTextView)
            addConstraintsWithFormat(format: "H:|[v0]|", views: statusImageView)
            addConstraintsWithFormat(format: "H:|-12-[v0]|", views: likesCommentsLabel)
            addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: dividerLineView)
            addConstraintsWithFormat(format: "H:|[v0(v2)][v1(v2)][v2]|", views: likeButton, commentButton, shareButton)
        
            // CONSTRAINTS: Vertical
            addConstraintsWithFormat(format: "V:|-12-[v0]", views: nameLabel)
            addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-8-[v4(0.4)][v5(44)]|", views: profileImageView, statusTextView, statusImageView, likesCommentsLabel, dividerLineView, likeButton)
            addConstraintsWithFormat(format: "V:[v0(44)]|", views: commentButton)
            addConstraintsWithFormat(format: "V:[v0(44)]|", views: shareButton)
            
        }
        
}


// adding functionality to RGB call not divide by 255
extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1 )
    }
}

// adding  constraints to UIView
extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
            
        }
             addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
   
}


