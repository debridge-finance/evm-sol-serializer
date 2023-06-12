// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../library/Builder.sol";
import "../library/ClaimOrderUnlockBuilder.sol";
import "../library/InitWalletIfNeededBuilder.sol";

contract DlnLibraryInvoker {
    uint256 public gasMeasured;

    function getSerializedClaimOrderUnlockExternalInstructionForOrder(
        uint64 initReward,
        uint64 claimUnlockReward,
        bytes32 unlockBeneficiary,
        uint256 orderId,
        DlnOrderLib.Order memory order
    ) external view returns (bytes memory) {
        return DlnBuilder.serializeClaimOrderUnlock(initReward, claimUnlockReward, unlockBeneficiary, orderId, order);
    }

    function measureClaimOrderUnlockExternalInstructionForOrder(
        uint64 initReward,
        uint64 claimUnlockReward,
        bytes32 unlockBeneficiary,
        uint256 orderId,
        DlnOrderLib.Order memory order
    ) external returns (bytes memory data) {
        uint gas = gasleft();
        data = DlnBuilder.serializeClaimOrderUnlock(initReward, claimUnlockReward, unlockBeneficiary, orderId, order);
        gasMeasured = gas - gasleft();
    }

    function getSerializedClaimOrderUnlockExternalInstruction(
        uint64 reward,
        bytes32 actionBeneficiary,
        uint256 orderId,
        uint256 orderTakeChainId,
        bytes32 orderGiveTokenAddress
    ) external pure returns (bytes memory) {
        return DlnClaimOrderUnlockBuilder.getSerializedClaimOrderUnlockExternalInstruction(
            reward, actionBeneficiary, orderId, orderTakeChainId, orderGiveTokenAddress
        );
    }

    function getSerializedInitWalletIfNeededExternalInstruction(uint64 reward, bytes32 actionBeneficiary, bytes32 orderGiveTokenAddress) external pure returns (bytes memory) {
        return DlnInitWalletIfNeededBuilder.getSerializedInitWalletIfNeededExternalInstruction(reward, actionBeneficiary, orderGiveTokenAddress);
    }
}
