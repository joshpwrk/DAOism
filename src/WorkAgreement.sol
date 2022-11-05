pragma solidity ^0.8.15;

contract WorkAgreement {
  enum State {
    LIVE,
    CANCELLED 
  }

	struct Agreement {
    address issuer;
		address recipient;
		uint startDate;
		uint endDate;
    bytes32 role; // bytes 32 string, assume ENUM? to keep simple?
		bytes32 salaryFromHash; // hash(secretEmpr, salary)
		State state; // did employee accepted
	}

  struct AgreementInput {
		address recipient;
		uint startDate;
		uint endDate;
    bytes32 role; // bytes 32 string, assume ENUM? to keep simple?
		bytes32 salaryFromHash; // hash(secretEmpr, salary)
	}

	mapping(address => mapping(address => uint)) public pairToId;
	mapping(address => uint[]) public liveIds; // list of parties agreements were issued to
	mapping(uint => Agreement) public agreements;

  uint nextId = 1;

	function issueAgreement(AgreementInput memory input) external returns (uint newId) {
    Agreement memory newAgreement = Agreement({
      issuer: msg.sender,
      recipient: input.recipient,
      startDate: input.startDate,
      endDate: input.endDate,
      role: input.role, 
      salaryFromHash: input.salaryFromHash, 
      state: State.LIVE 
    });

    newId = nextId++;
    pairToId[msg.sender][newAgreement.recipient] = newId;
    agreements[newId] = newAgreement;
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
