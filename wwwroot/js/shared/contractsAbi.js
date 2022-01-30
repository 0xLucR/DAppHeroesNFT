const _abiToken = {
    address: "0x7a916D388D6B14371dC7E1adcBB8eA43dFC1DC52",
    abi: [
        "function name() view returns (string)",
        "function symbol() view returns (string)",
        "function balanceOf(address _owner) public view returns (uint256 balance)",
        "function transfer(address _to, uint256 _value) public returns (bool success)",
        "function approve(address spender, uint256 amount) public virtual override returns (bool)",
    ],
};

const _abiClaimToken = {
    address: "0x0e67CB0B9f573DB5dB85DEeD4d9DA9897E7c970f",
    abi: [
        "function setAmountClaim(uint256 _amount) external onlyOwner",
        "function claim() public amountZero returns (bool)",
        "function clearTokenClaim() public onlyOwner returns (bool)",
    ],
};

const _abiNFT = {
    address: "0x8e50d84Fc49f606C6Ed51e06F90f435CC06E5638",
    abi: [
        "function getIdsHeroByOwner(address _owner) external view returns(uint[] memory)",
        "function getHeroById(uint256 _id) external view returns(tuple(uint256 id, string name, string class, uint32 level) memory)",
        "function getHeroByIds(uint256[] memory _ids) external view returns(tuple(uint256 id, string name, string class, uint32 level)[] memory)"
    ],
};

const _abiNFTGenerate = {
    address: "0x4118b314435027Db59e058026827EEbdB03989b1",
    abi: [
        "function createNFT() public amountAllowance returns(bool)",
    ],
};