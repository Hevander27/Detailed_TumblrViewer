//
//  ViewController.swift
//  ios101-project6-tumblr
//

import Foundation
import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dropButton: UIBarButtonItem!
    var posts: [Post] = []
    var blogName = "humansofnewyork"
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.title = blogName
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let navyBlue = UIColor(red: 6.0/255.0, green: 24.0/255.0, blue: 51.0/255.0, alpha: 1.0)

        self.navigationController?.navigationBar.barTintColor = navyBlue
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        dropButton = UIBarButtonItem(title: "More Blogs", style: .plain, target: self, action: #selector(dropdownButtonTapped))
        navigationItem.rightBarButtonItem = dropButton
        
       

        tableView.dataSource = self
        tableView.delegate = self
        fetchPosts()
        

    }
    
 
            
    @objc func dropdownButtonTapped() {
        let alert = UIAlertController(title: nil, message: "Popular Blogs", preferredStyle: .actionSheet)
        
        let blogs = ["humansofnewyork", "pitchersandpoets", "peacecorps", "derekg", "thisisnthappiness"]
        
        for blog in blogs {
            alert.addAction(UIAlertAction(title: blog, style: .default, handler: { (_) in
                self.blogName = blog
                self.fetchPosts()
                self.viewDidLoad()

                
            }))
        }
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        
        present(alert, animated: true, completion: nil)
    }
   





            


    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: posts[indexPath.row])
    }

    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell

        let post = posts[indexPath.row]

        cell.summaryLabel.text = post.summary

        if let photo = post.photos.first {
            let url = photo.originalSize.url
            Nuke.loadImage(with: url, into: cell.postImageView)
        }

        return cell
    }


    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/\(blogName)/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                return
            }

            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)

                DispatchQueue.main.async { [weak self] in

                    let posts = blog.response.posts
                    self?.posts = posts
                    self?.tableView.reloadData()

                    print("✅ We got \(posts.count) posts!")
                    for post in posts {
                        print("🍏 Summary: \(post.summary)")
                    }
                }

            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let detailViewController = segue.destination as? DetailViewController,
               let post = sender as? Post {
                detailViewController.post = post
            }
        }
    }

}

