module.exports = {
  networks: {
    Local: {
      protocol: 'http',
      host: 'localhost',
      port: 8545,
      gas: 99999999999,
      gasPrice: 0,
      networkId: '*',
    },
    Ganache: {
      protocol: 'http',
      host: 'localhost',
      port: 7545,
      gas: 999999999,
      gasPrice: 0,
      networkId: '*',
    },
    vps: {
      protocol: 'http',
      host: '51.75.246.191',
      port: 8545,
      gas: 999999999,
      gasPrice: 0,
      networkId: '*',
    },
  },
};
