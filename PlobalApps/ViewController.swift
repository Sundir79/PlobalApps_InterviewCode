//
//  ViewController.swift
//  PlobalApps
//
//  Created by Sundir Kumar on 12/07/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var unsortedArray = [["img" :"https://d3myyafggcycom.cloudfront.net/STAGING/0aa7f441-8310-11ea-86a0-06fa44be0788/60d57d52a7db1.png","order":2,"title":"Two"],["img":"https://cdn.shopify.com/s/files/1/0236/7209/4800/collections/images.jpg?v=1570794264","order":8,"title":"Eight"],["img":"https://cdn.shopify.com/s/files/1/0236/7209/4800/products/2019-HUB-PAGE-Zuhair-Murad-Designer-Flash-Mobile-Banner-opt_4f84c63d-4a26-4dd1-b921-fec767cea612.jpg?v=1591613489","order":5,"title":"Five"],["img":"https://cdn.shopify.com/s/files/1/0236/7209/4800/products/31lqKoMXjXL.jpg?v=1604470029","order":1,"title":"One"],["img":"https://cdn.shopify.com/s/files/1/0236/7209/4800/products/58f12c5e6b4607ad58af4d04cc70ce3a_8f81c2a1-356a-4453-8db9-6c06ad2e74b4.jpg?v=1591713681","order":7,"title":"Seven"],["img":"https://cdn.shopify.com/s/files/1/0236/7209/4800/collections/young-woman-chooses-shoes-stock-photography_csp36315301.jpg?v=1571311053","order":6,"title":"Six"],["img":"https://cdn.shopify.com/s/files/1/0236/7209/4800/collections/Gifts.jpg?v=1571310937","order":4,"title":"Four"],["img":"https://cdn.shopify.com/s/files/1/0236/7209/4800/products/promo3_5a78a4f9-0eaa-4e7f-b32b-d4d8c92db256.png?v=1608019340","order":3,"title":"Three"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var i = 1
        while i < unsortedArray.count {
            let x = unsortedArray[i]
            var j = i-1
            while j >= 0 && unsortedArray[j]["order"] as? Int ?? 0 > x["order"] as? Int ?? 0 {
                unsortedArray[j+1] = unsortedArray[j]
                j -= 1
            }
            unsortedArray[j+1] = x
            i += 1
        }
        print(unsortedArray)
    }
    
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unsortedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! collectionViewCell
        cell.constraintWidth.constant = ((self.view.frame.size.width-40)/2)
        cell.img_Picture.downloaded(from: unsortedArray[indexPath.row]["img"] as? String ?? "")
        return cell
    }
    
}

class collectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img_Picture: UIImageView!
    @IBOutlet weak var constraintWidth: NSLayoutConstraint!
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

