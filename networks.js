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
  },
};
