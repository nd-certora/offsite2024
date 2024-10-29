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
        // quorum = _quorum;
        // step = _step;
        
        // uint256 dummyIdx = 0;

        // transactionIds = new uint256[]();
        // transactionIds.push(dummyIdx);

        // transactions = new uint256[]();
        // validators.push(dummyIdx);
        // for (uint256 idx = 1; idx < newValidators.length; idx += 1) {
        //     validators.push(newValidators[idx]);
        // }
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
        require (isValidator[msg.sender], "sender is not a validator for this transaction");
        require (transactionId != 0, "0 is never a valid as a transactionId");

        if (!isValidTransaction(transactionId)) {
            Transaction memory newTransaction = Transaction({
                destination:destination,
                value:value,
                data:data,
                executed:false,
                hasReward:hasReward,
                validatorVotePeriod:ADD_VALIDATOR_VOTE_PERIOD
            });
            
            transactions[transactionId] = newTransaction;

            uint256 insertionIdx = transactionIds.length;
            transactionIds.push(transactionId);
            transactionIdsReverseMap[transactionId] = insertionIdx;
        }

        bool confirmation = confirmations[transactionId][msg.sender];
        require (!confirmation, "validator already voted");
        confirmations[transactionId][msg.sender] = true;
    }

    function isValidTransaction(bytes32 transactionId) public view returns (bool) {
        uint256 idx = transactionIdsReverseMap[transactionId];
        
        return (
            idx > 0
            && transactionIds.length > idx 
            && transactionIds[idx] == transactionId
            && transactions[transactionId].destination != address(0) // transaction is initialized
        );
    }

    function executeTransaction(bytes32 transactionId) public
    {
        // lengthChangeOnlyInAddValidatorActivation
        // one of three methods that can increase length of execute transaction

        // lengthChangeWorks3
        // has to have at least one example 
        // check valid transaction
        require( isValidTransation(transactionId) && transactionId!= 0 );
        // check quorum
        require(isConfirmed(transactionId));
        // call destination
        bool success;
        address _target = transactions[transactionId].destination;
        uint256 _value = transactions[transactionId].value;
        bytes _data = transactions[transactionId].data;
        (success, _) = _target.call{value: _value}(_data);
    
        //check that the call succeeded
        require(success);
        // mark as executed
        transactions[transactionId].executed;
        //maybe something on the reward 
    }

    function removeTransaction(bytes32 transactionId) public {
    }

    function isConfirmed(bytes32 transactionId) public view returns (bool) {
        // has enough votes for the quorum?
        return getConfirmationCount(transactionId) >= quorum; 
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
        for (uint256 id = 0 ; id <  validators.length < id ++ ) {
            if ( confirmations[transactionId][id] )
                count++;
        }
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