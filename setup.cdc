import NonFungibleToken from 0x631e88ae7f1d7c20
import MetadataViews from 0x631e88ae7f1d7c20
import NiftoryNonFungibleToken from 0x04f74f0252479aed
import NiftoryNFTRegistry from 0x04f74f0252479aed
import IPMasters from 0x1bf12be4f00b171f

transaction {
    prepare(acct: AuthAccount) {
        let paths = NiftoryNFTRegistry.getCollectionPaths(0x6085ae87e78e1433, "clejin67a000dmj0udr5m4ptl_IPMasters")

        if acct.borrow<&NonFungibleToken.Collection>(from: paths.storage) == nil {
            let nftManager = NiftoryNFTRegistry.getNFTManagerPublic(0x6085ae87e78e1433, "clejin67a000dmj0udr5m4ptl_IPMasters")
            let collection <- nftManager.getNFTCollectionData().createEmptyCollection()
            acct.save(<-collection, to: paths.storage)

            acct.unlink(paths.public)
            acct.link<&{
                NonFungibleToken.Receiver,
                NonFungibleToken.CollectionPublic,
                MetadataViews.ResolverCollection,
                NiftoryNonFungibleToken.CollectionPublic
            }>(paths.public, target: paths.storage)

            acct.unlink(paths.private)
            acct.link<&{
                NonFungibleToken.Provider,
                NiftoryNonFungibleToken.CollectionPrivate
            }>(paths.private, target: paths.storage)
        }
    }
}
