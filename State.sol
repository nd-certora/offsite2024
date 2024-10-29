pragma solidity ^0.8.7;

abstract contract State {

    struct Transaction {
        address destination;
        uint256 value;
        bytes data;
        bool executed;
        bool hasReward;
        uint256 validatorVotePeriod;
    }

    /// @dev Current set of validators, i.e. addresses that control the
    /// contract.
    address[] public validators; // valid values at index 1..
    mapping(address => uint256) public validatorsReverseMap;
    
    /// @dev Mapping kept in sync with validator list for fast lookups.
    mapping(address => bool) public isValidator;

    /// @dev Number of validator votes needed to execute a validator-majority
    /// only action.
    uint256 public quorum;
    uint256 public step;

    mapping(bytes32 => Transaction) public transactions;
    /// @dev List kept in sync to not lose information on mapping keys.
    bytes32[] public transactionIds; // valid values at index 1..
    mapping(bytes32 => uint256) public transactionIdsReverseMap;

    /// @dev Mapping to keep track of validator votes for a transaction
    /// proposal.
    mapping(bytes32 => mapping(address => bool)) public confirmations;

    uint256 public constant WRAPPING_FEE = 0.1 ether;

    /// @dev Describes how much of bridge's balance is available to be
    /// distributed among validators.
    uint256 public rewardsPot;
    uint256 public sideRewardsPot;
    uint256 public usersValue;
    /// @dev The last `block.timestamp` when rewards were distributed.
    uint256 public lastWithdrawalTime;

    uint256 public constant ADD_VALIDATOR_VOTE_PERIOD = 1 weeks;
    uint256 guard;
}
