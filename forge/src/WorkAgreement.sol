pragma solidity ^0.8.15;

contract WorkAgreement {
  enum State {
    EMPTY,
    LIVE,
    CANCELLED 
  }

	struct Agreement {
    uint id;
    address issuer;
		address recipient;
		uint startDate;
		uint endDate;
    bytes32 role; // bytes 32 string, assume ENUM? to keep simple?
		bytes32 salaryHash; // hash(secretEmpr, salary)
		State state; // did employee accepted
	}

  struct AgreementInput {
		address recipient;
		uint startDate;
		uint endDate;
    bytes32 role; // bytes 32 string, assume ENUM? to keep simple?
		bytes32 salaryHash; // hash(secretEmpr, salary)
	}

	mapping(address => mapping(address => uint)) public pairToId;
	mapping(address => uint[]) public liveIds; // list of parties agreements were issued to
	mapping(uint => Agreement) public agreements;

  uint nextId = 1;

  function getAgreements() external view returns (Agreement[] memory allAgreements) {
    allAgreements = new Agreement[](nextId + 1);
    for (uint i; i <= nextId; i++) {
      allAgreements[i] = agreements[i];
    }
  }

  function issueAgreement(AgreementInput memory input) external returns (uint newId) {
    newId = nextId++;

    Agreement memory newAgreement = Agreement({
      id: newId,
      issuer: msg.sender,
      recipient: input.recipient,
      startDate: input.startDate,
      endDate: input.endDate,
      role: input.role, 
      salaryHash: input.salaryHash, 
      state: State.LIVE 
    });

    pairToId[msg.sender][newAgreement.recipient] = newId;
    agreements[newId] = newAgreement;
    liveIds[msg.sender].push(newId);
	}

  function cancelAgreement(uint idToCancel) external {
    Agreement memory pendingAgreement = agreements[idToCancel];
    require(
      pendingAgreement.recipient == msg.sender || pendingAgreement.issuer == msg.sender, 
      "only issuer and recipient can cancel"
    );

    agreements[idToCancel].state = State.CANCELLED;
    uint liveLen = liveIds[pendingAgreement.issuer].length;
    bool removed;
    for (uint i; i < liveLen; i++) {
      if (liveIds[pendingAgreement.issuer][i] == idToCancel) {
        liveIds[pendingAgreement.issuer][i] = liveIds[pendingAgreement.issuer][liveLen-1];
        liveIds[pendingAgreement.issuer].pop();
        removed = true;
        break;
      }
    }

    require(removed, "agreement does not exist");
  }

}