import hre, { ethers } from 'hardhat';
import { expect, use } from 'chai';
import chaiBytes from 'chai-bytes';
import { BasicExample, BasicExample__factory } from '../typechain-types';

use(chaiBytes);

describe('Use case: basic dummy example', () => {
  let deployment: BasicExample;

  beforeEach(async () => {
    const [signer] = await hre.ethers.getSigners();
    deployment = await new BasicExample__factory(signer).deploy();
  });

  it('Should serialize ExternalInstruction on-chain', async () => {
    const result = await deployment.serializeNativeExternalInstruction();
    const master = new Uint8Array([
      136, 19, 0, 0, 0, 0, 0, 0, 1, 16, 39, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1,
      1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 1, 0, 0, 0, 1, 255, 1, 2, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 236, 19, 0, 0, 0, 0, 0, 0, 80, 20, 0, 0, 0, 0, 0, 0, 1, 10, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 212, 23, 0, 0, 0, 0, 0, 0, 156, 24, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0,
      0, 0, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50,
      50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 1, 0, 0, 0, 0, 0, 0, 0, 90, 90, 90, 90, 90, 90, 90,
      90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90, 90,
      90, 90, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 188, 188, 188, 188, 188, 188, 188, 188, 188, 188,
    ]);

    expect(ethers.utils.arrayify(result)).equalBytes(master).equalBytes(master);
  });
});
