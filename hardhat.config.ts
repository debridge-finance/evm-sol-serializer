import { HardhatUserConfig } from 'hardhat/config';
import '@nomicfoundation/hardhat-toolbox';

const config: HardhatUserConfig = {
  solidity: {
    version: '0.8.20',
    settings: {
      viaIR: false,
      optimizer: {
        enabled: true,
        runs: 999999,
      },
    },
  },
};

export default config;
