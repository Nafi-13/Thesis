// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Ownable {
  //using SafeMath for uint256;

  address private owner;
  address private nextOwner;
  uint public hidden_number1;
  uint public hidden_number2;
  uint private owner_count=0;
  uint private request_key;

  bool private first_req=false;
  bool private request=false;
  bool private open_request=false;

  bool private vote_req=false;
  bool private start_vote_permit=false;
  uint private permitForVoteCount=0;

  bool private reject_vote_permit=false;


  bool private terminate_req=false;
  bool private terminate_vote_permit=false;
  uint private permitForTerminationCount=0;

  address private requested_owner;
  address private first_request_address;
  uint private message;

  constructor() {
    owner = msg.sender;
  }

  mapping(address => uint) public owner_list;

  modifier onlyOwner() {
    require(msg.sender == owner, "Only the owner can perform this action");
    _;
  }

  modifier requestOkay() {
      require(request==true,"No request for initialization");
      _;
  }


  //first request to start
  function firstRequest() public {
      require(first_req==false,"Ekbar Request Hoye gese");
      require(msg.sender!=owner,"Self Request Not Allowed");
      first_request_address=msg.sender;
      first_req=true;
  }

  function openRequestAccess(address _requested_owner, uint _request_key) public onlyOwner {
      require(open_request==false);
      require(request==false);
      require(first_req==true,"Age Request Chaak vai");
      require(_requested_owner!=owner);
      require(first_request_address==_requested_owner);
      requested_owner=_requested_owner;
      request_key=_request_key;
      open_request=true;

  }

  function requestAccess(uint _key) public {
      require(request==false);
      require(open_request==true);
      require(requested_owner==msg.sender);
      require(request_key==_key);
      request=true;
      open_request=false;


  }

  function transferOwnership(address _newOwner, uint _h1, uint _h2, uint _message) public onlyOwner requestOkay {
    require(_newOwner != address(0), "The new owner cannot be the null address");
    require(_newOwner != owner, "The new owner must be different from the current owner");
    //require(_encryptedKey > 0, "The encrypted key must be a non-empty string");
    require(owner_list[owner]==0);

    nextOwner = _newOwner;
    hidden_number1 = _h1;
    hidden_number2 = _h2;
    message=_message;
    owner_list[owner]++;
    owner_count++;
  }

  function acceptOwnership(uint _checkMessage,uint _owner_count) public {
    require(msg.sender == nextOwner, "Only the next owner can accept ownership");
    require(_owner_count==owner_count);
    require(message==_checkMessage);
    require(owner_list[msg.sender]==0);

    owner = nextOwner;
    owner_list[msg.sender]++;
    
    nextOwner = address(0);
    hidden_number1 = 0;
    hidden_number2 = 0;
  }

  function transferOwnershipToAnotherParty(address _anotherParty, uint _h1,uint _h2, uint _message) public onlyOwner {
    require(_anotherParty != address(0), "The another party cannot be the null address");
    require(_anotherParty != owner, "The another party must be different from the current owner");
    //require(_encryptedKey > 0, "The encrypted key must be a non-empty string");
    require(owner_list[owner]==1);

    owner_list[owner]++;
    nextOwner = _anotherParty;
    hidden_number1 = _h1;
    hidden_number2 = _h2;
    message=_message;
    owner_count++;
  }




  //Election Process
  struct Candidate {
        string name;
        uint256 voteCount;
        uint256 id;
    }

    struct Voter {
        //address voterr;
        //uint weight;
        bool votedd;
        bool authorizedd;
        bytes32 voteHash;
        //string votername;

        //uint256 vote;
    }

    uint public expiration;
    uint256 public winningVote = 0;
    string public winnerName;
    string public electionName;
    string public names;
   

    //mapping(address => Voter) public voterss;
    mapping(address => Voter) public voted;

    Candidate[5] public candidates;
    Voter[] public voters;

    uint256 public totalVotes;

    uint256 public next_candidate = 0;

    enum State {
        Pre_election,
        Created,
        Voting,
        Ended
    }
    State public state=State.Pre_election;

    modifier inState(State _state) {
        require(state == _state);
        _;
    }


     function startElection(uint256 checkX) public onlyOwner inState(State.Pre_election) {
      require(owner_count>0);
      require(checkX==owner_count);
      require(owner_list[owner]==1);
      require(requested_owner==msg.sender,"Requested User Didnot Enter");
      owner_list[owner]++;
        //electionName = _name;
      state = State.Created;
    }

    function addCandidate(string memory _name, uint256 _id)
        public
        inState(State.Created)
        onlyOwner
    {
        console.log("log 1");
        
        console.log("log else");
        if (next_candidate >= candidates.length) {
            console.log("No spots left");
            return;
        }
        for (uint256 i = 0; i < next_candidate; i++) {
            console.log("log 2");
            if (candidates[i].id == _id) {
                console.log("Same id");
                return;
            }
        }

        candidates[next_candidate].name = _name;
        candidates[next_candidate].voteCount = 0;
        candidates[next_candidate].id = _id;
        //next_candidate++;
        if (next_candidate + 1 <= candidates.length) {
            next_candidate++;
        }
        console.log("XX");
    }

    function updateCandidate(string memory _name, uint256 _id, uint256 _new_id)
        public
        inState(State.Created)
        onlyOwner
    {
        
        for (uint256 i = 0; i < next_candidate; i++) {
            if (candidates[i].id == _id) {
                candidates[i].name = _name;
                console.log("Name Changed");
                candidates[i].id = _new_id;
                return;
            }
        }

        
    }


    function authorize(address person) public inState(State.Created) onlyOwner {
        require(voted[person].authorizedd==false,"Already Authorized");
        voted[person].authorizedd = true;
    }

    function unauthorize(address person) public inState(State.Created) onlyOwner {
        require(voted[person].authorizedd==true,"Authorize First");
        voted[person].authorizedd = false;
    }
    
    //request for starting the vote
    function requestToStartVote() public inState(State.Created) onlyOwner{
        require(vote_req==false);
        vote_req=true;

    }

    //permission given by all owners to start the vote
    function givePermissionToStartVote() public inState(State.Created) {
         require(start_vote_permit==false,"Permission is already granted");
         require(vote_req==true,"No request for starting vote");
         require(owner_list[msg.sender]==1 || owner_list[msg.sender]==2,"kichu de");
         require(msg.sender!=owner,"Self Permission Not Allowed");
         permitForVoteCount++;
         owner_list[msg.sender]+=2;
         if(permitForVoteCount==owner_count)
         {
             start_vote_permit=true;
             reject_vote_permit=false;
             permitForVoteCount=0;
         }

    }

    //rejects the request for starting the vote
    function rejectPermissionToStartVote() public inState(State.Created) {
        require(reject_vote_permit==false,"Already Terminated");
        require(vote_req==true,"Age request koruk");
        require(owner_list[msg.sender]==1 || owner_list[msg.sender]==2,"kichu de");
        require(msg.sender!=owner,"Self Permission Not Allowed");
        reject_vote_permit=true;

    }

    function startVote(uint256 t) public inState(State.Created) onlyOwner {
        require(start_vote_permit==true,"Permission Acquisition Required");
        require(reject_vote_permit==false,"Reject kore rakhse");
        expiration = block.timestamp + t*1 seconds;
        state = State.Voting;
        
    }

    function checkExpiration() public inState(State.Voting) view returns (bool) {
        return block.timestamp >= expiration;
    }

    function vote(uint256 _voteIndex, uint256 _snum) public inState(State.Voting) {
        // Check if the time limit for voting has been reached
        if (checkExpiration()) {
            // Time limit has been reached, do not allow the vote to be cast
            console.log("Time is over");
            for(uint i=0;i<candidates.length;i++)
            {
                if(candidates[i].voteCount>winningVote)
                {
                    winningVote=candidates[i].voteCount;
                    winnerName=candidates[i].name;
                }
            }
            state = State.Ended;
            showResult();
            return;
        }
        else
        {
            //console.log("Time ase mama");
            require(voted[msg.sender].votedd == false, "user already voted");
            require(voted[msg.sender].authorizedd == true, "problem occuring here");
            candidates[_voteIndex].voteCount += 1;
            totalVotes += 1;
            voted[msg.sender].votedd = true;
            voted[msg.sender].voteHash = sha256(abi.encodePacked(msg.sender,_voteIndex, _snum));
            
        }
        
    }

    function verify(uint256 _voteIndex, uint256 _snum) public inState(State.Voting) view returns (bool){
         require(voted[msg.sender].votedd == true,"Vote first");
         bytes32 _voteHash = sha256(abi.encodePacked(msg.sender,_voteIndex,_snum));
         return voted[msg.sender].voteHash==_voteHash;
     }





    //request for terminating the vote
    function requestToTerminateVote() public inState(State.Voting) onlyOwner{
        require(terminate_req==false);
        terminate_req=true;

    }

    //permission given by all owners to terminate the vote
    function givePermissionToTerminateVote() public inState(State.Voting) {
         require(terminate_vote_permit==false,"Permission is already granted");
         require(terminate_req==true,"No request for terminating vote");
         require(owner_list[msg.sender]==3 || owner_list[msg.sender]==4,"kichu de");
         require(msg.sender!=owner,"Self Permission Not Allowed");
         permitForTerminationCount++;
         owner_list[msg.sender]+=100;
         if(permitForTerminationCount==owner_count)
         {
             terminate_vote_permit=true;
         }

    } 

    function terminate() public inState(State.Voting) onlyOwner {
        require(terminate_vote_permit==true,"Permission Acquisition Required");
        for(uint i=0;i<candidates.length;i++)
        {
            if(candidates[i].voteCount>winningVote)
            {
                winningVote=candidates[i].voteCount;
                winnerName=candidates[i].name;
            }
        }
        state = State.Ended;
    }


    function showResult() public inState(State.Ended) view returns (string memory) {
        return winnerName;
    }


}
