const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.HttpProvider('https://rinkeby.infura.io/v3/f9cb229a18104764a359db6ac3e7b4c2'));
const Factory = require('./build/contracts/BWLBadgeFactory.json');

const main = async () => {
    const private = 'ed5b8dcf91e71488761f2811884cf751decf734182afffed78e458c2dcb7eac8';
    const account = await web3.eth.accounts.privateKeyToAccount(private);

    await minting(account);
}

const minting = async (account) => {
    const contractAdd = Factory.networks["4"].address;
    const testAbi = Factory.abi;
    const TestObj = new web3.eth.Contract(
        testAbi,
        contractAdd,
    );

    const id = 1;
    const amount = web3.utils.toHex("25");
    const uri = 'ipfs://QmfXmRop6nDCKVsbdNegAnwf3HxMFEjdGjjsE7g6Fy29tc';
    const data = TestObj.methods.mintWithUri(account.address, id, amount, uri).encodeABI();

    const signTransaction = await account.signTransaction({
        data: data,
        value: web3.utils.toHex(0),
        gas: web3.utils.toHex(600000),
        to: contractAdd,
        from: account.address
    });

    const tx = await web3.eth.sendSignedTransaction(signTransaction.rawTransaction,
        (error, hash) => {
            if (error) throw error;
            console.log(hash);
        });

    console.log(tx);
}

main();