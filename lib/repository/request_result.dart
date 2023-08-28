class RequestResult {
  bool success = false;
  String requestError = '';
  String message = '';

  RequestResult(this.success, this.requestError, this.message);
  RequestResult.withoutMessages(this.success);
}
