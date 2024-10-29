pragma solidity ^0.8.7;

import "./State.sol";

contract Multisig is State {

    function isVoteToChangeValidator(bytes calldata data, address destination)
        public
        view
        returns (bool)
    {
        if (data.length > 4) {
            return
                (bytes4(data[:4]) == this.addValidator.selector || bytes4(data[:4]) == this.replaceValidator.selector || bytes4(data[:4]) == this.removeValidator.selector) &&
                destination == address(this);
        }

        return false;
    }
    
    modifier reentracy(){
        require(guard == 1);
        guard = 2;
        _;
        guard = 1;
    }

    modifier reentracyChack(){
        require(guard == 1);
        _;
    }
    constructor(address[] memory newValidators,  uint256 _quorum, uint256 _step)
    {
    }

    function addValidator(
        address validator,
        uint256 newQuorum,
        uint256 _step
    ) public   {
        // make sure validator list isn't maxed out
        assert (validators.length < type(uint256).max ) ;

        // check that sender is contract 
        assert (msg.sender == address(this)) ; 

        // append validator to validators list
        validators.push(validator) ;
        isValidator[validator] = true ;

        // update quorum
        quorum = newQuorum ;
        
        // update step
        step = _step ;
        
        // TODO quorum has to be fibonacci of step (quorumIsValid)
    }


    function removeValidator(
        address validator,
        uint256 newQuorum,
        uint256 _step
    ) public {
    }


    function replaceValidator(
        address validator,
        address newValidator
    )
        public
    {
        // replaceValidatorCaller
        // * has to be reentrant 



    }

    function changeQuorum(uint256 _quorum, uint256 _step)
        public
    {
        // changeQuorumCaller
        // * has to be a reentrant call 

        // 
    }

    function transactionExists(bytes32 transactionId)
        public
        view
        returns (bool)
    {
    }

    function voteForTransaction(
        bytes32 transactionId,
        address destination,
        uint256 value,
        bytes calldata data,
        bool hasReward
    ) public payable {
        // lengthChangeOnlyInAddValidatorActivation
        // one of three methods that can increase length of execute transaction

        // lengthChangeWorks2
        // has to have at least one example 

        // voteForTransactionCaller
        // * can only be done by a validator 

        // 
    }

    function executeTransaction(bytes32 transactionId) public
    {
        // lengthChangeOnlyInAddValidatorActivation
        // one of three methods that can increase length of execute transaction

        // lengthChangeWorks3
        // has to have at least one example 
    }

    function removeTransaction(bytes32 transactionId) public {
    }

    function isConfirmed(bytes32 transactionId) public view returns (bool) {
        // has enough votes for the quorum?
    }

    function getDataOfTransaction(bytes32 id) external view returns (bytes memory data){
        data = transactions[id].data;
    }

    function hash(bytes memory data) external pure returns (bytes32 result)
    {
        result = keccak256(data);
    }

    function getConfirmationCount(bytes32 transactionId)
        public
        view
        returns (uint256 count)
    {

        // addValidatorFunctinality4
        // * count cannot change when adding a validaot
    }

    function distributeRewards() public reentracy
    {
    }
}