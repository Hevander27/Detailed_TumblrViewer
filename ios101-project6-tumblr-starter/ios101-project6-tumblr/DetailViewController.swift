//
//  DetailViewController.swift
//  ios101-project6-tumblr
//
//  Created by libraries on 10/26/23.
//

import Foundation
import UIKit
import Nuke

class DetailViewController: UIViewController {
    var post: Post?

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    func configureView() {
        if let imageURL = URL(string: post?.photos.first?.originalSize.url.absoluteString ?? "") {
            Nuke.loadImage(with: imageURL, into: postImageView)
        }

        // if let x = y, if y turns out not nill that then assign x = y and all x to be used within the curley brackets only,
        // nil may not be handled unless you use else
        

        if let postCaption = post?.caption.trimHTMLTags() {
            //print("Post Caption:", postCaption)
            captionTextView.text = postCaption
           } else {
               print("Unable to get caption.")
           }
        
    }
}

