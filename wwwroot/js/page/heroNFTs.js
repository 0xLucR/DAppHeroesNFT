var heroNFTs = function () {
    return {
        dotNetReference: null,
        provider: null,
        signer: null,
        userAddress: null,
        contractToken: null,
        contractNFT: null,
        contractNFTGenerate: null,
        openModal: false,
        requireTokenToMint: "10000000000000000000",

        init: async function (_dotNetReference) {
            this.dotNetReference = _dotNetReference;

            self.connectDisplay().isConnectedLoad(calbackConnected.bind(this));

            async function calbackConnected(connected) {
                if (connected) {
                    this.provider = new ethers.providers.Web3Provider(window.ethereum, "any");
                    await this.provider.send("eth_requestAccounts", []);
                    this.signer = this.provider.getSigner();
                    this.userAddress = await this.signer.getAddress();

                    this.contractToken = new ethers.Contract(_abiToken.address, _abiToken.abi, this.signer);
                    this.contractNFT = new ethers.Contract(_abiNFT.address, _abiNFT.abi, this.signer);
                    this.contractNFTGenerate = new ethers.Contract(_abiNFTGenerate.address, _abiNFTGenerate.abi, this.signer);

                    this.loadHeroNFT();
                }
            }
        },
        loadHeroNFT: async function () {
            let ids = await this.getIdsNFT();
            let nfts = await this.getHeroByIds(ids);
            console.log(nfts);

            let param = this.getStructNFT(nfts);
            this.dotNetReference.invokeMethod('LoadNFT', param);
            if (this.openModal) {
                this.dotNetReference.invokeMethod('SetNftMintado');
                this.openModal = false;
                $('#modalNFT').modal('show');
            }
        },
        getIdsNFT: function () {
            try {
                return this.contractNFT.getIdsHeroByOwner(this.userAddress);
            } catch (e) {
                response = `${e.message}`;
                console.log(response);
            }
        },
        getHeroByIds: function (ids) {
            try {
                return this.contractNFT.getHeroByIds(ids);
            } catch (e) {
                response = `${e.message}`;
                console.log(response);
            }
        },
        getStructNFT: function (nfts) {
            let retur = [];

            nfts.forEach(x => {
                retur.push({
                    id: x.id.toNumber(),
                    name: x.name,
                    class: x.class,
                    level: x.level
                });
            });
            return retur;
        },
        getBalance: async function () {
            try {
                let tokenBalance = await this.contractToken.balanceOf(this.userAddress);
                tokenBalance = parseFloat(ethers.utils.formatUnits(tokenBalance, 18));
                return tokenBalance;
            } catch (e) {
                response = `${e.message}`;
                console.log(response);
            }
        },
        approveTokenForMintNFT: async function () {
            try {

                let tx = await this.contractToken.approve(_abiNFTGenerate.address, this.requireTokenToMint);
                const receipt = await tx.wait();
                console.log(`Transaction hash: ${tx.hash}`);
                console.log(`APPROVE: Transaction confirmed in block ${receipt.blockNumber}`);
            } catch (e) {
                response = `${e.message}`;
                console.log(response);
            }
        },
        mintNFT: async function () {
            const requiredBbalance = 10;
            let balance = await this.getBalance();

            if (balance < requiredBbalance) {
                alert("BALANÇO INSUFICIENTE");
                return;
            }

            await this.approveTokenForMintNFT();
            try {
                const tx = await this.contractNFTGenerate.createNFT();
                const receipt = await tx.wait();

                console.log(`Transaction hash: ${tx.hash}`);
                console.log(`Mint NFT: Transaction confirmed in block ${receipt.blockNumber}`)

                this.openModal = true;
                this.loadHeroNFT();
            } catch (e) {
                response = `${e.message}`;
                console.log(response);
            }
        },

        dispose: function () {

        }

    }
}