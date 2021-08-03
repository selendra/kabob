import { ethers, Wallet } from 'ethers';



let url = 'https://bsc-dataseed.binance.org/';

var SwapContractAddress = "0x54419268c31678C31e94dB494C509193d7d2BB5D";

var SwapContractABI = [
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "_oldToken",
                "type": "address"
            },
            {
                "internalType": "address",
                "name": "_newToken",
                "type": "address"
            }
        ],
        "stateMutability": "nonpayable",
        "type": "constructor"
    },
    {
        "inputs": [],
        "name": "admin",
        "outputs": [
            {
                "internalType": "address",
                "name": "",
                "type": "address"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "newToken",
        "outputs": [
            {
                "internalType": "contract IERC20",
                "name": "",
                "type": "address"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "oldToken",
        "outputs": [
            {
                "internalType": "contract IERC20",
                "name": "",
                "type": "address"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "uint256",
                "name": "_amount",
                "type": "uint256"
            }
        ],
        "name": "swap",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    }
]




async function getPrivateKey(mnemonic: string) {
    return new Promise(async (resolve, reject) => {
        const walletMnemonic = Wallet.fromMnemonic(mnemonic);

        resolve(walletMnemonic.privateKey);
    });
}

async function validateEtherAddr(address: string) {
    return new Promise(async (resolve, reject) => {
        const isEtherAddress = ethers.utils.isAddress(address);
        resolve(isEtherAddress);
    });
}


async function swapToken(privateKey: string, amount: string) {
    return new Promise(async (resolve, reject) => {

        let provider = new ethers.providers.JsonRpcProvider(url);

        let res = await provider.getGasPrice();

        let etherString = ethers.utils.formatEther(res);

        console.log(etherString);
        let signer = new ethers.Wallet(privateKey).connect(provider);

        try {
            let SwapContract = new ethers.Contract(SwapContractAddress, SwapContractABI, signer);

            console.log("Start Swapping Amount: ", amount);
            let res = await SwapContract.swap(ethers.utils.parseUnits(amount, 18));

            resolve(res.hash);

            console.log(res.hash);
        } catch (error) {
            resolve(error.reason);
        }
    });
}




// async function getPrivateKey(mnemonic: string) {
//     return new Promise(async (resolve, reject) => {
//         const walletMnemonic = Wallet.fromMnemonic(mnemonic);
//         resolve(walletMnemonic.privateKey);
//     });
// }



export default {
    getPrivateKey,
    validateEtherAddr,
    swapToken,
};