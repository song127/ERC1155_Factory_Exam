let factoryContract = artifacts.require("BWLBadgeFactory");

module.exports = function(deployer){
    deployer.deploy(factoryContract);
}