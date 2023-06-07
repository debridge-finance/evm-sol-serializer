import hre, { ethers } from 'hardhat';
import { expect, use } from 'chai';
import chaiBytes from 'chai-bytes';
import {
  DlnClaimUnlockExample,
  DlnClaimUnlockExample1,
  DlnClaimUnlockExample1__factory,
  DlnClaimUnlockExample2,
  DlnClaimUnlockExample2__factory,
  DlnClaimUnlockExample__factory,
} from '../typechain-types';

use(chaiBytes);

describe('Use case: DlnClaimUnlockExample', () => {
  let deployment: DlnClaimUnlockExample;
  let deployment1: DlnClaimUnlockExample1;
  let deployment2: DlnClaimUnlockExample2;

  beforeEach(async () => {
    const [signer] = await hre.ethers.getSigners();
    deployment = await new DlnClaimUnlockExample__factory(signer).deploy();
    deployment1 = await new DlnClaimUnlockExample1__factory(signer).deploy();
    deployment2 = await new DlnClaimUnlockExample2__factory(signer).deploy();
  });

  it('Should serialize ExternalInstruction on-chain', async () => {
    const resultHex = await deployment.serializeNativeExternalInstruction0();

    const masterHex =
      '0x000000000000000001f01d1f0000000000000000000101000000000000000100000000000000010000008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f8590300000000000000000000002000000000000000c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c800000000200000000000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a9000000002000000000000000646464646464646464646464646464646464646464646464646464646464646400008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f85906000000000000001968562fef0aab1b1d8f99d44306595cd4ba41d7cc899c007a774d23ad702ff601019f3d96f657370bf1dbb3313efba51ea7a08296ac33d77b949e1b62d538db37f20001c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c80000646464646464646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000000000000000000000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a90000010000000000000001';

    expect(ethers.utils.arrayify(resultHex)).equalBytes(ethers.utils.arrayify(masterHex));
  });

  it('Should serialize ExternalInstruction (1) on-chain', async () => {
    const resultHex = await deployment1.serializeNativeExternalInstruction1();

    const masterHex =
      '0x000000000000000000000000000107000000000000000200000000000000010000000d0720fe448de59d8811e24d6df917dc8d0d98b392ddf4dd2b622a747a60fded01000000000000000000000005000000000000005354415445000300000000000000010000000d0720fe448de59d8811e24d6df917dc8d0d98b392ddf4dd2b622a747a60fded0100000000000000000000000a00000000000000464545204c4544474552000400000000000000010000000d0720fe448de59d8811e24d6df917dc8d0d98b392ddf4dd2b622a747a60fded02000000000000000000000011000000000000004645455f4c45444745525f57414c4c45540000000020000000000000006464646464646464646464646464646464646464646464646464646464646464000600000000000000010000000d0720fe448de59d8811e24d6df917dc8d0d98b392ddf4dd2b622a747a60fded0200000000000000000000001000000000000000474956455f4f524445525f5354415445000000002000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000700000000000000010000008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f8590300000000000000000000002000000000000000c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c800000000200000000000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a90000000020000000000000006464646464646464646464646464646464646464646464646464646464646464000900000000000000010000000d0720fe448de59d8811e24d6df917dc8d0d98b392ddf4dd2b622a747a60fded0200000000000000000000001100000000000000474956455f4f524445525f57414c4c4554000000002000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000b00000000000000010000000d0720fe448de59d8811e24d6df917dc8d0d98b392ddf4dd2b622a747a60fded0200000000000000000000001800000000000000415554484f52495a45445f4e41544956455f53454e4445520000000020000000000000000a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a00000d0720fe448de59d8811e24d6df917dc8d0d98b392ddf4dd2b622a747a60fded0d0000000000000062584959deb8a728a91cebdc187b545d920479265052145f31fb80c73fac5aea00001968562fef0aab1b1d8f99d44306595cd4ba41d7cc899c007a774d23ad702ff60101f2250182dbb654414c597aa68671aedf4c362cea471a83827874f7e5fc5cc2310001565adba0294c79178f6d8f740ad91b150a16f3664ac6b662396196aa74a366f80001cbacf3203fa78ab924a40edaea6df7c61852ed302f39bc5a5570a13a0230f8b1000106a7d517187bd16635dad40455fdc2c0c124c68f215675a5dbbacb5f080000000000d36092a49b1e0128ac52dac1d2e12a9620c26355e6b0395f261f38573380100a00019f3d96f657370bf1dbb3313efba51ea7a08296ac33d77b949e1b62d538db37f20001c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8000164b38af2b249f349fb2d575069b8f66db033e0d50a7ecac5be7178a9ca0d08e600016464646464646464646464646464646464646464646464646464646464646464000013ee19b00dbd5580bc34492d838579bb743a2626308be4490dfa514d873e0234000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a9000028000000000000005951b44f8e9042fbffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';

    expect(ethers.utils.arrayify(resultHex)).equalBytes(ethers.utils.arrayify(masterHex));
  });

  it('Should serialize ExternalInstruction (1) on-chain', async () => {
    const resultHex = await deployment2.serializeNativeExternalInstruction2();

    const masterHex =
      '0x000000000000000000000000000107000000000000000200000000000000010000000d0720fe448de59d8811e24d6df917dc8d0d98b392ddf4dd2b622a747a60fded01000000000000000000000005000000000000005354415445000300000000000000010000000d0720fe448de59d8811e24d6df917dc8d0d98b392ddf4dd2b622a747a60fded0100000000000000000000000a00000000000000464545204c4544474552000400000000000000010000000d0720fe448de59d8811e24d6df917dc8d0d98b392ddf4dd2b622a747a60fded02000000000000000000000011000000000000004645455f4c45444745525f57414c4c45540000000020000000000000006464646464646464646464646464646464646464646464646464646464646464000600000000000000010000000d0720fe448de59d8811e24d6df917dc8d0d98b392ddf4dd2b622a747a60fded0200000000000000000000001000000000000000474956455f4f524445525f5354415445000000002000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe000700000000000000010000008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f8590300000000000000000000002000000000000000c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c800000000200000000000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a90000000020000000000000006464646464646464646464646464646464646464646464646464646464646464000900000000000000010000000d0720fe448de59d8811e24d6df917dc8d0d98b392ddf4dd2b622a747a60fded0200000000000000000000001100000000000000474956455f4f524445525f57414c4c4554000000002000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe000b00000000000000010000000d0720fe448de59d8811e24d6df917dc8d0d98b392ddf4dd2b622a747a60fded0200000000000000000000001800000000000000415554484f52495a45445f4e41544956455f53454e4445520000000020000000000000000a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a00000d0720fe448de59d8811e24d6df917dc8d0d98b392ddf4dd2b622a747a60fded0d0000000000000062584959deb8a728a91cebdc187b545d920479265052145f31fb80c73fac5aea00001968562fef0aab1b1d8f99d44306595cd4ba41d7cc899c007a774d23ad702ff60101f2250182dbb654414c597aa68671aedf4c362cea471a83827874f7e5fc5cc2310001565adba0294c79178f6d8f740ad91b150a16f3664ac6b662396196aa74a366f80001cbacf3203fa78ab924a40edaea6df7c61852ed302f39bc5a5570a13a0230f8b1000106a7d517187bd16635dad40455fdc2c0c124c68f215675a5dbbacb5f0800000000006f7c5b17390ae4be9495d943c750d6c0eb63268e1b4680267c2b4f6c718eed3e00019f3d96f657370bf1dbb3313efba51ea7a08296ac33d77b949e1b62d538db37f20001c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c8c80001366c537907e93ad66070ac62454ff7d9ddf86653266f23260c2a3db8f05c4e9600016464646464646464646464646464646464646464646464646464646464646464000013ee19b00dbd5580bc34492d838579bb743a2626308be4490dfa514d873e0234000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a9000028000000000000005951b44f8e9042fbfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe';

    expect(ethers.utils.arrayify(resultHex)).equalBytes(ethers.utils.arrayify(masterHex));
  });
});
