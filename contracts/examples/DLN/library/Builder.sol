// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ClaimOrderUnlockBuilder.sol";
import "./InitWalletIfNeededBuilder.sol";
import "./DlnOrderLib.sol";

library DlnBuilder {
    function serializeClaimOrderUnlock(
        uint64 initReward,
        uint64 claimUnlockReward,
        bytes32 unlockBeneficiary,
        uint256 orderId,
        DlnOrderLib.Order memory order
    ) internal view returns (bytes memory data) {

        data = abi.encodePacked(
            DlnInitWalletIfNeededBuilder.getSerializedInitWalletIfNeededExternalInstruction(
                initReward,
                unlockBeneficiary,
                toBytes32(order.giveTokenAddress, 0)
            ),
            DlnClaimOrderUnlockBuilder.getSerializedClaimOrderUnlockExternalInstruction(
                claimUnlockReward,
                unlockBeneficiary,
                orderId,
                getChainId(),
                toBytes32(order.giveTokenAddress, 0)
            )
        );
    }

    function getChainId() private view returns (uint256 cid) {
        assembly {
            cid := chainid()
        }

    }

    function toBytes32(bytes memory _bytes, uint256 _start) private pure returns (bytes32) {
        require(_bytes.length >= _start + 32, "toBytes32_outOfBounds");
        bytes32 tempBytes32;

        assembly {
            tempBytes32 := mload(add(add(_bytes, 0x20), _start))
        }

        return tempBytes32;
    }
}