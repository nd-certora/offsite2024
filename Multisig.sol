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

        // check validator is not already a validator
        for (uint i = 0; i < validators.length; i++) {
            require (validators[i] != validator);
        }

        // Update reverse map: the new validator is in the last index.
        validatorsReverseMap[validator] = validators.length;

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
        // check that sender is contract 
        assert (msg.sender == address(this)) ;       

        // check size > 1
        assert (validators.length > 1);

        // make sure validator is in the map
        assert (validatorsReverseMap[validator] != 0) ;
        
        // remove validator from validators
        uint256 index = validatorsReverseMap[validator];
        validators[index] = validators[validators.length - 1];
        validators.pop();
        isValidator[validator] = false;

        // reverse values map updating
        validatorsReverseMap[validators[index]] = index;
        validatorsReverseMap[validator] = 0;

        // update quorum
        quorum = newQuorum ;
        
        // update step
        step = _step ;
        
        // TODO quorum has to be fibonacci of step (quorumIsValid)
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
        // * count cannot change when adding a validator

        // removeValidatorFunctinality4, 5, 6
        // * getConfirmationCount may stay the same or decrement when removing a validator
        // * has to be one or the other
    }

    function distributeRewards() public reentracy
    {
    }
}