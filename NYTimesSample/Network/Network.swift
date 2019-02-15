//
//  Network.swift
//  NYTimesSample
//
//  Created by Ersin Gursu on 15.02.2019.
//  Copyright © 2019 Ersin Gürsu. All rights reserved.
//

import UIKit


public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}


class Network : NSObject {

    typealias SuccessCallback<T> = (_ response: T) -> Void
    
    public static let instance = Network()
    
    private var session : URLSession?
    
    override init() {
        super.init()
        session = URLSession.init(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    func request<T: Decodable>(_ httpMethodType:HTTPMethod = .get, params : [String:Any],section : String,dayType : String, onSuccess: @escaping SuccessCallback<T> ){
        
        var requestString = String.init(format: Constants.requestUrl, section,dayType)
        
        var urlRequest : URLRequest?
        
        if httpMethodType == .post
        {
            urlRequest = URLRequest.init(url: URL.init(string: requestString)!)
            let httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            urlRequest!.httpBody = httpBody
        }else {
            
            if params.count > 0 {
                
                for (k,v) in params{
                    requestString = "\(requestString)&\(k)=\(v)"
                }
                
            }
            urlRequest = URLRequest.init(url: URL.init(string: requestString)!)
        }
        
        urlRequest!.httpMethod = httpMethodType.rawValue
        urlRequest!.timeoutInterval = Constants.CONNECTION_TIMEOUT
        urlRequest!.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest!.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        let dataTask = session?.dataTask(with: urlRequest!, completionHandler: { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                else {
                    print("error: not a valid http response")
                    return
            }
            
            switch (httpResponse.statusCode)
            {
            case 200:
                
                let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                 
                do {
                    
                    let getResponse = try JSONSerialization.jsonObject(with: receivedData, options: .allowFragments)
                    
                    print(getResponse)
                    
                    if let obj = try T.decode(from: data!) {
                        onSuccess(obj)
                    }
                } catch {
                    print("error serializing JSON: \(error)")
                }
                
                break
            case 400:
                
                break
            default:
                print("wallet GET request got response \(httpResponse.statusCode)")
            }
        })
        
        dataTask?.resume()
        
    }
    
}

extension Network : URLSessionDelegate{
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
    }
    
}
