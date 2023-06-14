// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

library DlnOrderLib {
    struct Order {
        /// Unique nonce number for each maker
        /// Together with the maker, it forms the uniqueness for the order,
        /// which is important for calculating the order id
        uint64 makerOrderNonce;
        /// Order maker address
        /// Address in source chain
        bytes makerSrc;
        uint256 giveChainId;
        bytes giveTokenAddress;
        uint256 giveAmount;
        uint256 takeChainId;
        bytes takeTokenAddress;
        uint256 takeAmount;
        bytes receiverDst;
        bytes givePatchAuthoritySrc;
        /// Address in destination chain
        /// Can `send_order_cancel`, `process_fallback` and `patch_order_take`
        bytes orderAuthorityAddressDst;
        /// allowedTakerDst * optional
        bytes allowedTakerDst;
        /// Address in source chain
        /// If the field is `Some`, then only this address can receive cancel
        /// * optional
        bytes allowedCancelBeneficiarySrc;
        /// externalCall * optional
        bytes externalCall;
    }
}
