//
//  Post.swift
//  CombineFrameWorkBootCamp
//
//  Created by Adarsh Ranjan on 02/03/25.
//


struct Post: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}