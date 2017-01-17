//
//  DocumentService.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 17/01/2017.
//
//

import Foundation

class DocumentService: Service<Document> {

    // MARK: Instance properties

    private var configuration: MongoLabConfiguration


    // MARK: Object life cycle

    required init(client: MongoLabClient, configuration: MongoLabConfiguration, delegate: ServiceDelegate) {
        self.configuration = configuration
        super.init(client: client)

        self.delegate = delegate
    }


    required init(configuration: MongoLabConfiguration, delegate: ServiceDelegate) {
        self.configuration = configuration
        super.init(client: MongoLabClient())

        self.delegate = delegate
    }


    // MARK: Public APIs

    public func addDocument(_ document: Document, inCollection collection: Collection) {
        delegate?.serviceWillLoad(self)

        do {
            let request = try MongoLabURLRequest.urlRequestWith(configuration, relativeURL: "collections/\(collection)", method: .POST, parameters: [], bodyData: document.payload as AnyObject?)

            perform(request: request, with: DocumentParser.parse)

        } catch let error {
            delegate?.service(self, didFailWith: error as? ErrorDescribable ?? MongoLabError.requestError)
        }
    }
    
}
