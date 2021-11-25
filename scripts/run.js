const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  // compiling our smart contract
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  // deploying our smart contract after hardhat creates a local ethereum network
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  // probably waiting for the transaction to be mined
  await waveContract.deployed();
  // getting the address of our deployed smart contract
  console.log("Contract deployed to this address ", waveContract.address);
  console.log("Contract deployed by ", owner.address);

  let contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    "Contract balance: ",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let waveCount = await waveContract.getTotalNumberOfWaves();

  let waveTxn = await waveContract.wave("Hi this is a new wave");
  await waveTxn.wait();

  waveCount = await waveContract.getTotalNumberOfWaves();
  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    "Contract balance: ",
    hre.ethers.utils.formatEther(contractBalance)
  );
  waveTxn = await waveContract
    .connect(randomPerson)
    .wave("Hi this is a newer wave");
  await waveTxn.wait();

  waveCount = await waveContract.getTotalNumberOfWaves();
  contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    "Contract balance: ",
    hre.ethers.utils.formatEther(contractBalance)
  );
  let waves = await waveContract.getAllWaves();
  console.log(waves);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (e) {
    console.log(e);
    process.exit(1);
  }
};

runMain();
