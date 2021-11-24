const HelloWorld = artifacts.require("HelloWorld") ;

contract("HelloWorld" , () => {
	it("Hello World Testing" , async () => {
	const helloWorld = await HelloWorld.deployed() ;
	await helloWorld.setName("Almoutanabi") ;
	const result = await helloWorld.name() ;
	assert(result === "Almoutanabi") ;
	});
});
