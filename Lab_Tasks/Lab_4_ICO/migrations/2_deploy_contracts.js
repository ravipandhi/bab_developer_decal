var Crowdsale = artifacts.require("./Crowdsale.sol");
var Queue = artifacts.require("./Queue.sol");
var Token = artifacts.require("./Token.sol");

module.exports = function(deployer) {
	deployer.deploy(Crowdsale);
	deployer.deploy(Queue);
	deployer.deploy(Token);
};
