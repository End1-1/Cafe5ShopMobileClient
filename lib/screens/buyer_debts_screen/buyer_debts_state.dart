class BuyerDebtsState {

}

class BuyerDebtsStateError extends BuyerDebtsState {
  String error = "";
  BuyerDebtsStateError(this.error);
}

class BuyerDebtsStateProgress extends BuyerDebtsState {

}

class BuyerDebtsStateReady extends BuyerDebtsState {

}
