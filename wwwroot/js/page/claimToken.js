var clainToken = function () {
    return {
        dotNetReference: null,
        provider: null,
        signer: null,
        userAddress: null,
        contractToken: null,
        contractClaimToken: null,

        init: function (_dotNetReference) {
            this.dotNetReference = _dotNetReference;

            self.connectDisplay().isConnectedLoad(calbackConnected.bind(this));

            async function calbackConnected(connected) {
                if (connected) {
                    this.provider = new ethers.providers.Web3Provider(window.ethereum, "any");
                    await this.provider.send("eth_requestAccounts", []);
                    this.signer = this.provider.getSigner();
                    this.userAddress = await this.signer.getAddress();

                    this.contractToken = new ethers.Contract(_abiToken.address, _abiToken.abi, this.signer);
                    this.contractClaimToken = new ethers.Contract(_abiClaimToken.address, _abiClaimToken.abi, this.signer);

                    this.loadClaimToken();
                }
            }

        },
        loadClaimToken: function () {
            this.updateBalance();
        },
        updateBalance: async function () {
            try {
                let balanceUser = await this.contractToken.balanceOf(this.userAddress);
                balanceUser = ethers.utils.formatUnits(balanceUser, 18);
                this.dotNetReference.invokeMethod('UpdateBalance', balanceUser);
            } catch (e) {
                response = `${e.message}`;
                console.log(response);
            }
        },
        claimToken: async function () {
            try {
                const tx = await this.contractClaimToken.claim();

                const receipt = await tx.wait();
                console.log(`Transaction hash: ${tx.hash}`);
                console.log(`Transaction confirmed in block ${receipt.blockNumber}`);
                console.log(`Gas used: ${receipt.gasUsed.toString()}`);

                this.updateBalance();

            } catch (e) {
                response = e?.data?.message ?? `${e.message}`;
                alert(response);
                console.log(response);
            }
        },

        dispose: function () {

        }

    }
}

