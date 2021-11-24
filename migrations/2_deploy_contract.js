const Vaccination = artifacts.require("Vaccination");

module.exports = function (deployer) {
deployer.deploy(Vaccination);
};
