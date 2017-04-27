//
//  ShotsViewModel.swift
//  KamcordShots
//
//  Created by Sang Hyuk Cho on 3/29/17.
//  Copyright © 2017 sang. All rights reserved.
//

import Foundation
import UIKit

class ShotsViewModel{
	// Static variables
	let kamcordAPI = KamcordAPI()
	
	// Dynamic variables
	var latestFeedId: String?
	var latestNextPage: String?
	var shots: [Shot] = []
	
	func prepareRequest(url: URL) -> URLRequest{
		// Prepare the request header
		var request = URLRequest(url: url)
		let requestMethod = "GET"
		let requestFields = [
			"Accept": "application/json",
			"accept-language": "en",
			"device-token": "abc123",
			"client-name": "ios"
		]
		request.httpMethod = requestMethod
		for (fieldKey, fieldValue) in requestFields{
			request.setValue(fieldValue, forHTTPHeaderField: fieldKey)
		}
		return request
	}
	
	func prepareURL(path: String, parameters: [String: String]) -> URL?{
		// Complete url with the path and the parameters given
		var components = URLComponents(string: kamcordAPI.baseURL + path)
		var queryItems: [URLQueryItem] = []
		for (key, value) in parameters{
			let item = URLQueryItem(name: key, value: value)
			queryItems.append(item)
		}
		components?.queryItems = queryItems
		return components?.url
	}
	
	func processResults(withJSON data: Data?) -> KamcordAPIResult{
		// Check if data is valid
		guard
			let data = data,
			let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
			let json = jsonObject as? [String: Any] else{
				return .failure("Invalid JSON data")
		}
		
		var shotsFeed: [Shot] = []
		
		// Parse JSON
		let (feedId, nextPage, cards) = self.processGroupData(json: json)
		for card in cards{
			if let shot = self.processCard(card: card){
				shotsFeed.append(shot)
			}
		}
		
		guard !shotsFeed.isEmpty else{
			return .failure("Failed to get Shots Feed")
		}
		
		return .success(feedId, nextPage, shotsFeed)
	}
	
	func processGroupData(json: [String: Any]) -> (String, String, [[String: Any]]){
		// When fetching for the first time, json -> groups -> cards
		if
			let groups = json["groups"] as? [Any],
			let group = groups[0] as? [String: Any],
			let feedId = group["feedId"] as? String,
			let nextPage = group["nextPage"] as? String,
			let cards = group["cards"] as? [[String: Any]]{
			return (feedId, nextPage, cards)
		}// When fetching for additional times, json -> cards (no groups)
		else if
			let feedId = json["feedId"] as? String,
			let nextPage = json["nextPage"] as? String,
			let cards = json["cards"] as? [[String: Any]]{
			return (feedId, nextPage, cards)
		}// If JSON structure different from expectation, return empty variables
		else{
			return ("", "", [[:]])
		}
	}
	
	func processCard(card: [String: Any]) -> Shot?{
		guard
			let shotCardData = card["shotCardData"] as? [String: Any],
			let numHearts = shotCardData["heartCount"] as? Int,
			let thumbNailStrings = shotCardData["shotThumbnail"] as? [String: String],
			let play = shotCardData["play"] as? [String: String],
			let videoString = play["mp4"] else{
				return nil
		}
		return Shot(thumbNailURLStrings: thumbNailStrings, videoURLString: videoString, numHearts: numHearts)
	}
	
	func fetchShotsFeed(errorHandler: @escaping ()->(), completionHandler: @escaping ()->()){
		// Change the url based on whether you are fetching for the first time
		var url: URL?
		if let feedId = self.latestFeedId, let nextPage = self.latestNextPage{
			let path = "/\(feedId)"
			let params = [
				"count": "20",
				"page": "\(nextPage)"
			]
			url = prepareURL(path: path, parameters: params)
		}
		else{
			let path = "/set/featuredShots"
			let params = ["count": "20"]
			url = prepareURL(path: path, parameters: params)
		}
		
		// Send request and parse data received
		if let url = url{
			let request = self.prepareRequest(url: url)
			let session = URLSession(configuration: .default)
			let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
				if error != nil{
					print("Error occured while requesting for Shots Feed")
				}
				else{
					let shotsDataProcessingResult = self.processResults(withJSON: data)
					switch shotsDataProcessingResult{
					case .success(let feedId, let nextPage, let shots):
						self.latestFeedId = feedId
						self.latestNextPage = nextPage
						self.shots.append(contentsOf: shots)
						completionHandler()
					case .failure(let errorMessage):
						print(errorMessage)
						errorHandler()
					}
				}
			})
			dataTask.resume()
		}
		else{
			print("Error occurred with url preparation")
			errorHandler()
		}
	}
}


