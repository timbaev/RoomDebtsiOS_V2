//
//  ImageParameterEncoder.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 02/02/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct ImageParameterEncoder {
    
    // MARK: - Instance Methods
    
    static func encode(urlRequest: inout URLRequest, media: MediaData, boundary: String) {
        let lineBreak = "\r\n"
        
        var body = Data()
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"filename\"\(lineBreak + lineBreak)")
        body.append("\(media.filename + lineBreak)")
        
        guard let data = media.data else {
            return Log.e("Unable to load data")
        }
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"data\"\(lineBreak + lineBreak)")
        body.append(data)
        body.append(lineBreak)
        
        body.append("--\(boundary)--\(lineBreak)")
        
        urlRequest.httpBody = body
        
        urlRequest.setValue("\(body.count)", forHTTPHeaderField: HeaderKeys.contentLength)
    }
}
