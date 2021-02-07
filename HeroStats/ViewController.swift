//
//  ViewController.swift
//  HeroStats
//
//  Created by macuser on 10/07/2020.
//  Copyright © 2020 Dimas Syuhada. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var hero:[Hero]?
    var heroes = [HeroStats]()
    var sortedHeroes = [HeroStats]()
    let rolesHero = ["Carry","Durable","Disabler","Escape","Initiator","Jungler","Nuker","Pusher","Support","All",nil]
    var isSorted = false

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var baseUrl = "https://api.opendota.com"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if checkDB(){
            getData();
        }else{
            getJSON{
                print("Success!")
                self.collectionView.reloadData()
    //            self.tableView.reloadData()
            };
        }
        
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Check Connection
        if CheckInternet.Connection(){
            self.Alert(Message: "Connected!")
        }
        else{
            self.Alert(Message: "Your Device is not connected with internet")
        }
    }
    
    //Check Core Data if ever saved the data before
    func checkDB() -> Bool {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Hero")
            let count  = try context.count(for: request)
            return count == 0
        } catch {
            return true
        }
    }
    
    //request API
    func getJSON(completed: @escaping() -> ()){
        let url = URL (string: "https://api.opendota.com/api/herostats")
        URLSession.shared.dataTask(with: url!) { (data,response,error) in
            if error == nil {
                do{
                    self.heroes = try JSONDecoder().decode([HeroStats].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }.resume()
    }
    
    //reload from Core Data
    func getData(){
        do{
            self.hero = try context.fetch(Hero.fetchRequest())
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        catch{
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSorted {
            return sortedHeroes.count
        }else{
            return heroes.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCollectionViewCell
        
        if isSorted {
            cell.lblName.text = sortedHeroes[indexPath.row].localized_name.capitalized
            cell.imageView.contentMode = .scaleAspectFill
            
            let urlImg = baseUrl + sortedHeroes[indexPath.row].img
            cell.imageView.downloadedFrom(link: urlImg)
        }else{
            cell.lblName.text = heroes[indexPath.row].localized_name.capitalized
            cell.imageView.contentMode = .scaleAspectFill
            
            let urlImg = baseUrl + heroes[indexPath.row].img
            cell.imageView.downloadedFrom(link: urlImg)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HeroDetailsViewController") as? HeroDetailsViewController
        if isSorted {
            vc?.hero = sortedHeroes[(indexPath.row)]
            vc?.similarHeroes = sortedHeroes
        }else{
            vc?.hero = heroes[(indexPath.row)]
            vc?.similarHeroes = heroes
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rolesHero.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = rolesHero[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getRolesType(roles: rolesHero[indexPath.row]!)
    }
    
    //sort which types of heroes to view
    func getRolesType(roles: String){
        sortedHeroes.removeAll()
        for i in 0..<heroes.count{
            for x in 0..<heroes[i].roles.count{
                if roles == heroes[i].roles[x] {
                    sortedHeroes.append(heroes[i])
                    break
                }
            }
        }
        isSorted = true
        self.collectionView.reloadData()
    }
    
    //Show Alert Connection
    func Alert (Message: String){
        let alert = UIAlertController(title: "Internet Connection", message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//modify collectionView 
extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        return CGSize(width: bounds.width/2 - 20, height:bounds.height/4)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
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
    func downloaded(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

