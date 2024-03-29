import { ethers } from 'hardhat';
import { DlnLibraryInvoker__factory } from '../typechain-types';

const hre = require('hardhat');

const Reward = 1000;
const Beneficiary = Buffer.alloc(32, 200);
const OrderGiveTokenAddress = Buffer.alloc(32, 100);
const OrderId = ethers.constants.MaxUint256;

async function main() {
  const [signer] = await hre.ethers.getSigners();
  const deployment = await new DlnLibraryInvoker__factory(signer).deploy();

  const tx = await deployment.measureClaimOrderUnlockExternalInstructionForOrder(
    Reward, // uint64 initReward,
    Reward, // uint64 claimUnlockReward,
    Beneficiary, // bytes32 unlockBeneficiary,
    OrderId, // uint256 orderId,
    {
      // DLN's order
      makerOrderNonce: 0,
      makerSrc: Buffer.alloc(32, 100),
      giveChainId: ethers.constants.MaxUint256,
      giveTokenAddress: OrderGiveTokenAddress,
      giveAmount: ethers.constants.MaxUint256,
      takeChainId: (await hre.ethers.provider.getNetwork()).chainId, // mind the current chainID
      takeTokenAddress: Buffer.alloc(32, 1),
      takeAmount: ethers.constants.MaxInt256,
      receiverDst: Buffer.alloc(33, 1),
      givePatchAuthoritySrc: Buffer.alloc(32, 100),
      orderAuthorityAddressDst: Buffer.alloc(32, 101),
      allowedTakerDst: '0x',
      allowedCancelBeneficiarySrc: '0x',
      externalCall: '0x',
    },
  );

  const rcp = await tx.wait();
  console.log(`Gas used by the transaction: ${rcp.gasUsed}`);

  const gasUsedOnChain = await deployment.gasMeasured();
  console.log(`Gas consumed to serialize instructions: ${gasUsedOnChain}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
