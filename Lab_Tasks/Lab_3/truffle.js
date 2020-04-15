module.exports = {
  networks: {
      //download testrpc and type `testrpc` in your console to start a locally hosted blockchain
    development: {
      host: "localhost",
      port: 7545,
      network_id: "*" // Match any network id
    }
  },
  compilers: {
    solc: {
      version: "0.5.0"  // Fetch exact version from solc-bin (default: truffle's version)
    }
  }
};
