var Migrations = artifacts.require("Migrations");
var Greeter = artifacts.require("Greeter");
var Fibonacci = artifacts.require("Fibonacci.sol");
var xor = artifacts.require("xor");
var Concatenator = artifacts.require("Concatenator");
var Betting = artifacts.require("Betting");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Greeter);
  deployer.deploy(Fibonacci);
  deployer.deploy(xor);
  deployer.deploy(Concatenator);
  deployer.deploy(Betting);
};
