import hre, { ethers } from 'hardhat';
import { expect, use } from 'chai';
import chaiBytes from 'chai-bytes';
import {
  DeBridgeSolanaLibraryInvoker,
  DeBridgeSolanaLibraryInvoker__factory,
} from '../typechain-types';

use(chaiBytes);

describe('DeBridgeExternalInstructionTest', () => {
  let libraryInvoker: DeBridgeSolanaLibraryInvoker;

  beforeEach(async () => {
    const [signer] = await hre.ethers.getSigners();
    libraryInvoker = await new DeBridgeSolanaLibraryInvoker__factory(signer).deploy();
  });

  describe('PubkeySubstitutions', () => {
    it('PubkeySubstitution::SubmissionAuthWallet', async () => {
      const result = await libraryInvoker.serializeSubmissionAuthWallet({
        // allocate [0xFFu8; 32]
        token_mint: Buffer.alloc(32, 255),
      });
      const master = new Uint8Array([
        0, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
      ]);
      expect(ethers.utils.arrayify(result)).to.equalBytes(master);
    });

    describe('SeedVariants', () => {
      it('SeedVariants::Arbitrary', async () => {
        const result = await libraryInvoker.serializeArbitrarySeed([100, 200, 3]);
        const master = new Uint8Array([0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 100, 200, 3]);
        expect(ethers.utils.arrayify(result)).to.equalBytes(master);
      });

      it('SeedVariants::SubmissionAuth', async () => {
        const result = await libraryInvoker.serializeSubmissionAuthSeed();
        const master = new Uint8Array([1, 0, 0, 0]);
        expect(ethers.utils.arrayify(result)).to.equalBytes(master);
      });
    });

    it('PubkeySubstitution::BySeeds', async () => {
      const result = await libraryInvoker.serializeBySeeds({
        program_id: new Uint8Array([
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
          26, 27, 28, 29, 30, 31, 32,
        ]),
        seeds: [await libraryInvoker.serializeArbitrarySeed([0, 1, 2])],
        bump: 0,
      });
      const master = new Uint8Array([
        1, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
        23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0,
        0, 0, 0, 0, 1, 2, 0,
      ]);
      expect(ethers.utils.arrayify(result)).to.equalBytes(master);
    });

    it('PubkeySubstitutionTuples', async () => {
      const result = await libraryInvoker.serializePubkeySubstitutionTuples([
        {
          u64: 200,
          data: await libraryInvoker.serializeSubmissionAuthWallet({
            token_mint: [
              1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
              25, 26, 27, 28, 29, 30, 31, 32,
            ],
          }),
        },
      ]);

      const master = new Uint8Array([
        1, 1, 0, 0, 0, 0, 0, 0, 0, 200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
        10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,
      ]);

      expect(ethers.utils.arrayify(result)).to.equalBytes(master);
    });
  });

  describe('DataSubstitutions', () => {
    it('DataSubstitution::SubmissionAuthWalletAmount', async () => {
      const result = await libraryInvoker.serializeSubmissionAuthWalletAmount({
        account_index: 200,
        offset: 500,
        is_big_endian: true,
        subtraction: 10,
      });
      const master = new Uint8Array([
        0, 0, 0, 0, 200, 0, 0, 0, 0, 0, 0, 0, 244, 1, 0, 0, 0, 0, 0, 0, 1, 10, 0, 0, 0, 0, 0, 0, 0,
      ]);
      expect(ethers.utils.arrayify(result)).to.equalBytes(master);
    });

    it('DataSubstitutions', async () => {
      const result = await libraryInvoker.serializeDataSubstitutions([
        {
          data: await libraryInvoker.serializeSubmissionAuthWalletAmount({
            account_index: 200,
            offset: 500,
            is_big_endian: true,
            subtraction: 10,
          }),
        },
      ]);

      const master = new Uint8Array([
        1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 200, 0, 0, 0, 0, 0, 0, 0, 244, 1, 0, 0, 0, 0, 0, 0,
        1, 10, 0, 0, 0, 0, 0, 0, 0,
      ]);

      expect(ethers.utils.arrayify(result)).to.equalBytes(master);
    });
  });

  describe('Instruction', () => {
    it('AccountsMeta', async () => {
      const result = await libraryInvoker.serializeAccountsMeta({
        pubkey: new Uint8Array([
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
          26, 27, 28, 29, 30, 31, 32,
        ]),
        is_signer: true,
        is_writable: false,
      });
      const master = new Uint8Array([
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
        26, 27, 28, 29, 30, 31, 32, 1, 0,
      ]);

      expect(ethers.utils.arrayify(result)).to.equalBytes(master);
    });

    it('Instruction', async () => {
      const result = await libraryInvoker.serializeInstruction({
        program_id: new Uint8Array([
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
          26, 27, 28, 29, 30, 31, 32,
        ]),
        accounts: [
          {
            pubkey: Buffer.alloc(32, 0),
            is_signer: true,
            is_writable: false,
          },
          {
            pubkey: Buffer.alloc(32, 1),
            is_signer: true,
            is_writable: false,
          },
        ],
        data: Buffer.alloc(10, 100),
      });
      const master = new Uint8Array([
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
        26, 27, 28, 29, 30, 31, 32, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 10, 0, 0, 0, 0, 0,
        0, 0, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,
      ]);

      expect(ethers.utils.arrayify(result)).to.equalBytes(master);
    });
  });

  it('Should serialize ExternalInstruction', async () => {
    const result = await libraryInvoker.serializeExternalInstruction({
      reward: 5000,
      expense: 10_000,
      execute_policy: 0,
      pubkey_substitutions: [
        {
          u64: 0,
          data: await libraryInvoker.serializeSubmissionAuthWallet({
            token_mint: Buffer.alloc(32, 0),
          }),
        },
        {
          u64: 1,
          data: await libraryInvoker.serializeBySeeds({
            program_id: Buffer.alloc(32, 1),
            seeds: [
              await libraryInvoker.serializeArbitrarySeed(new Uint8Array([1, 2, 3])),
              await libraryInvoker.serializeSubmissionAuthSeed(),
            ],
            bump: 255,
          }),
        },
      ],
      data_substitutions: [
        {
          data: await libraryInvoker.serializeSubmissionAuthWalletAmount({
            account_index: 5100,
            offset: 5200,
            is_big_endian: true,
            subtraction: 10,
          }),
        },
        {
          data: await libraryInvoker.serializeSubmissionAuthWalletAmount({
            account_index: 6100,
            offset: 6300,
            is_big_endian: false,
            subtraction: 20,
          }),
        },
      ],
      instruction: {
        program_id: Buffer.alloc(32, 50),
        accounts: [
          {
            pubkey: Buffer.alloc(32, 90),
            is_signer: false,
            is_writable: false,
          },
        ],
        data: Buffer.alloc(10, 188),
      },
    });

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
    expect(ethers.utils.arrayify(result)).to.equalBytes(master);
  });
});
