import MetadataViews from 0x631e88ae7f1d7c20
import DapperUtilityCoin from 0x82ec283f88a62e65

import NiftoryNonFungibleToken from 0x04f74f0252479aed
import NiftoryNFTRegistry from 0x04f74f0252479aed

pub struct PurchaseData {
    pub let id: UInt64
    pub let name: String
    pub let amount: UFix64
    pub let description: String
    pub let imageURL: String
    pub let paymentVaultTypeID: Type

    init(id: UInt64, name: String, amount: UFix64, description: String, imageURL: String, paymentVaultTypeID: Type) {
    self.id = id
    self.name = name
    self.amount = amount
    self.description = description
    self.imageURL = imageURL
    self.paymentVaultTypeID = paymentVaultTypeID
    }
}

pub fun main(
    merchantAccountAddress: Address,
    registryAddress: Address,
    brand: String,
    nftId: UInt64?,
    nftTypeRef: String,
    setId: Int?,
    templateId: Int?,
    price: UFix64,
    expiry: UInt64
): PurchaseData {

    if setId == nil || templateId == nil {
    panic("setId and templateId must be provided")
    }

    let setManager = NiftoryNFTRegistry.getSetManagerPublic(
    registryAddress,
    brand
    )

    let template = setManager
    .getSet(setId!)
    .getTemplate(templateId!)
    .metadata()
    .get() as! {String: String}
    let name = template["title"]!
    let description = template["description"]!
    let posterURL = template["posterUrl"]
    let mediaURL = template["mediaUrl"]
    var imageURL = ""
  
    if (posterURL != nil ) {
      imageURL = posterURL!
    } else {
      imageURL = mediaURL!
    }
  
    if (imageURL.slice(from: 0, upTo: 7) == "ipfs://") {
      imageURL = "https://cloudflare-ipfs.com/ipfs/".concat(
          imageURL.slice(
          from: 7,
          upTo: imageURL.length
          )
      )
    }

    return PurchaseData(
    id: nftId ?? 0,
    name: name,
    amount: price,
    description: description,
    imageURL: imageURL,
    paymentVaultTypeID: Type<@DapperUtilityCoin.Vault>()
    )
}
