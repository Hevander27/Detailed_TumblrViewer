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
                postImageView.contentMode = .scaleAspectFill 
            }

            // Ensure that the caption is displayed properly without HTML tags
            if let postCaption = post?.caption.trimHTMLTags() {
                captionTextView.text = postCaption
            } else {
                print("Unable to get caption.")
            }
        }
}

